//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"

@class JSTSensorTag;
@class JSTSensorManager;
@class JSTBaseViewController;


@interface JSTConnectionViewController : UIViewController <JSTSensorManagerDelegate>

- (instancetype)initWithSensors:(NSArray *)sensors iconName:(NSString *)iconName finalViewController:(JSTBaseViewController *)finalViewController;

@end
