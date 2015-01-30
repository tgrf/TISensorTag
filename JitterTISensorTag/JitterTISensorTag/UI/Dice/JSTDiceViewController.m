//
// Created by Blazej Marcinkiewicz on 30/01/15.
// ***REMOVED***
//

#import "JSTDiceViewController.h"
#import "JSTDiceView.h"
#import "JSTAppDelegate.h"
#import "JSTSensorTag.h"
#import "JSTAccelerometerSensor.h"
#import "JSTDice.h"


@interface JSTDiceViewController ()
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic, strong) JSTSensorTag *sensor;
@property(nonatomic, strong) JSTDice *dice;
@end

@implementation JSTDiceViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;
        
        self.dice = [[JSTDice alloc] init];
    }

    return self;
}

- (void)dealloc {
    self.sensor.accelerometerSensor.sensorDelegate = nil;
    [self.sensorManager disconnectSensor:self.sensor];
}

- (void)loadView {
    self.view = [[JSTDiceView alloc] init];
}

- (JSTDiceView *)diceView {
    if (self.isViewLoaded) {
        return (JSTDiceView *) self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.sensorManager.state == CBCentralManagerStatePoweredOn) {
        if ([self.sensorManager hasPreviouslyConnectedSensor]) {
            [self.sensorManager connectLastSensor];
        } else {
            [self.sensorManager connectNearestSensor];
        }
    }
}


#pragma mark - JSTSensorManagerDelegate
- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    self.sensor = sensor;
    sensor.accelerometerSensor.sensorDelegate = self;
    [sensor.accelerometerSensor setPeriodValue:10];
    [sensor.accelerometerSensor configureWithValue:JSTSensorAccelerometer2GRange];
    [sensor.accelerometerSensor setNotificationsEnabled:YES];
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    if (self.sensorManager.state == CBCentralManagerStatePoweredOn) {
        if ([self.sensorManager hasPreviouslyConnectedSensor]) {
            [self.sensorManager connectLastSensor];
        } else {
            [self.sensorManager connectNearestSensor];
        }
    }
}

#pragma mark - JSTBaseSensorDelegate

- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTAccelerometerSensor class]]) {
        JSTAccelerometerSensor *accelerometerSensor = (JSTAccelerometerSensor *) sensor;
        JSTVector3D value = accelerometerSensor.acceleration;
        [self.dice updateWithValue:value];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.diceView.resultLabel.text = self.dice.value;
            [self.diceView setNeedsLayout];
        });
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

@end
