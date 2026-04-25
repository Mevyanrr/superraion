import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HabitModel {
  final String tidurMulai;
  final String tidurSelesai;
  final double durasiJam;
  final String? relaxed;
  final String? moderate;
  final String? stresshigh;
  final String? stresslow;
  final String? active;
  final String? light;
  final String? none;
  final String? energyhigh;
  final String? energylow;
  final String logDate;
  final DateTime createdAt;

  HabitModel({
    required this.tidurMulai,
    required this.tidurSelesai,
    required this.durasiJam,
    required this.logDate,
    required this.createdAt,
    this.active,
    this.stresshigh,
    this.stresslow,
    this.light,
    this.energyhigh,
    this.energylow,
    this.moderate,
    this.none,
    this.relaxed,
  });

  factory HabitModel.fromMap(Map<String, dynamic> data) {
    String formatDate(dynamic date) {
      if (date is Timestamp) {
        return DateFormat('yyyy-MM-dd').format(date.toDate());
      } else if (date is String) {
        return date;
      }
      return DateFormat('yyyy-MM-dd').format(DateTime.now());
    }

    return HabitModel(
      tidurMulai: data['tidur_mulai'] ?? '',
      tidurSelesai: data['tidur_selesai'] ?? '',
      durasiJam: (data['durasi_jam'] ?? 0).toDouble(),
      logDate: formatDate(data['log_date']),
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(),
      relaxed: data['relaxed'],
      moderate: data['moderate'],
      stresshigh: data['stresshigh'],
      stresslow: data['stresslow'],
      active: data['active'],
      light: data['light'],
      none: data['none'],
      energyhigh: data['energyhigh'],
      energylow: data['energylow'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'tidur_mulai': tidurMulai,
      'tidur_selesai': tidurSelesai,
      'durasi_jam': durasiJam,
      'log_date': logDate,
      'created_at': Timestamp.fromDate(createdAt),
    };

    if (relaxed != null) map['relaxed'] = relaxed;
    if (moderate != null) map['moderate'] = moderate;
    if (stresshigh != null) map['stresshigh'] = stresshigh;
    if (stresslow != null) map['stresslow'] = stresslow;
    if (active != null) map['active'] = active;
    if (light != null) map['light'] = light;
    if (none != null) map['none'] = none;
    if (energyhigh != null) map['energyhigh'] = energyhigh;
    if (energylow != null) map['energylow'] = energylow;

    return map;
  }
}