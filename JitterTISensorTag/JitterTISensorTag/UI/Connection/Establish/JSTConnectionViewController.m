//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
//

#import "JSTConnectionViewController.h"
#import "JSTSensorTag.h"
#import "JSTSensorManager.h"
#import "JSTAppDelegate.h"
#import "JSTConnectionView.h"
#import "JSTBaseViewController.h"


@interface JSTConnectionViewController ()
@property(nonatomic, copy) NSString *iconName;
@property(nonatomic, strong) JSTSensorTag *sensorTag;
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic, strong) JSTBaseViewController *finalViewController;
@end

@implementation JSTConnectionViewController {

}

- (instancetype)initWithSensor:(JSTSensorTag *)sensorTag iconName:(NSString *)iconName finalViewController:(JSTBaseViewController *)finalViewController {
    self = [self init];
    if (self) {
        self.iconName = iconName;
        self.sensorTag = sensorTag;
        self.finalViewController = finalViewController;
        
        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];

    JSTConnectionView *view = [[JSTConnectionView alloc] init];
    view.iconView.text = self.iconName;
    [view.retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    self.view = view;
}

- (void)retry {
    [self.sensorManager connectSensorWithUUID:self.sensorTag.peripheral.identifier];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.sensorManager.delegate = self;
    if (self.sensorManager.state == CBPeripheralManagerStatePoweredOn) {
        [self.sensorManager connectSensorWithUUID:self.sensorTag.peripheral.identifier];
    }
}


#pragma mark - Sensor manager
- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    NSMutableArray *array = [self.navigationController.viewControllers mutableCopy];
    while (array.count > 1) {
        [array removeLastObject];
    }
    [array addObject:self.finalViewController];
    self.finalViewController.sensorTag = sensor;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController setViewControllers:array animated:YES];
    });
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor error:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    });
}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    if (self.sensorManager.state == CBPeripheralManagerStatePoweredOn) {
        [self.sensorManager connectSensorWithUUID:self.sensorTag.peripheral.identifier];
    }
}

@end
