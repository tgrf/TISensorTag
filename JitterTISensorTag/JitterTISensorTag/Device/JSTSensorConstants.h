// Service UUID
extern NSString *const JSTSensorBarometerServiceUUID;
extern NSString *const JSTSensorTestServiceUUID;
extern NSString *const JSTSensorOADServiceUUID;
extern NSString *const JSTSensorSimpleKeysServiceUUID;


// Barometer Characteristic UUID
extern NSString *const JSTSensorBarometerDataCharacteristicUUID;        // TempLSB:TempMSB:PressureLSB:PressureMSB
extern NSString *const JSTSensorBarometerConfigCharacteristicUUID;      // Write "01" to start Sensor and Measurements, "00" to put to sleep, "02" to read calibration values from sensor
extern NSString *const JSTSensorBarometerPeriodCharacteristicUUID;      // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms
extern NSString *const JSTSensorBarometerCalibrationCharacteristicUUID; // When write "02" to Barometer conf. has been issued, the calibration values is found here.

// Simple Keys Characteristic UUID
extern NSString *const JSTSensorSimpleKeysCharacteristicUUID;           // Key press state


// Config values

typedef enum {
    JSTSensorBarometerDisabled          = 0x00,
    JSTSensorBarometerEnabled           = 0x01,
    JSTSensorBarometerReadCalibrationCharacteristicUUID = 0x02,
} JSTSensorBarometerConfig;

