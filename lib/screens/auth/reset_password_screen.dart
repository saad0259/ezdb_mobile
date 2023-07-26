import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../state/auth_state.dart';
import '../../utils/snippet.dart';
import '../auth_handler.dart';
import 'register_screen.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key, required this.phoneNumber});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String phoneNumber;
  String _password = '';
  String _otp = '';

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);
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
                    obscureText: true,
                    onSaved: (value) => _password = value.toString(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (value) => _otp = value.toString(),
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter OTP';
                      } else if (value.length < 6) {
                        return 'Please enter valid OTP';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'OTP',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          try {
                            getStickyLoader(context);
                            await authState.resetPassword(
                              phone: phoneNumber,
                              password: _password,
                              otp: _otp,
                            );
                            pop(context);
                            snack(context, 'Password reset successful',
                                info: true);
                            popAllAndGoTo(context, AuthHandler());
                          } catch (e) {
                            snack(context, e.toString());
                            popAllAndGoTo(context, AuthHandler());
                          }
                        }
                      },
                      child: const Text('Reset Password'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () => replace(context, RegisterScreen()),
                        child: const Text('Register'),
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
}
