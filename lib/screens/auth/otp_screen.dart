import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mega_petertan343/screens/auth_handler.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../repo/auth_repo.dart';
import '../../reusables/numpad.dart';
import '../../state/otp_state.dart';
import '../../utils/snippet.dart';

class OtpScreen extends StatefulWidget {
  final AuthType authType;

  final String? phone;
  final String? email;

  const OtpScreen({
    Key? key,
    required this.authType,
    this.phone,
    this.email,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final OtpState otpState = Provider.of<OtpState>(context, listen: false);
      otpState.startTimer();
    });
  }

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
              'Enter the 6-digit code sent to ${widget.phone}',
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
                        state.add(value);
                      },
                      onSubmit: () async {
                        if (state.otpChars.length > 5) {
                          state.isLoading = true;

                          try {
                            await AuthRepo.instance.verifyOtp(
                              widget.email!,
                              state.otpChars.join(),
                            );

                            if (context.mounted) {
                              snack(context,
                                  'Otp verified successfully. Login to continue',
                                  info: true);
                              popAllAndGoTo(context, AuthHandler());
                            }

                            state.isLoading = false;

                            // if (context.mounted) {
                            //   popToMain(context);
                            // }
                          } catch (e) {
                            state.isLoading = false;
                            log('not firebae error');
                            log(e.toString());
                            snack(context, e.toString());
                          }
                        }
                      },
                      onClear: () {
                        state.clear();
                      },
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Resend OTP in ',
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 14,
                      ),
                    ),
                    Consumer<OtpState>(
                      builder: (context, state, child) {
                        return Text(
                          '${state.timer}',
                          style: const TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                    const Text(
                      ' seconds',
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Consumer<OtpState>(
                  builder: (context, otpState, child) {
                    return otpState.timer > 0
                        ? const SizedBox(height: 30)
                        : TextButton(
                            onPressed: () async {
                              try {
                                getStickyLoader(context);
                                await AuthRepo.instance
                                    .resendOtp(widget.email!);

                                otpState.timer = 60;
                                otpState.startTimer();
                                snack(context, 'Otp sent', info: true);
                              } catch (e) {
                                snack(context, e.toString());
                              }
                              pop(context);
                            },
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontFamily: 'Bold',
                                fontSize: 14,
                              ),
                            ),
                          );
                  },
                )
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
