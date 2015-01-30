//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTMorseDetector.h"

typedef enum {
    JSTMorseDetectorStateIdle,
    JSTMorseDetectorStateSignalDetection,
    JSTMorseDetectorStateCancelDetection,
    JSTMorseDetectorStateSendDetection
} JSTMorseDetectorState;

@interface JSTMorseDetector ()
@property(nonatomic) NSTimeInterval lastCancelPressTimestamp;
@property(nonatomic) NSTimeInterval lastSignalPressTimestamp;
@property(nonatomic, strong) NSMutableString *currentText;
@property(nonatomic, strong) NSMutableString *currentSign;
@property(nonatomic) JSTMorseDetectorState state;
@end

@implementation JSTMorseDetector {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentText = [[NSMutableString alloc] init];
        self.currentSign = [[NSMutableString alloc] init];
        
        self.state = JSTMorseDetectorStateIdle;
    }

    return self;
}

- (NSString *)text {
    return self.currentText;
}

- (void)updateWithLeftKeyPress:(BOOL)leftKeyPressed rightKeyPressed:(BOOL)rightKeyPressed {
    switch (self.state) {
        case JSTMorseDetectorStateIdle:
            if (leftKeyPressed && rightKeyPressed) {
                self.state = JSTMorseDetectorStateSendDetection;
                [self sendDetected];
            } else if (rightKeyPressed) {
                self.state = JSTMorseDetectorStateCancelDetection;
                [self cancelDetection:rightKeyPressed];
            } else if (leftKeyPressed) {
                self.state = JSTMorseDetectorStateSignalDetection;
                [self signalDetection:leftKeyPressed];
            }
            break;
        case JSTMorseDetectorStateSignalDetection:
            if (leftKeyPressed && rightKeyPressed) {
                self.state = JSTMorseDetectorStateSendDetection;
                [self sendDetected];
            } else {
                [self signalDetection:leftKeyPressed];
            }
            break;
        case JSTMorseDetectorStateCancelDetection:
            if (leftKeyPressed && rightKeyPressed) {
                self.state = JSTMorseDetectorStateSendDetection;
                [self sendDetected];
            } else {
                [self signalDetection:rightKeyPressed];
            }
            break;
        case JSTMorseDetectorStateSendDetection:
            if (!leftKeyPressed && !rightKeyPressed) {
                self.state = JSTMorseDetectorStateIdle;
            }
            break;
    }
}

- (void)signalDetection:(BOOL)leftKeyPressed {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });
    if (leftKeyPressed) {
        self.lastSignalPressTimestamp = [[NSDate date] timeIntervalSince1970];
    } else {
        NSTimeInterval length = [[NSDate date] timeIntervalSince1970] - self.lastSignalPressTimestamp;
        self.lastSignalPressTimestamp = 0;
        if (length < 0.4) {
            [self.currentSign appendString:@"."];
        } else if (length > 0.4) {
            [self.currentSign appendString:@"_"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(processCurrentSign) withObject:nil afterDelay:1.f inModes:@[NSRunLoopCommonModes]];
        });
        NSLog(@"%@", self.currentSign);
    }
}

- (void)cancelDetection:(BOOL)pressed {
    if (pressed && self.currentText.length > 0) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(text))];
        [self.currentText replaceCharactersInRange:NSMakeRange(self.currentText.length - 1, 1) withString:@""];
        [self didChangeValueForKey:NSStringFromSelector(@selector(text))];
    }
    self.currentSign = [[NSMutableString alloc] init];
    self.state = JSTMorseDetectorStateIdle;
}

- (void)sendDetected {
    // TODO Post to Twitter
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.currentSign = [[NSMutableString alloc] init];
}

- (void)processCurrentSign {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    NSDictionary *symbolMapping = @{
            @"._" : @"A",
            @"_..." : @"B",
            @"_._." : @"C",
            @"_.." : @"D",
            @"." : @"E",
            @".._." : @"F",
            @"__." : @"G",
            @"...." : @"H",
            @".." : @"I",
            @".___" : @"J",
            @"_._" : @"K",
            @"._.." : @"L",
            @"__" : @"M",
            @"_." : @"N",
            @"___" : @"O",
            @".__." : @"P",
            @"__._" : @"Q",
            @"._." : @"R",
            @"..." : @"S",
            @"_" : @"T",
            @".._" : @"U",
            @"..._" : @"V",
            @".__" : @"W",
            @"_.._" : @"X",
            @"_.__" : @"Y",
            @"__.." : @"Z"
    };
    NSMutableString *currentValue = self.currentSign;
    NSString *sign = symbolMapping[currentValue];
    self.currentSign = [[NSMutableString alloc] init];
    if (sign) {
        [self willChangeValueForKey:NSStringFromSelector(@selector(text))];
        [self.currentText appendString:sign];
        [self didChangeValueForKey:NSStringFromSelector(@selector(text))];
    } else {
        NSLog(@"Unknown sign %@", currentValue);
    }
    self.state = JSTMorseDetectorStateIdle;
}

@end
