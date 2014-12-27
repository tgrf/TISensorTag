//
//  JSTRootViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 22/12/14.
//  ***REMOVED***
//

#import "JSTRootViewController.h"
#import "JSTSensorManager.h"

@interface JSTRootViewController ()

@property(nonatomic, strong) JSTSensorManager *sensorManager;
@end

@implementation JSTRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.sensorManager = [[JSTSensorManager alloc] init];
    if (![self.sensorManager hasPreviouslyConnectedSensor]) {
        [self.sensorManager connectNearestSensor];
    } else {
        [self.sensorManager connectLastSensor];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
