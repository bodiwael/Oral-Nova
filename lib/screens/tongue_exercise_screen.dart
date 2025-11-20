import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../models/patient.dart';
import '../services/bluetooth_service.dart' show BluetoothManager, SensorType;
import '../services/data_service.dart';
import '../services/google_sheets_service.dart';
import '../widgets/exercise_widget.dart';

class TongueExerciseScreen extends StatefulWidget {
  final Patient patient;
  final String direction;

  const TongueExerciseScreen({
    super.key,
    required this.patient,
    required this.direction,
  });

  @override
  State<TongueExerciseScreen> createState() => _TongueExerciseScreenState();
}

class _TongueExerciseScreenState extends State<TongueExerciseScreen> {
  int currentTrial = 1;
  double? currentReading;
  bool hasUnsavedReading = false;

  @override
  Widget build(BuildContext context) {
    return ExerciseWidget(
      title: '${widget.direction} Tongue Movement',
      exerciseType: AppConstants.tongueName,
      direction: widget.direction,
      patient: widget.patient,
      currentTrial: currentTrial,
      currentReading: currentReading,
      hasUnsavedReading: hasUnsavedReading,
      sensorType: SensorType.tongue,
      mascotImage: _getMascotForDirection(widget.direction),
      onGetReading: () async {
        final bluetoothService = context.read<BluetoothManager>();
        final reading = bluetoothService.getCurrentReading(SensorType.tongue);

        setState(() {
          currentReading = reading;
          hasUnsavedReading = true;
        });
      },
      onSaveReading: () async {
        if (currentReading == null) return;

        final data = ExerciseData(
          patientId: widget.patient.id,
          exerciseType: AppConstants.tongueName,
          direction: widget.direction,
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

  Widget _getMascotForDirection(String direction) {
    // Return appropriate illustration based on direction
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getIconForDirection(direction),
            size: 100,
            color: AppConstants.primaryBlue,
          ),
          const SizedBox(height: 8),
          Text(
            'Move tongue $direction',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForDirection(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
        return Icons.arrow_upward;
      case 'down':
        return Icons.arrow_downward;
      case 'left':
        return Icons.arrow_back;
      case 'right':
        return Icons.arrow_forward;
      case 'forward':
        return Icons.arrow_forward;
      case 'backward':
        return Icons.arrow_back;
      default:
        return Icons.accessibility_new;
    }
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
