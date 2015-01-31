//
//  JSTBlowViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 31/01/15.
//  ***REMOVED***
//
#import "JSTBlowViewController.h"
#import "JSTBaseSensor.h"
#import "JSTSensorManager.h"
#import "JSTHumiditySensor.h"
#import "JSTAppDelegate.h"
#import "JSTBlowView.h"
#import "JSTSensorTag.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static int ddLogLevel = DDLogLevelAll;

@interface JSTBlowViewController () <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@property (nonatomic, strong) JSTSensorTag *sensorTag;
@property (nonatomic) float *values;
@property (nonatomic) NSUInteger valuesIdx;
@end

const float JSTBlowViewControllerValuesDifferentialThreshold = 20;
const NSUInteger JSTBlowViewControllerValuesRange = 6; // 0,1s/value
const NSUInteger JSTBlowViewControllerValuesEdgesRange = 2;

@implementation JSTBlowViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        self.values = (float *) malloc(JSTBlowViewControllerValuesRange * sizeof(float));
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
    self.view = [[JSTBlowView alloc] initWithFrame:CGRectZero];
}

- (JSTBlowView *)blowView {
    if (self.isViewLoaded) {
        return (JSTBlowView *)self.view;
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

    sensor.humiditySensor.sensorDelegate = self;
    [sensor.humiditySensor configureWithValue:JSTSensorHumidityEnabled];
    [sensor.humiditySensor setNotificationsEnabled:YES];
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
    if ([sensor isKindOfClass:[JSTHumiditySensor class]]) {
        JSTHumiditySensor *humiditySensor = (JSTHumiditySensor *) sensor;
        self.values[self.valuesIdx] = humiditySensor.humidity;

        NSLog(@"humiditySensor.humidity = %f", humiditySensor.humidity);

        self.valuesIdx = (self.valuesIdx + 1) % JSTBlowViewControllerValuesRange;
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

    for (NSUInteger idx = 0; idx < JSTBlowViewControllerValuesRange; ++idx) {
        avg += self.values[idx];
        min = (min > self.values[idx] ? self.values[idx] : min);
        max = (max < self.values[idx] ? self.values[idx] : max);
    }
    if (!self.hasRaised && max - min > JSTBlowViewControllerValuesDifferentialThreshold && !(self.valuesIdx % JSTBlowViewControllerValuesRange)) {
        __weak JSTBlowViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.blowView.valuesLabel.text = [NSString stringWithFormat:@"Stop blowing! %f\tHumidity: %f", max-min, self.values[self.valuesIdx]];
            [weakSelf.blowView setNeedsLayout];
        });
    }
}

- (BOOL)hasRaised {
    float leftEdgeAvg  = -1.0f;
    float rightEdgeAvg = -1.0f;

    for (NSUInteger beginIdx = 0, endIdx = JSTBlowViewControllerValuesRange - 1;
         beginIdx < JSTBlowViewControllerValuesEdgesRange && endIdx > JSTBlowViewControllerValuesRange - JSTBlowViewControllerValuesEdgesRange - 1;
         ++beginIdx, --endIdx) {
        leftEdgeAvg  += self.values[beginIdx];
        rightEdgeAvg += self.values[endIdx];
    }

    return (leftEdgeAvg/JSTBlowViewControllerValuesEdgesRange < rightEdgeAvg/JSTBlowViewControllerValuesEdgesRange);
}

@end
