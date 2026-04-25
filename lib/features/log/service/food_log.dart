import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../model/log/food_model.dart';

class FoodLog{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;

  Future<bool> saveDailyLog({
    required List<String> foodCategories,
    required String foodDetail,
    required int waterMl,
  }) async {
    user = auth.currentUser;
    if (user == null) return false;

    try {
      final model = FoodModel(
        categories: foodCategories,
        detail: foodDetail,
        waterMl: waterMl,
        logDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        createdAt: DateTime.now(),
      );

      await firestore
          .collection('user_superraion')
          .doc(user!.uid)
          .collection('food_log')
          .add(model.toMap());
      return true;
    } catch (e) {
      print('gagal simpan food: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getFoodLog() async {
    user = auth.currentUser;
    if(user==null){
      return [];
    }

    try{
      QuerySnapshot snapshot = await firestore.collection("user_superraion").doc(user!.uid).collection('food_log').orderBy('created_at', descending: true).get();
      List<Map<String, dynamic>> makanan = snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      })
      .toList();
      return makanan;
    }catch(e){
      print('pengambilan data gagal: $e');
      return[];
    }
  }
}