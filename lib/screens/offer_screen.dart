import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/offer_model.dart';
import '../models/payment.dart';
import '../repo/payment_repo.dart';
import '../state/auth_state.dart';
import '../state/offer_state.dart';
import '../utils/snippet.dart';
import 'dashboard.dart';

class PriceScreen extends StatelessWidget {
  PriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OfferState offerState = Provider.of<OfferState>(context);

    final AuthState authState = Provider.of<AuthState>(context);
    final user = authState.user;

    final creationDate = DateUtils.dateOnly(user?.createdAt ?? DateTime.now());
    final expiryDate =
        DateUtils.dateOnly(user?.memberShipExpiry ?? DateTime.now());

    final offerList = offerState.offers;
    if (expiryDate.compareTo(creationDate) != 0) {
      offerList.removeWhere((element) => element.isFreeTrial);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 500),
          crossFadeState: offerState.isLoading
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: shimmerTableEffect(),
          secondChild: Column(
            children: [
              MembershipDetails(),
              // OffersListWidget(offers: offers),
              OfferListWidget(offerList: offerList, doPop: false),
              const SizedBox(height: 20.0),

              //contact us button with whatsapp link
              ElevatedButton(
                onPressed: () async {
                  try {
                    log('whatsapp link: ' + offerState.whatsappLink);
                    await customLaunch(offerState.whatsappLink);
                  } catch (e) {
                    snack(context, e.toString());
                  }
                },
                child: const Text('Contact Us'),
              ),

              // const SizedBox(height: 20.0),

              // ElevatedButton(
              //   onPressed: () async {
              //     try {
              //       await showDialog(
              //           context: context,
              //           builder: (context) => AlertDialog(
              //                 title: const Text('Contact Us'),
              //                 content: Column(
              //                   mainAxisSize: MainAxisSize.min,
              //                   children: [
              //                     if (offerState.whatsappLink.isNotEmpty)
              //                       ListTile(
              //                         leading: const Icon(Icons.message),
              //                         title: const Text('WhatsApp Us'),
              //                         onTap: () async {
              //                           try {
              //                             log('whatsapp link: ' +
              //                                 offerState.whatsappLink);
              //                             await customLaunch(
              //                                 offerState.whatsappLink);
              //                           } catch (e) {
              //                             snack(context, e.toString());
              //                           }
              //                         },
              //                       ),
              //                     if (offerState.telegramLink.isNotEmpty)
              //                       ListTile(
              //                         leading: const Icon(Icons.message),
              //                         title: const Text('Telegram Us'),
              //                         onTap: () async {
              //                           try {
              //                             await customLaunch(
              //                                 offerState.telegramLink);
              //                           } catch (e) {
              //                             snack(context, e.toString());
              //                           }
              //                         },
              //                       ),
              //                   ],
              //                 ),
              //               ));
              //     } catch (e) {
              //       snack(context, e.toString());
              //     }
              //   },
              //   child: const Text('Contact Us'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class MembershipDetails extends StatelessWidget {
  const MembershipDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthState authState = Provider.of<AuthState>(context);
    final DateTime expiry = authState.user?.memberShipExpiry ?? DateTime.now();

    final bool isExpired = expiry.isBefore(DateTime.now());
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Membership Status: ${isExpired ? 'Expired' : 'Active'}'),
        Text(
            'Membership Expiry : ${DateFormat('MMM d, y').format(expiry)} ${isExpired ? '(Expired)' : '(${expiry.difference(DateTime.now()).inDays + 1} Days Left)'}'),
      ].expand((element) => [element, const SizedBox(height: 12)]).toList(),
    );
  }
}

Future<void> initiatePayment(BuildContext context, OfferModel offer) async {
  try {
    getStickyLoader(context);
    final AuthState authState = Provider.of<AuthState>(context, listen: false);
    log('initiating payment: ${authState.user!.id}');
    final PaymentModel payment = PaymentModel(
      offer: offer,
      userId: authState.user!.id,
    );
    final String? paymentSessionUrl =
        await PaymentRepo.instance.createPaymentIntent(
      payment,
      authState.user!.phone,
    );

    if (offer.isFreeTrial) {
      snack(context, 'Free Trial Activated', info: true);
      pop(context);
    } else {
      await customLaunch(paymentSessionUrl!);
      pop(context);
      snack(context, 'Payment initiated', info: true);
    }
  } catch (e) {
    log('error initiating payment: $e');
    snack(context, e.toString());
    pop(context);
  }
}

class PriceItem {
  double price;
  int days;
  PriceItem({required this.price, required this.days});
}
