import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_images.dart';
import '../../constants/enums.dart';
import '../../repo/auth_repo.dart';
import '../../utils/snippet.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _phoneNumber = '';
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _phoneNumber = '60101231234';
      _passwordController.text = 'Lahore123@';
    }
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 50,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    AppImages.logo,
                    width: 120,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    initialValue: _phoneNumber,
                    onSaved: (value) {
                      _phoneNumber = '$value';
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(13),
                    ],
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      } else if (value.length < 11) {
                        return 'Please enter valid phone number';
                      } else if (!value.startsWith('60')) {
                        return 'Please enter valid phone number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: '60 10-123 1234',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    onSaved: (value) {
                      _passwordController.text = value!;
                    },
                    validator: passwordValidator,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Enter Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      register(context);
                    },
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          push(context, LoginScreen());
                        },
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        getStickyLoader(context);
        await AuthRepo.instance
            .signUp(phone: _phoneNumber, password: _passwordController.text);
        pop(context);
        push(
            context,
            OtpScreen(
              phone: _phoneNumber,
              authType: AuthType.register,
            ));
      } catch (e) {
        pop(context);
        snack(context, e.toString());
        return;
      }
    }
  }
}
