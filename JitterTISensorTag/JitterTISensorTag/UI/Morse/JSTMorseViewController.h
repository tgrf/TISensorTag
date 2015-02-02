//
// Created by Blazej Marcinkiewicz on 25/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"
#import "JSTBaseSensor.h"
#import "JSTBaseViewController.h"

@class JSTMorseDetector;
@class JSTSensorManager;
@class JSTSensorTag;


@interface JSTMorseViewController : JSTBaseViewController <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@end
