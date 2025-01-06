import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    signInOption: SignInOption.standard,
  );
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получение текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Получить UID текущего пользователя
  String? get currentUserId => _auth.currentUser?.uid;

  // Вход через Google
  Future<User?> signInWithGoogle() async {
    try {
      // Инициализация Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  
      // Проверка: Пользователь отменил авторизацию
      if (googleUser == null) {
        print("Google Sign-In: Пользователь отменил авторизацию.");
        return null;
      }
  
      // Лог успешного входа через Google
      print("Google Sign-In: Успешно.");
      print("Имя пользователя: ${googleUser.displayName}");
      print("Email: ${googleUser.email}");
  
      // Получение токенов Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  
      // Лог токенов
      print("Google Auth: AccessToken = ${googleAuth.accessToken}");
      print("Google Auth: IdToken = ${googleAuth.idToken}");
  
      // Проверка: Токены должны быть валидными
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        print("Ошибка: Не удалось получить токены Google.");
        return null;
      }
  
      // Создание учетных данных Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
  
      // Вход через Firebase
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
  
      // Лог данных, возвращенных Firebase
      print("Firebase Auth: UserCredential получен.");
      print("UserCredential: ${userCredential.toString()}");
  
      // Проверка, что пользователь найден
      if (userCredential.user != null) {
        final user = userCredential.user!;
        print("Firebase Auth: Пользователь успешно вошел.");
        print("UID: ${user.uid}");
        print("Email: ${user.email}");
        print("Имя: ${user.displayName}");
        return user;
      } else {
        print("Ошибка: Пользователь не найден после входа.");
        return null;
      }
    } catch (e, stackTrace) {
      // Лог ошибки и стека вызовов
      print("Неизвестная ошибка при входе через Google: $e");
      print("StackTrace: $stackTrace");
      return null;
    }
  }


  // Выход из системы
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      print("Пользователь успешно вышел.");
      notifyListeners();
    } catch (e) {
      print("Ошибка при выходе: $e");
    }
  }

  // Слушатель изменений состояния авторизации
  void listenToAuthChanges() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('Пользователь вышел.');
      } else {
        print('Пользователь вошел: ${user.email}');
      }
      notifyListeners();
    });
  }

  // Инициализация документа пользователя в Firestore
  Future<void> _initializeUserDocument(String userId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    try {
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'skills': [], // Инициализируем пустым массивом навыков
        });
        print("Документ пользователя создан.");
      } else {
        print("Документ пользователя уже существует.");
      }
    } catch (e) {
      print("Ошибка при инициализации документа пользователя: $e");
    }
  }

  // Сохранение навыков в Firestore
  Future<void> saveSkillsToFirestore(List<Map<String, String>> skills) async {
    final userId = currentUserId;
    if (userId != null) {
      try {
        await _firestore.collection('users').doc(userId).update({
          'skills': skills,
        });
        print("Навыки успешно сохранены.");
      } catch (e) {
        print("Ошибка при сохранении навыков: $e");
      }
    }
  }

  // Загрузка навыков из Firestore
  Future<List<Map<String, String>>> loadSkillsFromFirestore() async {
    final userId = currentUserId;
    if (userId != null) {
      try {
        final doc = await _firestore.collection('users').doc(userId).get();
        if (doc.exists) {
          final data = doc.data();
          return List<Map<String, String>>.from(data?['skills'] ?? []);
        }
      } catch (e) {
        print("Ошибка при загрузке навыков: $e");
      }
    }
    return [];
  }
}
