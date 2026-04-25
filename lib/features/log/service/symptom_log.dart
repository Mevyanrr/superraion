import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SymptomLog{
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;

  Future<void> saveSymptom(Map<String,dynamic> SymptomModel) async {
    user = auth.currentUser;
    if(user == null){
      print("user belum login");
      return;
    }
    try{
      final dataToSave = {
        'nama_makanan': SymptomModel['makanan'] ?? 'Tidak ada makanan'
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