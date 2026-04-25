import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodLog{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;

  Future<void> saveFood(Map<String,dynamic> FoodModel) async {
    user = auth.currentUser;
    if(user == null){
      print("user belum login");
      return;
    }
    try{
      final dataToSave = {
        'nama_makanan': FoodModel['makanan'] ?? 'Tidak ada makanan'
      };
      await firestore
          .collection('user_superraion')
          .doc(user!.uid)
          .collection('food_log')
          .add(dataToSave);

    }catch(e){
      
    }
  }
}