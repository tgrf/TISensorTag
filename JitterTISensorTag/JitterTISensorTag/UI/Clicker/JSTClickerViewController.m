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

- (void)setSensors:(NSArray *)sensors {
    self.firstSensor = [sensors firstObject];
    self.firstClicker = [[JSTClicker alloc] initWithSensor:self.firstSensor.keysSensor];
    self.firstClicker.clickerDelegate = self;
    [self.firstSensor.keysSensor setNotificationsEnabled:YES];

    self.secondSensor = [sensors lastObject];
    self.secondClicker = [[JSTClicker alloc] initWithSensor:self.secondSensor.keysSensor];
    self.secondClicker.clickerDelegate = self;
    [self.secondSensor.keysSensor setNotificationsEnabled:YES];
}

- (void)loadView {
    [super loadView];

    JSTClickerView *view = [[JSTClickerView alloc] init];
    [view.resetButton addTarget:self action:@selector(didTapReset) forControlEvents:UIControlEventTouchUpInside];
    self.view = view;
}

- (JSTClickerView *)clickerView {
    if (self.isViewLoaded) {
        return (JSTClickerView *) self.view;
    }
    return nil;
}

- (void)didTapReset {
    [self.firstClicker resetProgress];
    [self.secondClicker resetProgress];
    [self updateUI];
}

#pragma mark - Sensor manager delegate

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
