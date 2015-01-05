#import "JSTBaseSensor.h"
#import "CBUUID+StringRepresentation.h"


@interface JSTBaseSensor ()
@property (nonatomic, readwrite) CBPeripheral *peripheral;
@end

@implementation JSTBaseSensor {

}

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [self init];
    if (self) {
        self.peripheral = peripheral;
    }
    return self;
}

- (void)configureWithValue:(char)value {
    CBCharacteristic *configurationCharacteristic = [self characteristicForUUID:[[self class] configurationCharacteristicUUID]];
    if (configurationCharacteristic) {
        [self.peripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:configurationCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)setPeriodValue:(char)periodValue {
    CBCharacteristic *configurationCharacteristic = [self characteristicForUUID:[[self class] periodCharacteristicUUID]];
    if (configurationCharacteristic) {
        [self.peripheral writeValue:[NSData dataWithBytes:&periodValue length:sizeof(periodValue)] forCharacteristic:configurationCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)setNotificationsEnabled:(BOOL)enabled {
    CBCharacteristic *dataCharacteristic = [self characteristicForUUID:[[self class] dataCharacteristicUUID]];
    if (dataCharacteristic) {
        [self.peripheral setNotifyValue:enabled forCharacteristic:dataCharacteristic];
    }
}

- (BOOL)canBeConfigured {
    return [self characteristicForUUID:[[self class] configurationCharacteristicUUID]] != nil;
}

- (BOOL)canSetPeriod {
    return [self characteristicForUUID:[[self class] periodCharacteristicUUID]] != nil;
}

#pragma mark -

- (CBCharacteristic *)characteristicForUUID:(NSString *)UUID {
    CBCharacteristic *configurationCharacteristic;
    for (CBService *service in self.peripheral.services) {
        if ([[service.UUID stringRepresentation] isEqualToString:[[self class] serviceUUID]]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([[service.UUID stringRepresentation] isEqualToString:UUID]) {
                    configurationCharacteristic = characteristic;
                }
            }
        }
    }
    return configurationCharacteristic;
}

#pragma mark - Override in subclasses
- (BOOL)processCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID.stringRepresentation isEqualToString:[[self class] dataCharacteristicUUID]]) {
        if (error) {
            [self.sensorDelegate sensorDidFailCommunicating:self withError:error];
            return NO;
        }
        return YES;
    }
    return NO;
}

+ (NSString *)serviceUUID {
    return nil;
}

+ (NSString *)configurationCharacteristicUUID {
    return nil;
}

+ (NSString *)periodCharacteristicUUID {
    return nil;
}

+ (NSString *)dataCharacteristicUUID {
    return nil;
}

@end
