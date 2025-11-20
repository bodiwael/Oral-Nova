import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/patient.dart';
import 'tongue_exercise_selection_screen.dart';
import 'bite_pressure_exercise_screen.dart';
import 'flow_rate_exercise_screen.dart';
import 'dashboard_screen.dart';

class ExerciseSelectionScreen extends StatelessWidget {
  final Patient patient;

  const ExerciseSelectionScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              AppConstants.lightBlue.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppConstants.lightBlue.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.medical_services_rounded,
                              size: 40,
                              color: AppConstants.primaryBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.chooseExercise,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Decorative circles
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: -50,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: AppConstants.lightBlue.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      left: -80,
                      child: Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppConstants.lightBlue.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Exercise Buttons
                    Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _ExerciseButton(
                              title: 'Tongue',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TongueExerciseSelectionScreen(
                                            patient: patient),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            _ExerciseButton(
                              title: 'Bite Pressure',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BitePressureExerciseScreen(
                                            patient: patient),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            _ExerciseButton(
                              title: 'Flow Rate Exercise',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FlowRateExerciseScreen(
                                            patient: patient),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                            // Dashboard Button
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DashboardScreen(patient: patient),
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: AppConstants.primaryBlue,
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  'View Dashboard',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppConstants.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _ExerciseButton({
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
          elevation: 5,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
