import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:skill_tracker_app/data/skills_list.dart';
import 'package:skill_tracker_app/data/roadmaps.dart'; // Импортируем роадмапы

class SkillManager extends ChangeNotifier {
  final List<Map<String, dynamic>> _skills = []; // Теперь будем хранить не только название и уровень, но и роадмап
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> get skills => _skills;

  final List<String> _allSkills = skillsList;

  List<String> get allSkills => _allSkills;

  // Добавить новый навык с роадмапом
  void addSkill(String skillName) {
    // Получаем роадмап для этого навыка, если он есть
    List<Map<String, dynamic>> roadmap = roadmaps[skillName] ?? [];
    _skills.add({'name': skillName, 'level': 'Новичок', 'roadmap': roadmap});
    notifyListeners();
    saveSkillsToFirestore(); // Сохранить изменения
  }

  // Обновить уровень навыка
  void updateSkillLevel(int index, String newLevel) {
    _skills[index]['level'] = newLevel;
    notifyListeners();
    saveSkillsToFirestore(); // Сохранить изменения
  }

  // Удалить навык
  void removeSkill(int index) {
    if (index >= 0 && index < _skills.length) {
      _skills.removeAt(index);
      notifyListeners();
      saveSkillsToFirestore(); // Сохранить изменения
      print("Навык успешно удалён.");
    } else {
      print("Ошибка: индекс вне диапазона.");
    }
  }

  // Сохранение навыков в Firestore
  Future<void> saveSkillsToFirestore() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('users').doc(userId).set({
          'skills': _skills,
        });
        print("Навыки успешно сохранены.");
      } catch (e) {
        print("Ошибка при сохранении навыков: $e");
      }
    }
  }

  // Загрузка навыков из Firestore
  Future<void> loadSkillsFromFirestore() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          final data = doc.data();

          // Получаем список навыков как List<dynamic>
          final rawSkills = data?['skills'] as List<dynamic>? ?? [];

          // Преобразуем List<dynamic> в List<Map<String, String>>
          final List<Map<String, dynamic>> savedSkills = rawSkills.map((item) {
            if (item is Map<dynamic, dynamic>) {
              // Преобразуем каждую запись Map<dynamic, dynamic> в Map<String, String>
              return item.map(
                (key, value) => MapEntry(key.toString(), value),
              );
            }
            return <String, dynamic>{};
          }).toList();

          _skills.clear();
          _skills.addAll(savedSkills);
          print("Навыки успешно загружены: $_skills");
          notifyListeners();
        }
      } catch (e) {
        print("Ошибка при загрузке навыков: $e");
      }
    }
  }

  // Уровни навыков
  final List<String> skillLevels = ['Новичок', 'Средний', 'Продвинутый', 'Эксперт'];

  // Инициализация навыков при входе пользователя
  Future<void> initializeUserSkills() async {
    await loadSkillsFromFirestore();
  }

  // Функция для получения роадмапа для выбранного навыка
  List<Map<String, dynamic>> getRoadmap(String skillName) {
    final skill = _skills.firstWhere((element) => element['name'] == skillName, orElse: () => {});
    return skill['roadmap'] ?? [];
  }
}
