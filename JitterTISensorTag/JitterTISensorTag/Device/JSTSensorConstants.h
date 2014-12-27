// Service UUID
extern NSString *const JSTSensorIRTemperatureServiceUUID;
extern NSString *const JSTSensorAccelerometerServiceUUID;
extern NSString *const JSTSensorHumidityServiceUUID;
extern NSString *const JSTSensorMagnetometerServiceUUID;
extern NSString *const JSTSensorBarometerServiceUUID;
extern NSString *const JSTSensorGyroscopeServiceUUID;
extern NSString *const JSTSensorTestServiceUUID;
extern NSString *const JSTSensorOADServiceUUID;
extern NSString *const JSTSensorSimpleKeysServiceUUID;

// Temperature Sensor Characteristic UUID
extern NSString *const JSTSensorIRTemperatureDataCharacteristicUUID;    // ObjectLSB:ObjectMSB:AmbientLSB:AmbientMSB
extern NSString *const JSTSensorIRTemperatureConfigCharacteristicUUID;  // Write "01" to start Sensor and Measurements, "00" to put to sleep
extern NSString *const JSTSensorIRTemperaturePeriodCharacteristicUUID;  // Period =[Input*10]ms, (lower limit 300 ms), default 1000 ms

// Accelerometer Characteristic UUID
extern NSString *const JSTSensorAccelerometerDataCharacteristicUUID;    // X:Y:Z Coordinates
extern NSString *const JSTSensorAccelerometerConfigCharacteristicUUID;  // Write "01" to select range 2G, "02" for 4G, "03" for 8G, "00" disable sensor
extern NSString *const JSTSensorAccelerometerPeriodCharacteristicUUID;  // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms

// Humidity Characteristic UUID
extern NSString *const JSTSensorHumidityDataCharacteristicUUID;         // TempLSB:TempMSB:HumidityLSB:HumidityMSB
extern NSString *const JSTSensorHumidityConfigCharacteristicUUID;       // Write "01" to start measurements, "00" to stop
extern NSString *const JSTSensorHumidityPeriodCharacteristicUUID;       // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms

// Magnetometer Characteristic UUID
extern NSString *const JSTSensorMagnetometerDataCharacteristicUUID;     // XLSB:XMSB:YLSB:YMSB:ZLSB:ZMSB Coordinates
extern NSString *const JSTSensorMagnetometerConfigCharacteristicUUID;   // Write "01" to start Sensor and Measurements, "00" to put to sleep
extern NSString *const JSTSensorMagnetometerPeriodCharacteristicUUID;   // Period =[Input*10]ms, (lower limit 100 ms), default 2000 ms

// Barometer Characteristic UUID
extern NSString *const JSTSensorBarometerDataCharacteristicUUID;        // TempLSB:TempMSB:PressureLSB:PressureMSB
extern NSString *const JSTSensorBarometerConfigCharacteristicUUID;      // Write "01" to start Sensor and Measurements, "00" to put to sleep, "02" to read calibration values from sensor
extern NSString *const JSTSensorBarometerPeriodCharacteristicUUID;      // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms
extern NSString *const JSTSensorBarometerCalibrationCharacteristicUUID; // When write "02" to Barometer conf. has been issued, the calibration values is found here.

// Gyroscope Characteristic UUID
extern NSString *const JSTSensorGyroscopeDataCharacteristicUUID;        // XLSB:XMSB:YLSB:YMSB:ZLSB:ZMSB
extern NSString *const JSTSensorGyroscopeConfigCharacteristicUUID;      // Write 0 to turn off gyroscope, 1 to enable X axis only, 2 to enable Y axis only, 3 = X and Y, 4 = Z only, 5 = X and Z, 6 = Y and Z, 7 = X, Y and Z
extern NSString *const JSTSensorGyroscopePeriodCharacteristicUUID;      // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms

// Simple Keys Characteristic UUID
extern NSString *const JSTSensorSimpleKeysCharacteristicUUID;           // Key press state

// Sensors
typedef enum {
    JSTSensorTagSensorIRTemperature,
    JSTSensorTagSensorAccelerometer,
    JSTSensorTagSensorHumidity,
    JSTSensorTagSensorMagnetometer,
    JSTSensorTagSensorBarometer,
    JSTSensorTagSensorGyroscope,
    JSTSensorTagSensorKey
} JSTSensorTagSensor;

// Config values
typedef enum {
    JSTSensorIRTemperatureDisabled      = 0x00,
    JSTSensorIRTemperatureEnabled       = 0x01,
} JSTSensorIRTemperatureConfig;

typedef enum {
    JSTSensorAccelerometerDisabled      = 0x00,
    JSTSensorAccelerometer2GRange       = 0x01,
    JSTSensorAccelerometer4GRange       = 0x02,
    JSTSensorAccelerometer8GRange       = 0x03,
} JSTSensorAccelerometerConfig;

typedef enum {
    JSTSensorHumidityDisabled           = 0x00,
    JSTSensorHumidityEnabled            = 0x01,
} JSTSensorHumidityConfig;

typedef enum {
    JSTSensorMagnetometerDisabled       = 0x00,
    JSTSensorMagnetometerEnabled        = 0x01,
} JSTSensorMagnetometerConfig;

typedef enum {
    JSTSensorBarometerDisabled          = 0x00,
    JSTSensorBarometerEnabled           = 0x01,
    JSTSensorBarometerReadCalibrationCharacteristicUUID = 0x02,
} JSTSensorBarometerConfig;

typedef enum {
    JSTSensorGyroscopeDisabled          = 0x00,
    JSTSensorGyroscopeXOnly             = 0x01,
    JSTSensorGyroscopeYOnly             = 0x02,
    JSTSensorGyroscopeXAndY             = 0x03,
    JSTSensorGyroscopeZOnly             = 0x04,
    JSTSensorGyroscopeXAndZ             = 0x05,
    JSTSensorGyroscopeYAndZ             = 0x06,
    JSTSensorGyroscopeAllAxis           = 0x07,
} JSTSensorGyroscopeConfig;
