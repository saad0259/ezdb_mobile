import 'package:flutter/material.dart';

import '../../models/member.dart';

class MemberDetailsDialog extends StatelessWidget {
  const MemberDetailsDialog({
    super.key,
    required this.member,
  });

  final MemberModel member;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Text(
            'Member Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailItem(
              title: 'Name',
              value: member.name,
            ),
            DetailItem(
              title: 'Address',
              value: member.address,
            ),
            DetailItem(
              title: 'Postcode',
              value: member.postcode,
            ),
            DetailItem(
              title: 'Tel 1',
              value: member.tel1,
            ),
            DetailItem(
              title: 'Tel 2',
              value: member.tel2,
            ),
            DetailItem(
              title: 'Tel 3',
              value: member.tel3,
            ),
          ],
        ));
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
