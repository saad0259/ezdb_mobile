import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../repo/auth_repo.dart';
import '../../state/general_state.dart';
import '../../utils/snippet.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  String _phoneNumber = '';
  String _password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _phoneNumber = '60101231234';
      _password = 'Lahore123@';
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
                  //logo, phone input, password input, login button, forgot password, register
                  const SizedBox(height: 30),
                  Image.asset(
                    AppImages.logo,
                    width: 120,
                  ),
                  const SizedBox(height: 50),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _phoneNumber = '+$value',
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
                    initialValue: _phoneNumber,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: const InputDecoration(
                      labelText: '60 10-123 1234',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),

                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: _password,
                    obscureText: true,
                    onSaved: (value) => _password = value ?? '',
                    validator: passwordValidator,
                    decoration: const InputDecoration(
                      labelText: 'Enter Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => ForgotPasswordWidget(),
                        );
                      },
                      child: const Text('Forgot Password'),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Consumer<GeneralState>(
                          builder: (context, state, child) {
                            return ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () async {
                                      try {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        _formKey.currentState?.save();
                                        state.setLoading(true);
                                        await AuthRepo.instance.signIn(
                                            // email: _email,
                                            phone: _phoneNumber,
                                            password: _password);
                                        if (context.mounted) {
                                          state.setLoading(false);
                                        }
                                      } catch (e) {
                                        snack(context, e.toString());
                                        log(e.toString());
                                      }
                                      state.setLoading(false);
                                    },
                              child: state.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Login'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  TextButton(
                    onPressed: () {
                      replace(context, RegisterScreen());
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
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
