import 'package:cloud_fire_store_learning/pages/admin_home_page.dart';
import 'package:cloud_fire_store_learning/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/utils_service.dart';
import 'fire_cloud_page.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  TextEditingController tfc1 = TextEditingController();
  TextEditingController tfc2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign in here"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 160,),
              TextField(
                controller: tfc1,
                decoration: InputDecoration(
                  labelText: "Your email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
              const SizedBox(height: 30,),
              TextField(
                controller: tfc2,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: "Your password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
              ),
              const SizedBox(height: 40,),
              MaterialButton(
                minWidth: MediaQuery.of(context).size.width*0.8,
                height: 50,
                onPressed: ()async{
                  User? user = await AuthService.loginUser(context, email: tfc1.text, password: tfc2.text);
                  if(user != null){
                    Utils.fireSnackBar("Successfully Loged-in", context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminHomePage(),));
                  }else{
                    Utils.fireSnackBar("Email or Password is wrong", context);
                  }
                },
                color: Colors.blue,
                shape: const StadiumBorder(),
                child: const Text("Log-in",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 22,color: Colors.white),textAlign: TextAlign.center,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
