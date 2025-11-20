import 'package:flutter/material.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import '../models/patient.dart';

class GoogleSheetsService extends ChangeNotifier {
  sheets.SheetsApi? _sheetsApi;
  String? _spreadsheetId;
  bool isAuthenticated = false;

  // TODO: Add your Google Cloud Service Account credentials
  // Download the JSON file from Google Cloud Console
  final String _credentialsPath = 'assets/credentials.json';

  Future<void> initialize(String spreadsheetId) async {
    _spreadsheetId = spreadsheetId;

    try {
      // For production, use service account credentials
      // For now, this is a placeholder - you'll need to implement proper OAuth2
      // or service account authentication

      // Example service account auth (requires credentials file):
      /*
      final credentials = ServiceAccountCredentials.fromJson(
        await rootBundle.loadString(_credentialsPath)
      );

      final client = await clientViaServiceAccount(
        credentials,
        [sheets.SheetsApi.spreadsheetsScope]
      );

      _sheetsApi = sheets.SheetsApi(client);
      */

      isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing Google Sheets: $e');
      isAuthenticated = false;
    }
  }

  Future<void> saveExerciseData(ExerciseData data) async {
    if (_sheetsApi == null || _spreadsheetId == null) {
      debugPrint('Google Sheets not initialized');
      return;
    }

    try {
      final sheetName = data.exerciseType;
      final row = data.toSheetRow();

      final valueRange = sheets.ValueRange.fromJson({
        'values': [row]
      });

      await _sheetsApi!.spreadsheets.values.append(
        valueRange,
        _spreadsheetId!,
        '$sheetName!A:F',
        valueInputOption: 'RAW',
      );

      debugPrint('Data saved to Google Sheets');
    } catch (e) {
      debugPrint('Error saving to Google Sheets: $e');
      rethrow;
    }
  }

  Future<void> savePatientData(Patient patient) async {
    if (_sheetsApi == null || _spreadsheetId == null) {
      debugPrint('Google Sheets not initialized');
      return;
    }

    try {
      final row = [
        patient.id,
        patient.name,
        patient.age,
        patient.gender,
        patient.diagnosis,
        patient.weight,
        patient.createdAt.toIso8601String(),
      ];

      final valueRange = sheets.ValueRange.fromJson({
        'values': [row]
      });

      await _sheetsApi!.spreadsheets.values.append(
        valueRange,
        _spreadsheetId!,
        'Patients!A:G',
        valueInputOption: 'RAW',
      );

      debugPrint('Patient data saved to Google Sheets');
    } catch (e) {
      debugPrint('Error saving patient to Google Sheets: $e');
      rethrow;
    }
  }

  Future<List<List<dynamic>>> getExerciseHistory(
      String patientId, String exerciseType) async {
    if (_sheetsApi == null || _spreadsheetId == null) {
      return [];
    }

    try {
      final response = await _sheetsApi!.spreadsheets.values.get(
        _spreadsheetId!,
        '$exerciseType!A:F',
      );

      final values = response.values ?? [];

      // Filter by patient ID
      return values
          .where((row) => row.isNotEmpty && row[0] == patientId)
          .toList();
    } catch (e) {
      debugPrint('Error getting exercise history: $e');
      return [];
    }
  }

  // Offline mode: Save to local storage and sync later
  Future<void> syncOfflineData(List<ExerciseData> offlineData) async {
    for (var data in offlineData) {
      try {
        await saveExerciseData(data);
      } catch (e) {
        debugPrint('Error syncing offline data: $e');
      }
    }
  }
}
