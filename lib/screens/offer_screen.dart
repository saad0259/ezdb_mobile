import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/offer_model.dart';
import '../state/offer_state.dart';
import '../utils/snippet.dart';

class PriceScreen extends StatefulWidget {
  PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final OfferState offerState =
          Provider.of<OfferState>(context, listen: false);
      offerState.isLoading = true;
      try {
        await offerState.loadData();
      } catch (e) {
        log(e.toString());
      }
      offerState.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final OfferState offerState = Provider.of<OfferState>(context);
    final List<OfferModel> offers = offerState.offers;
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
              ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  final OfferModel offer = offers[index];
                  return Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      leading: Text(
                        'RM ${offer.price}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Text('${offer.days} Days'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Contact Us'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (offerState.whatsappLink.isNotEmpty)
                                    ListTile(
                                      leading: const Icon(Icons.message),
                                      title: const Text('WhatsApp Us'),
                                      onTap: () async {
                                        try {
                                          log('whatsapp link: ' +
                                              offerState.whatsappLink);
                                          await customLaunch(
                                              offerState.whatsappLink);
                                        } catch (e) {
                                          snack(context, e.toString());
                                        }
                                      },
                                    ),
                                  if (offerState.telegramLink.isNotEmpty)
                                    ListTile(
                                      leading: const Icon(Icons.message),
                                      title: const Text('Telegram Us'),
                                      onTap: () async {
                                        try {
                                          await customLaunch(
                                              offerState.telegramLink);
                                        } catch (e) {
                                          snack(context, e.toString());
                                        }
                                      },
                                    ),
                                ],
                              ),
                            ));
                  } catch (e) {
                    snack(context, e.toString());
                  }
                },
                child: const Text('Contact Us'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PriceItem {
  double price;
  int days;
  PriceItem({required this.price, required this.days});
}
