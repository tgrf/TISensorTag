#import "JSTSensorManager.h"
#import "JSTSensorTag.h"
#import "CBUUID+StringRepresentation.h"

#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelDebug;

static NSString *const kJSTSensorManagerLastDeviceUUID = @"kJSTSensorManagerLastDeviceUUID";
NSString *const JSTSensorManagerErrorDomain = @"JSTSensorManagerErrorDomain";

@interface JSTSensorManager ()
@property(nonatomic, strong) CBCentralManager *centralManager;
@property(nonatomic) BOOL shouldStartScanning;
@property(nonatomic, strong) NSMutableDictionary *peripherals;
@property(nonatomic) BOOL isScanning;
@end

@implementation JSTSensorManager {

}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_queue_create("JitterTISensorTagManagerQueue", DISPATCH_QUEUE_SERIAL)];
        self.peripherals = [NSMutableDictionary dictionary];
    }

    return self;
}

#pragma mark -

- (void)startScanning {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    self.shouldStartScanning = YES;
    [self scan];
}

- (void)stopScanning {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self.centralManager stopScan];
}

- (void)connectSensorWithUUID:(NSUUID *)uuid {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, uuid);
    JSTSensorTag *sensorTag = self.peripherals[uuid.UUIDString];
    if (sensorTag) {
        [self.centralManager connectPeripheral:sensorTag.peripheral options:nil];
    } else {
        CBPeripheral *peripheral = [[self.centralManager retrievePeripheralsWithIdentifiers:@[uuid]] firstObject];
        if (peripheral) {
            sensorTag = [[JSTSensorTag alloc] initWithPeripheral:peripheral];
            self.peripherals[uuid.UUIDString] = sensorTag;
            [self.centralManager connectPeripheral:peripheral options:nil];
        } else {
            [self.delegate manager:self didFailToConnectToSensorWithError:[NSError errorWithDomain:JSTSensorManagerErrorDomain code:JSTSensorManagerErrorNoDeviceFound userInfo:nil]];
        }
    }
}

- (void)connectNearestSensor {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self startScanning];
    [self performSelector:@selector(findNearestAndConnect) withObject:nil afterDelay:10];
}

- (void)connectLastSensor {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self connectSensorWithUUID:[[NSUUID alloc] initWithUUIDString:[[NSUserDefaults standardUserDefaults] objectForKey:kJSTSensorManagerLastDeviceUUID]]];
}

- (BOOL)hasPreviouslyConnectedSensor {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kJSTSensorManagerLastDeviceUUID] != nil;
}

- (void)findNearestAndConnect {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    [self stopScanning];
    NSArray *sortedPeripherals = [[self.peripherals allValues] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(rssi)) ascending:NO]]];
    if (sortedPeripherals.count == 0) {
        [self.delegate manager:self didFailToConnectToSensorWithError:[NSError errorWithDomain:JSTSensorManagerErrorDomain code:JSTSensorManagerErrorNoDeviceFound userInfo:nil]];
    } else {
        JSTSensorTag *tag = [sortedPeripherals firstObject];
        [self.centralManager connectPeripheral:tag.peripheral options:nil];
    }
}

- (void)scan {
    DDLogInfo(@"%s", __PRETTY_FUNCTION__);
    if (self.shouldStartScanning && self.centralManager.state == CBCentralManagerStatePoweredOn) {
        self.shouldStartScanning = NO;
        [self.centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @(YES)}];
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self scan];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    DDLogVerbose(@"%s %@", __PRETTY_FUNCTION__, peripheral);
    JSTSensorTag *sensor = self.peripherals[peripheral.identifier.UUIDString];
    if (!sensor && [peripheral.name isEqualToString:@"TI BLE Sensor Tag"]) {
        sensor = [[JSTSensorTag alloc] initWithPeripheral:peripheral];
        self.peripherals[peripheral.identifier.UUIDString] = sensor;
    }
    sensor.rssi = [RSSI integerValue];

    [self.delegate manager:self didDiscoverSensor:sensor];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, peripheral);
    [[NSUserDefaults standardUserDefaults] setObject:peripheral.identifier.UUIDString forKey:kJSTSensorManagerLastDeviceUUID];
    [[NSUserDefaults standardUserDefaults] synchronize];

    JSTSensorTag *sensor = self.peripherals[peripheral.identifier.UUIDString];
    [sensor discoverServices];

    [self.delegate manager:self didConnectSensor:self.peripherals[peripheral.identifier.UUIDString]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    DDLogError(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, error);
    [self.delegate manager:self didFailToConnectToSensorWithError:error];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, error);
    [self.delegate manager:self didDisconnectSensor:self.peripherals[peripheral.identifier.UUIDString]];
}

- (NSArray *)sensors {
    return [self.peripherals allValues];
}

@end
