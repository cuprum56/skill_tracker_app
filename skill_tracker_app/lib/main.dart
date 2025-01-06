import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Импорт провайдера
import 'package:firebase_core/firebase_core.dart';
import 'package:skill_tracker_app/services/auth_service.dart';
import 'package:skill_tracker_app/services/skill_manager.dart';
import 'package:skill_tracker_app/screens/app_screen.dart';
import 'package:skill_tracker_app/screens/learning_screen.dart'; // Импорт страницы "Обучение"

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider<SkillManager>(
          create: (context) => SkillManager(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/app': (context) => const AppScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/learning') {
          // Получаем аргументы
          final args = settings.arguments as Map<String, dynamic>?;

          if (args != null && args.containsKey('topicTitle') && args.containsKey('links')) {
            return MaterialPageRoute(
              builder: (context) => LearningPage(
                topicTitle: args['topicTitle'],
                links: args['links'],
              ),
            );
          } else {
            // Если аргументы не переданы, возвращаем ошибочную страницу
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Неправильные аргументы для страницы обучения')),
              ),
            );
          }
        }
        return null; // Возврат null для несуществующих маршрутов
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false); // Получаем AuthService

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await authService.signInWithGoogle();
            if (user != null) {
              final skillManager = Provider.of<SkillManager>(context, listen: false);
              await skillManager.loadSkillsFromFirestore(); // Загружаем навыки после входа
              Navigator.pushReplacementNamed(context, '/app');
            }
          },
          child: const Text('Войти через Google'),
        ),
      ),
    );
  }
}
