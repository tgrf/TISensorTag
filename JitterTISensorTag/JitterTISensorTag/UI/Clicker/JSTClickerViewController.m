//
// Created by Blazej Marcinkiewicz on 01/02/15.
// ***REMOVED***
//

#import "JSTClickerViewController.h"
#import "JSTClickerView.h"
#import "JSTSensorManager.h"
#import "JSTAppDelegate.h"
#import "JSTSensorTag.h"
#import "JSTClicker.h"
#import "JSTKeysSensor.h"


@interface JSTClickerViewController ()
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic, strong) JSTSensorTag *firstSensor;
@property(nonatomic, strong) JSTClicker *firstClicker;
@property(nonatomic, strong) JSTClicker *secondClicker;
@property(nonatomic, strong) JSTSensorTag *secondSensor;
@end

@implementation JSTClickerViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;
    }

    return self;
}

- (void)dealloc {
    [self.sensorManager disconnectSensor:self.firstSensor];
    [self.sensorManager disconnectSensor:self.secondSensor];
}

- (void)loadView {
    [super loadView];

    JSTClickerView *view = [[JSTClickerView alloc] init];
    [view.resetButton addTarget:self action:@selector(didTapReset) forControlEvents:UIControlEventTouchUpInside];
    self.view = view;

    [self startScan];
}

- (JSTClickerView *)clickerView {
    if (self.isViewLoaded) {
        return (JSTClickerView *) self.view;
    }
    return nil;
}

- (void)startScan {
    if (self.sensorManager.state == CBCentralManagerStatePoweredOn) {
        [self.sensorManager startScanning];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(didFinishSearch) withObject:nil afterDelay:5.f];
        });
    }
}

- (void)didFinishSearch {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    [self.sensorManager stopScanning];
    NSArray *sortedPeripherals = [self.sensorManager.sensors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(rssi)) ascending:NO]]];
    if (sortedPeripherals.count < 2) {
        NSLog(@"Error retrying search");
        [self.sensorManager startScanning];
    } else {
        self.firstSensor = sortedPeripherals[0];
        self.secondSensor = sortedPeripherals[1];

        [self.sensorManager connectSensorWithUUID:self.firstSensor.peripheral.identifier];
    }
}

- (void)didTapReset {
    [self.firstClicker resetProgress];
    [self.secondClicker resetProgress];
    [self updateUI];
}

#pragma mark - Sensor manager delegate

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    if (self.firstClicker == nil) {
        self.firstClicker = [[JSTClicker alloc] initWithSensor:sensor.keysSensor];
        self.firstClicker.clickerDelegate = self;
        [sensor.keysSensor setNotificationsEnabled:YES];
        [self.sensorManager connectSensorWithUUID:self.secondSensor.peripheral.identifier];
    } else if (self.secondClicker == nil) {
        self.secondSensor = sensor;
        self.secondClicker = [[JSTClicker alloc] initWithSensor:sensor.keysSensor];
        self.secondClicker.clickerDelegate = self;
        [sensor.keysSensor setNotificationsEnabled:YES];
    }
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    [self startScan];
}

- (void)clickerDidClick:(JSTClicker *)clicker {
    if (clicker.progress == 100) {
        [self.firstClicker stop];
        [self.secondClicker stop];
    }

    [self updateUI];
}

- (void)updateUI {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.clickerView.firstPlayerProgress.value = self.firstClicker.progress;
        self.clickerView.secondPlayerProgress.value = self.secondClicker.progress;
    });
}

@end
