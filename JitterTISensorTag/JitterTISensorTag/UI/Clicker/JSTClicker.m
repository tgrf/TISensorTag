//
// Created by Blazej Marcinkiewicz on 01/02/15.
// ***REMOVED***
//

#import "JSTClicker.h"
#import "JSTSensorTag.h"
#import "JSTKeysSensor.h"

typedef enum {
    JSTClickerStateLeftClick,
    JSTClickerStateRightClick,
    JSTClickerStateStop
} JSTClickerState;

@interface JSTClicker ()
@property(nonatomic) JSTClickerState state;
@property(nonatomic, strong) JSTKeysSensor *sensor;
@property (nonatomic, readwrite) int progress;
@end

@implementation JSTClicker {

}

- (instancetype)initWithSensor:(JSTKeysSensor *)keysSensor {
    self = [self init];
    if (self) {
        self.state = JSTClickerStateLeftClick;
        self.sensor = keysSensor;
        self.sensor.sensorDelegate = self;
    }

    return self;
}

- (void)resetProgress {
    self.progress = 0;
    self.state = JSTClickerStateLeftClick;
}

- (void)stop {
    self.state = JSTClickerStateStop;
}

#pragma mark -
- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {
    if (self.state == JSTClickerStateStop) {
        return;
    }

    if ([sensor isKindOfClass:[JSTKeysSensor class]]) {
        JSTKeysSensor *keysSensor = (JSTKeysSensor *) sensor;
        if (self.state == JSTClickerStateLeftClick && keysSensor.pressedLeftButton && !keysSensor.pressedRightButton) {
            ++self.progress;
            [self.clickerDelegate clickerDidClick:self];
            self.state = JSTClickerStateRightClick;
        } else if (self.state == JSTClickerStateRightClick && !keysSensor.pressedLeftButton && keysSensor.pressedRightButton) {
            ++self.progress;
            self.state = JSTClickerStateLeftClick;
            [self.clickerDelegate clickerDidClick:self];
        }
    }
}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {

}

@end
