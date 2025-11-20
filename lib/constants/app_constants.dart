import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryBlue = Color(0xFF2E5C9A);
  static const Color lightBlue = Color(0xFF87CEEB);
  static const Color accentBlue = Color(0xFF5B9BD5);
  static const Color backgroundColor = Color(0xFFF5F5F5);

  // Exercise Types
  static const String tongueName = 'Tongue';
  static const String bitePressureName = 'Bite Pressure';
  static const String flowRateName = 'Flow Rate';

  // Tongue Directions
  static const List<String> tongueDirections = [
    'Up',
    'Down',
    'Right',
    'Left',
    'Forward',
    'Backward',
  ];

  // Trial Configuration
  static const int maxTrials = 5;

  // Bluetooth UUIDs (Update these with your ESP32 UUIDs)
  static const String flowRateServiceUUID = '4fafc201-1fb5-459e-8fcc-c5c9c331914b';
  static const String flowRateCharUUID = 'beb5483e-36e1-4688-b7f5-ea07361b26a8';

  static const String biteForceServiceUUID = '4fafc202-1fb5-459e-8fcc-c5c9c331914b';
  static const String biteForceCharUUID = 'beb5483e-36e1-4688-b7f5-ea07361b26a9';

  static const String tongueServiceUUID = '4fafc203-1fb5-459e-8fcc-c5c9c331914b';
  static const String tongueCharUUID = 'beb5483e-36e1-4688-b7f5-ea07361b26aa';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
}

class AppStrings {
  static const String appName = 'Oral Nova';
  static const String tagline = 'From Motion To Expression';
  static const String welcomeDoctor = 'Welcome Dr.';
  static const String chooseExercise = 'Choose Exercise !!';
  static const String patientData = 'Patient Data';
  static const String dashboard = 'Dash Board';

  // Button Labels
  static const String getReading = 'Get Reading';
  static const String saveReading = 'Save Reading';
  static const String nextTrial = 'Next Bite';
  static const String letsStart = "Let's Start";

  // Messages
  static const String congratulations = 'Congratulations!';
  static const String trialComplete = 'Trial completed successfully!';
  static const String allTrialsComplete = 'All trials completed!';
}
