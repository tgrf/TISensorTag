//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import "JSTCadenceViewController.h"
#import "JSTCadenceView.h"
#import "JSTSensorManager.h"
#import "JSTSensorTag.h"
#import "JSTGyroscopeSensor.h"
#import "JSTAppDelegate.h"


@interface JSTCadenceViewController ()
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic) BOOL isCalibrated;
@property(nonatomic, strong) JSTSensorTag *sensor;
@end

@implementation JSTCadenceViewController {

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
    self.sensor.gyroscopeSensor.sensorDelegate = nil;
    [self.sensorManager disconnectSensor:self.sensor];
}

- (void)loadView {
    self.view = [[JSTCadenceView alloc] init];
}

- (JSTCadenceView *)cadenceView {
    if (self.isViewLoaded) {
        return (JSTCadenceView *) self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.sensorManager.state == CBCentralManagerStatePoweredOn) {
        [self.sensorManager connectNearestSensor];
    }
}

#pragma mark - Sensor manager delegate
- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    self.sensor = sensor;
    sensor.gyroscopeSensor.sensorDelegate = self;
    [sensor.gyroscopeSensor configureWithValue:JSTSensorGyroscopeAllAxis];
    [sensor.gyroscopeSensor setPeriodValue:10];
    [sensor.gyroscopeSensor setNotificationsEnabled:YES];
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
    if ([sensor isKindOfClass:[JSTGyroscopeSensor class]]) {
        JSTGyroscopeSensor *gyroscopeSensor = (JSTGyroscopeSensor *) sensor;
        if (!self.isCalibrated) {
            self.isCalibrated = YES;
            [gyroscopeSensor calibrate];
        } else {
            float cadence = 0.f;
            float length = gyroscopeSensor.value.x * gyroscopeSensor.value.x + gyroscopeSensor.value.y * gyroscopeSensor.value.y + gyroscopeSensor.value.z * gyroscopeSensor.value.z;
            length = sqrtf(length);
            cadence = length / 6.f;
            NSLog(@"Values %f %f %f length %f cadence %f", gyroscopeSensor.value.x, gyroscopeSensor.value.y, gyroscopeSensor.value.z, length, cadence);

            __weak JSTCadenceViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.cadenceView.resultLabel.text = [NSString stringWithFormat:@"Cadence: %f", cadence];
                [weakSelf.cadenceView setNeedsLayout];
            });
        }
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

@end
