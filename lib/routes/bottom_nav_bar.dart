import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'destinations.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('BottomNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: navigationShell.goBranch,
        indicatorColor: Theme.of(context).primaryColor,
        destinations: destinations
            .map(
              (destination) => NavigationDestination(
                icon: Icon(destination.icon),
                label: destination.label,
                selectedIcon: Icon(
                  destination.icon,
                  color: Colors.white,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
