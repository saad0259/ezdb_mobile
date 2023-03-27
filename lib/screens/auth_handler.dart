import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mega_petertan343/screens/dashboard.dart';

import 'auth/login_screen.dart';
import 'splash_screen.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext conte, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (!snapshot.hasData || snapshot.data == null) {
          return LoginScreen();
        } else {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return DashboardScreen();
        }
      },
    );
  }
}
