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
#import <CocoaLumberjack/CocoaLumberjack.h>

static int ddLogLevel = DDLogLevelAll;

@interface JSTWandViewController () <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@property (nonatomic, strong) JSTSensorTag *sensorTag;
@property (nonatomic) BOOL isCalibrated;
@property (nonatomic) float *values;
@property (nonatomic) NSUInteger valuesIdx;
@end

const NSUInteger JSTWandViewControllerValuesRange  = 10; // 0,1s/value

@implementation JSTWandViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        self.values = (float *) malloc(JSTWandViewControllerValuesRange * sizeof(float));
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

    if (self.sensorManager.state == CBCentralManagerStatePoweredOn) {
        [self.sensorManager connectNearestSensor];
    }
}

#pragma mark - JSTSensorManagerDelegate

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    self.sensorTag = sensor;

    sensor.magnetometerSensor.sensorDelegate = self;
    [sensor.magnetometerSensor configureWithValue:JSTSensorMagnetometerEnabled];
    [sensor.magnetometerSensor setPeriodValue:10];
    [sensor.magnetometerSensor setNotificationsEnabled:YES];
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    if (manager.state == CBCentralManagerStatePoweredOn) {
        [manager connectNearestSensor];
    }
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

            __weak JSTWandViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.wandView.valuesLabel.text = [NSString stringWithFormat:@"Length: %f\nValues: %f\n%f\n%f", length, magnetometerSensor.value.x, magnetometerSensor.value.y, magnetometerSensor.value.z];
                [weakSelf.wandView setNeedsLayout];
            });
        }
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

- (void)estimateValues {
    float diff = 0.0f;
    for (NSUInteger idx = 0; idx < self.valuesIdx; ++idx) {
        diff += self.values[idx];
    }
    NSLog(@"diff = %f", diff);
}

@end
