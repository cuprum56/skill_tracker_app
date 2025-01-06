//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const SkillTrackerApp());
}


class SkillTrackerApp extends StatelessWidget {
  const SkillTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainScreen(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Skill Tracker'),
        ),
        body: const Center(
          child: Text(
            'Работает!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

class SkillCard extends StatelessWidget {
  final String skill;
  final String level;

  const SkillCard({
    super.key,
    required this.skill,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(skill),
            const Spacer(),
            Text(level),
          ],
        ),
      ),
    );
  }
}
