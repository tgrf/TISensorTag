//
// Created by Blazej Marcinkiewicz on 30/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorTag.h"


@interface JSTDice : NSObject
@property(nonatomic, readonly) NSString *value;

- (void)updateWithValue:(JSTVector3D)vector3D;

@end
