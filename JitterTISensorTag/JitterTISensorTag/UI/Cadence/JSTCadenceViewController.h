//
// Created by Blazej Marcinkiewicz on 20/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"
#import "JSTBaseSensor.h"

@class JSTSensorManager;
@class JSTSensorTag;


@interface JSTCadenceViewController : UIViewController <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@end
