import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_tracker_app/services/auth_service.dart';
import 'package:skill_tracker_app/screens/skill_screen.dart';
import 'package:skill_tracker_app/screens/profile_screen.dart';
import 'package:skill_tracker_app/screens/friends_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndex = 0;

  // Список экранов для навигации
  final List<Widget> _pages = const [
    SkillsPage(),
    ProfilePage(
      userName: 'Имя пользователя',
      userEmail: 'user@example.com',
    ),
    FriendsListPage(
      friendsList: [
        {'name': 'Иван Иванов', 'email': 'ivan@example.com'},
        {'name': 'Ольга Петрова', 'email': 'olga@example.com'},
        {'name': 'Алексей Сидоров', 'email': 'alex@example.com'},
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Друзья',
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(_getAppBarTitle(_selectedIndex)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Навыки';
      case 1:
        return 'Профиль';
      case 2:
        return 'Друзья';
      default:
        return 'Приложение';
    }
  }
}
