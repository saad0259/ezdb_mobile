import 'package:flutter/material.dart';

import '../../models/member.dart';
import '../../state/home_state.dart';
import 'member_details_dialog.dart';

class MembersList extends StatelessWidget {
  const MembersList({
    super.key,
    required this.homeState,
  });
  final HomeState homeState;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: homeState.members.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 20);
      },
      itemBuilder: (BuildContext context, int index) {
        final MemberModel member = homeState.members[index];
        return MemberWidget(member: member);
      },
    );
  }
}

class MemberWidget extends StatelessWidget {
  const MemberWidget({
    super.key,
    required this.member,
  });

  final MemberModel member;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => MemberDetailsDialog(member: member));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              // width: context.width * 0.3,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      member.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (member.ic.isNotEmpty)
                  Row(
                    children: [
                      const SizedBox(width: 35),
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
                if (member.tel1.isNotEmpty)
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 35),
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
                const SizedBox(width: 35),
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
          ],
        ),
      ),
    );
  }
}
