//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTSafeViewController.h"
#import "JSTSensorManager.h"
#import "JSTAppDelegate.h"
#import "JSTSensorTag.h"
#import "JSTGyroscopeSensor.h"
#import "JSTSafeView.h"
#import "JSTSafe.h"
#import "JSTSafeCombinationValue.h"

@interface JSTSafeViewController ()
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic) BOOL isCalibrated;
@property(nonatomic) float lastRead;
@property(nonatomic) float currentRead;
@property(nonatomic) float currentValue;
@property(nonatomic) int resetCounter;
@property(nonatomic, strong) NSArray *values;
@property(nonatomic, strong) JSTSafe *safe;
@end

@implementation JSTSafeViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        JSTSafeCombinationValue *value1 = [[JSTSafeCombinationValue alloc] init];
        value1.direction = JSTSafeRotationDirectionLeft;
        value1.rotationValue = 3;

        JSTSafeCombinationValue *value2 = [[JSTSafeCombinationValue alloc] init];
        value2.direction = JSTSafeRotationDirectionRight;
        value2.rotationValue = 3;

        self.safe = [[JSTSafe alloc] initWithCombinationValue:@[value1, value2]];
    }

    return self;
}

- (void)dealloc {
    self.sensorTag.gyroscopeSensor.sensorDelegate = nil;
    [self.sensorManager disconnectSensor:self.sensorTag];
}

- (void)loadView {
    JSTSafeView *view = [[JSTSafeView alloc] init];
    [view.startButton addTarget:self action:@selector(calibrate) forControlEvents:UIControlEventTouchUpInside];
    [view setNumberOfValues:2];
    self.view = view;
}

- (void)calibrate {
    [self.sensorTag.gyroscopeSensor calibrate];
    [self.safe reset];
}

- (JSTSafeView *)safeView {
    if (self.isViewLoaded) {
        return (JSTSafeView *) self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensorTag.gyroscopeSensor.sensorDelegate = self;
    [self.sensorTag.gyroscopeSensor configureWithValue:JSTSensorGyroscopeAllAxis];
    [self.sensorTag.gyroscopeSensor setPeriodValue:10];
    [self.sensorTag.gyroscopeSensor setNotificationsEnabled:YES];
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

#pragma mark - Sensor delegate

- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTGyroscopeSensor class]]) {
        JSTGyroscopeSensor *gyroscopeSensor = (JSTGyroscopeSensor *) sensor;
        if (!self.isCalibrated) {
            self.isCalibrated = YES;
            [gyroscopeSensor calibrate];
        } else {
            [self.safe updateWithRead:gyroscopeSensor.value.z];

            __weak JSTSafeViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.safeView.resultLabel.text = [NSString stringWithFormat:@"%@", self.safe.isCombinationCorrect ? @"\uf09c" : @"\uf023"];
                [weakSelf.safeView setNumberOfCorrectValues:[weakSelf.safe numberOfCorrectValuesFromStart]];
                [weakSelf.safeView setNeedsLayout];
            });
        }
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

@end
