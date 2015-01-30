//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTMorseViewController.h"
#import "JSTMorseDetector.h"
#import "JSTSensorManager.h"
#import "JSTAppDelegate.h"
#import "JSTBaseSensor.h"
#import "JSTGyroscopeSensor.h"
#import "JSTSafeViewController.h"
#import "JSTKeysSensor.h"
#import "JSTSensorTag.h"
#import "JSTMorseView.h"


@interface JSTMorseViewController ()
@property(nonatomic, strong) JSTMorseDetector *morseDetector;
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic, strong) JSTSensorTag *sensor;
@end

@implementation JSTMorseViewController {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.morseDetector = [[JSTMorseDetector alloc] init];
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;

        [self.morseDetector addObserver:self forKeyPath:NSStringFromSelector(@selector(text)) options:NSKeyValueObservingOptionNew context:nil];
    }

    return self;
}

- (void)dealloc {
    self.sensor.keysSensor.sensorDelegate = nil;
    [self.sensorManager disconnectSensor:self.sensor];

    [self.morseDetector removeObserver:self forKeyPath:NSStringFromSelector(@selector(text))];
}

- (void)loadView {
    self.view = [[JSTMorseView alloc] init];
}

- (JSTMorseView *)morseView {
    if (self.isViewLoaded) {
        return (JSTMorseView *) self.view;
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

#pragma mark - Sensor manager delegate

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    self.sensor = sensor;
    self.sensor.keysSensor.sensorDelegate = self;
    [self.sensor.keysSensor setNotificationsEnabled:YES];
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    if (manager.state == CBCentralManagerStatePoweredOn) {
        if ([manager hasPreviouslyConnectedSensor]) {
            [manager connectLastSensor];
        } else {
            [manager connectNearestSensor];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.morseDetector) {
        __weak JSTMorseViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.morseView.resultLabel.text = weakSelf.morseDetector.text;
            [weakSelf.morseView setNeedsLayout];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - Sensor delegate

- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTKeysSensor class]]) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        JSTKeysSensor *keysSensor = (JSTKeysSensor *) sensor;
        [self.morseDetector updateWithLeftKeyPress:keysSensor.pressedLeftButton rightKeyPressed:keysSensor.pressedRightButton];
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

@end
