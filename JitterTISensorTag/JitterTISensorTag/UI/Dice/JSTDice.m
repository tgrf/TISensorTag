//
// Created by Blazej Marcinkiewicz on 30/01/15.
// ***REMOVED***
//

#import "JSTDice.h"
#import "JSTSensorTag.h"


@interface JSTDice ()
@property(nonatomic, readwrite) NSString *value;
@end

@implementation JSTDice {

}

- (void)updateWithValue:(JSTVector3D)vector3D {
    float absY = fabsf(vector3D.y);
    float absX = fabsf(vector3D.x);
    float absZ = fabsf(vector3D.z);

    if (absX > absY && absX > absZ) {
        if (vector3D.x > 0) {
            self.value = @"5";
        } else {
            self.value = @"2";
        }
    } else if (absY > absZ && absY > absX) {
        if (vector3D.y > 0) {
            self.value = @"3";
        } else {
            self.value = @"4";
        }
    } else if (absZ > absX && absZ > absY) {
        if (vector3D.z > 0) {
            self.value = @"6";
        } else {
            self.value = @"1";
        }
    }
}

@end
