//
//  JSTPressureViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 01/02/15.
//  ***REMOVED***
//
#import "JSTPressureViewController.h"
#import "JSTBaseSensor.h"
#import "JSTSensorManager.h"
#import "JSTMagnetometerSensor.h"
#import "JSTAppDelegate.h"
#import "JSTPressureView.h"
#import "JSTPressureSensor.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static int ddLogLevel = DDLogLevelAll;

@interface JSTPressureViewController () <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@property (nonatomic, strong) JSTSensorTag *sensorTag;
@property (nonatomic) BOOL currentState;
@property (nonatomic) BOOL isCalibrated;
@property (nonatomic) float *values;
@property (nonatomic) NSUInteger valuesIdx;
@end

const NSUInteger JSTPressureViewControllerValuesDifferentialThreshold  = 20;
const NSUInteger JSTPressureViewControllerValuesRange  = 10; // 0,1s/value
const NSUInteger JSTPressureViewControllerValuesEdgesRange  = 3;

@implementation JSTPressureViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        self.values = (float *) malloc(JSTPressureViewControllerValuesRange * sizeof(float));
        self.valuesIdx = 0;
        self.currentState = NO;
    }

    return self;
}

- (void)dealloc {
    free(self.values);

    self.sensorManager.delegate = nil;
    if (self.sensorTag) {
        [self.sensorManager disconnectSensor:self.sensorTag];
        self.sensorTag = nil;
    }
}

- (void)loadView {
    self.view = [[JSTPressureView alloc] initWithFrame:CGRectZero];
}

- (JSTPressureView *)pressureView {
    if (self.isViewLoaded) {
        return (JSTPressureView *)self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensorTag.pressureSensor.sensorDelegate = self;
    [self.sensorTag.pressureSensor configureWithValue:JSTSensorPressureEnabled];
    [self.sensorTag.pressureSensor setPeriodValue:10];
    [self.sensorTag.pressureSensor setNotificationsEnabled:YES];
}

#pragma mark - JSTSensorManagerDelegate

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    });
}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
}

#pragma mark - Sensor delegate

- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTPressureSensor class]]) {
        JSTPressureSensor *pressureSensor = (JSTPressureSensor *)sensor;
        if (!self.isCalibrated) {
            self.isCalibrated = YES;
            [pressureSensor calibrate];
        } else {
            self.values[self.valuesIdx] = pressureSensor.pressure;
            self.valuesIdx = (self.valuesIdx + 1) % JSTPressureViewControllerValuesRange;
            [self estimateValues];
        }
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTPressureSensor class]]) {
        JSTPressureSensor *pressureSensor = (JSTPressureSensor *)sensor;
        [pressureSensor configureWithValue:JSTSensorPressureEnabled];
        [pressureSensor setNotificationsEnabled:YES];
    }
}

- (void)estimateValues {
    float min = FLT_MAX;
    float max = 0.0f;
    float avg = 0.0f;

    for (NSUInteger idx = 0; idx < JSTPressureViewControllerValuesRange; ++idx) {
        avg += self.values[idx];
        min = (min > self.values[idx] ? self.values[idx] : min);
        max = (max < self.values[idx] ? self.values[idx] : max);
    }

    float diff = max - min;
    if (diff > JSTPressureViewControllerValuesDifferentialThreshold && !(self.valuesIdx % 10)) {
        if (self.hasRaised && !self.currentState) {
            self.currentState = !self.currentState;
            [self stateHasChanged:self.currentState];
        }
        else if (!self.hasRaised && self.currentState) {
            self.currentState = !self.currentState;
            [self stateHasChanged:self.currentState];
        }
    }
}

- (BOOL)hasRaised {
    float leftEdgeAvg  = -1.0f;
    float rightEdgeAvg = -1.0f;

    for (NSUInteger beginIdx = 0, endIdx = JSTPressureViewControllerValuesRange - 1;
         beginIdx < JSTPressureViewControllerValuesEdgesRange && endIdx > JSTPressureViewControllerValuesRange - JSTPressureViewControllerValuesEdgesRange - 1;
         ++beginIdx, --endIdx) {
        leftEdgeAvg  += self.values[beginIdx];
        rightEdgeAvg += self.values[endIdx];
    }

    return (leftEdgeAvg/JSTPressureViewControllerValuesEdgesRange < rightEdgeAvg/JSTPressureViewControllerValuesEdgesRange);
}

- (void)stateHasChanged:(BOOL)currentState {
    __weak JSTPressureViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.pressureView.valuesLabel.text = [NSString stringWithFormat:(currentState ? @"Pressed" : @"Released")];
        [weakSelf.pressureView setNeedsLayout];
    });
}

@end
