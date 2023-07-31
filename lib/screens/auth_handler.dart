import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mega_petertan343/screens/dashboard.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../state/auth_state.dart';
import '../utils/prefs.dart';
import 'auth/login_screen.dart';
import 'splash_screen.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      stream: prefs.authData.stream,
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (userSnap.hasData && (userSnap.data?.isNotEmpty ?? false)) {
          final AuthState authState =
              Provider.of<AuthState>(context, listen: false);

          log('userSnap.data: ${userSnap.data}');
          authState.user = UserModel.fromMap(userSnap.data ?? {});
          return DashboardScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
