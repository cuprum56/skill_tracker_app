import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skill_tracker_app/services/skill_manager.dart';
import 'package:skill_tracker_app/screens/learning_screen.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  @override
  Widget build(BuildContext context) {
    final skillManager = Provider.of<SkillManager>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ваши навыки'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ваши навыки:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: skillManager.skills.isNotEmpty
                    ? ListView.builder(
                        itemCount: skillManager.skills.length,
                        itemBuilder: (context, index) {
                          final skill = skillManager.skills[index];
                          return GestureDetector(
                            onTap: () => _showSkillDetailsDialog(context, skillManager, index),
                            child: SkillCard(
                              skill: skill['name']!,
                              level: skill['level']!,
                              hasRoadmap: skill['roadmap']?.isNotEmpty ?? false,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'У вас еще нет навыков. Добавьте первый!',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddSkillDialog(context, skillManager),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }


void _showSkillDetailsDialog(
    BuildContext context, SkillManager skillManager, int index) {
  final skill = skillManager.skills[index];
  final roadmap = skill['roadmap'] ?? [];

  List<bool> _expanded = List.generate(roadmap.length, (index) => false);

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Информация о "${skill['name']}"'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Уровень: ${skill['level']}'),
                  const SizedBox(height: 10),
                  if (roadmap.isNotEmpty)
                    ExpansionPanelList(
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          _expanded[panelIndex] = !_expanded[panelIndex];
                        });
                      },
                      children: roadmap.asMap().entries.map<ExpansionPanel>((entry) {
                        final step = entry.value;
                        final stepIndex = entry.key;
                        final topics = step['topics'] as List<dynamic>? ?? [];

                        return ExpansionPanel(
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              title: Text(step['title'] ?? 'Без названия'),
                            );
                          },
                          body: topics.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: topics.map<Widget>((topic) {
                                  final topicTitle = topic['title'] ?? 'Без названия';
                                  final topicLinks = topic['links'] as List<dynamic>? ?? [];
                              
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LearningPage(
                                            topicTitle: topicTitle,
                                            links: topicLinks.cast<String>(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4.0,
                                        horizontal: 16.0,
                                      ),
                                      child: Text(
                                        '- $topicTitle',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )

                            : const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Text('Нет тем'),
                              ),

                          isExpanded: _expanded[stepIndex],
                        );
                      }).toList(),
                    )
                  else
                    const Text('Роадмап отсутствует'),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await _showLevelDialog(context, skillManager, index);
                  Navigator.of(context).pop();
                },
                child: const Text('Изменить уровень'),
              ),
              ElevatedButton(
                onPressed: () {
                  _confirmDeleteSkill(context, skillManager, index);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Красная кнопка для удаления
                ),
                child: const Text('Удалить'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Закрыть'),
              ),
            ],
          );
        },
      );
    },
  );
}



  void _confirmDeleteSkill(
      BuildContext context, SkillManager skillManager, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Подтвердите удаление'),
          content: Text(
              'Вы уверены, что хотите удалить навык "${skillManager.skills[index]['name']}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                skillManager.removeSkill(index); // Удаляем навык
                Navigator.of(context).pop(); // Закрываем подтверждение
                Navigator.of(context).pop(); // Закрываем диалог
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Красная кнопка подтверждения
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _showLevelDialog(
    BuildContext context, SkillManager skillManager, int index) async {
    final skill = skillManager.skills[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Изменить уровень для "${skill['name']}"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: skillManager.skillLevels.map((level) {
              return ElevatedButton(
                onPressed: () async {
                  // Обновляем уровень навыка
                  skillManager.updateSkillLevel(index, level);
                  await skillManager.saveSkillsToFirestore();
                  Navigator.of(context).pop(); // Закрываем диалог
                },
                child: Text(level),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showAddSkillDialog(BuildContext context, SkillManager skillManager) {
    String? selectedSkill;
    List<String> filteredSkills = skillManager.allSkills; // Изначально показываем все навыки
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Используем StatefulBuilder для обновления состояния внутри диалога
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Добавить новый навык'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Поле для поиска
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Поиск навыков',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (query) {
                        setState(() {
                          filteredSkills = skillManager.allSkills
                              .where((skill) => skill.toLowerCase().contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Выпадающий список с фильтрацией
                    Container(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        items: filteredSkills.map((skill) {
                          return DropdownMenuItem(
                            value: skill,
                            child: Text(skill),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedSkill = value;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Выберите навык',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedSkill != null) {
                      skillManager.addSkill(selectedSkill!);
                      // Сохраняем обновленные данные
                      await skillManager.saveSkillsToFirestore();
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
}

class SkillCard extends StatelessWidget {
  final String skill;
  final String level;
  final bool hasRoadmap;

  const SkillCard({
    super.key,
    required this.skill,
    required this.level,
    this.hasRoadmap = false,
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
            if (hasRoadmap)
              const SizedBox(height: 8),
            if (hasRoadmap)
              const Text(
                'Роадмап доступен',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
