//
//  JSTRootViewController.h
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 22/12/14.
//  ***REMOVED***
//

#import <UIKit/UIKit.h>
#import "JSTSensorManager.h"
#import "JSTBaseSensor.h"

@class JSTSensorManager;

@interface JSTRootViewController : UIViewController <JSTSensorManagerDelegate, JSTBaseSensorDelegate>


@end

