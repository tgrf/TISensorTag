// Services
NSString *const JSTSensorIRTemperatureServiceUUID = @"F000AA00-0451-4000-B000-000000000000";
NSString *const JSTSensorAccelerometerServiceUUID = @"F000AA10-0451-4000-B000-000000000000";
NSString *const JSTSensorHumidityServiceUUID = @"F000AA20-0451-4000-B000-000000000000";
NSString *const JSTSensorMagnetometerServiceUUID = @"F000AA30-0451-4000-B000-000000000000";
NSString *const JSTSensorBarometerServiceUUID = @"F000AA40-0451-4000-B000-000000000000";
NSString *const JSTSensorGyroscopeServiceUUID = @"F000AA50-0451-4000-B000-000000000000";
NSString *const JSTSensorTestServiceUUID = @"F000AA60-0451-4000-B000-000000000000";
NSString *const JSTSensorOADServiceUUID = @"F000FFC0-0451-4000-B000-000000000000";
NSString *const JSTSensorSimpleKeysServiceUUID = @"FFE0";

// Temperature Sensor Characteristic UUID
NSString *const JSTSensorIRTemperatureDataCharacteristicUUID = @"F000AA01-0451-4000-B000-000000000000";    // ObjectLSB:ObjectMSB:AmbientLSB:AmbientMSB
NSString *const JSTSensorIRTemperatureConfigCharacteristicUUID = @"F000AA02-0451-4000-B000-000000000000";  // Write "01" to start Sensor and Measurements, "00" to put to sleep
NSString *const JSTSensorIRTemperaturePeriodCharacteristicUUID = @"F000AA03-0451-4000-B000-000000000000";  // Period =[Input*10]ms, (lower limit 300 ms), default 1000 ms

// Accelerometer Characteristic UUID
NSString *const JSTSensorAccelerometerDataCharacteristicUUID = @"F000AA11-0451-4000-B000-000000000000";    // X:Y:Z Coordinates
NSString *const JSTSensorAccelerometerConfigCharacteristicUUID = @"F000AA12-0451-4000-B000-000000000000";  // Write "01" to select range 2G, "02" for 4G, "03" for 8G, "00" disable sensor
NSString *const JSTSensorAccelerometerPeriodCharacteristicUUID = @"F000AA13-0451-4000-B000-000000000000";  // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms

// Humidity Characteristic UUID
NSString *const JSTSensorHumidityDataCharacteristicUUID = @"F000AA21-0451-4000-B000-000000000000";         // TempLSB:TempMSB:HumidityLSB:HumidityMSB
NSString *const JSTSensorHumidityConfigCharacteristicUUID = @"F000AA22-0451-4000-B000-000000000000";       // Write "01" to start measurements, "00" to stop
NSString *const JSTSensorHumidityPeriodCharacteristicUUID = @"F000AA23-0451-4000-B000-000000000000";       // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms

// Magnetometer Characteristic UUID
NSString *const JSTSensorMagnetometerDataCharacteristicUUID = @"F000AA31-0451-4000-B000-000000000000";     // XLSB:XMSB:YLSB:YMSB:ZLSB:ZMSB Coordinates
NSString *const JSTSensorMagnetometerConfigCharacteristicUUID = @"F000AA32-0451-4000-B000-000000000000";   // Write "01" to start Sensor and Measurements, "00" to put to sleep
NSString *const JSTSensorMagnetometerPeriodCharacteristicUUID = @"F000AA33-0451-4000-B000-000000000000";   // Period =[Input*10]ms, (lower limit 100 ms), default 2000 ms

// Barometer Characteristic UUID
NSString *const JSTSensorBarometerDataCharacteristicUUID = @"F000AA41-0451-4000-B000-000000000000";        // TempLSB:TempMSB:PressureLSB:PressureMSB
NSString *const JSTSensorBarometerConfigCharacteristicUUID = @"F000AA42-0451-4000-B000-000000000000";      // Write "01" to start Sensor and Measurements, "00" to put to sleep, "02" to read calibration values from sensor
NSString *const JSTSensorBarometerPeriodCharacteristicUUID = @"F000AA44-0451-4000-B000-000000000000";      // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms
NSString *const JSTSensorBarometerCalibrationCharacteristicUUID = @"F000AA43-0451-4000-B000-000000000000"; // When write "02" to Barometer conf. has been issued, the calibration values is found here.

// Gyroscope Characteristic UUID
NSString *const JSTSensorGyroscopeDataCharacteristicUUID = @"F000AA51-0451-4000-B000-000000000000";        // XLSB:XMSB:YLSB:YMSB:ZLSB:ZMSB
NSString *const JSTSensorGyroscopeConfigCharacteristicUUID = @"F000AA52-0451-4000-B000-000000000000";      // Write 0 to turn off gyroscope, 1 to enable X axis only, 2 to enable Y axis only, 3 = X and Y, 4 = Z only, 5 = X and Z, 6 = Y and Z, 7 = X, Y and Z
NSString *const JSTSensorGyroscopePeriodCharacteristicUUID = @"F000AA53-0451-4000-B000-000000000000";      // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms

// Simple Keys Characteristic UUID
NSString *const JSTSensorSimpleKeysCharacteristicUUID = @"FFE1";                                            // Key press state
