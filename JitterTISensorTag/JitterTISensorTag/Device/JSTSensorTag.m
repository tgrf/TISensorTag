#import "JSTSensorTag.h"
#import "JSTSensorConstants.h"
#import "JSTSensorManager.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static int ddLogLevel = DDLogLevelAll;

NSString *const JSTSensorTagDidFinishDiscoveryNotification = @"JSTSensorTagDidFinishDiscoveryNotification";
NSString *const JSTSensorTagConnectionFailureNotification = @"JSTSensorTagConnectionFailureNotification";
NSString *const JSTSensorTagConnectionFailureNotificationErrorKey = @"JSTSensorTagConnectionFailureNotificationErrorKey";

static NSString *const JSTSensorOptionUnavailableError = @"Option unavailable.";

@interface JSTSensorTag () <CBPeripheralDelegate>
@property(nonatomic, readwrite) CBPeripheral *peripheral;
@property(nonatomic) int numberOfDiscoveredServices;
@property(nonatomic) UInt16 *calibrationDataUnsigned;
@property(nonatomic) int16_t *calibrationDataSigned;
@end

@implementation JSTSensorTag {

}

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [self init];
    if (self) {
        self.peripheral = peripheral;
        self.peripheral.delegate = self;
        
        self.calibrationDataUnsigned = (UInt16 *)malloc(sizeof(UInt16) * 8);
        self.calibrationDataSigned = (int16_t *)malloc(sizeof(int16_t) * 8);
        self.numberOfDiscoveredServices = 0;
    }
    return self;
}

- (void)dealloc {
    if (self.calibrationDataUnsigned) {
        free(self.calibrationDataUnsigned);
    }

    if (self.calibrationDataSigned) {
        free(self.calibrationDataSigned);
    }
}

- (void)configureSensor:(JSTSensorTagSensor)sensor withValue:(unsigned char)value {
    CBService *service;
    CBCharacteristic *characteristic;
    NSString *serviceIdentifier = [self serviceUUIDForSensor:sensor];
    NSString *characteristicIdentifier = [self configurationCharacteristicUUIDForSensor:sensor];

    if (serviceIdentifier && characteristicIdentifier) {
        service = [[self.peripheral.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:serviceIdentifier]]] firstObject];
        characteristic = [[service.characteristics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:characteristicIdentifier]]] firstObject];
        if (characteristic) {
            [self.peripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    } else {
        [self.sensorDelegate sensor:self didFailBLECommunicationWithError:[NSError errorWithDomain:JSTSensorTagErrorDomain code:JSTSensorTagOptionUnavailable userInfo:@{NSLocalizedDescriptionKey : JSTSensorOptionUnavailableError}]];
    }
}

