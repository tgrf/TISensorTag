#import <Foundation/Foundation.h>
#import "JSTSensorConstants.h"

@class JSTSensorTag;

typedef struct {
    float x, y, z;
} JSTVector3D;

extern NSString *const JSTSensorTagDidFinishDiscoveryNotification;
extern NSString *const JSTSensorTagConnectionFailureNotification;
extern NSString *const JSTSensorTagConnectionFailureNotificationErrorKey;

@protocol JSTSensorTagDelegate<NSObject>
- (void)sensor:(JSTSensorTag *)sensorTag didConfigureSensor:(JSTSensorTagSensor)sensor;
- (void)sensor:(JSTSensorTag *)sensorTag didConfigurePeriodForSensor:(JSTSensorTagSensor)sensor;
- (void)sensorDidCalibratePressureSensor:(JSTSensorTag *)sensorTag;
- (void)sensor:(JSTSensorTag *)sensorTag didReadMagnetometerValue:(JSTVector3D)vector;
- (void)sensor:(JSTSensorTag *)sensorTag didReadAccelerometerValue:(JSTVector3D)vector;
- (void)sensor:(JSTSensorTag *)sensorTag didReadGyroscopeValue:(JSTVector3D)vector;
- (void)sensor:(JSTSensorTag *)sensorTag didReadIRObjectTemperature:(float)objectTemp ambientTemperature:(float)ambientTemp;
- (void)sensor:(JSTSensorTag *)sensorTag didReadHumidityTemperature:(float)objectTemp humidity:(float)ambientTemp;
- (void)sensor:(JSTSensorTag *)sensorTag didReadBarometerTemperature:(float)objectTemp pressure:(float)ambientTemp;

- (void)sensor:(JSTSensorTag *)sensorTag didFailBLECommunicationWithError:(NSError *)error;
@end

@interface JSTSensorTag : NSObject

@property(nonatomic, readonly) CBPeripheral *peripheral;

@property(nonatomic) NSInteger rssi;

@property(nonatomic, weak) id<JSTSensorTagDelegate> sensorDelegate;

+ (NSArray *)availableServicesUUIDArray;

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;

- (void)discoverServices;

- (void)configureSensor:(JSTSensorTagSensor)sensor withValue:(unsigned char)value;

- (void)configurePeriodForSensor:(JSTSensorTagSensor)sensor withValue:(unsigned char)value;

- (void)setUpdatingSensor:(JSTSensorTagSensor)sensor enabled:(BOOL)enabled;

- (void)calibratePressure;

+ (NSArray *)availableCharacteristicsUUIDArrayForServiceUUID:(NSString *)service;
@end
