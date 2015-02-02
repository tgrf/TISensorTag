//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"

@class JSTSensorManager;
@class JSTBaseViewController;


@interface JSTDeviceListViewController : UIViewController <JSTSensorManagerDelegate, UITableViewDelegate, UITableViewDataSource>
- (instancetype)initWithFinalViewController:(JSTBaseViewController *)viewController icon:(NSString *)icon;
@end
