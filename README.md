# Oral Nova - Oral Motor Therapy (OMT) Monitoring App

A comprehensive Flutter application for monitoring and tracking oral motor therapy exercises using ESP32-based sensors. The app integrates with three different sensors (Flow Rate, Bite Force, and Tongue Movement) via Bluetooth and saves data to Google Sheets for analysis.

## Features

- **Patient Management**: Add, view, and manage patient information
- **Exercise Types**:
  - **Tongue Exercises**: 6 directional movements (Up, Down, Left, Right, Forward, Backward)
  - **Bite Pressure**: Measure bite force using FSR sensor
  - **Flow Rate**: Monitor inhale/exhale flow rates
- **Trial System**: Each exercise supports 5 trials with individual readings
- **Real-time Bluetooth Connectivity**: Connect to ESP32 sensors for live data
- **Google Sheets Integration**: Automatic data backup to cloud
- **Offline Mode**: Local data storage with automatic sync
- **Dashboard**: Visual charts showing patient progress over time
- **Modern UI**: Beautiful, animated interface based on Material Design

## Screenshots

The app design is based on the mockups in the `assets/` folder, featuring:
- Clean blue color scheme
- Animated transitions
- Circular progress indicators
- User-friendly navigation

## Project Structure

```
Oral-Nova/
├── lib/
│   ├── main.dart
│   ├── constants/
│   │   └── app_constants.dart
│   ├── models/
│   │   └── patient.dart
│   ├── services/
│   │   ├── bluetooth_service.dart
│   │   ├── google_sheets_service.dart
│   │   └── data_service.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   ├── home_screen.dart
│   │   ├── patient_data_screen.dart
│   │   ├── dashboard_screen.dart
│   │   ├── exercise_selection_screen.dart
│   │   ├── tongue_exercise_selection_screen.dart
│   │   ├── tongue_exercise_screen.dart
│   │   ├── bite_pressure_exercise_screen.dart
│   │   └── flow_rate_exercise_screen.dart
│   └── widgets/
│       └── exercise_widget.dart
├── esp32_code/
│   ├── flow_rate_sensor/
│   │   └── flow_rate_sensor.ino
│   ├── bite_force_sensor/
│   │   └── bite_force_sensor.ino
│   └── tongue_movement_sensor/
│       └── tongue_movement_sensor.ino
├── assets/
└── pubspec.yaml
```

## Prerequisites

### Flutter Development
- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio or VS Code with Flutter extensions
- Android device or emulator with Bluetooth support

### Hardware
- 3x ESP32 development boards
- 2x Flow rate sensors (for inhale/exhale)
- 1x Force Sensitive Resistor (FSR) for bite force
- 1x Flex sensor for tongue movement
- Appropriate resistors and wiring

### Cloud Services
- Google Cloud Platform account (for Sheets API)
- Service account credentials JSON file

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/Oral-Nova.git
cd Oral-Nova
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure Google Sheets API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable Google Sheets API
4. Create a Service Account
5. Download the credentials JSON file
6. Place it in `assets/credentials.json`
7. Update `lib/services/google_sheets_service.dart` with your spreadsheet ID

### 4. Setup ESP32 Sensors

#### Flow Rate Sensor
1. Open `esp32_code/flow_rate_sensor/flow_rate_sensor.ino` in Arduino IDE
2. Install required libraries:
   - ESP32 BLE Arduino (by Neil Kolban)
3. Connect sensors to ESP32:
   - Sensor 1 (Inhale): RX->GPIO16, TX->GPIO17
   - Sensor 2 (Exhale): RX->GPIO25, TX->GPIO26
4. Upload to ESP32
5. Note the device name: `FlowRate_ESP32`

#### Bite Force Sensor
1. Open `esp32_code/bite_force_sensor/bite_force_sensor.ino`
2. Connect FSR to GPIO34 (analog pin)
3. Calibrate `MAX_FORCE_NEWTONS` based on your sensor
4. Upload to ESP32
5. Note the device name: `BiteForce_ESP32`

#### Tongue Movement Sensor
1. Open `esp32_code/tongue_movement_sensor/tongue_movement_sensor.ino`
2. Connect flex sensor to GPIO35 (analog pin)
3. Calibrate `STRAIGHT_VALUE` and `BENT_VALUE` by measuring ADC values
4. Upload to ESP32
5. Note the device name: `Tongue_ESP32`

