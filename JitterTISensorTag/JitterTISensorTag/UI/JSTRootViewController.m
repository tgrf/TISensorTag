//
//  JSTRootViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 22/12/14.
//  Copyright (c) 2014 mceconf.com. All rights reserved.
//

#import "JSTRootViewController.h"
#import "JSTSensorTag.h"
#import "JSTPressureSensor.h"
#import "JSTRootView.h"
#import "JSTDeviceListViewController.h"
#import "JSTAppDelegate.h"
#import "JSTKeysSensor.h"
#import "JSTGyroscopeSensor.h"
#import "JSTAccelerometerSensor.h"
#import "JSTHumiditySensor.h"
#import "JSTIRSensor.h"
#import "JSTMagnetometerSensor.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelAll;

@interface JSTRootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) JSTSensorManager *sensorManager;
@end

@implementation JSTRootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @" ";
    }

    return self;
}

- (void)loadView {
    JSTRootView *view = [[JSTRootView alloc] initWithFrame:CGRectZero];
    self.view = view;
}

- (JSTRootView *)rootView {
    if (self.isViewLoaded) {
        return (JSTRootView *)self.view;
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sensorManager = [JSTSensorManager sharedInstance];
    self.sensorManager.delegate = self;

}

#pragma mark - JSTSensorManagerDelegate

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor error:(NSError *)error {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
    sensor.keysSensor.sensorDelegate = self;
    [sensor.keysSensor setNotificationsEnabled:YES];

    sensor.gyroscopeSensor.sensorDelegate = self;
    [sensor.gyroscopeSensor configureWithValue:JSTSensorGyroscopeAllAxis];
    [sensor.gyroscopeSensor setNotificationsEnabled:YES];
    // Calibrate on first use
//    [sensor.gyroscopeSensor calibrate];

    sensor.accelerometerSensor.sensorDelegate = self;
    [sensor.accelerometerSensor configureWithValue:JSTSensorAccelerometer2GRange];
    [sensor.accelerometerSensor setNotificationsEnabled:YES];

    sensor.humiditySensor.sensorDelegate = self;
    [sensor.humiditySensor configureWithValue:JSTSensorHumidityEnabled];
    [sensor.humiditySensor setNotificationsEnabled:YES];

    sensor.irSensor.sensorDelegate = self;
    [sensor.irSensor configureWithValue:JSTSensorIRTemperatureEnabled];
    [sensor.irSensor setNotificationsEnabled:YES];

    sensor.magnetometerSensor.sensorDelegate = self;
    [sensor.magnetometerSensor configureWithValue:JSTSensorMagnetometerEnabled];
    [sensor.magnetometerSensor setNotificationsEnabled:YES];
    // Calibrate on first use
//    [sensor.magnetometerSensor calibrate];

    sensor.pressureSensor.sensorDelegate = self;
    // Start calibration flow
    [sensor.pressureSensor calibrate];

}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
}

- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {

}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTPressureSensor class]]) {
        JSTPressureSensor *pressureSensor = (JSTPressureSensor *) sensor;
        [pressureSensor configureWithValue:JSTSensorPressureEnabled];
        [pressureSensor setNotificationsEnabled:YES];
    }
}

@end
