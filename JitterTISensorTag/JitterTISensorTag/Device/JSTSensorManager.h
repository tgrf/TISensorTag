#import <Foundation/Foundation.h>

extern NSString *const JSTSensorTagErrorDomain;

typedef enum {
    JSTSensorManagerErrorNoDeviceFound,
    JSTSensorTagOptionUnavailable
} JSTSensorTagError;

@class JSTSensorManager;
@class JSTSensorTag;

@protocol JSTSensorManagerDelegate<NSObject>
- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor;
- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor;
- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error;
- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor;
- (void)manager:(JSTSensorManager *)manager didChangeStateTo:(CBCentralManagerState)state;
@end

@interface JSTSensorManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, weak) id<JSTSensorManagerDelegate> delegate;

- (void)startScanning;
- (void)stopScanning;
- (void)connectSensorWithUUID:(NSUUID *)uuid;
- (void)connectNearestSensor;
- (void)connectLastSensor;
- (BOOL)hasPreviouslyConnectedSensor;
- (CBCentralManagerState)state;
- (void)disconnectSensor:(JSTSensorTag *)sensorTag;

- (NSArray *)sensors;

@end
