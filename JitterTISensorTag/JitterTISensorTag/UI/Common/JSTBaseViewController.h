//
// Created by Blazej Marcinkiewicz on 02/02/15.
// Copyright (c) 2015 mceconf.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSTSensorTag;


@interface JSTBaseViewController : UIViewController
@property (nonatomic, strong) JSTSensorTag *sensorTag;
- (void)setSensors:(NSArray *)sensors;
@end
