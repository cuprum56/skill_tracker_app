import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SkillsProvider(),
      child: const SkillTrackerApp(),
    ),
  );
}

class SkillTrackerApp extends StatelessWidget {
  const SkillTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skill Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class SkillsProvider extends ChangeNotifier {
  List<Map<String, String>> _skills = [];

  List<Map<String, String>> get skills => _skills;

  void addSkill(String skillName, String level) {
    _skills.add({'skill': skillName, 'level': level});
    notifyListeners();
  }

  void updateSkillLevel(int index, String newLevel) {
    _skills[index]['level'] = newLevel;
    notifyListeners();
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MainScreen(),
    const UserProfilePage(),
    const FriendsListPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _showAddSkillDialog(BuildContext context) {
    String? selectedSkill;
    String selectedLevel = 'Новичок';
    final List<String> skillList = _popularSkills;
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            final filteredSkills = skillList
                .where((skill) => skill
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();

            return AlertDialog(
              title: const Text('Добавить новый навык'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Поиск навыков',
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: selectedSkill,
                    hint: const Text('Выберите навык'),
                    isExpanded: true,
                    onChanged: (String? value) {
                      setState(() {
                        selectedSkill = value;
                      });
                    },
                    items: filteredSkills.map((skill) {
                      return DropdownMenuItem(
                        value: skill,
                        child: Text(skill),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedLevel,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          selectedLevel = value;
                        });
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'Новичок',
                        child: Text('Новичок'),
                      ),
                      DropdownMenuItem(
                        value: 'Любитель',
                        child: Text('Любитель'),
                      ),
                      DropdownMenuItem(
                        value: 'Профессионал',
                        child: Text('Профессионал'),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedSkill != null) {
                      Provider.of<SkillsProvider>(context, listen: false)
                          .addSkill(selectedSkill!, selectedLevel);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Добавить'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditSkillDialog(BuildContext context, int index) {
    String selectedLevel =
        Provider.of<SkillsProvider>(context, listen: false).skills[index]
            ['level']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Изменить уровень навыка'),
          content: DropdownButton<String>(
            value: selectedLevel,
            onChanged: (String? value) {
              if (value != null) {
                selectedLevel = value;
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'Новичок',
                child: Text('Новичок'),
              ),
              DropdownMenuItem(
                value: 'Любитель',
                child: Text('Любитель'),
              ),
              DropdownMenuItem(
                value: 'Профессионал',
                child: Text('Профессионал'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<SkillsProvider>(context, listen: false)
                    .updateSkillLevel(index, selectedLevel);
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final skills = Provider.of<SkillsProvider>(context).skills;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Главная'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ваши навыки:',
                style: TextStyle(fontSize: 18),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: skills.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showEditSkillDialog(context, index),
                      child: SkillCard(
                        skill: skills[index]['skill']!,
                        level: skills[index]['level']!,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddSkillDialog(context),
          tooltip: 'Добавить навык',
          child: const Icon(Icons.add),
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
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              skill,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Уровень: $level',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> _popularSkills = [
  'Программирование',
  'Английский язык',
  'Дизайн',
  'Веб-разработка',
  'Фотография',
  'Видеомонтаж',
  'Тайм-менеджмент',
  'Инвестиции',
  'Публичные выступления',
  'Лидерство',
  'Копирайтинг',
  'SEO',
  'Маркетинг',
  'Графический дизайн',
  'UI/UX дизайн',
  'Сторителлинг',
  '3D моделирование',
  'Йога',
  'Тренерство',
  'Эмоциональный интеллект',
  'Кулинария',
  'Ведение блога',
  'Иностранные языки',
  'Медитация',
  'Финансовая грамотность',
  'Критическое мышление',
  'Продажи',
  'Soft skills',
  'Аналитическое мышление',
  'Карьера',
  'Здоровое питание',
  'Мобильная разработка',
  'Работа в команде',
  'Игровая разработка',
  'Искусственный интеллект',
  'Data Science',
  'Machine Learning',
  'Blockchain',
  'Кодинг',
  'Риторика',
  'Психология',
  'Работа с клиентами',
  'Энергетика',
  'Рисование',
  'Мозговой штурм',
  'Networking',
  'Анализ данных',
  'Курирование контента',
  'Руководство проектами',
  'Планирование',
  'Декорирование',
  'Разработка приложений',
  'Подкастинг',
  'Работа в социальных сетях',
  'Цифровой маркетинг',
  'Ландшафтный дизайн',
  'Архитектура',
  'Шитье',
  'Плетение',
  'Игровая аналитика',
  'Бег',
  'Фитнес',
  'Танцы',
  'Музыка',
  'Фокусировка',
  'Креативность',
  'Этика',
  'Эффективность',
  'Социальная работа',
  'Ораторское искусство',
  'Коммуникация',
  'Саморазвитие',
  'Хобби',
  'Киноанализ',
  'Генеалогия',
  'Кроссфит',
  'Гимнастика',
  'Фехтование',
  'Диджеинг',
  'Настольные игры',
  'Разработка игр',
  '3D-анимация',
  'Философия',
  'История',
  'Чтение',
  'Эссеистика',
  'Математика',
  'Астрономия',
  'География',
  'Репетиторство',
  'Волонтерство',
  'Электроника',
  'Робототехника',
];

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.person,
              size: 100,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            const Text(
              'Имя пользователя',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Электронная почта: user@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Логика редактирования профиля
              },
              child: const Text('Редактировать профиль'),
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsListPage extends StatelessWidget {
  const FriendsListPage({super.key});

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
          FriendCard(friendName: 'Иван Иванов', friendEmail: 'ivan@example.com'),
          FriendCard(friendName: 'Ольга Петрова', friendEmail: 'olga@example.com'),
          FriendCard(friendName: 'Алексей Сидоров', friendEmail: 'alex@example.com'),
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
