//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"

@class JSTSensorManager;
@class JSTBaseViewController;

typedef enum {
    JSTDeviceListTypeSingleSelection,
    JSTDeviceListTypeDoubleSelection
} JSTDeviceListType;

@interface JSTDeviceListViewController : UIViewController <JSTSensorManagerDelegate, UITableViewDelegate, UITableViewDataSource>
- (instancetype)initWithFinalViewController:(JSTBaseViewController *)viewController icon:(NSString *)icon type:(JSTDeviceListType)type;
@end
