//
// Created by Blazej Marcinkiewicz on 02/02/15.
// ***REMOVED***
//

#import "JSTDeviceListViewController.h"
#import "JSTSensorManager.h"
#import "JSTAppDelegate.h"
#import "JSTSensorTag.h"
#import "JSTDeviceListView.h"
#import "UIColor+JSTExtensions.h"
#import "JSTDeviceListCell.h"
#import "JSTConnectionViewController.h"
#import "JSTBaseViewController.h"

static NSString *const reuseIdentifier = @"reuseIdentifier";

@interface JSTDeviceListViewController ()
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, strong) JSTBaseViewController *finalViewController;
@property(nonatomic, strong) JSTSensorManager *sensorManager;
@property(nonatomic) JSTDeviceListType type;
@property(nonatomic, strong) NSMutableArray *selectedSensors;
@end

@implementation JSTDeviceListViewController {

}
- (instancetype)initWithFinalViewController:(JSTBaseViewController *)viewController icon:(NSString *)icon type:(JSTDeviceListType)type {
    self = [self init];
    if (self) {
        self.icon = icon;
        self.finalViewController = viewController;

        self.sensorManager = [JSTSensorManager sharedInstance];
        self.sensorManager.delegate = self;
        
        self.type = type;
        
        self.selectedSensors = [NSMutableArray array];
    }
    return self;
}

- (void)loadView {
    [super loadView];

    JSTDeviceListView *view = [[JSTDeviceListView alloc] init];
    view.tableView.dataSource = self;
    view.tableView.delegate = self;
    [view.tableView registerClass:[JSTDeviceListCell class] forCellReuseIdentifier:reuseIdentifier];

    UILabel *header = [[UILabel alloc] init];
    header.textAlignment = NSTextAlignmentCenter;
    header.font = [UIFont fontWithName:@"mce_st_icons" size:100];
    header.textColor = [UIColor darkJSTColor];
    header.text = self.icon;
    [header sizeToFit];
    view.tableView.tableHeaderView = header;

    self.view = view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.sensorManager.delegate = self;
    if (self.sensorManager.state == CBCentralManagerStatePoweredOn) {
        [self.sensorManager startScanning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.sensorManager stopScanning];
}

- (JSTDeviceListView *)deviceListView {
    if (self.isViewLoaded) {
        return (JSTDeviceListView *) self.view;
    }
    return nil;
}

#pragma mark - Table view

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.type == JSTDeviceListTypeSingleSelection) {
        return @"Pick one device to connect";
    } else {
        return @"Pick two devices to connect";
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
    UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *) view;
    headerFooterView.contentView.backgroundColor = [UIColor clearColor];
    headerFooterView.textLabel.textColor = [UIColor darkJSTColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sensorManager.sensors.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JSTDeviceListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    JSTSensorTag *sensorTag = self.sensorManager.sensors[(NSUInteger) indexPath.row];
    cell.textLabel.textColor = [UIColor lightJSTColor];
    cell.textLabel.text = [sensorTag.peripheral.identifier UUIDString];
    cell.detailTextLabel.textColor = [UIColor lightJSTColor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI: %d", sensorTag.rssi];

    if ([self.selectedSensors containsObject:sensorTag]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSTSensorTag *sensorTag = self.sensorManager.sensors[(NSUInteger) indexPath.row];
    if ([self.selectedSensors containsObject:sensorTag]) {
        [self.selectedSensors removeObject:sensorTag];
    } else {
        [self.selectedSensors addObject:sensorTag];
    }

    if (self.type == JSTDeviceListTypeSingleSelection || (self.type == JSTDeviceListTypeDoubleSelection && self.selectedSensors.count == 2)) {
        JSTConnectionViewController *viewController = [[JSTConnectionViewController alloc] initWithSensors:self.selectedSensors iconName:self.icon finalViewController:self.finalViewController];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - Sensor manager delegate
- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor {

}

- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor error:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error {

}

- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.deviceListView.tableView reloadData];
    });
}

- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state {
    if (manager.state == CBCentralManagerStatePoweredOn) {
        [manager startScanning];
    }
}

@end
