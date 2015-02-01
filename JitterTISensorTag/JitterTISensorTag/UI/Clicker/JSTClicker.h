//
// Created by Blazej Marcinkiewicz on 01/02/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTBaseSensor.h"

@class JSTKeysSensor;
@class JSTClicker;

@protocol JSTClickerDelegate
- (void)clickerDidClick:(JSTClicker *)clicker;
@end

@interface JSTClicker : NSObject<JSTBaseSensorDelegate>

@property (nonatomic, weak) id<JSTClickerDelegate> clickerDelegate;

@property (nonatomic, readonly) int progress;

- (instancetype)initWithSensor:(JSTKeysSensor *)keysSensor;

- (void)stop;

- (void)resetProgress;

@end
