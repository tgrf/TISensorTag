#import <Foundation/Foundation.h>

extern NSString *const JSTSensorManagerErrorDomain;

typedef enum {
    JSTSensorManagerErrorNoDeviceFound
} JSTSensorManagerError;

@class JSTSensorManager;
@class JSTSensorTag;

@protocol JSTSensorManagerDelegate<NSObject>
- (void)manager:(JSTSensorManager *)manager didConnectSensor:(JSTSensorTag *)sensor;
- (void)manager:(JSTSensorManager *)manager didDisconnectSensor:(JSTSensorTag *)sensor;
- (void)manager:(JSTSensorManager *)manager didFailToConnectToSensorWithError:(NSError *)error;
- (void)manager:(JSTSensorManager *)manager didDiscoverSensor:(JSTSensorTag *)sensor;
@end

@interface JSTSensorManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, weak) id<JSTSensorManagerDelegate> delegate;

- (void)startScanning;
- (void)stopScanning;
- (void)connectSensorWithUUID:(NSUUID *)uuid;
- (void)connectNearestSensor;
- (void)connectLastSensor;
- (BOOL)hasPreviouslyConnectedSensor;

- (NSArray *)sensors;

@end
