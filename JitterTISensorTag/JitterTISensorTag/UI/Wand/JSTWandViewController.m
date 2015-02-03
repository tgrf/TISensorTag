//
//  JSTWandViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 23/01/15.
//  ***REMOVED***
//
#import "JSTWandViewController.h"
#import "JSTBaseSensor.h"
#import "JSTSensorManager.h"
#import "JSTMagnetometerSensor.h"
#import "JSTAppDelegate.h"
#import "JSTWandView.h"
#import "JSTDetailsResultView.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static int ddLogLevel = DDLogLevelAll;

@interface JSTWandViewController () <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@property (nonatomic, strong) JSTSensorTag *sensorTag;
@property (nonatomic) BOOL isCalibrated;
@property (nonatomic) float *values;
@property (nonatomic) NSUInteger valuesIdx;
@property (nonatomic) NSUInteger currentPercentageState;
@end

const NSUInteger JSTWandViewControllerValuesRange  = 5; // 0,1s/value
const float JSTWandViewControllerValuesDifferentialThreshold = 100.0f;


@implementation JSTWandViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        self.values = (float *)malloc(JSTWandViewControllerValuesRange * sizeof(float));
        self.valuesIdx = 0;
        self.currentPercentageState = 0;
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
    self.view = [[JSTWandView alloc] initWithFrame:CGRectZero];
}

- (JSTWandView *)wandView {
    if (self.isViewLoaded) {
        return (JSTWandView *)self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensorTag.magnetometerSensor.sensorDelegate = self;
    [self.sensorTag.magnetometerSensor configureWithValue:JSTSensorMagnetometerEnabled];
    [self.sensorTag.magnetometerSensor setPeriodValue:10];
    [self.sensorTag.magnetometerSensor setNotificationsEnabled:YES];
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
    if ([sensor isKindOfClass:[JSTMagnetometerSensor class]]) {
        JSTMagnetometerSensor *magnetometerSensor = (JSTMagnetometerSensor *) sensor;
        if (!self.isCalibrated) {
            self.isCalibrated = YES;
            [magnetometerSensor calibrate];
        } else {
            float length = magnetometerSensor.value.x * magnetometerSensor.value.x
                    + magnetometerSensor.value.y * magnetometerSensor.value.y
                    + magnetometerSensor.value.z * magnetometerSensor.value.z;
            length = sqrtf(length);

            self.values[self.valuesIdx] = length;
            self.valuesIdx = (self.valuesIdx + 1) % JSTWandViewControllerValuesRange;
            [self estimateValues];
        }
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

- (void)estimateValues {
    float min = FLT_MAX;
    float max = 0.0f;
    float avg = 0.0f;

    for (NSUInteger idx = 0; idx < JSTWandViewControllerValuesRange; ++idx) {
        avg += self.values[idx];
        min = (min > self.values[idx] ? self.values[idx] : min);
        max = (max < self.values[idx] ? self.values[idx] : max);
    }
    if (max - min > JSTWandViewControllerValuesDifferentialThreshold && !(self.valuesIdx % 10) && self.currentPercentageState < 100) {
        self.currentPercentageState += 10;
        __weak JSTWandViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.wandView.resultView.resultLabel.text = (self.currentPercentageState != 100
                    ? [NSString stringWithFormat:@"%ld%%", (long)self.currentPercentageState]
                    : @"Yo!"
            );
            [weakSelf.wandView setNeedsLayout];
        });
    }
}

@end
