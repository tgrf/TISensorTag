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
#import <CocoaLumberjack/CocoaLumberjack.h>

static int ddLogLevel = DDLogLevelAll;

@interface JSTHandshakeViewController () <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@property (nonatomic, strong) JSTSensorTag *sensorTag;
@property (nonatomic) float *values;
@property (nonatomic) NSUInteger valuesIdx;
@end

const NSUInteger JSTWandViewControllerValuesRange  = 10; // 0,1s/value

@implementation JSTHandshakeViewController

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

    if (self.sensorManager.state == CBCentralManagerStatePoweredOn) {
        [self.sensorManager connectNearestSensor];
    }
}

#pragma mark - JSTSensorManagerDelegate

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    self.sensorTag = sensor;

    sensor.irSensor.sensorDelegate = self;
    [sensor.irSensor configureWithValue:JSTSensorIRTemperatureEnabled];
    [sensor.irSensor setPeriodValue:10];
    [sensor.irSensor setNotificationsEnabled:YES];
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
    if ([sensor isKindOfClass:[JSTIRSensor class]]) {
        JSTIRSensor *irSensor = (JSTIRSensor *) sensor;
        self.values[self.valuesIdx] = irSensor.objectTemperature;
        self.valuesIdx = (self.valuesIdx + 1) % JSTWandViewControllerValuesRange;
        [self estimateValues];

        __weak JSTHandshakeViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.handshakeView.valuesLabel.text = [NSString stringWithFormat:@"Temperature: %f", irSensor.objectTemperature];
            [weakSelf.handshakeView setNeedsLayout];
        });
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
