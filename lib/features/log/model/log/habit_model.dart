import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HabitModel {
  final String kebiasaan;
  final String logDate;
  final DateTime createdAt;

  HabitModel({
    required this.kebiasaan,
    required this.logDate,
    required this.createdAt
});

  factory HabitModel.fromMap(Map<String, dynamic> data) {
    return HabitModel(
      kebiasaan: data['kebiasaan'] ?? '',
      logDate: data['log_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic>toMap(){
    return{
      'kebiasaan': kebiasaan,
      'log_date': logDate,
      'created_at': Timestamp.fromDate(createdAt)
    };
  }
}
