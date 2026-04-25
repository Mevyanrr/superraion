import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/log/symptom_model.dart';

class SymptomLog {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;

  Future<bool> saveSymptom(Map<String, String?> bodySignals, {required String logDate}) async {
    user = auth.currentUser;
    if (user == null) return false;

    try {
      final model = SymptomModel.fromSignals(bodySignals, logDate: logDate);

      await firestore
          .collection('user_superraion')
          .doc(user!.uid)
          .collection('symptom_log')
          .add(model.toMap());

      return true;
    } catch (e) {
      print('gagal simpan symptom: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getSymptomLog() async {
    user = auth.currentUser;
    if (user == null) return [];

    try {
      QuerySnapshot snapshot = await firestore
          .collection('user_superraion')
          .doc(user!.uid)
          .collection('symptom_log')
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

  Future<Map<String, dynamic>?> getSymptomByDate(String date) async {
    user = auth.currentUser;
    if (user == null) return null;

    try {
      QuerySnapshot snapshot = await firestore
          .collection('user_superraion')
          .doc(user!.uid)
          .collection('symptom_log')
          .where('log_date', isEqualTo: date)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      return {'id': doc.id, ...doc.data() as Map<String, dynamic>};
    } catch (e) {
      print('get symptom by date gagal: $e');
      return null;
    }
  }
}