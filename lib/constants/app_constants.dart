import 'package:flutter/material.dart';

class AppConstants {
  // Enhanced Color Palette - Harmonious & Vibrant
  // Primary Colors
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color deepBlue = Color(0xFF2E5CB8);
  static const Color lightBlue = Color(0xFF6EC1E4);
  static const Color skyBlue = Color(0xFF87CEEB);

  // Accent Colors
  static const Color accentPurple = Color(0xFF8B7EC8);
  static const Color accentTeal = Color(0xFF4ECDC4);
  static const Color accentPink = Color(0xFFE94B7D);
  static const Color accentOrange = Color(0xFFFF8C42);

  // Background & Surface
  static const Color backgroundColor = Color(0xFFF8F9FE);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFAFBFF);

  // Gradient Combinations
  static const List<Color> primaryGradient = [
    Color(0xFF4A90E2),
    Color(0xFF6EC1E4),
  ];

  static const List<Color> accentGradient = [
    Color(0xFF8B7EC8),
    Color(0xFFE94B7D),
  ];

  static const List<Color> successGradient = [
    Color(0xFF4ECDC4),
    Color(0xFF44A08D),
  ];

  static const List<Color> warmGradient = [
    Color(0xFFFF8C42),
    Color(0xFFE94B7D),
  ];

  static const List<Color> coolGradient = [
    Color(0xFF2E5CB8),
    Color(0xFF8B7EC8),
  ];

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
  static const Duration microAnimation = Duration(milliseconds: 150);
  static const Duration shortAnimation = Duration(milliseconds: 300);
  static const Duration mediumAnimation = Duration(milliseconds: 500);
  static const Duration longAnimation = Duration(milliseconds: 800);
  static const Duration extraLongAnimation = Duration(milliseconds: 1200);

  // Shadow & Elevation
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: primaryBlue.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> accentShadow = [
    BoxShadow(
      color: accentPurple.withOpacity(0.15),
      blurRadius: 15,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];
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
