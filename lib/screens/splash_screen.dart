import 'package:flutter/material.dart';
import '../constants/app_images.dart';
import 'auth_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AuthHandler()));
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Image.asset(AppImages.logo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
