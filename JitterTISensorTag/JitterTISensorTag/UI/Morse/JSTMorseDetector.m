//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTMorseDetector.h"


@interface JSTMorseDetector ()
@property(nonatomic) NSTimeInterval lastPressTimestamp;
@property(nonatomic, strong) NSMutableString *currentText;
@property(nonatomic, strong) NSMutableString *currentSign;
@end

@implementation JSTMorseDetector {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentText = [[NSMutableString alloc] init];
        self.currentSign = [[NSMutableString alloc] init];
    }

    return self;
}

- (NSString *)text {
    return self.currentText;
}

- (void)updateWithKeyPress:(BOOL)isPressed {
    if (isPressed) {
        self.lastPressTimestamp = [[NSDate date] timeIntervalSince1970];
    } else if (self.lastPressTimestamp > 0) {
        NSTimeInterval length = [[NSDate date] timeIntervalSince1970] - self.lastPressTimestamp;
        self.lastPressTimestamp = 0;
        if (length < 0.4) {
            [self.currentSign appendString:@"."];
        } else if (length > 0.4) {
            [self.currentSign appendString:@"_"];
        }
    } else {
        [self processCurrentSign];
    }
}

- (void)processCurrentSign {
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
        [self.currentText appendString:sign];
    } else {
        NSLog(@"Unknown sign %@", currentValue);
    }
}

@end
