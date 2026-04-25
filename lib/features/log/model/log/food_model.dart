import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FoodModel {
  final List<String> categories;
  final String detail;
  final int waterMl;
  final String logDate;
  final DateTime createdAt;

  FoodModel({
    required this.categories,
    required this.detail,
    required this.waterMl,
    required this.logDate,
    required this.createdAt,
  });

  factory FoodModel.fromMap(Map<String, dynamic> data) {
    return FoodModel(
      categories: List<String>.from(data['categories'] ?? []),
      detail: data['detail'] ?? '',
      waterMl: data['water_ml'] ?? 0,
      logDate: data['log_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories': categories,
      'detail': detail,
      'water_ml': waterMl,
      'log_date': logDate,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}