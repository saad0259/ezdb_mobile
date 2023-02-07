import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../repo/auth_repo.dart';
import '../../state/general_state.dart';
import '../../utils/snippet.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  String _phoneNumber = '';
  String _email = '';
  String _password = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // if (kDebugMode) {
    //   _phoneNumber = '+60123456789';
    //   _email = 'saad259@yopmail.com';
    //   _password = '123456789';
    // }
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
                    initialValue: _email,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value ?? '',
                    validator: emailValidator,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
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
                                            email: _email,
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

class ForgotPasswordWidget extends StatelessWidget {
  ForgotPasswordWidget({
    super.key,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _phone = '';
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _email = 'saad259@yopmail.com';
      _phone = '+60123456789';
    }
    return AlertDialog(
      title: const Center(child: Text('Forgot Password')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Enter your email to receive a link to reset your password.'),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _email,
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _email = value ?? '',
              validator: emailValidator,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: _phone,
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _phone = '+$value',
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
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: const InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                _formKey.currentState?.validate();
                _formKey.currentState?.save();
                getStickyLoader(context);
                try {
                  await AuthRepo.instance.passwordReset(_email, _phone);

                  if (context.mounted) {
                    snack(context, 'Password reset link sent to your email');
                  }
                } catch (e) {
                  snack(context, e.toString());
                }

                if (context.mounted) {
                  pop(context);
                  pop(context);
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
