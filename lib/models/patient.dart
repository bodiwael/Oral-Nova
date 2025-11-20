class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String diagnosis;
  final double weight;
  final DateTime createdAt;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.diagnosis,
    required this.weight,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'diagnosis': diagnosis,
      'weight': weight,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      gender: json['gender'],
      diagnosis: json['diagnosis'],
      weight: json['weight'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ExerciseData {
  final String patientId;
  final String exerciseType;
  final String? direction; // For tongue exercises
  final int trialNumber;
  final double value;
  final DateTime timestamp;

  ExerciseData({
    required this.patientId,
    required this.exerciseType,
    this.direction,
    required this.trialNumber,
    required this.value,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'patientId': patientId,
      'exerciseType': exerciseType,
      'direction': direction,
      'trialNumber': trialNumber,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ExerciseData.fromJson(Map<String, dynamic> json) {
    return ExerciseData(
      patientId: json['patientId'],
      exerciseType: json['exerciseType'],
      direction: json['direction'],
      trialNumber: json['trialNumber'],
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  List<dynamic> toSheetRow() {
    return [
      patientId,
      exerciseType,
      direction ?? '',
      trialNumber,
      value,
      timestamp.toIso8601String(),
    ];
  }
}
