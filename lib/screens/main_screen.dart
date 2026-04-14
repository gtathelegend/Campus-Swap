import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/message_service.dart';
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
  final _messageService = MessageService();
  int _unreadCount = 0;
  RealtimeChannel? _unreadChannel;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadUnreadCount();
    // Subscribe to conversation changes to keep badge updated
    _unreadChannel =
        _messageService.subscribeToConversationChanges(_loadUnreadCount);
  }

  @override
  void dispose() {
    if (_unreadChannel != null) {
      Supabase.instance.client.removeChannel(_unreadChannel!);
    }
    super.dispose();
  }

  Future<void> _loadUnreadCount() async {
    if (!mounted) return;
    final count = await _messageService.getUnreadCount();
    if (mounted) setState(() => _unreadCount = count);
  }

  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  void _onNavTap(int i) {
    if (i == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true, builder: (_) => const SellFlowScreen()),
      );
    } else {
      final mapped = i < 2 ? i : i - 1;
      if (mapped == 2) _loadUnreadCount(); // refresh badge when switching to messages
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
          currentIndex: _currentIndex < 2 ? _currentIndex : _currentIndex + 1,
          onTap: _onNavTap,
          backgroundColor: AppColors.base,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.stone,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.search), label: 'Search'),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 32),
              activeIcon:
                  Icon(Icons.add_circle, size: 32, color: AppColors.gold),
              label: 'Sell',
            ),
            BottomNavigationBarItem(
              icon: _badgeIcon(
                  Icons.chat_bubble_outline, Icons.chat_bubble, false),
              activeIcon:
                  _badgeIcon(Icons.chat_bubble, Icons.chat_bubble, true),
              label: 'Messages',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _badgeIcon(IconData icon, IconData activeIcon, bool isActive) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(isActive ? activeIcon : icon),
        if (_unreadCount > 0)
          Positioned(
            right: -6,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                  color: AppColors.alert, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                _unreadCount > 9 ? '9+' : '$_unreadCount',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
