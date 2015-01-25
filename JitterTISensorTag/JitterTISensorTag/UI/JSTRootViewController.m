//
//  JSTRootViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 22/12/14.
//  ***REMOVED***
//

#import "JSTRootViewController.h"
#import "JSTSensorTag.h"
#import "JSTKeysSensor.h"
#import "JSTGyroscopeSensor.h"
#import "JSTAccelerometerSensor.h"
#import "JSTHumiditySensor.h"
#import "JSTIRSensor.h"
#import "JSTMagnetometerSensor.h"
#import "JSTPressureSensor.h"
#import "JSTAppDelegate.h"
#import "JSTRootView.h"
#import "JSTCadenceViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelAll;

@interface JSTRootViewController ()

@property(nonatomic, strong) JSTSensorManager *sensorManager;
@end

@implementation JSTRootViewController

- (void)loadView {
    JSTRootView *view = [[JSTRootView alloc] init];
    self.view = view;

    [view.cadenceButton addTarget:self action:@selector(didTapCadenceButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapCadenceButton {
    [self.navigationController pushViewController:[[JSTCadenceViewController alloc] init] animated:YES];
}

- (JSTRootView *)rootView {
    if (self.isViewLoaded) {
        return (JSTRootView *) self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
//    self.sensorManager = [JSTSensorManager sharedInstance];
//    self.sensorManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.sensorManager.delegate = self;
}


#pragma mark - JSTSensorManagerDelegate

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
//    if (state == CBPeripheralManagerStatePoweredOn) {
//        [manager connectLastSensor];
//    }
}

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);

//    sensor.keysSensor.sensorDelegate = self;
//    [sensor.keysSensor setNotificationsEnabled:YES];
//
//    sensor.gyroscopeSensor.sensorDelegate = self;
//    [sensor.gyroscopeSensor configureWithValue:JSTSensorGyroscopeAllAxis];
//    [sensor.gyroscopeSensor setNotificationsEnabled:YES];
//    [sensor.gyroscopeSensor calibrate];
//
//    sensor.accelerometerSensor.sensorDelegate = self;
//    [sensor.accelerometerSensor configureWithValue:JSTSensorAccelerometer2GRange];
//    [sensor.accelerometerSensor setNotificationsEnabled:YES];
//
//    sensor.humiditySensor.sensorDelegate = self;
//    [sensor.humiditySensor configureWithValue:JSTSensorHumidityEnabled];
//    [sensor.humiditySensor setNotificationsEnabled:YES];
//
//    sensor.irSensor.sensorDelegate = self;
//    [sensor.irSensor configureWithValue:JSTSensorIRTemperatureEnabled];
//    [sensor.irSensor setNotificationsEnabled:YES];
//
//    sensor.magnetometerSensor.sensorDelegate = self;
//    [sensor.magnetometerSensor configureWithValue:JSTSensorMagnetometerEnabled];
//    [sensor.magnetometerSensor setNotificationsEnabled:YES];
//    [sensor.magnetometerSensor calibrate];
//
//    sensor.pressureSensor.sensorDelegate = self;
//    [sensor.pressureSensor calibrate];
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
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
