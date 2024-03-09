// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mega_petertan343/theme/app_theme.dart';
import 'package:mega_petertan343/utils/snippet.dart';
import 'package:provider/provider.dart';

import '../constants/app_images.dart';
import '../models/offer_model.dart';
import '../models/user.dart';
import '../notification/notification_handler.dart';
import '../state/auth_state.dart';
import '../state/dashboard_state.dart';
import '../state/home_state.dart';
import '../state/offer_state.dart';
import '../utils/prefs.dart';
import 'auth_handler.dart';
import 'billing_screen.dart';
import 'bottom_navigation_widget.dart';
import 'home/home_screen.dart';
import 'offer_screen.dart';
import 'setting_screen.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<DashboardTabs> _tabs = [
    DashboardTabs(
      title: 'Home',
      child: HomeScreen(),
    ),
    const DashboardTabs(
      title: 'Billing',
      child: BillingScreen(),
    ),
    DashboardTabs(
      title: 'Price',
      child: PriceScreen(),
    ),
    const DashboardTabs(
      title: 'Settings',
      child: SettingScreen(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final OfferState offerState =
            Provider.of<OfferState>(context, listen: false);
        final AuthState authState =
            Provider.of<AuthState>(context, listen: false);
        getStickyLoader(context);
        await handleNotification(context);
        String userId = (authState.user?.id ?? '').toString();
        // assert(authState.user != null);
        // log('init state update user');
        // await authState.updateUser(userId);
        authState.startUpdatingUser(userId);
        await offerState.loadData();

        bool showedInitialOffer =
            await prefs.showedInitialOffer.load() ?? false;

        log('showedInitialOffer: $showedInitialOffer');

        if (!showedInitialOffer &&
            authState.user!.isExpired &&
            offerState.offers.isNotEmpty) {
          await prefs.showedInitialOffer.save(true);
          await prefs.showedInitialOffer.load() ?? false;

          log('2 showedInitialOffer: $showedInitialOffer');
          await showDialog(
              // useSafeArea: true,
              // barrierDismissible: false,
              context: context,
              builder: (context) => InitialOfferWidget(authState.user));
        }
      } catch (e) {
        snack(context, e.toString());
        await _logoutIfFalseToken(e, context);
        pop(context);
        return;
      }
      pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardState>(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              _tabs[state.currentIndex].title,
            ),
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                AppImages.logo,
                fit: BoxFit.cover,
                height: 20,
                width: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final AuthState authState =
                      Provider.of<AuthState>(context, listen: false);
                  getStickyLoader(context);
                  try {
                    String userId = (authState.user?.id ?? '').toString();
                    await authState.updateUser(userId);
                    snack(context, 'Info updated', info: true);
                  } catch (e) {
                    snack(context, e.toString());
                    await _logoutIfFalseToken(e, context);
                    return;
                  }
                  pop(context);
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationWidget(),
          body: _tabs[state.currentIndex].child,
        );
      },
    );
  }

  Future<void> _logoutIfFalseToken(Object e, BuildContext context) async {
    if ('$e' == 'Invalid auth token') {
      final AuthState authState =
          Provider.of<AuthState>(context, listen: false);
      final DashboardState dashboardState =
          Provider.of<DashboardState>(context, listen: false);
      final HomeState homeState =
          Provider.of<HomeState>(context, listen: false);

      await authState.logout();
      dashboardState.reset();
      homeState.reset();
      popAllAndGoTo(context, AuthHandler());
    }
  }
}

class InitialOfferWidget extends StatelessWidget {
  const InitialOfferWidget(
    this.user, {
    Key? key,
  }) : super(key: key);

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final OfferState offerState =
        Provider.of<OfferState>(context, listen: false);

    final creationDate = DateUtils.dateOnly(user?.createdAt ?? DateTime.now());
    final expiryDate =
        DateUtils.dateOnly(user?.memberShipExpiry ?? DateTime.now());

    final offerList = offerState.offers;
    if (expiryDate.compareTo(creationDate) == 0) {
      final OfferModel freeOffer = OfferModel(
        uid: '10101',
        days: 7,
        price: 0,
        isActive: true,
        isFreeTrial: true,
        name: 'Free Trial',
      );
      offerList.add(freeOffer);
    }

    return AlertDialog(
      content: SizedBox(
        // height: 300,
        width: context.width,
        child: OfferListWidget(offerList: offerList),
      ),
    );
  }
}

class OfferListWidget extends StatelessWidget {
  const OfferListWidget({
    super.key,
    required this.offerList,
    this.doPop = true,
  });

  final List<OfferModel> offerList;
  final bool doPop;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
      shrinkWrap: true,
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: offerList.length,
      itemBuilder: (BuildContext context, int index) {
        final OfferModel offer = offerList[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.black38),
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () async {
              await initiatePayment(context, offer);
              if (doPop) pop(context);
            },
            child: ListTile(
              title: Text(offer.name),
              subtitle: Text(
                  '${offer.isFreeTrial ? '' : '${offer.price} RM /'} ${offer.days} days'),
              trailing: Icon(Icons.arrow_circle_right_outlined,
                  color: context.primaryColor),
            ),
          ),
        );
      },
    );
  }
}

class DashboardTabs {
  final String title;
  final Widget child;

  const DashboardTabs({
    required this.title,
    required this.child,
  });
}
