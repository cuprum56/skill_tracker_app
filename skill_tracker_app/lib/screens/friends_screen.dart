import 'package:flutter/material.dart';

class FriendsListPage extends StatelessWidget {
  final List<Map<String, String>> friendsList;

  const FriendsListPage({
    super.key,
    required this.friendsList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список друзей'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Ваши друзья:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Динамически строим список друзей
          for (var friend in friendsList)
            FriendCard(
              friendName: friend['name']!,
              friendEmail: friend['email']!,
            ),
        ],
      ),
    );
  }
}

class FriendCard extends StatelessWidget {
  final String friendName;
  final String friendEmail;

  const FriendCard({
    super.key,
    required this.friendName,
    required this.friendEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              friendName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              friendEmail,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
