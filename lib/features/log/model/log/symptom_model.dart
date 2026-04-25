import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SymptomModel {
  final String gejala;
  final String logDate;
  final DateTime createdAt;

  SymptomModel({
    required this.gejala,
    required this.logDate,
    required this.createdAt
});

  factory SymptomModel.fromMap(Map<String, dynamic> data) {
    return SymptomModel(
      gejala: data['gejala'] ?? '',
      logDate: data['log_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic>toMap(){
    return{
      'gejala': gejala,
      'log_date': logDate,
      'created_at': Timestamp.fromDate(createdAt)
    };
  }
}
