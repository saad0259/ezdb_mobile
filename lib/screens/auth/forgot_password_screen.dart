import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../repo/auth_repo.dart';
import '../../utils/snippet.dart';

class ForgotPasswordWidget extends StatelessWidget {
  ForgotPasswordWidget({
    super.key,
  });
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  // String _phone = '';
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      _email = 'saad259@yopmail.com';
      // _phone = '+60123456789';
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
            ElevatedButton(
              onPressed: () async {
                _formKey.currentState?.validate();
                _formKey.currentState?.save();
                getStickyLoader(context);
                try {
                  // await AuthRepo.instance.passwordReset(_email);

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
