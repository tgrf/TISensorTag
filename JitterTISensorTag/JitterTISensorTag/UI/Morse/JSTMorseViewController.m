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
        [self.morseDetector addObserver:self forKeyPath:NSStringFromSelector(@selector(sign)) options:NSKeyValueObservingOptionNew context:nil];
    }

    return self;
}

- (void)dealloc {
    self.sensorTag.keysSensor.sensorDelegate = nil;
    [self.sensorManager disconnectSensor:self.sensorTag];

    [self.morseDetector removeObserver:self forKeyPath:NSStringFromSelector(@selector(text))];
    [self.morseDetector removeObserver:self forKeyPath:NSStringFromSelector(@selector(sign))];
}

- (void)loadView {
    JSTMorseView *view = [[JSTMorseView alloc] init];
    view.textLabel.text = [self.morseDetector.text stringByAppendingString:@"#jitter #mceconf"];
    [view setSymbolMapping:self.morseDetector.symbolMapping];
    self.view = view;
}

- (JSTMorseView *)morseView {
    if (self.isViewLoaded) {
        return (JSTMorseView *) self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sensorTag.keysSensor.sensorDelegate = self;
    [self.sensorTag.keysSensor setNotificationsEnabled:YES];
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.morseDetector) {
        __weak JSTMorseViewController *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.morseView.textLabel.text = [weakSelf.morseDetector.text stringByAppendingString:@"#jitter #mceconf"];
            weakSelf.morseView.currentSignLabel.text = weakSelf.morseDetector.sign;
            [weakSelf.morseView setActiveSymbol:weakSelf.morseDetector.sign];
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
