import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                      Positioned(
                        top: -50,
                        right: -50,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: AppConstants.lightBlue.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: -100,
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: AppConstants.lightBlue.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          // OMT Logo
                          Hero(
                            tag: 'omt_logo',
                            child: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: AppConstants.lightBlue.withOpacity(0.3),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 8,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppConstants.primaryBlue
                                        .withOpacity(0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.medical_services_rounded,
                                      size: 70,
                                      color: AppConstants.primaryBlue,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'OMT',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: AppConstants.primaryBlue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                          // Sign Up Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreen(isSignUp: true),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Log In Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const LoginScreen(isSignUp: false),
                                  ),
                                );
                              },
                              child: const Text(
                                'Log In',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Tagline
                          Text(
                            'Join our Oral Motor Therapy',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Oral Motor Therapy Team',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConstants.primaryBlue,
                            ),
                          ),
                          Text(
                            'Oral Motor Therapy',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConstants.primaryBlue,
                            ),
                          ),
                          Text(
                            AppStrings.tagline,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppConstants.primaryBlue,
                              fontStyle: FontStyle.italic,
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
