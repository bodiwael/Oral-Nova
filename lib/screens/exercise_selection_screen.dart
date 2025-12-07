import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/animations.dart';
import '../models/patient.dart';
import 'tongue_exercise_selection_screen.dart';
import 'bite_pressure_exercise_screen.dart';
import 'flow_rate_exercise_screen.dart';
import 'dashboard_screen.dart';

class ExerciseSelectionScreen extends StatefulWidget {
  final Patient patient;

  const ExerciseSelectionScreen({super.key, required this.patient});

  @override
  State<ExerciseSelectionScreen> createState() =>
      _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends State<ExerciseSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppConstants.mediumAnimation,
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        colors: [
          AppConstants.backgroundColor,
          AppConstants.lightBlue.withOpacity(0.08),
          AppConstants.accentPink.withOpacity(0.03),
        ],
        duration: const Duration(seconds: 6),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              FadeTransition(
                opacity: _controller,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          BounceAnimation(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: AppConstants.primaryGradient,
                                ),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppConstants.primaryBlue.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const Spacer(),
                          PulseAnimation(
                            duration: const Duration(milliseconds: 2000),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppConstants.surfaceWhite,
                                    AppConstants.cardBackground,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppConstants.accentPurple.withOpacity(0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                  BoxShadow(
                                    color: AppConstants.accentTeal.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(-5, -5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      AppConstants.primaryBlue,
                                      AppConstants.accentPurple,
                                    ],
                                  ).createShader(bounds),
                                  child: const Icon(
                                    Icons.medical_services_rounded,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            AppConstants.deepBlue,
                            AppConstants.accentPurple,
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          AppStrings.chooseExercise,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Exercise Buttons
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StaggeredAnimationItem(
                          index: 0,
                          child: _ExerciseButton(
                            title: 'Tongue',
                            icon: Icons.fitness_center,
                            gradient: AppConstants.primaryGradient,
                            onPressed: () {
                              Navigator.push(
                                context,
                                AnimatedPageRoute(
                                  page: TongueExerciseSelectionScreen(
                                      patient: widget.patient),
                                  direction: AxisDirection.left,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        StaggeredAnimationItem(
                          index: 1,
                          child: _ExerciseButton(
                            title: 'Bite Pressure',
                            icon: Icons.compress,
                            gradient: AppConstants.accentGradient,
                            onPressed: () {
                              Navigator.push(
                                context,
                                AnimatedPageRoute(
                                  page: BitePressureExerciseScreen(
                                      patient: widget.patient),
                                  direction: AxisDirection.left,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        StaggeredAnimationItem(
                          index: 2,
                          child: _ExerciseButton(
                            title: 'Flow Rate Exercise',
                            icon: Icons.water_drop,
                            gradient: AppConstants.successGradient,
                            onPressed: () {
                              Navigator.push(
                                context,
                                AnimatedPageRoute(
                                  page: FlowRateExerciseScreen(
                                      patient: widget.patient),
                                  direction: AxisDirection.left,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Dashboard Button
                        StaggeredAnimationItem(
                          index: 3,
                          child: BounceAnimation(
                            onTap: () {
                              Navigator.push(
                                context,
                                ScalePageRoute(
                                  page: DashboardScreen(patient: widget.patient),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppConstants.surfaceWhite,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  width: 2.5,
                                  color: AppConstants.accentPurple,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppConstants.accentPurple.withOpacity(0.2),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: AppConstants.accentGradient,
                                      ).createShader(bounds),
                                      child: const Icon(
                                        Icons.dashboard,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: AppConstants.accentGradient,
                                      ).createShader(bounds),
                                      child: const Text(
                                        'View Dashboard',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
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

class _ExerciseButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onPressed;

  const _ExerciseButton({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BounceAnimation(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 75,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
