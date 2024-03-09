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
            member.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.info),
                    const SizedBox(width: 10),
                    Text(
                      member.ic,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.phone),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      member.tel1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                const Icon(
                  Icons.home,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    member.address +
                        (member.postcode.isNotEmpty
                            ? ', ${member.postcode}'
                            : ''),
                    // textAlign: TextAlign.end,
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.grey),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 20),
                Icon(Icons.phone),
                const SizedBox(width: 10),
                Text(
                  member.tel2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const SizedBox(width: 20),
                Icon(Icons.phone),
                const SizedBox(width: 10),
                Text(
                  member.tel3,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ],
        ));
  }
}
