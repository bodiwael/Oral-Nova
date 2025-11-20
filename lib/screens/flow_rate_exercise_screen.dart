import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/patient.dart';
import '../services/bluetooth_service.dart';
import '../services/data_service.dart';
import '../services/google_sheets_service.dart';
import '../widgets/exercise_widget.dart';

class FlowRateExerciseScreen extends StatefulWidget {
  final Patient patient;

  const FlowRateExerciseScreen({super.key, required this.patient});

  @override
  State<FlowRateExerciseScreen> createState() => _FlowRateExerciseScreenState();
}

class _FlowRateExerciseScreenState extends State<FlowRateExerciseScreen> {
  int currentTrial = 1;
  double? currentReading;
  bool hasUnsavedReading = false;

  @override
  Widget build(BuildContext context) {
    return ExerciseWidget(
      title: 'Flow Rate Exercise',
      exerciseType: AppConstants.flowRateName,
      patient: widget.patient,
      currentTrial: currentTrial,
      currentReading: currentReading,
      hasUnsavedReading: hasUnsavedReading,
      sensorType: SensorType.flowRate,
      mascotImage: _buildMascot(),
      onGetReading: () async {
        final bluetoothService = context.read<BluetoothService>();
        final reading = bluetoothService.getCurrentReading(SensorType.flowRate);

        setState(() {
          currentReading = reading;
          hasUnsavedReading = true;
        });
      },
      onSaveReading: () async {
        if (currentReading == null) return;

        final data = ExerciseData(
          patientId: widget.patient.id,
          exerciseType: AppConstants.flowRateName,
          trialNumber: currentTrial,
          value: currentReading!,
          timestamp: DateTime.now(),
        );

        // Save locally
        await context.read<DataService>().addOfflineData(data);

        // Try to save to Google Sheets
        try {
          await context.read<GoogleSheetsService>().saveExerciseData(data);
        } catch (e) {
          debugPrint('Could not save to Google Sheets: $e');
        }

        setState(() {
          hasUnsavedReading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Reading saved successfully!')),
          );
        }
      },
      onNextTrial: () {
        if (currentTrial < AppConstants.maxTrials) {
          setState(() {
            currentTrial++;
            currentReading = null;
            hasUnsavedReading = false;
          });

          _showCongratulatiosDialog();
        } else {
          _showAllTrialsCompleteDialog();
        }
      },
    );
  }

  Widget _buildMascot() {
    // Cute penguin mascot similar to the design
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppConstants.lightBlue.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.air,
                size: 80,
                color: AppConstants.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Breathe into the sensor',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Consumer<BluetoothService>(
            builder: (context, bluetooth, _) {
              return Column(
                children: [
                  Text(
                    'Inhale: ${bluetooth.currentFlowRateInhale.toStringAsFixed(1)} L/min',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Exhale: ${bluetooth.currentFlowRateExhale.toStringAsFixed(1)} L/min',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _showCongratulatiosDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: AppConstants.primaryBlue, size: 30),
            const SizedBox(width: 8),
            const Text('Congratulations!'),
          ],
        ),
        content: Text(
          'Trial ${currentTrial - 1} completed successfully!\nReady for trial $currentTrial.',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showAllTrialsCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.emoji_events, color: AppConstants.primaryBlue, size: 30),
            const SizedBox(width: 8),
            const Text('Well Done!'),
          ],
        ),
        content: const Text(
          'All trials completed successfully!',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to previous screen
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }
}
