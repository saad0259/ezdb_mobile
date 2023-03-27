import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../repo/auth_repo.dart';
import '../state/dashboard_state.dart';
import '../state/home_state.dart';

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
          FutureBuilder<UserModel>(
            future: AuthRepo.instance.getUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                log(snapshot.error.toString());
                return const Text('Error');
              } else {
                final UserModel user = snapshot.data;
                return Column(
                  children: [
                    Text(
                      'Hello ${user.name}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Your membership will expire on ${DateFormat('dd MMM yyyy').format(user.memberShipExpiry.toDate())}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                );
              }
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
            onTap: () {
              AuthRepo.instance.signOut();
              dashboardState.reset();
              homeState.reset();
            },
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
