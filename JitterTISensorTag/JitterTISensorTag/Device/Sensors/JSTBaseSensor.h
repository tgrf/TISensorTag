#import <Foundation/Foundation.h>

@class JSTBaseSensor;

@protocol JSTBaseSensorDelegate<NSObject>
- (void)sensorDidUpdateValue:(JSTBaseSensor *)sensor;
- (void)sensorDidFailCommunicating:(JSTBaseSensor *)sensor withError:(NSError *)error;
@end

@interface JSTBaseSensor : NSObject

@property (nonatomic, readonly) CBPeripheral *peripheral;
@property (nonatomic, weak) id<JSTBaseSensorDelegate> sensorDelegate;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

- (void)configureWithValue:(char)value;
- (void)setPeriodValue:(char)periodValue;
- (void)setNotificationsEnabled:(BOOL)enabled;

- (BOOL)canBeConfigured;
- (BOOL)canSetPeriod;
- (CBCharacteristic *)characteristicForUUID:(NSString *)UUID;

// Methods to override
- (BOOL)processCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

+ (NSString *)serviceUUID;
+ (NSString *)configurationCharacteristicUUID;
+ (NSString *)periodCharacteristicUUID;
+ (NSString *)dataCharacteristicUUID;
@end
