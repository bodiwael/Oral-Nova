# ESP32 Sensor Code

This directory contains Arduino code for three ESP32-based sensors used in the Oral Nova app.

## Hardware Requirements

### Flow Rate Sensor
- 1x ESP32 development board
- 2x Flow rate sensors (serial output, 9600 baud)
- Connecting wires

**Wiring:**
- Sensor 1 (Inhale): RX → GPIO16, TX → GPIO17, VCC → 5V, GND → GND
- Sensor 2 (Exhale): RX → GPIO25, TX → GPIO26, VCC → 5V, GND → GND

### Bite Force Sensor
- 1x ESP32 development board
- 1x Force Sensitive Resistor (FSR)
- 1x 10kΩ resistor (pull-down)
- Connecting wires

**Wiring:**
```
FSR (one end) → 3.3V
FSR (other end) → GPIO34 (analog input)
                → 10kΩ resistor → GND
```

### Tongue Movement Sensor
- 1x ESP32 development board
- 1x Flex sensor (2.2" or 4.5")
- 1x 10kΩ resistor (voltage divider)
- Connecting wires

**Wiring:**
```
Flex Sensor (one end) → 3.3V
Flex Sensor (other end) → GPIO35 (analog input)
                        → 10kΩ resistor → GND
```

## Software Requirements

1. **Arduino IDE** (version 1.8.x or 2.x)
2. **ESP32 Board Support**:
   - In Arduino IDE, go to File → Preferences
   - Add to "Additional Board Manager URLs":
     ```
     https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
     ```
   - Go to Tools → Board → Boards Manager
   - Search "ESP32" and install "esp32 by Espressif Systems"

3. **Required Libraries**:
   - ESP32 BLE Arduino (included with ESP32 board support)

## Installation Steps

### 1. Flow Rate Sensor

1. Open `flow_rate_sensor/flow_rate_sensor.ino` in Arduino IDE
2. Select board: Tools → Board → ESP32 Arduino → ESP32 Dev Module
3. Select port: Tools → Port → (your ESP32 COM port)
4. Upload the code
5. Open Serial Monitor (115200 baud) to verify operation
6. Device will advertise as "FlowRate_ESP32"

### 2. Bite Force Sensor

1. Open `bite_force_sensor/bite_force_sensor.ino` in Arduino IDE
2. **Important**: Calibrate the sensor first:
   - Upload the code
   - Open Serial Monitor (115200 baud)
   - Apply no pressure and note the raw value
   - Apply maximum expected pressure and note the value
   - Update `MIN_RAW_VALUE` and `MAX_RAW_VALUE` in code
   - Adjust `MAX_FORCE_NEWTONS` based on your FSR specs
3. Re-upload after calibration
4. Device will advertise as "BiteForce_ESP32"

### 3. Tongue Movement Sensor

1. Open `tongue_movement_sensor/tongue_movement_sensor.ino` in Arduino IDE
2. **Important**: Calibrate the sensor first:
   - Upload the code
   - Open Serial Monitor (115200 baud)
   - Keep sensor straight and note the ADC value
   - Bend sensor fully and note the ADC value
   - Update `STRAIGHT_VALUE` and `BENT_VALUE` in code
3. Re-upload after calibration
4. Device will advertise as "Tongue_ESP32"

## Calibration Guide

### FSR Calibration (Bite Force)

The FSR's resistance varies with applied force. To calibrate:

1. **Measure No Load**: With no pressure, note the raw ADC value
2. **Measure Maximum Load**: Apply the maximum expected bite force and note the value
3. **Update Code**:
   ```cpp
   const int MIN_RAW_VALUE = <your_no_load_value>;
   const int MAX_RAW_VALUE = <your_max_load_value>;
   const float MAX_FORCE_NEWTONS = <expected_max_force>;
   ```

### Flex Sensor Calibration (Tongue Movement)

The flex sensor's resistance changes with bending angle:

1. **Measure Straight**: Keep sensor straight, note ADC value
2. **Measure Bent**: Bend sensor to maximum expected angle, note value
3. **Update Code**:
   ```cpp
   const int STRAIGHT_VALUE = <your_straight_value>;
   const int BENT_VALUE = <your_bent_value>;
   const float MAX_ANGLE = 90.0;  // Adjust as needed
   ```

## Bluetooth UUIDs

Each sensor uses unique UUIDs for BLE communication:

| Sensor | Service UUID | Characteristic UUID |
|--------|-------------|---------------------|
| Flow Rate | 4fafc201-1fb5-459e-8fcc-c5c9c331914b | beb5483e-36e1-4688-b7f5-ea07361b26a8 |
| Bite Force | 4fafc202-1fb5-459e-8fcc-c5c9c331914b | beb5483e-36e1-4688-b7f5-ea07361b26a9 |
| Tongue | 4fafc203-1fb5-459e-8fcc-c5c9c331914b | beb5483e-36e1-4688-b7f5-ea07361b26aa |

## Data Format

### Flow Rate Sensor
Sends CSV format: `Inhale,Exhale\n`
Example: `45.2,38.7\n`

### Bite Force Sensor
Sends single value: `Force\n`
Example: `23.5\n`

### Tongue Movement Sensor
Sends percentage: `Percentage\n`
Example: `67.3\n`

## Troubleshooting

### Upload Fails
- Hold "BOOT" button on ESP32 while uploading
- Check USB cable supports data transfer
- Try different USB port
- Reset ESP32 and try again

### Bluetooth Not Advertising
- Check Serial Monitor for errors
- Ensure BLE library is properly installed
- Reset ESP32 and check again
- Verify antenna connection (if external)

### Sensor Readings Incorrect
- Recalibrate sensors
- Check wiring connections
- Verify sensor power supply (3.3V)
- Check for loose connections
- Use multimeter to verify sensor resistance

### No Serial Output
- Check baud rate is 115200
- Verify TX/RX connections
- Try different USB cable
- Reset ESP32

## Power Considerations

- ESP32 can be powered via USB (5V) or external power (3.3V)
- When using battery power, ensure voltage regulator provides stable 3.3V
- Total current draw per ESP32: ~80-100mA during BLE transmission
- Consider using a battery pack with at least 500mAh capacity

## Enclosure Recommendations

For medical use, consider:
- Food-safe plastic enclosures
- Easy-to-clean surfaces
- Secure sensor mounting
- Access to USB port for charging/updates
- LED indicators for power and connection status

## Maintenance

- Regularly clean sensors with isopropyl alcohol
- Check connections periodically
- Update firmware as needed
- Replace sensors if readings become inconsistent
- Keep spare ESP32 boards for quick replacement

## Safety Notes

- Sensors are for monitoring purposes only
- Not intended for medical diagnosis
- Ensure proper hygiene when used with multiple patients
- Regular calibration recommended (weekly for clinical use)
- Do not expose to water unless properly sealed

## Support

For technical issues:
- Check Serial Monitor for debug messages
- Verify all wiring connections
- Ensure latest ESP32 board support is installed
- Refer to main project README for app-side troubleshooting
