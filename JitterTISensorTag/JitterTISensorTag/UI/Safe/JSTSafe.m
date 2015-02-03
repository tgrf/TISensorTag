//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTSafe.h"
#import "JSTSafeCombinationValue.h"


@interface JSTSafe ()
@property(nonatomic) float currentRead;
@property(nonatomic) JSTSafeRotationDirection previousDirection;
@property(nonatomic) float currentValue;
@property(nonatomic, readwrite) NSArray *values;

@property(nonatomic, strong) NSArray *safeCombination;
@end

@implementation JSTSafe {

}

- (instancetype)initWithCombinationValue:(NSArray *)safeCombination {
    self = [super init];
    if (self) {
        self.values = @[];
        self.safeCombination = safeCombination;
        self.range = 20;

        NSMutableArray *combination = [NSMutableArray array];
        int currentValue = 0;
        for (JSTSafeCombinationValue *value in self.safeCombination) {
            if (value.direction == JSTSafeRotationDirectionLeft) {
                currentValue -= value.rotationValue;
            } else {
                currentValue += value.rotationValue;
            }

            if (currentValue < 0) {
                currentValue += self.range;
            } else if (currentValue >= self.range) {
                currentValue -= self.range;
            }

            JSTSafeCombinationValue *safeValue = [[JSTSafeCombinationValue alloc] init];
            safeValue.rotationValue = currentValue;
            safeValue.direction = value.direction;
            [combination addObject:safeValue];
        }

        self.safeCombination = combination;
    }

    return self;
}

- (void)updateWithRead:(float)value {
    self.currentRead = value;
    
    // Check if move was started
    float threshold = 5.f;
    if (fabsf(self.currentRead) < threshold) {
    } else if (self.currentRead > 0) {
        if (self.previousDirection == JSTSafeRotationDirectionRight) {
            JSTSafeCombinationValue *value = [[JSTSafeCombinationValue alloc] init];
            value.direction = JSTSafeRotationDirectionRight;
            value.rotationValue = (int) self.currentValue;
            self.values = [self.values arrayByAddingObject:value];
        }
        self.currentValue -= (self.currentRead * 0.1f) / (360.f / self.range);
        self.previousDirection = JSTSafeRotationDirectionLeft;
    } else {
        if (self.previousDirection == JSTSafeRotationDirectionLeft) {
            JSTSafeCombinationValue *value = [[JSTSafeCombinationValue alloc] init];
            value.direction = JSTSafeRotationDirectionLeft;
            value.rotationValue = (int) self.currentValue;
            self.values = [self.values arrayByAddingObject:value];
        }
        self.currentValue -= (self.currentRead * 0.1f) / (360.f / self.range);
        self.previousDirection = JSTSafeRotationDirectionRight;
    }

    if (self.currentValue < 0) {
        self.currentValue += self.range;
    } else if (self.currentValue >= self.range) {
        self.currentValue -= self.range;
    }

    NSLog(@"%@", @((int)self.currentValue));

    if (self.values.count > self.safeCombination.count) {
        self.values = @[];
    }
}

- (int)currentSafeValue {
    return (int) self.currentValue;
}

- (BOOL)isCombinationCorrect {
    BOOL isCorrect = YES;
    if (self.safeCombination.count != self.values.count) {
        return NO;
    }

    for (int i = 0; i < self.safeCombination.count; ++i) {
        JSTSafeCombinationValue *combinationValue = self.safeCombination[i];
        JSTSafeCombinationValue *currentValue = self.values[i];
        if (combinationValue.direction != currentValue.direction || combinationValue.rotationValue != currentValue.rotationValue) {
            isCorrect = NO;
            break;
        }
    }
    return isCorrect;
}

- (int)numberOfCorrectValuesFromStart {
    int result = 0;
    for (int i = 0; i < self.safeCombination.count && i < self.values.count; ++i) {
        JSTSafeCombinationValue *combinationValue = self.safeCombination[i];
        JSTSafeCombinationValue *currentValue = self.values[i];
        if (combinationValue.direction != currentValue.direction || combinationValue.rotationValue != currentValue.rotationValue) {
            break;
        }
        ++result;
    }
    return result;
}


- (void)reset {
    self.currentValue = 0;
    self.values = @[];
}
@end
