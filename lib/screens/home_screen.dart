import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../utils/animations.dart';
import '../services/data_service.dart';
import '../models/patient.dart';
import 'patient_data_screen.dart';
import 'exercise_selection_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _headerController;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    )..forward();

    Future.microtask(() {
      context.read<DataService>().loadPatients();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        colors: [
          AppConstants.backgroundColor,
          AppConstants.lightBlue.withOpacity(0.08),
          AppConstants.accentTeal.withOpacity(0.05),
        ],
        duration: const Duration(seconds: 6),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              FadeTransition(
                opacity: _headerController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _headerController,
                    curve: Curves.easeOutCubic,
                  )),
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
                            '${AppStrings.welcomeDoctor} ........',
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
              ),
              // Patient List
              Expanded(
                child: Consumer<DataService>(
                  builder: (context, dataService, child) {
                    final patients = dataService.patients;

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: patients.length + 1,
                      itemBuilder: (context, index) {
                        return StaggeredAnimationItem(
                          index: index,
                          delay: const Duration(milliseconds: 80),
                          child: index < patients.length
                              ? _PatientCard(
                                  patient: patients[index],
                                  patientNumber: index + 1,
                                )
                              : const _AddPatientCard(),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final Patient patient;
  final int patientNumber;

  const _PatientCard({
    required this.patient,
    required this.patientNumber,
  });

  @override
  Widget build(BuildContext context) {
    // Cycle through gradient colors for variety
    final gradientColors = [
      AppConstants.primaryGradient,
      AppConstants.accentGradient,
      AppConstants.successGradient,
      AppConstants.warmGradient,
    ];
    final selectedGradient = gradientColors[patientNumber % gradientColors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: BounceAnimation(
        onTap: () {
          context.read<DataService>().setCurrentPatient(patient);
          Navigator.push(
            context,
            AnimatedPageRoute(
              page: ExerciseSelectionScreen(patient: patient),
              direction: AxisDirection.left,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: selectedGradient,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: selectedGradient[0].withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    '$patientNumber',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Patient $patientNumber',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      patient.name.isNotEmpty ? patient.name : 'No name',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
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
      ),
    );
  }
}

class _AddPatientCard extends StatelessWidget {
  const _AddPatientCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      child: BounceAnimation(
        onTap: () {
          Navigator.push(
            context,
            AnimatedPageRoute(
              page: const PatientDataScreen(),
              direction: AxisDirection.left,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppConstants.surfaceWhite,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: AppConstants.accentPurple.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppConstants.accentPurple.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppConstants.accentGradient,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: AppConstants.accentGradient,
                ).createShader(bounds),
                child: const Text(
                  'Add Patient',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
