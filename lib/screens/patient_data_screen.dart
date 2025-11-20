import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../models/patient.dart';
import '../services/data_service.dart';
import '../services/google_sheets_service.dart';

class PatientDataScreen extends StatefulWidget {
  const PatientDataScreen({super.key});

  @override
  State<PatientDataScreen> createState() => _PatientDataScreenState();
}

class _PatientDataScreenState extends State<PatientDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _diagnosisController = TextEditingController();

  double _age = 40;
  double _weight = 75;
  String _gender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate()) {
      final patient = Patient(
        id: const Uuid().v4(),
        name: _nameController.text,
        age: _age.toInt(),
        gender: _gender,
        diagnosis: _diagnosisController.text,
        weight: _weight,
        createdAt: DateTime.now(),
      );

      await context.read<DataService>().addPatient(patient);

      // Try to save to Google Sheets
      try {
        await context.read<GoogleSheetsService>().savePatientData(patient);
      } catch (e) {
        debugPrint('Could not save to Google Sheets: $e');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient added successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppConstants.primaryBlue,
              AppConstants.accentBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      AppStrings.patientData,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.medical_services_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Form
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          const Text(
                            'Your Full Name:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: '...........................',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter patient name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          // Age
                          const Text(
                            'Your Age:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: AppConstants.primaryBlue,
                                    inactiveTrackColor:
                                        AppConstants.lightBlue.withOpacity(0.3),
                                    thumbColor: AppConstants.primaryBlue,
                                    overlayColor: AppConstants.primaryBlue
                                        .withOpacity(0.2),
                                    valueIndicatorColor:
                                        AppConstants.primaryBlue,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _age,
                                    min: 5,
                                    max: 80,
                                    divisions: 75,
                                    label: _age.toInt().toString(),
                                    onChanged: (value) {
                                      setState(() => _age = value);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _age.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Gender
                          const Text(
                            'Gender:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Male'),
                                  value: 'Male',
                                  groupValue: _gender,
                                  activeColor: AppConstants.primaryBlue,
                                  onChanged: (value) {
                                    setState(() => _gender = value!);
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Female'),
                                  value: 'Female',
                                  groupValue: _gender,
                                  activeColor: AppConstants.primaryBlue,
                                  onChanged: (value) {
                                    setState(() => _gender = value!);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Diagnosis
                          const Text(
                            'Diagnosis:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _diagnosisController,
                            decoration: const InputDecoration(
                              hintText: '...........................',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter diagnosis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          // Weight
                          const Text(
                            'Your Weight:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: AppConstants.primaryBlue,
                                    inactiveTrackColor:
                                        AppConstants.lightBlue.withOpacity(0.3),
                                    thumbColor: AppConstants.primaryBlue,
                                    overlayColor: AppConstants.primaryBlue
                                        .withOpacity(0.2),
                                    valueIndicatorColor:
                                        AppConstants.primaryBlue,
                                    valueIndicatorTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: Slider(
                                    value: _weight,
                                    min: 5,
                                    max: 200,
                                    divisions: 195,
                                    label: _weight.toInt().toString(),
                                    onChanged: (value) {
                                      setState(() => _weight = value);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryBlue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _weight.toInt().toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 48),
                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _savePatient,
                              child: const Text(
                                'Save Patient',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
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
