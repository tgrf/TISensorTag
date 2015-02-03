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
#import "JSTDetailsResultView.h"
#import "DDLogMacros.h"
static int ddLogLevel = DDLogLevelError;

@interface JSTCadenceViewController ()
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic) BOOL isCalibrated;
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
    self.sensorTag.gyroscopeSensor.sensorDelegate = nil;
    [self.sensorManager disconnectSensor:self.sensorTag];
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
            float cadence = 0.f;
            float length = gyroscopeSensor.value.x * gyroscopeSensor.value.x + gyroscopeSensor.value.y * gyroscopeSensor.value.y + gyroscopeSensor.value.z * gyroscopeSensor.value.z;
            length = sqrtf(length);
            cadence = length / 6.f; // length / 360 deg * 60s (to get RPM)
            DDLogDebug(@"Values %f %f %f length %f cadence %f", gyroscopeSensor.value.x, gyroscopeSensor.value.y, gyroscopeSensor.value.z, length, cadence);

            __weak JSTCadenceViewController *weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *arrow;
                if (cadence < 29) {
                    arrow = @"\u25B2";
                } else if (cadence > 31){
                    arrow = @"\u25BC";
                } else {
                    arrow = @"\u2713";
                }
                weakSelf.cadenceView.resultView.resultLabel.text = [NSString stringWithFormat:@"%.0f RPM %@", cadence, arrow];
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
