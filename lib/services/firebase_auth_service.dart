import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

final class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<User?> registerUser(BuildContext context,
      {required String fullName,
        required String email,
        required String password}) async {
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user?.updateDisplayName(fullName);
      if(userCredential.user != null){
        return userCredential.user;
      }else{
        return null;
      }
    }catch (e){
      // Utils.fireSnackBar("\n\nError: $e\n\n", context);
      log("\n\nError: $e\n\n");
      return null;
    }
  }

  static Future<User?>loginUser(BuildContext context, {required String email, required String password})async{
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user != null){
        return userCredential.user;
      }else{
        return null;
      }
    }catch(e){
      // Utils.fireSnackBar("Error: \n\n$e\n\n", context);
      log("Error: $e");
      return null;
    }
  }

  static Future<void> deleteAccount() async{
    await auth.currentUser?.delete();
  }

  static Future<void> logoutAccount() async{
    await auth.signOut();
  }
}
