//
//  JSTHandshakeViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 25/01/15.
//  ***REMOVED***
//
#import "JSTHandshakeViewController.h"
#import "JSTBaseSensor.h"
#import "JSTSensorManager.h"
#import "JSTMagnetometerSensor.h"
#import "JSTAppDelegate.h"
#import "JSTIRSensor.h"
#import "JSTHandshakeView.h"
#import "JSTDetailsResultView.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static int ddLogLevel = DDLogLevelAll;

@interface JSTHandshakeViewController () <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@property (nonatomic, strong) JSTSensorTag *sensorTag;
@property (nonatomic) float *values;
@property (nonatomic) NSUInteger valuesIdx;
@property (nonatomic) NSUInteger currentPercentageState;
@end

const NSUInteger JSTHandshakeViewControllerValuesDifferentialThreshold  = 1;
const NSUInteger JSTHandshakeViewControllerValuesRange  = 5; // 0,1s/value

@implementation JSTHandshakeViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        self.values = (float *) malloc(JSTHandshakeViewControllerValuesRange * sizeof(float));
        self.valuesIdx = 0;
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
    self.view = [[JSTHandshakeView alloc] initWithFrame:CGRectZero];
}

- (JSTHandshakeView *)handshakeView {
    if (self.isViewLoaded) {
        return (JSTHandshakeView *)self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensorTag.irSensor.sensorDelegate = self;
    [self.sensorTag.irSensor configureWithValue:JSTSensorIRTemperatureEnabled];
    [self.sensorTag.irSensor setPeriodValue:10];
    [self.sensorTag.irSensor setNotificationsEnabled:YES];
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
    if ([sensor isKindOfClass:[JSTIRSensor class]]) {
        JSTIRSensor *irSensor = (JSTIRSensor *) sensor;
        self.values[self.valuesIdx] = irSensor.objectTemperature;
        self.valuesIdx = (self.valuesIdx + 1) % JSTHandshakeViewControllerValuesRange;
        [self estimateValues];
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

    for (NSUInteger idx = 0; idx < JSTHandshakeViewControllerValuesRange; ++idx) {
        avg += self.values[idx];
        min = (min > self.values[idx] ? self.values[idx] : min);
        max = (max < self.values[idx] ? self.values[idx] : max);
    }
    if (max - min > JSTHandshakeViewControllerValuesDifferentialThreshold && !(self.valuesIdx % JSTHandshakeViewControllerValuesRange) && self.currentPercentageState < 100) {
        self.currentPercentageState += 25;
        __weak JSTHandshakeViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.handshakeView.resultView.resultLabel.text = (self.currentPercentageState != 100
                    ? [NSString stringWithFormat:@"%ld%%", (long)self.currentPercentageState]
                    : @"Hug me now!"
            );
            [weakSelf.handshakeView setNeedsLayout];
        });
    }
}

@end
