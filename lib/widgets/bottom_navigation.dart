import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final void Function(int index) onItemTapped;

  const BottomNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 30,
      selectedIconTheme:
          Theme.of(context).bottomNavigationBarTheme.selectedIconTheme,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      unselectedIconTheme:
          Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_graph),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'School',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }
}
