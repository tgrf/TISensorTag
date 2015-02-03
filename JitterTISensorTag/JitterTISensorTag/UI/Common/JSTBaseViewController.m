//
// Created by Blazej Marcinkiewicz on 02/02/15.
// Copyright (c) 2015 mceconf.com. All rights reserved.
//

#import "JSTBaseViewController.h"
#import "JSTSensorTag.h"


@implementation JSTBaseViewController {

}
- (void)setSensors:(NSArray *)sensors {
    self.sensorTag = [sensors firstObject];
}

@end
