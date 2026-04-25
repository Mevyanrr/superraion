import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:superraion/features/log/model/log/habit_model.dart';

class HabitLog {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;

  Future<bool> saveHabit({
    required String tidurMulai,
    required String tidurSelesai,
    required double durasiJam,
    String? relaxed,
    String? moderate,
    String? stresshigh,
    String? stresslow,
    String? active,
    String? light,
    String? none,
    String? energyhigh,
    String? energylow,
  }) async {
    user = auth.currentUser;
    if (user == null) return false;

    try {
      final model = HabitModel(
        tidurMulai: tidurMulai,
        tidurSelesai: tidurSelesai,
        durasiJam: durasiJam,
        logDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        createdAt: DateTime.now(),
        relaxed: relaxed,
        moderate: moderate,
        stresshigh: stresshigh,
        stresslow: stresslow,
        active: active,
        light: light,
        none: none,
        energyhigh: energyhigh,
        energylow: energylow,
      );

      await firestore
          .collection('user_superraion')
          .doc(user!.uid)
          .collection('habit_log')
          .add(model.toMap());

      return true;
    } catch (e) {
      print('gagal $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getHabitLog() async {
    user = auth.currentUser;
    if (user == null) return [];

    try {
      QuerySnapshot snapshot = await firestore
          .collection('user_superraion')
          .doc(user!.uid)
          .collection('habit_log')
          .get();

      final list = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      }).toList();

      list.sort((a, b) {
        final ta = a['created_at'] as Timestamp?;
        final tb = b['created_at'] as Timestamp?;
        return (tb?.seconds ?? 0).compareTo(ta?.seconds ?? 0);
      });

      return list;
    } catch (e) {
      print('pengambilan data gagal: $e');
      return [];
    }
  }
}