### 5. Update Bluetooth UUIDs (if needed)

If you change the UUIDs in ESP32 code, update them in:
- `lib/constants/app_constants.dart`

### 6. Build and Run

```bash
# For Android
flutter run

# For release build
flutter build apk --release
```

## Usage

### First Time Setup

1. **Launch App**: Open the app on your device
2. **Login/Sign Up**: Create an account or log in
3. **Add Patient**: Tap "Add Patient" and fill in patient details
4. **Connect Sensors**: Ensure all ESP32 devices are powered on
5. **Select Patient**: Choose a patient from the list
6. **Choose Exercise**: Select from Tongue, Bite Pressure, or Flow Rate

### Conducting an Exercise

1. **Start Exercise**: Tap on the exercise type
2. **Get Reading**: Press "Get Reading" to capture sensor data
3. **Save Reading**: Press "Save Reading" to store the measurement
4. **Next Trial**: Complete all 5 trials
5. **View Dashboard**: Check progress charts

### Data Management

- **Local Storage**: All data is saved locally using Hive
- **Cloud Sync**: Automatic upload to Google Sheets when online
- **Offline Mode**: Works without internet, syncs when connected

## Bluetooth Connection

The app automatically scans and connects to ESP32 devices with names:
- `FlowRate_ESP32`
- `BiteForce_ESP32`
- `Tongue_ESP32`

Make sure Bluetooth is enabled and location permissions are granted.

## Google Sheets Data Format

### Patients Sheet
| ID | Name | Age | Gender | Diagnosis | Weight | Created At |
|----|------|-----|--------|-----------|--------|------------|

### Exercise Data Sheets (Tongue, Bite Pressure, Flow Rate)
| Patient ID | Exercise Type | Direction | Trial # | Value | Timestamp |
|------------|---------------|-----------|---------|-------|-----------|

## Troubleshooting

### Bluetooth Connection Issues
- Ensure location permissions are granted
- Enable Bluetooth on your device
- Keep ESP32 devices within range
- Restart the ESP32 if not appearing in scan

### Sensor Reading Issues
- Check sensor wiring
- Verify ESP32 is powered
- Monitor Serial output from ESP32 (9600 baud)
- Recalibrate sensor values if needed

### Google Sheets Errors
- Verify credentials.json is correct
- Check internet connection
- Ensure spreadsheet permissions are set
- Data will be stored locally if offline

## Customization

### Change Color Scheme
Edit `lib/constants/app_constants.dart`:
```dart
static const Color primaryBlue = Color(0xFF2E5C9A);
static const Color lightBlue = Color(0xFF87CEEB);
```

### Adjust Trial Count
Change `maxTrials` in `lib/constants/app_constants.dart`

### Modify Sensor Calibration
Edit calibration values in respective ESP32 .ino files

## Dependencies

Key Flutter packages:
- `flutter_blue_plus` - Bluetooth connectivity
- `fl_chart` - Data visualization
- `googleapis` - Google Sheets API
- `provider` - State management
- `hive` - Local database
- `google_fonts` - Typography
- `percent_indicator` - Progress displays

## Architecture

- **State Management**: Provider pattern
- **Local Storage**: Hive (NoSQL)
- **Cloud Storage**: Google Sheets API
- **Bluetooth**: BLE (Bluetooth Low Energy)
- **UI**: Material Design 3

## Future Enhancements

- [ ] Add authentication with Firebase
- [ ] Export data as PDF reports
- [ ] Add multi-language support
- [ ] Implement data encryption
- [ ] Add exercise history comparison
- [ ] Voice-guided exercises
- [ ] Add reminder notifications

## Contributing

Contributions are welcome! Please follow these steps:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## License

This project is licensed under the MIT License - see LICENSE file for details.

## Support

For issues, questions, or suggestions:
- Create an issue on GitHub
- Email: support@oralnova.com

## Acknowledgments

- Design mockups from OralNova Sense design team
- ESP32 community for sensor examples
- Flutter community for amazing packages

---

**Developed with ❤️ for Oral Motor Therapy professionals**
