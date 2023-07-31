import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../state/auth_state.dart';
import '../../state/general_state.dart';
import '../../utils/snippet.dart';
import '../auth_handler.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  String _phoneNumber = '';
  String _password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // _phoneNumber = '60101231234';
      // _password = 'Lahore123@';
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
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _phoneNumber = value.toString(),
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
                      LengthLimitingTextInputFormatter(13),
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<GeneralState>(
                          builder: (context, state, child) {
                            return ElevatedButton(
                              onPressed: state.isLoading
                                  ? null
                                  : () async {
                                      final AuthState authState =
                                          Provider.of<AuthState>(context,
                                              listen: false);
                                      try {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        _formKey.currentState?.save();
                                        state.setLoading(true);
                                        await authState.login(
                                          _phoneNumber,
                                          _password,
                                        );
                                        if (context.mounted) {
                                          snack(context, 'Login Success',
                                              info: true);
                                          state.setLoading(false);

                                          popAllAndGoTo(context, AuthHandler());
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
                  const SizedBox(height: 0),
                  Align(
                    alignment: Alignment.centerRight,
                    heightFactor: 1,
                    child: TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            final GlobalKey<FormState> _newKey =
                                GlobalKey<FormState>();
                            return AlertDialog(
                              title: const Text('Forgot Password'),
                              content: Form(
                                key: _newKey,
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onSaved: (value) =>
                                      _phoneNumber = value.toString(),
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
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]')),
                                    LengthLimitingTextInputFormatter(13),
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: '60 10-123 1234',
                                    prefixIcon: Icon(Icons.phone_outlined),
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final AuthState authState =
                                        Provider.of<AuthState>(context,
                                            listen: false);
                                    try {
                                      if (!_newKey.currentState!.validate()) {
                                        return;
                                      }
                                      _newKey.currentState?.save();
                                      getStickyLoader(context);
                                      await authState.forgotPassword(
                                        _phoneNumber,
                                      );
                                      pop(context);
                                      // if (context.mounted) {
                                      snack(context, 'OTP Sent', info: true);
                                      pop(context);
                                      replace(
                                          context,
                                          ResetPasswordScreen(
                                              phoneNumber: _phoneNumber));

                                      // }
                                    } catch (e) {
                                      snack(context, e.toString());
                                      pop(context);
                                      pop(context);
                                      log(e.toString());
                                    }
                                  },
                                  child: const Text('Send OTP'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
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
