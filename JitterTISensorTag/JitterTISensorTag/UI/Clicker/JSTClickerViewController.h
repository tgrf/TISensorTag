//
// Created by Blazej Marcinkiewicz on 01/02/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"
#import "JSTClicker.h"
#import "JSTBaseViewController.h"

@class JSTSensorManager;
@class JSTSensorTag;
@class JSTClicker;


@interface JSTClickerViewController : JSTBaseViewController <JSTSensorManagerDelegate, JSTClickerDelegate>
@end
