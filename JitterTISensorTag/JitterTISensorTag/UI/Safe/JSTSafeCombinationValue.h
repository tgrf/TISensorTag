//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>

typedef enum {
    JSTSafeRotationDirectionNone,
    JSTSafeRotationDirectionLeft,
    JSTSafeRotationDirectionRight
} JSTSafeRotationDirection;

@interface JSTSafeCombinationValue : NSObject

@property (nonatomic) JSTSafeRotationDirection direction;
@property (nonatomic) int rotationValue;

@end
