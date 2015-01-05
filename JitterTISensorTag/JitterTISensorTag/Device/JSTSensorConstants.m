// Services


NSString *const JSTSensorBarometerServiceUUID = @"F000AA40-0451-4000-B000-000000000000";
NSString *const JSTSensorTestServiceUUID = @"F000AA60-0451-4000-B000-000000000000";
NSString *const JSTSensorOADServiceUUID = @"F000FFC0-0451-4000-B000-000000000000";
NSString *const JSTSensorSimpleKeysServiceUUID = @"FFE0";

// Barometer Characteristic UUID
NSString *const JSTSensorBarometerDataCharacteristicUUID = @"F000AA41-0451-4000-B000-000000000000";        // TempLSB:TempMSB:PressureLSB:PressureMSB
NSString *const JSTSensorBarometerConfigCharacteristicUUID = @"F000AA42-0451-4000-B000-000000000000";      // Write "01" to start Sensor and Measurements, "00" to put to sleep, "02" to read calibration values from sensor
NSString *const JSTSensorBarometerPeriodCharacteristicUUID = @"F000AA44-0451-4000-B000-000000000000";      // Period =[Input*10]ms, (lower limit 100 ms), default 1000 ms
NSString *const JSTSensorBarometerCalibrationCharacteristicUUID = @"F000AA43-0451-4000-B000-000000000000"; // When write "02" to Barometer conf. has been issued, the calibration values is found here.

// Simple Keys Characteristic UUID
NSString *const JSTSensorSimpleKeysCharacteristicUUID = @"FFE1";                                            // Key press state
