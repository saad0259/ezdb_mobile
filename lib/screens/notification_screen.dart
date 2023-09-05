import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../state/auth_state.dart';
import '../state/notifications_state.dart';
import '../utils/custom_tabbed_view.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final NotificationsState notificationState =
          Provider.of<NotificationsState>(context, listen: false);
      final AuthState authState =
          Provider.of<AuthState>(context, listen: false);

      final user = authState.user;
      notificationState.setCurrentTabIndex = 0;

      notificationState.getUserSearches(user!.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomTabbedButton(
              initialIndex: 0,
              onChanged: (int index) {
                final NotificationsState notificationState =
                    Provider.of<NotificationsState>(context, listen: false);
                final AuthState authState =
                    Provider.of<AuthState>(context, listen: false);

                final user = authState.user;

                notificationState.setCurrentTabIndex = index;

                if (index == 0) {
                  notificationState.getUserSearches(user!.id.toString());
                } else {
                  notificationState.getUserMembershipLogs(user!.id.toString());
                }
              },
              items: [
                CustomTabItem(
                  title: 'Activity',
                ),
                CustomTabItem(
                  title: 'Package Updates',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Consumer<NotificationsState>(
                builder: (context, notificationState, child) {
                  return notificationState.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : notificationState.currentTabIndex == 0
                          ? ActivityTab(notificationState)
                          : PackageUpdatesTab(notificationState);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ActivityTab extends StatelessWidget {
  const ActivityTab(
    this.notificationState, {
    super.key,
  });
  final NotificationsState notificationState;
  @override
  Widget build(BuildContext context) {
    return notificationState.userSearches.isEmpty
        ? const Center(child: Text('No activity yet'))
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notificationState.userSearches.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              //date, value , searchtype
              return ListTile(
                title: Text(
                    'Type: ${notificationState.userSearches[index].searchType}'),
                subtitle: Text(
                    'Value: ${notificationState.userSearches[index].searchValue}'),
                trailing: Text(DateFormat('dd-MMM-yyyy hh:mm a')
                    .format(notificationState.userSearches[index].createdAt)),
              );
            },
          );
  }
}

class PackageUpdatesTab extends StatelessWidget {
  const PackageUpdatesTab(
    this.notificationState, {
    super.key,
  });
  final NotificationsState notificationState;
  @override
  Widget build(BuildContext context) {
    return notificationState.userMembershipLogs.isEmpty
        ? const Center(child: Text('No package updates yet'))
        : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notificationState.userMembershipLogs.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
            itemBuilder: (BuildContext context, int index) {
              //date, value , searchtype
              return ListTile(
                title: Text(
                    'Membership updated to : ${DateFormat('dd-MMM-yyyy').format(notificationState.userMembershipLogs[index].membershipExpiry)}'),
              );
            },
          );
  }
}
