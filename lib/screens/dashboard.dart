import 'package:flutter/material.dart';
import 'package:mega_petertan343/utils/snippet.dart';
import 'package:provider/provider.dart';

import '../constants/app_images.dart';
import '../notification/notification_handler.dart';
import '../state/auth_state.dart';
import '../state/dashboard_state.dart';
import 'home/home_screen.dart';
import 'notification_screen.dart';
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
      title: 'Notifications',
      child: NotificationScreen(),
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
      final AuthState authState =
          Provider.of<AuthState>(context, listen: false);
      getStickyLoader(context);
      try {
        String userId = (authState.user?.id ?? '').toString();
        await authState.updateUser(userId);
      } catch (e) {
        // snack(context, e.toString());
      }
      await handleNotification(context);
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
                  }
                  pop(context);
                },
                icon: const Icon(Icons.refresh),
              ),
              // IconButton(
              //   onPressed: () {
              //     replace(context, const LoginScreen());
              //   },
              //   icon: const Icon(Icons.logout),
              // ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Price',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: state.currentIndex,
            onTap: (index) {
              state.setCurrentIndex(index);
            },
          ),
          body: _tabs[state.currentIndex].child,
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
