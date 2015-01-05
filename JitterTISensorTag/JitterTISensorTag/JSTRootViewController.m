//
//  JSTRootViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 22/12/14.
//  Copyright (c) 2014 mceconf.com. All rights reserved.
//

#import "JSTRootViewController.h"
#import "JSTSensorManager.h"
#import "JSTSensorTag.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelAll;

@interface JSTRootViewController ()

@property(nonatomic, strong) JSTSensorManager *sensorManager;
@end

@implementation JSTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.sensorManager = [[JSTSensorManager alloc] init];
    self.sensorManager.delegate = self;

    if (![self.sensorManager hasPreviouslyConnectedSensor]) {
        [self.sensorManager connectNearestSensor];
    } else {
        [self.sensorManager connectLastSensor];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - JSTSensorManagerDelegate

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
    for (int i = 0; i < 6; ++i) {
        [sensor configureSensor:i withValue:0x00];
        [sensor configurePeriodForSensor:i withValue:0xFF];
    }
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
}

@end
