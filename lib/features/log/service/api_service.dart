import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

import 'log_mapper.dart';

class ApiService {
  String _baseUrl = 'http://10.0.175.154:8000/log';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final user = _auth.currentUser;
  late final userId = user?.uid;

  Future<bool> submitDailyLog({
    required String logDate,
    required List<String> foodCategories,
    required String foodDetail,
    required Map<String, String?> signals,
    required double durasiJam,
    required int waterMl,
    String? stresshigh,
    String? moderate,
    String? relaxed,
    String? active,
    String? light,
    String? none, String? energyhigh, String? energylow,
  }) async {
    try {

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
        Uri.parse('$_baseUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode([payload]),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('API sukses: ${response.body}');
        return true;
      } else {
        print('API gagal: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('API error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getAnalysis() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final response = await http.get(
        Uri.parse('$_baseUrl/analyze/${user.uid}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle kalau data belum cukup
        if (data['status'] == 'insufficient_data') {
          print('Belum cukup data: ${data['message']}');
          return data; // tetap return supaya UI bisa tampilkan pesan
        }

        return data;
      } else {
        print('Get analysis gagal: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('Get analysis error: $e');
      return null;
    }
  }
}