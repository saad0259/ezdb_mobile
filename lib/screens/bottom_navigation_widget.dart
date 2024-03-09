import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/dashboard_state.dart';

class BottomNavigationWidget extends StatelessWidget {
  const BottomNavigationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardState state = Provider.of<DashboardState>(context);
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          // boxShadow: [
          //   BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Color(0xffF3F3F3),
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: <BottomNavigationBarItem>[
              GetBottomNavigationBarItem(Icons.home, 'Home'),
              GetBottomNavigationBarItem(Icons.receipt_long, 'Billing'),
              GetBottomNavigationBarItem(Icons.list, 'Price'),
              GetBottomNavigationBarItem(Icons.settings, 'Settings'),
            ],
            currentIndex: state.currentIndex,
            onTap: (index) {
              state.setCurrentIndex(index);
            },
          ),
        ));
  }

  BottomNavigationBarItem GetBottomNavigationBarItem(
    IconData icon,
    String label,
  ) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: Colors.black),
      label: 'Billing',
      activeIcon: Container(
        padding: EdgeInsets.all(10),
        child: Icon(
          icon,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Colors.black,
              blurRadius: 7,
              offset: Offset(1, 1),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffff7518),
        ),
      ),
    );
  }
}
