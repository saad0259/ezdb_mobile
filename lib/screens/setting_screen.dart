import 'dart:developer';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../repo/auth_repo.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                return Text(
                  'Hello ${user.name}',
                  style: Theme.of(context).textTheme.titleLarge,
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
            onTap: () => AuthRepo.instance.signOut(),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }
}
