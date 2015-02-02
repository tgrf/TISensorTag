//
//  JSTRootViewController.m
//  JitterTISensorTag
//
//  Created by Tomasz Grynfelder on 22/12/14.
//  ***REMOVED***
//

#import "JSTRootViewController.h"
#import "JSTSensorTag.h"
#import "JSTPressureSensor.h"
#import "JSTRootView.h"
#import "JSTCadenceViewController.h"
#import "JSTSafeViewController.h"
#import "JSTWandViewController.h"
#import "JSTHandshakeViewController.h"
#import "JSTMorseViewController.h"
#import "JSTDiceViewController.h"
#import "JSTBlowViewController.h"
#import "JSTPressureViewController.h"
#import "JSTClickerViewController.h"
#import "JSTRootViewCell.h"
#import "JSTDeviceListViewController.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelAll;

@interface JSTRootViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong, readonly) JSTSensorManager *sensorManager;
@property (nonatomic, strong, readonly) NSArray *gamesConfiguration;
@end

NSString *JSTRootViewControllerCellIdentifier = @"JSTRootViewTableViewCell";

@implementation JSTRootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _gamesConfiguration = @[
                @{ @"name" : @"Cadence",    @"class" : NSStringFromClass(JSTCadenceViewController.class),   @"icon" : @"W" },
                @{ @"name" : @"Safe",       @"class" : NSStringFromClass(JSTSafeViewController.class),      @"icon" : @"S" },
                @{ @"name" : @"Wand",       @"class" : NSStringFromClass(JSTWandViewController.class),      @"icon" : @"A" },
                @{ @"name" : @"Handshake",  @"class" : NSStringFromClass(JSTHandshakeViewController.class), @"icon" : @"P" },
                @{ @"name" : @"Dice",       @"class" : NSStringFromClass(JSTDiceViewController.class),      @"icon" : @"D" },
                @{ @"name" : @"Pressure",   @"class" : NSStringFromClass(JSTPressureViewController.class),  @"icon" : @"T" },
                @{ @"name" : @"Morse",      @"class" : NSStringFromClass(JSTMorseViewController.class),     @"icon" : @"M" },
                @{ @"name" : @"Fast click", @"class" : NSStringFromClass(JSTClickerViewController.class),   @"icon" : @"G" },
                @{ @"name" : @"Blow",       @"class" : NSStringFromClass(JSTBlowViewController.class),      @"icon" : @"C" },
        ];
        self.title = @" ";
    }

    return self;
}

- (void)loadView {
    JSTRootView *view = [[JSTRootView alloc] initWithFrame:CGRectZero];
    self.view = view;
}

- (JSTRootView *)rootView {
    if (self.isViewLoaded) {
        return (JSTRootView *)self.view;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rootView.gamesTableView.delegate = self;
    self.rootView.gamesTableView.dataSource = self;
    [self.rootView.gamesTableView registerClass:[JSTRootViewCell class]
                         forCellReuseIdentifier:JSTRootViewControllerCellIdentifier];

    if ([self.rootView.gamesTableView respondsToSelector:@selector(setEstimatedRowHeight:)]
            && [self.rootView.gamesTableView respondsToSelector:@selector(setRowHeight:)]) {
        self.rootView.gamesTableView.estimatedRowHeight = 180;
        self.rootView.gamesTableView.rowHeight = UITableViewAutomaticDimension;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    self.sensorManager.delegate = self;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gamesConfiguration.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSTRootViewCell *tableViewCell = [self.rootView.gamesTableView dequeueReusableCellWithIdentifier:JSTRootViewControllerCellIdentifier
                                                                                        forIndexPath:indexPath];
    tableViewCell.icon.text = _gamesConfiguration[(NSUInteger)indexPath.row][@"icon"];
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.rootView.gamesTableView deselectRowAtIndexPath:indexPath animated:YES];

    Class controllerClass = NSClassFromString(_gamesConfiguration[(NSUInteger)indexPath.row][@"class"]);
    UIViewController *viewController = (UIViewController *)[controllerClass new];
    JSTDeviceListViewController *deviceListViewController = [[JSTDeviceListViewController alloc] initWithFinalViewController:viewController
                                                                                                                        icon:_gamesConfiguration[(NSUInteger) indexPath.row][@"icon"]];
    [self.navigationController pushViewController:deviceListViewController animated:YES];
}

#pragma mark - JSTSensorManagerDelegate

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
}

- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor error:(NSError *)error {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {
    DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, sensor);
}

- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor {

}

- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error {

}

- (void)sensorDidFinishCalibration:(JSTBaseSensor *)sensor {
    if ([sensor isKindOfClass:[JSTPressureSensor class]]) {
        JSTPressureSensor *pressureSensor = (JSTPressureSensor *) sensor;
        [pressureSensor configureWithValue:JSTSensorPressureEnabled];
        [pressureSensor setNotificationsEnabled:YES];
    }
}

@end
