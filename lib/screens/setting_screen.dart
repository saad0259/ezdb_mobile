import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../state/dashboard_state.dart';
import '../state/home_state.dart';
import '../utils/snippet.dart';
import 'auth_handler.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardState dashboardState =
        Provider.of<DashboardState>(context, listen: false);
    final HomeState homeState = Provider.of<HomeState>(context, listen: false);
    final AuthState authState = Provider.of<AuthState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          SettingsListItem(
            title: 'Billing',
            icon: Icons.timer_outlined,
            onTap: () {
              final DateTime expiry =
                  authState.user?.memberShipExpiry ?? DateTime.now();

              final bool isExpired = expiry.isBefore(DateTime.now());
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Membership Details'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          'Membership Expiry: ${DateFormat.yMMMMd().format(expiry)}'),
                      const SizedBox(height: 18),
                      Text(
                          'Membership Status: ${isExpired ? 'Expired' : 'Active'}'),
                      if (!isExpired) ...[
                        const SizedBox(height: 18),
                        Text(
                          'Days Left: ${expiry.difference(DateTime.now()).inDays + 1}',
                        ),
                      ]
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          SettingsListItem(
            title: 'Logout',
            icon: Icons.arrow_circle_right_outlined,
            onTap: () async {
              final AuthState authState =
                  Provider.of<AuthState>(context, listen: false);
              await authState.logout();
              dashboardState.reset();
              homeState.reset();
              popAllAndGoTo(context, AuthHandler());
            },
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}

class SettingsListItem extends StatelessWidget {
  const SettingsListItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey.shade200,
      contentPadding: const EdgeInsets.all(10),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      trailing: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}
