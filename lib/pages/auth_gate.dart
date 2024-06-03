import 'package:cloud_fire_store_learning/pages/fire_cloud_page.dart';
import 'package:cloud_fire_store_learning/pages/register_page.dart';
import 'package:flutter/material.dart';

import '../services/firebase_auth_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService.auth.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData ? const HomePage(): const RegisterPage();
        }
    );
  }
}