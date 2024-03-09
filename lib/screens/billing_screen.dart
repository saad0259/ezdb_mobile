import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_petertan343/theme/app_theme.dart';
import 'package:provider/provider.dart';

import '../models/payment.dart';
import '../repo/payment_repo.dart';
import '../state/auth_state.dart';

class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState authState = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: PaymentRepo.instance.getPaymentsByUserId(authState.user!.id),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.data.isEmpty) {
              return const Center(
                child: Text('No payments found'),
              );
            } else {
              final List<PaymentModel> payments = snapshot.data;
              return ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                padding: const EdgeInsets.all(16),
                itemCount: payments.length,
                itemBuilder: (BuildContext context, int index) {
                  final PaymentModel payment = payments[index];
                  return ListTile(
                    title: Text(
                      '${payment.offer.days} Days',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        DateFormat('MMM dd, yyyy').format(payment.createdAt)),
                    trailing: Text(
                      payment.isFreeTrial
                          ? 'Free Trial'
                          : '${payment.offer.price} RM',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: payment.isFreeTrial ? 16 : 20,
                          color: context.primaryColor),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
