import 'dart:developer';

import 'package:cloud_fire_store_learning/pages/admin_login_page.dart';
import 'package:cloud_fire_store_learning/pages/fire_cloud_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController surnameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmC = TextEditingController();


  Future<void> checkFilling() async{
    if (nameC.text.length <= 2 || surnameC.text.length <= 2) {
      // Utils.fireSnackBar("Name or Surname is not filled right", context);
      log("Name or Surname is not filled right");
    } else if (!emailC.text.endsWith("@gmail.com") ||
        emailC.text.length <= 11) {
      log("email is not filled right");
      // Utils.fireSnackBar("email is not filled right", context);
    } else if (passwordC == confirmC || passwordC.text.length <= 7) {
      // Utils.fireSnackBar("Password is not filled true", context);
      log("Password is not filled true");
    } else {
      User? user = await AuthService.registerUser(context, fullName: "${nameC.text}/${surnameC.text}", email: emailC.text, password: passwordC.text);
      if(user != null){
        if(mounted){
          log("Successfully registered !");
          // Utils.fireSnackBar("Successfully registered !", context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Registration Menu",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: Colors.black87,
                    fontFamily: ""),
              ),
              const SizedBox(
                height: 100,
              ),
              TextField(
                controller: nameC,
                decoration: InputDecoration(
                    labelText: "Your Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: surnameC,
                decoration: InputDecoration(
                    labelText: "Your Surname",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailC,
                decoration: InputDecoration(
                    labelText: "Your Email",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordC,
                decoration: InputDecoration(
                    labelText: "Your Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: confirmC,
                decoration: InputDecoration(
                    labelText: "Confirm the password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
              ),
              const SizedBox(
                height: 30,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  height: 70,
                  minWidth: double.infinity,
                  color: Colors.blue,
                  splashColor: Colors.blue,
                  onPressed: checkFilling,
                  child: const Text(
                    "Register",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              TextButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminLogin()));
              }, child: const Text("I'm an admin!",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),))
            ],
          ),
        ),
      ),
    );
  }
}
