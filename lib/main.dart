import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'firebase_options.dart';
import 'screens/auth_handler.dart';
import 'state/dashboard_state.dart';
import 'state/general_state.dart';
import 'state/home_state.dart';
import 'state/offer_state.dart';
import 'state/otp_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GeneralState()),
        ChangeNotifierProvider(create: (_) => OtpState()),
        ChangeNotifierProvider(create: (_) => DashboardState()),
        ChangeNotifierProvider(create: (_) => HomeState()),
        ChangeNotifierProvider(create: (_) => OfferState()),
      ],
      child: MaterialApp(
        theme: getTheme(),
        debugShowCheckedModeBanner: false,
        home: AuthHandler(),
      ),
    );
  }
}
