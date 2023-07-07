
import 'package:flutter/material.dart';
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
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        children: [
          Consumer<AuthState>(
            builder: (context, authState, child) {
              return Column(
                children: [
                  Text(
                    'Hello ${authState.user?.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Your membership will expire on ${authState.user?.memberShipExpiry}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          ListTile(
            tileColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              'Send Feedback',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Icon(
              Icons.arrow_circle_right_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 18),
          ListTile(
            tileColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              'Report a Bug',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Icon(
              Icons.arrow_circle_right_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 18),
          ListTile(
            tileColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              'Rate our App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Icon(
              Icons.arrow_circle_right_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 18),
          ListTile(
            tileColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              'About',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Icon(
              Icons.arrow_circle_right_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 18),
          ListTile(
            tileColor: Colors.grey.shade200,
            contentPadding: const EdgeInsets.all(10),
            title: Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            trailing: Icon(
              Icons.arrow_circle_right_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
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
