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
#import "JSTCadenceViewController.h"
#import "JSTSafeViewController.h"
#import "JSTWandViewController.h"
#import "JSTHandshakeViewController.h"
#import "JSTMorseViewController.h"
#import "JSTDiceViewController.h"
#import "JSTBlowViewController.h"
#import "JSTPressureViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelAll;

@interface JSTRootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readonly) JSTSensorManager *sensorManager;
@property (nonatomic, strong, readonly) NSArray *gamesConfiguration;
@end

NSString *JSTRootViewControllerCellIdentifier = @"JSTRootViewTableViewCell";

@implementation JSTRootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _gamesConfiguration = @[
                @{ @"name" : @"Cadence",    @"class" : NSStringFromClass(JSTCadenceViewController.class),           @"icon" : @"icon_name" },
                @{ @"name" : @"Safe",       @"class" : NSStringFromClass(JSTSafeViewController.class),              @"icon" : @"icon_name" },
                @{ @"name" : @"Wand",       @"class" : NSStringFromClass(JSTWandViewController.class),              @"icon" : @"icon_name" },
                @{ @"name" : @"Handshake",  @"class" : NSStringFromClass(JSTHandshakeViewController.class),         @"icon" : @"icon_name" },
                @{ @"name" : @"Dice",       @"class" : NSStringFromClass(JSTDiceViewController.class),              @"icon" : @"icon_name" },
                @{ @"name" : @"Pressure",   @"class" : NSStringFromClass(JSTPressureViewController.class),          @"icon" : @"icon_name" },
                @{ @"name" : @"Morse",      @"class" : NSStringFromClass(JSTMorseViewController.class),             @"icon" : @"icon_name" },
                @{ @"name" : @"Fast click", @"class" : NSStringFromClass(JSTCadenceViewController.class),           @"icon" : @"icon_name" },
                @{ @"name" : @"Blow",       @"class" : NSStringFromClass(JSTBlowViewController.class),              @"icon" : @"icon_name" },
        ];
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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rootView.gamesTableView.delegate = self;
    self.rootView.gamesTableView.dataSource = self;
    [self.rootView.gamesTableView registerClass:[UITableViewCell class]
                         forCellReuseIdentifier:JSTRootViewControllerCellIdentifier];

//    self.sensorManager = [JSTSensorManager sharedInstance];
//    self.sensorManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.sensorManager.delegate = self;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gamesConfiguration.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = [self.rootView.gamesTableView dequeueReusableCellWithIdentifier:JSTRootViewControllerCellIdentifier
                                                                                        forIndexPath:indexPath];
    tableViewCell.textLabel.text = _gamesConfiguration[(NSUInteger)indexPath.row][@"name"];

    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rootView.gamesTableView deselectRowAtIndexPath:indexPath animated:YES];

    Class controllerClass = NSClassFromString(_gamesConfiguration[(NSUInteger)indexPath.row][@"class"]);
    UIViewController *viewController = (UIViewController *)[controllerClass new];

    [self.navigationController pushViewController:viewController animated:YES];
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
