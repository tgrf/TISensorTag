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
#import "JSTDetailsResultView.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static int ddLogLevel = DDLogLevelAll;

@interface JSTBlowViewController () <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@property (nonatomic) float *values;
@property (nonatomic) NSUInteger valuesIdx;
@property (nonatomic) NSUInteger currentPercentageState;
@end

const float JSTBlowViewControllerValuesDifferentialThreshold = 5;
const NSUInteger JSTBlowViewControllerValuesRange = 5; // 0,1s/value
const NSUInteger JSTBlowViewControllerValuesEdgesRange = 2;

@implementation JSTBlowViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        self.values = (float *) malloc(JSTBlowViewControllerValuesRange * sizeof(float));
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

    self.sensorTag.humiditySensor.sensorDelegate = self;
    [self.sensorTag.humiditySensor configureWithValue:JSTSensorHumidityEnabled];
    [self.sensorTag.humiditySensor setPeriodValue:10];
    [self.sensorTag.humiditySensor setNotificationsEnabled:YES];
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
    if ([sensor isKindOfClass:[JSTHumiditySensor class]]) {
        JSTHumiditySensor *humiditySensor = (JSTHumiditySensor *) sensor;
        self.values[self.valuesIdx] = humiditySensor.humidity;

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
    if (self.hasRaised && max - min > JSTBlowViewControllerValuesDifferentialThreshold && !(self.valuesIdx % JSTBlowViewControllerValuesRange)) {
        self.currentPercentageState += 33;
        __weak JSTBlowViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.blowView.resultView.resultLabel.text = (self.currentPercentageState < 99
                    ? [NSString stringWithFormat:@"%ld%%", (long)self.currentPercentageState]
                    : @"Wow!");
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
