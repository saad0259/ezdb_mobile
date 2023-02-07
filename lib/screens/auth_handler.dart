import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mega_petertan343/screens/dashboard.dart';

import 'auth/login_screen.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext conte, snapshot) {
        if (!snapshot.hasData) {
          return LoginScreen();
        } else {
          log('User is logged in');
          //pop all and push dashboard
          // Navigator.of(context).popUntil((route) => route.isFirst);
          return DashboardScreen();
        }
      },
    );
  }
}
