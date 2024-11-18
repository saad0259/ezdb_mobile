import 'package:flutter/material.dart';

import '../../flutter-utils/other_snippets.dart';
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
          child: InkWell(
            onTap: () => copyToClipboard(context, member.name),
            child: Text(
              member.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (member.ic.isNotEmpty)
                Row(
                  children: [
                    InkWell(
                      onTap: () => copyToClipboard(context, member.ic),
                      child: Row(
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
                    ),
                  ],
                ),
              if (member.tel1.isNotEmpty)
                InkWell(
                  onTap: () => copyToClipboard(context, member.tel1),
                  child: Row(
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
                ),
              if (member.tel2.isNotEmpty)
                InkWell(
                  onTap: () => copyToClipboard(context, member.tel2),
                  child: Row(
                    children: [
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
                ),
              if (member.tel3.isNotEmpty)
                InkWell(
                  onTap: () => copyToClipboard(context, member.tel3),
                  child: Row(
                    children: [
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
                ),
              if (member.address.isNotEmpty)
                InkWell(
                  onTap: () => copyToClipboard(context, member.address),
                  child: Row(
                    children: [
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
                ),
            ].expand((e) => [e, const SizedBox(height: 10)]).toList()
              ..removeLast(),
          ),
        ));
  }
}
