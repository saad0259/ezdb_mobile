import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../repo/auth_repo.dart';
import '../../reusables/numpad.dart';
import '../../state/otp_state.dart';
import '../../utils/snippet.dart';
import '../dashboard.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;
  final AuthType authType;

  final String? phoneNumber;
  final String? email;
  final String? password;
  final String? name;
  final String? phone;

  const OtpScreen({
    Key? key,
    required this.authType,
    required this.verificationId,
    this.phoneNumber,
    this.email,
    this.password,
    this.name,
    this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Otp'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Enter the 6-digit code sent to $phoneNumber',
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Consumer<OtpState>(
                    builder: (context, state, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List<Widget>.generate(6, (pos) {
                          return pos < state.otpChars.length
                              ? getBox(text: state.otpChars[pos])
                              : getBox();
                        }),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Consumer<OtpState>(
                  builder: (context, state, child) {
                    return NumPad(
                      isLoading: state.isLoading,
                      onUpdate: (value) {
                        context.read<OtpState>().add(value);
                      },
                      onSubmit: () async {
                        if (context.read<OtpState>().otpChars.length > 5) {
                          state.isLoading = true;

                          try {
                            await AuthRepo.instance.signUp(
                              code: context.read<OtpState>().otpChars.join(),
                              verificationId: verificationId,
                              email: email!,
                              password: password!,
                            );
                            if (context.mounted) {
                              replace(context, DashboardScreen());
                            }
                            if (authType == AuthType.register) {
                              await AuthRepo.instance.createNewUser(
                                email: email!,
                                password: password!,
                                name: name!,
                                phone: phone!,
                              );
                            }

                            state.isLoading = false;

                            // if (context.mounted) {
                            //   popToMain(context);
                            // }
                          } catch (e) {
                            state.isLoading = false;
                            if (e
                                .toString()
                                .contains('The sms verification code used')) {
                              snack(context, 'invalid otp, please try again');
                            } else {
                              log('not firebae error');
                              log(e.toString());
                              snack(context, e.toString());
                            }
                          }
                        }
                      },
                      onClear: () {
                        context.read<OtpState>().clear();
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getBox({String? text}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text ?? " ",
          style: const TextStyle(
            fontFamily: 'Bold',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
