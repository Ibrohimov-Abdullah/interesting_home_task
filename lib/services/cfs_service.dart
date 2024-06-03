import 'package:cloud_firestore/cloud_firestore.dart';

class CFService{

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  // create
  static Future<DocumentReference<Map<String, dynamic>>> createCollection({required String collectionPath, required String secondPath, required String thirdPath, required Map<String, dynamic> data}) async{
    var result = await db.collection(collectionPath).doc(secondPath).collection(thirdPath).add(data);
    return result;
  }

  // read
  static Future<List<QueryDocumentSnapshot<Object?>>> read({required String collectionPath,required String secondPath, required String thirdPath}) async{
    List<QueryDocumentSnapshot> list = [];
    QuerySnapshot querySnapshot = await db.collection(collectionPath).doc(secondPath).collection(thirdPath).get();
    for (var e in querySnapshot.docs) {
      list.add(e);
    }
    return list;
  }

  // update
  static Future<void> update({required String collectionPath, required String id, required Map<String,dynamic> data})async{
    await db.collection(collectionPath).doc(id).update(data);
  }

  // delete
  static Future<void> delete({required String collectionPath, required String id})async{
    await db.collection(collectionPath).doc(id).delete();
  }
}