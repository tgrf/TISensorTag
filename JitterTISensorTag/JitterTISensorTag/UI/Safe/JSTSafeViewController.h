//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"
#import "JSTBaseSensor.h"

@class JSTSensorManager;
@class JSTSensorTag;
@class JSTSafe;


@interface JSTSafeViewController : UIViewController <JSTSensorManagerDelegate, JSTBaseSensorDelegate>

@end