- (void)configurePeriodForSensor:(JSTSensorTagSensor)sensor withValue:(unsigned char)value {
    CBService *service;
    CBCharacteristic *characteristic;
    NSString *serviceIdentifier = [self serviceUUIDForSensor:sensor];
    NSString *characteristicIdentifier = [self periodCharacteristicUUIDForSensor:sensor];

    if (serviceIdentifier && characteristicIdentifier) {
        service = [[self.peripheral.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:serviceIdentifier]]] firstObject];
        characteristic = [[service.characteristics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K == %@", NSStringFromSelector(@selector(UUID)), [CBUUID UUIDWithString:characteristicIdentifier]]] firstObject];
        if (characteristic) {
            [self.peripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
        }
    } else {
        [self.sensorDelegate sensor:self didFailBLECommunicationWithError:[NSError errorWithDomain:JSTSensorTagErrorDomain code:JSTSensorTagOptionUnavailable userInfo:@{NSLocalizedDescriptionKey : JSTSensorOptionUnavailableError}]];
    }
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, peripheral.services);

    if (error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        [[NSNotificationCenter defaultCenter] postNotificationName:JSTSensorTagConnectionFailureNotification object:self userInfo:@{JSTSensorTagConnectionFailureNotificationErrorKey : error}];
    } else {
        for (CBService *service in [peripheral services]) {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral.identifier, service.characteristics);

    if (error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        [[NSNotificationCenter defaultCenter] postNotificationName:JSTSensorTagConnectionFailureNotification object:self userInfo:@{JSTSensorTagConnectionFailureNotificationErrorKey : error}];
    } else {
        ++self.numberOfDiscoveredServices;
        if (self.numberOfDiscoveredServices == [JSTSensorTag availableServicesUUIDArray].count) {
            [[NSNotificationCenter defaultCenter] postNotificationName:JSTSensorTagDidFinishDiscoveryNotification object:self];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral.identifier, characteristic);
    if (error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        [self.sensorDelegate sensor:self didFailBLECommunicationWithError:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        [self.sensorDelegate sensor:self didFailBLECommunicationWithError:error];
    } else {
        DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral.identifier, characteristic);
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    DDLogInfo(@"%s %@", __PRETTY_FUNCTION__, peripheral.identifier);
    if (error) {
        DDLogError(@"%s %@", __PRETTY_FUNCTION__, error);
        [self.sensorDelegate sensor:self didFailBLECommunicationWithError:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices {
    DDLogInfo(@"%s %@ %@", __PRETTY_FUNCTION__, peripheral, invalidatedServices);
    [peripheral discoverServices:invalidatedServices];
}

#pragma mark -

- (void)discoverServices {
    [self.peripheral discoverServices:[JSTSensorTag availableServicesUUIDArray]];
}

- (void)setUpdatingSensor:(JSTSensorTagSensor)sensor enabled:(BOOL)enabled {
    BOOL characteristicFound = NO;
    NSString *serviceUUID = [self serviceUUIDForSensor:sensor];
    NSString *characteristicUUID = [self dataCharacteristicForSensor:sensor];

    for (CBService *service in self.peripheral.services)

    if (!characteristicFound) {
        [self.sensorDelegate sensor:self didFailBLECommunicationWithError:[NSError errorWithDomain:JSTSensorTagErrorDomain code:JSTSensorTagOptionUnavailable userInfo:@{NSLocalizedDescriptionKey : JSTSensorOptionUnavailableError}]];
    }
}

- (void)calibratePressure {

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

#pragma mark -

- (NSString *)periodCharacteristicUUIDForSensor:(JSTSensorTagSensor)sensor {
    NSString *characteristicIdentifier;
    switch (sensor) {
        case JSTSensorTagSensorIRTemperature:
            characteristicIdentifier = JSTSensorIRTemperaturePeriodCharacteristicUUID;
            break;
        case JSTSensorTagSensorAccelerometer:
            characteristicIdentifier = JSTSensorAccelerometerPeriodCharacteristicUUID;
            break;
        case JSTSensorTagSensorHumidity:
            characteristicIdentifier = JSTSensorHumidityPeriodCharacteristicUUID;
            break;
        case JSTSensorTagSensorMagnetometer:
            characteristicIdentifier = JSTSensorMagnetometerPeriodCharacteristicUUID;
            break;
        case JSTSensorTagSensorBarometer:
            characteristicIdentifier = JSTSensorBarometerPeriodCharacteristicUUID;
            break;
        case JSTSensorTagSensorGyroscope:
            characteristicIdentifier = JSTSensorGyroscopePeriodCharacteristicUUID;
            break;
        case JSTSensorTagSensorKey:
            break;
    }
    return characteristicIdentifier;
}

- (NSString *)serviceUUIDForSensor:(JSTSensorTagSensor)sensor {
    NSString *serviceIdentifier;
    switch (sensor) {
        case JSTSensorTagSensorIRTemperature:
            serviceIdentifier = JSTSensorIRTemperatureServiceUUID;
            break;
        case JSTSensorTagSensorAccelerometer:
            serviceIdentifier = JSTSensorAccelerometerServiceUUID;
            break;
        case JSTSensorTagSensorHumidity:
            serviceIdentifier = JSTSensorHumidityServiceUUID;
            break;
        case JSTSensorTagSensorMagnetometer:
            serviceIdentifier = JSTSensorMagnetometerServiceUUID;
            break;
        case JSTSensorTagSensorBarometer:
            serviceIdentifier = JSTSensorBarometerServiceUUID;
            break;
        case JSTSensorTagSensorGyroscope:
            serviceIdentifier = JSTSensorGyroscopeServiceUUID;
            break;
        case JSTSensorTagSensorKey:
            serviceIdentifier = JSTSensorSimpleKeysServiceUUID;
            break;
    }
    return serviceIdentifier;
}

- (NSString *)configurationCharacteristicUUIDForSensor:(JSTSensorTagSensor)sensor {
    NSString *characteristicIdentifier;
    switch (sensor) {
        case JSTSensorTagSensorIRTemperature:
            characteristicIdentifier = JSTSensorIRTemperatureConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorAccelerometer:
            characteristicIdentifier = JSTSensorAccelerometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorHumidity:
            characteristicIdentifier = JSTSensorHumidityConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorMagnetometer:
            characteristicIdentifier = JSTSensorMagnetometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorBarometer:
            characteristicIdentifier = JSTSensorBarometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorGyroscope:
            characteristicIdentifier = JSTSensorGyroscopeConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorKey:
            break;
    }
    return characteristicIdentifier;
}


- (NSString *)dataCharacteristicForSensor:(JSTSensorTagSensor)sensor {
    NSString *characteristicIdentifier;
    switch (sensor) {
        case JSTSensorTagSensorIRTemperature:
            characteristicIdentifier = JSTSensorIRTemperatureConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorAccelerometer:
            characteristicIdentifier = JSTSensorAccelerometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorHumidity:
            characteristicIdentifier = JSTSensorHumidityConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorMagnetometer:
            characteristicIdentifier = JSTSensorMagnetometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorBarometer:
            characteristicIdentifier = JSTSensorBarometerConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorGyroscope:
            characteristicIdentifier = JSTSensorGyroscopeConfigCharacteristicUUID;
            break;
        case JSTSensorTagSensorKey:
            break;
    }
    return characteristicIdentifier;
}

@end
