//
// Created by Blazej Marcinkiewicz on 02/02/15.
// Copyright (c) 2015 mceconf.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSTSensorManager.h"

@class JSTSensorTag;
@class JSTSensorManager;
@class JSTBaseViewController;


@interface JSTConnectionViewController : UIViewController <JSTSensorManagerDelegate>

- (instancetype)initWithSensors:(NSArray *)sensors iconName:(NSString *)iconName finalViewController:(JSTBaseViewController *)finalViewController;

@end
