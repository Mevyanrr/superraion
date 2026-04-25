import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'log_mapper.dart';

class ApiService {
  final String _baseUrl = 'http://10.0.175.154:8000';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>?> _buildPayloadFromFirestore() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final foodSnap = await _firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('food_log')
          .orderBy('log_date')
          .get();

      final symptomSnap = await _firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('symptom_log')
          .orderBy('log_date')
          .get();

      final habitSnap = await _firestore
          .collection('user_superraion')
          .doc(user.uid)
          .collection('habit_log')
          .orderBy('log_date')
          .get();

      final Map<String, Map<String, dynamic>> byDate = {};

      for (var doc in foodSnap.docs) {
        final d = doc.data();
        final date = d['log_date'] as String? ?? '';
        final categories = List<String>.from(d['categories'] ?? []);
        final detail = d['detail'] as String? ?? '';

        byDate[date] = {
          'log_date': date,
          // ← Pakai LogMapper supaya format sama dengan submitDailyLog
          'food': LogMapper.mapFood(categories, detail),
          'symptoms': {},
          'habits': {},
        };
      }

      for (var doc in symptomSnap.docs) {
        final d = doc.data();
        final date = d['log_date'] as String? ?? '';
        if (byDate.containsKey(date)) {
          byDate[date]!['symptoms'] = {
            'skin_score':      LogMapper.scoreFromLabel('Acne', d['acne']),
            'hair_loss_score': LogMapper.scoreFromLabel('Hair Loss', d['hair_loss']),
            'bloating_score':  LogMapper.scoreFromLabel('Bloating Level', d['bloating_level']),
            'energy_score':    LogMapper.scoreFromLabel('Energy Level', d['energy_level']),
            'mood_score':      LogMapper.scoreFromLabel('Mood', d['mood']),
            'weight_score':    LogMapper.scoreFromLabel('Weight', d['weight']),
            'digestion_score': LogMapper.scoreFromLabel('Digestion', d['digestion']),
          };
        }
      }

      for (var doc in habitSnap.docs) {
        final d = doc.data();
        final date = d['log_date'] as String? ?? '';
        if (byDate.containsKey(date)) {
          byDate[date]!['habits'] = LogMapper.mapHabits(
            durasiJam: (d['durasi_jam'] ?? 0).toDouble(),
            waterMl:   ((d['water_ml'] ?? 0) as num).toInt(),
            stresshigh: d['stresshigh'],
            moderate:   d['moderate'],
            relaxed:    d['relaxed'],
            active:     d['active'],
            light:      d['light'],
            none:       d['none'],
          );
        }
      }

      final result = byDate.values.toList();
      print('Payload to API: ${jsonEncode(result)}');
      return result;
    } catch (e) {
      print('_buildPayloadFromFirestore error: $e');
      return null;
    }
  }

  // ── Submit daily log ke /analyze ──
  Future<bool> submitDailyLog({
    required String logDate,
    required List<String> foodCategories,
    required String foodDetail,
    required Map<String, String?> signals,
    required double durasiJam,
    required int waterMl,
    String? stresshigh, String? moderate, String? relaxed,
    String? active, String? light, String? none,
    String? energyhigh, String? energylow,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      final payload = {
        'log_date': logDate,
        'food': LogMapper.mapFood(foodCategories, foodDetail),
        'symptoms': LogMapper.mapSymptoms(signals),
        'habits': LogMapper.mapHabits(
          durasiJam: durasiJam,
          waterMl: waterMl,
          stresshigh: stresshigh,
          moderate: moderate,
          relaxed: relaxed,
          active: active,
          light: light,
          none: none,
        ),
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode([payload]),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('submitDailyLog sukses: ${response.body}');
        return true;
      } else {
        print('submitDailyLog gagal: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('submitDailyLog error: $e');
      return false;
    }
  }

  // ── GET trends chart → POST /summary/trends ──
  Future<Map<String, dynamic>?> getAnalysis(String userId) async {
    try {
      final payload = await _buildPayloadFromFirestore();
      if (payload == null || payload.isEmpty) return null;

      final response = await http.post(
        Uri.parse('$_baseUrl/summary/trends'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('getTrends sukses');
        return jsonDecode(response.body);
      } else {
        print('getTrends gagal: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('getTrends error: $e');
      return null;
    }
  }

  // ── GET weekly report → POST /summary/weekly-report ──
  Future<Map<String, dynamic>?> getWeeklyReport() async {
    try {
      final payload = await _buildPayloadFromFirestore();
      if (payload == null || payload.isEmpty) return null;

      final response = await http.post(
        Uri.parse('$_baseUrl/summary/weekly-report'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('getWeeklyReport sukses');
        return jsonDecode(response.body);
      } else {
        print('getWeeklyReport gagal: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('getWeeklyReport error: $e');
      return null;
    }
  }
}