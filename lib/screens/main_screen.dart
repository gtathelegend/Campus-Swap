import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'messages_screen.dart';
import 'profile_screen.dart';
import 'sell_flow_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  // Only 4 real screens (no Sell in IndexedStack)
  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  void _onNavTap(int i) {
    if (i == 2) {
      // Sell tab → push sell flow as full-screen
      Navigator.push(
        context,
        MaterialPageRoute(fullscreenDialog: true, builder: (_) => const SellFlowScreen()),
      );
    } else {
      // Map nav indices: 0→0, 1→1, skip 2, 3→2, 4→3
      final mapped = i < 2 ? i : i - 1;
      setState(() => _currentIndex = mapped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.base,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: BottomNavigationBar(
          // Map back to display index (insert 2 for Sell)
          currentIndex: _currentIndex < 2 ? _currentIndex : _currentIndex + 1,
          onTap: _onNavTap,
          backgroundColor: AppColors.base,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.stone,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 32),
              activeIcon: Icon(Icons.add_circle, size: 32, color: AppColors.gold),
              label: 'Sell',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
