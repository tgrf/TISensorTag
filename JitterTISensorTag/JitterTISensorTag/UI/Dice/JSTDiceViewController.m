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
#import "JSTDetailsResultView.h"


@interface JSTDiceViewController ()
@property(nonatomic, strong) JSTSensorManager *sensorManager;
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
    self.sensorTag.accelerometerSensor.sensorDelegate = nil;
    [self.sensorManager disconnectSensor:self.sensorTag];
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

    self.sensorTag.accelerometerSensor.sensorDelegate = self;
    [self.sensorTag.accelerometerSensor setPeriodValue:10];
    [self.sensorTag.accelerometerSensor configureWithValue:JSTSensorAccelerometer2GRange];
    [self.sensorTag.accelerometerSensor setNotificationsEnabled:YES];
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

#pragma mark - JSTBaseSensorDelegate

- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTAccelerometerSensor class]]) {
        JSTAccelerometerSensor *accelerometerSensor = (JSTAccelerometerSensor *) sensor;
        JSTVector3D value = accelerometerSensor.acceleration;
        [self.dice updateWithValue:value];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.diceView.resultView.resultLabel.text = self.dice.value;
            [self.diceView setNeedsLayout];
        });
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

@end
