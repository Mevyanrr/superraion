import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SymptomModel {
  final String? bloatingLevel;
  final String? energyLevel;
  final String? acne;
  final String? mood;
  final String? hairLoss;
  final String? weight;
  final String? digestion;
  final String logDate;
  final DateTime createdAt;

  SymptomModel({
    this.bloatingLevel,
    this.energyLevel,
    this.acne,
    this.mood,
    this.hairLoss,
    this.weight,
    this.digestion,
    required this.logDate,
    required this.createdAt,
  });

  factory SymptomModel.fromSignals(Map<String, String?> signals) {
    return SymptomModel(
      bloatingLevel: signals['Bloating Level'],
      energyLevel: signals['Energy Level'],
      acne: signals['Acne'],
      mood: signals['Mood'],
      hairLoss: signals['Hair Loss'],
      weight: signals['Weight'],
      digestion: signals['Digestion'],
      logDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      createdAt: DateTime.now(),
    );
  }

  factory SymptomModel.fromMap(Map<String, dynamic> data) {
    return SymptomModel(
      bloatingLevel: data['bloating_level'],
      energyLevel: data['energy_level'],
      acne: data['acne'],
      mood: data['mood'],
      hairLoss: data['hair_loss'],
      weight: data['weight'],
      digestion: data['digestion'],
      logDate: data['log_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bloating_level': bloatingLevel,
      'energy_level': energyLevel,
      'acne': acne,
      'mood': mood,
      'hair_loss': hairLoss,
      'weight': weight,
      'digestion': digestion,
      'log_date': logDate,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}