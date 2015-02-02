//
// Created by Blazej Marcinkiewicz on 30/01/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTBaseSensor.h"
#import "JSTSensorManager.h"
#import "JSTBaseViewController.h"

@class JSTSensorTag;
@class JSTDice;


@interface JSTDiceViewController : JSTBaseViewController <JSTSensorManagerDelegate, JSTBaseSensorDelegate>
@end
