#import <Foundation/Foundation.h>
#import "JSTSensorConstants.h"

@interface JSTSensorTag : NSObject
@property(nonatomic, readonly) CBPeripheral *peripheral;

@property(nonatomic) NSInteger rssi;

+ (NSArray *)availableServicesUUIDArray;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

- (void)discoverServices;

- (void)configureSensor:(JSTSensorTagSensor)sensor withValue:(int)value;

+ (NSArray *)availableCharacteristicsUUIDArrayForServiceUUID:(NSString *)service;
@end
