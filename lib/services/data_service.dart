import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/patient.dart';

class DataService extends ChangeNotifier {
  List<Patient> _patients = [];
  List<ExerciseData> _offlineData = [];
  Patient? _currentPatient;

  List<Patient> get patients => _patients;
  Patient? get currentPatient => _currentPatient;
  List<ExerciseData> get offlineData => _offlineData;

  Future<void> loadPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final patientsJson = prefs.getStringList('patients') ?? [];

    _patients = patientsJson
        .map((json) => Patient.fromJson(jsonDecode(json)))
        .toList();

    notifyListeners();
  }

  Future<void> addPatient(Patient patient) async {
    _patients.add(patient);
    await _savePatients();
    notifyListeners();
  }

  Future<void> updatePatient(Patient patient) async {
    final index = _patients.indexWhere((p) => p.id == patient.id);
    if (index != -1) {
      _patients[index] = patient;
      await _savePatients();
      notifyListeners();
    }
  }

  Future<void> deletePatient(String patientId) async {
    _patients.removeWhere((p) => p.id == patientId);
    await _savePatients();
    notifyListeners();
  }

  Future<void> _savePatients() async {
    final prefs = await SharedPreferences.getInstance();
    final patientsJson =
        _patients.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList('patients', patientsJson);
  }

  void setCurrentPatient(Patient patient) {
    _currentPatient = patient;
    notifyListeners();
  }

  // Offline data management
  Future<void> addOfflineData(ExerciseData data) async {
    _offlineData.add(data);
    await _saveOfflineData();
    notifyListeners();
  }

  Future<void> clearOfflineData() async {
    _offlineData.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('offline_data');
    notifyListeners();
  }

  Future<void> _saveOfflineData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson =
        _offlineData.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList('offline_data', dataJson);
  }

  Future<void> loadOfflineData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataJson = prefs.getStringList('offline_data') ?? [];

    _offlineData = dataJson
        .map((json) => ExerciseData.fromJson(jsonDecode(json)))
        .toList();

    notifyListeners();
  }

  // Get exercise history for current patient
  List<ExerciseData> getPatientExerciseData(String exerciseType) {
    if (_currentPatient == null) return [];

    return _offlineData
        .where((data) =>
            data.patientId == _currentPatient!.id &&
            data.exerciseType == exerciseType)
        .toList();
  }

  // Get aggregated data for charts
  Map<String, List<double>> getChartData(String exerciseType) {
    final data = getPatientExerciseData(exerciseType);
    Map<String, List<double>> chartData = {};

    for (var item in data) {
      String key = item.direction ?? 'default';
      if (!chartData.containsKey(key)) {
        chartData[key] = [];
      }
      chartData[key]!.add(item.value);
    }

    return chartData;
  }
}
