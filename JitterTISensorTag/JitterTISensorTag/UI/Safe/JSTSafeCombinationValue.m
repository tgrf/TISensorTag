//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import "JSTSafeCombinationValue.h"


@implementation JSTSafeCombinationValue {

}
- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:[NSString stringWithFormat:@"direction %@, value %@", @(self.direction), @(self.rotationValue)]];
    [description appendString:@">"];
    return description;
}

@end
