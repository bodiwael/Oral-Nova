import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../utils/animations.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: AppConstants.longAnimation,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        colors: [
          AppConstants.backgroundColor,
          AppConstants.lightBlue.withOpacity(0.1),
          AppConstants.accentPurple.withOpacity(0.05),
        ],
        duration: const Duration(seconds: 5),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Decorative circles in background
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      FloatingAnimation(
                        duration: const Duration(seconds: 3),
                        offset: 15,
                        child: Positioned(
                          top: -50,
                          right: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  AppConstants.accentTeal.withOpacity(0.3),
                                  AppConstants.lightBlue.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      FloatingAnimation(
                        duration: const Duration(milliseconds: 2500),
                        offset: 20,
                        child: Positioned(
                          bottom: 50,
                          left: -100,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  AppConstants.accentPurple.withOpacity(0.2),
                                  AppConstants.accentPink.withOpacity(0.05),
                                  Colors.transparent,
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // OMT Logo
                          PulseAnimation(
                            duration: const Duration(milliseconds: 2000),
                            child: Hero(
                              tag: 'omt_logo',
                              child: Container(
                                width: 180,
                                height: 180,
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
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.accentTeal.withOpacity(0.3),
                                      blurRadius: 30,
                                      offset: const Offset(-5, 10),
                                    ),
                                    BoxShadow(
                                      color: AppConstants.accentPurple.withOpacity(0.2),
                                      blurRadius: 25,
                                      offset: const Offset(5, -5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            AppConstants.primaryBlue,
                                            AppConstants.accentPurple,
                                          ],
                                        ).createShader(bounds),
                                        child: const Icon(
                                          Icons.medical_services_rounded,
                                          size: 70,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            AppConstants.primaryBlue,
                                            AppConstants.deepBlue,
                                          ],
                                        ).createShader(bounds),
                                        child: const Text(
                                          'OMT',
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
                          ),
                          const SizedBox(height: 80),
                          // Sign Up Button
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _slideController,
                              child: BounceAnimation(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    AnimatedPageRoute(
                                      page: const LoginScreen(isSignUp: true),
                                      direction: AxisDirection.left,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: AppConstants.primaryGradient,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: AppConstants.cardShadow,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Log In Button
                          SlideTransition(
                            position: _slideAnimation,
                            child: FadeTransition(
                              opacity: _slideController,
                              child: BounceAnimation(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    AnimatedPageRoute(
                                      page: const LoginScreen(isSignUp: false),
                                      direction: AxisDirection.left,
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: AppConstants.accentGradient,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: AppConstants.accentShadow,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Tagline
                          FadeTransition(
                            opacity: _slideController,
                            child: Column(
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      AppConstants.primaryBlue,
                                      AppConstants.accentPurple,
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'Join our Oral Motor Therapy',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Oral Motor Therapy Team',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.deepBlue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Oral Motor Therapy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppConstants.accentTeal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      AppConstants.accentPink,
                                      AppConstants.accentOrange,
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    AppStrings.tagline,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
