#import "JSTSensorTag.h"
#import "JSTSensorConstants.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelAll;

@interface JSTSensorTag () <CBPeripheralDelegate>
@property(nonatomic, readwrite) CBPeripheral *peripheral;
@end

@implementation JSTSensorTag {

}

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [self init];
    if (self) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
    }
    return self;
}

- (void)configureSensor:(JSTSensorTagSensor)sensor withValue:(int)value {
    CBService *service;
    CBCharacteristic *characteristic;
    NSString *serviceIdentifier;
    NSString *characteristicIdentifier;
    switch (sensor) {
        case JSTSensorTagSensorIRTemperature:
            serviceIdentifier = JSTSensorIRTemperatureServiceUUID;
            characteristicIdentifier = JSTSensorIRTemperatureConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorAccelerometer:
            serviceIdentifier = JSTSensorAccelerometerServiceUUID;
            characteristicIdentifier = JSTSensorAccelerometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorHumidity:
            serviceIdentifier = JSTSensorHumidityServiceUUID;
            characteristicIdentifier = JSTSensorHumidityConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorMagnetometer:
            serviceIdentifier = JSTSensorMagnetometerServiceUUID;
            characteristicIdentifier = JSTSensorMagnetometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorBarometer:
            serviceIdentifier = JSTSensorBarometerServiceUUID;
            characteristicIdentifier = JSTSensorBarometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorGyroscope:
            serviceIdentifier = JSTSensorGyroscopeServiceUUID;
            characteristicIdentifier = JSTSensorGyroscopeConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorKey:
            break;
    }
    
    if (serviceIdentifier && characteristicIdentifier) {
        service = [[self.peripheral.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:serviceIdentifier]]] firstObject];
        characteristic = [[service.characteristics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:characteristicIdentifier]]] firstObject];
        if (characteristic) {
            [self.peripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, peripheral.services);
    for (CBService *service in [peripheral services]) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, service);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, characteristic);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, characteristic);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, peripheral);
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, invalidatedServices);
    [peripheral discoverServices:invalidatedServices];
}

#pragma mark -
+ (NSArray *)availableServicesUUIDArray {
    return @[
            [CBUUID UUIDWithString:JSTSensorIRTemperatureServiceUUID],
            [CBUUID UUIDWithString:JSTSensorAccelerometerServiceUUID],
            [CBUUID UUIDWithString:JSTSensorHumidityServiceUUID],
            [CBUUID UUIDWithString:JSTSensorMagnetometerServiceUUID],
            [CBUUID UUIDWithString:JSTSensorBarometerServiceUUID],
            [CBUUID UUIDWithString:JSTSensorGyroscopeServiceUUID],
            [CBUUID UUIDWithString:JSTSensorTestServiceUUID],
            [CBUUID UUIDWithString:JSTSensorOADServiceUUID],
            [CBUUID UUIDWithString:JSTSensorSimpleKeysServiceUUID]
    ];
}

- (void)discoverServices {
    [self.peripheral discoverServices:[JSTSensorTag availableServicesUUIDArray]];
}

+ (NSArray *)availableCharacteristicsUUIDArrayForServiceUUID:(NSString *)service {
    if ([service isEqualToString:JSTSensorIRTemperatureServiceUUID]) {
        return @[
                [CBUUID UUIDWithString:JSTSensorIRTemperatureDataCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorIRTemperatureConfigCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorIRTemperaturePeriodCharacteristicUUID],
        ];
    } else if ([service isEqualToString:JSTSensorAccelerometerServiceUUID]) {
        return @[
                [CBUUID UUIDWithString:JSTSensorAccelerometerDataCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorAccelerometerConfigCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorAccelerometerPeriodCharacteristicUUID],
        ];
    } else if ([service isEqualToString:JSTSensorHumidityServiceUUID]) {
        return @[
                [CBUUID UUIDWithString:JSTSensorHumidityDataCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorHumidityConfigCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorHumidityPeriodCharacteristicUUID],
        ];
    } else if ([service isEqualToString:JSTSensorMagnetometerServiceUUID]) {
        return @[
                [CBUUID UUIDWithString:JSTSensorMagnetometerDataCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorMagnetometerConfigCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorMagnetometerPeriodCharacteristicUUID],
        ];
    } else if ([service isEqualToString:JSTSensorBarometerServiceUUID]) {
        return @[
                [CBUUID UUIDWithString:JSTSensorBarometerDataCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorBarometerConfigCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorBarometerPeriodCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorBarometerCalibrationCharacteristicUUID],
        ];
    } else if ([service isEqualToString:JSTSensorGyroscopeServiceUUID]) {
        return @[
                [CBUUID UUIDWithString:JSTSensorGyroscopeDataCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorGyroscopeConfigCharacteristicUUID],
                [CBUUID UUIDWithString:JSTSensorGyroscopePeriodCharacteristicUUID],
        ];
    } else if ([service isEqualToString:JSTSensorSimpleKeysServiceUUID]) {
        return @[
                [CBUUID UUIDWithString:JSTSensorSimpleKeysCharacteristicUUID],
        ];
    }
    return nil;
}

@end
