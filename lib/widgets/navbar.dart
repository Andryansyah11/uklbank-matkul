import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int activePage;

  const BottomNav(this.activePage, {super.key});

  void getLink(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/matkul');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: activePage,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) => getLink(context, index),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Mata Kuliah',
        ),
      ],
    );
  }
}
