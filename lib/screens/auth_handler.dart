import 'package:flutter/material.dart';
import 'package:mega_petertan343/screens/dashboard.dart';

import '../utils/prefs.dart';
import 'auth/login_screen.dart';
import 'splash_screen.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String?>(
      stream: prefs.authToken.stream,
      builder: (context, userSnap) {
        if (userSnap.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (userSnap.hasData && (userSnap.data?.isNotEmpty ?? false)) {
          return DashboardScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
