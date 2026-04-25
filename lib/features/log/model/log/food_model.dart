import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class FoodModel {
  final String makanan;
  final String logDate;
  final DateTime createdAt;

  FoodModel({
    required this.makanan,
    required this.logDate,
    required this.createdAt
});

  factory FoodModel.fromMap(Map<String, dynamic> data) {
    return FoodModel(
      makanan: data['makanan'] ?? '',
      logDate: data['log_date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now()),
      createdAt: data['created_at'] != null ? (data['created_at'] as Timestamp).toDate() : DateTime.now(),
    );
  }



  Map<String, dynamic>toMap(){
    return{
      'makanan': makanan,
      'log_date': logDate,
      'created_at': Timestamp.fromDate(createdAt)
    };
  }
}