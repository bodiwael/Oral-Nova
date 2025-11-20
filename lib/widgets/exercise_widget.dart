import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../constants/app_constants.dart';
import '../models/patient.dart';
import '../services/bluetooth_service.dart';

class ExerciseWidget extends StatelessWidget {
  final String title;
  final String exerciseType;
  final String? direction;
  final Patient patient;
  final int currentTrial;
  final double? currentReading;
  final bool hasUnsavedReading;
  final SensorType sensorType;
  final Widget mascotImage;
  final VoidCallback onGetReading;
  final VoidCallback onSaveReading;
  final VoidCallback onNextTrial;

  const ExerciseWidget({
    super.key,
    required this.title,
    required this.exerciseType,
    this.direction,
    required this.patient,
    required this.currentTrial,
    required this.currentReading,
    required this.hasUnsavedReading,
    required this.sensorType,
    required this.mascotImage,
    required this.onGetReading,
    required this.onSaveReading,
    required this.onNextTrial,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = currentReading != null ? (currentReading! / 100).clamp(0.0, 1.0) : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppConstants.lightBlue.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.medical_services_rounded,
                  color: AppConstants.primaryBlue,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Trial $currentTrial of ${AppConstants.maxTrials}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              // Mascot/Illustration
              mascotImage,
              const SizedBox(height: 30),
              // Progress Indicator
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppConstants.primaryBlue,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.primaryBlue.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: CircularPercentIndicator(
                  radius: 100,
                  lineWidth: 20,
                  percent: percentage,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentReading != null
                            ? '${currentReading!.toStringAsFixed(1)}%'
                            : '0%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (direction != null)
                        Text(
                          direction!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  backgroundColor: AppConstants.accentBlue,
                  progressColor: Colors.white,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(height: 40),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onGetReading,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(AppStrings.getReading),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: hasUnsavedReading ? onSaveReading : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(AppStrings.saveReading),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: !hasUnsavedReading ? onNextTrial : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    currentTrial < AppConstants.maxTrials
                        ? AppStrings.nextTrial
                        : 'Finish',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Trial Progress Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  AppConstants.maxTrials,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index < currentTrial
                          ? AppConstants.primaryBlue
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
