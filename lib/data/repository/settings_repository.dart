import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsRepository {
  Future<String?> getLanguage();
  Future<void> updateLanguage(String language);
  Future<bool?> getDarkMode();
  Future<void> updateDarkMode(bool isDark);
  Future<bool?> getIsLock();
  Future<void> updateIsLock(bool isLock);
  Future<void> deleteUser();
  Future<void> deleteAllData();
  Future<int> scheduleInputTask(String date, String description, double money,
      String catId, String icon, String name, bool isIncome, String option);
  Future<void> removeScheduleTask(int id);
  Future<void> removeAllSchedule();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser?.uid ?? '';

  @override
  Future<String?> getLanguage() async {
    if (_uid.isEmpty) return 'en';
    final doc = await _firestore.collection('users').doc(_uid).get();
    if (doc.exists && doc.data()!.containsKey('language')) {
      return doc.data()!['language'];
    }
    return 'en';
  }

  @override
  Future<void> updateLanguage(String language) async {
    if (_uid.isEmpty) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .update({'language': language});
  }

  @override
  Future<bool?> getDarkMode() async {
    if (_uid.isEmpty) return false;
    final doc = await _firestore.collection('users').doc(_uid).get();
    if (doc.exists && doc.data()!.containsKey('is_dark')) {
      return doc.data()!['is_dark'];
    }
    return false;
  }

  @override
  Future<void> updateDarkMode(bool isDark) async {
    if (_uid.isEmpty) return;
    await _firestore.collection('users').doc(_uid).update({'is_dark': isDark});
  }

  @override
  Future<bool?> getIsLock() async {
    if (_uid.isEmpty) return false;
    final doc = await _firestore.collection('users').doc(_uid).get();
    if (doc.exists && doc.data()!.containsKey('is_lock')) {
      return doc.data()!['is_lock'];
    }
    return false;
  }

  @override
  Future<void> updateIsLock(bool isLock) async {
    if (_uid.isEmpty) return;
    await _firestore.collection('users').doc(_uid).update({'is_lock': isLock});
  }

  @override
  Future<void> deleteUser() async {
    if (_uid.isEmpty) return;
    try {
      await _auth.currentUser!.delete();
      await _firestore.collection('users').doc(_uid).delete();
    } catch (e) {
      throw Exception("Failed to delete user");
    }
  }

  @override
  Future<void> deleteAllData() async {
    if (_uid.isEmpty) return;

    // Delete subcollections
    final batch = _firestore.batch();

    var inputs = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('input')
        .get();
    for (var doc in inputs.docs) {
      batch.delete(doc.reference);
    }

    var categories = await _firestore
        .collection('users')
        .doc(_uid)
        .collection('category')
        .get();
    for (var doc in categories.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  @override
  Future<int> scheduleInputTask(
      String date,
      String description,
      double money,
      String catId,
      String icon,
      String name,
      bool isIncome,
      String option) async {
    if (_uid.isEmpty) return 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    List<String> inputData = [
      _uid,
      date,
      description,
      money.toString(),
      catId,
      icon,
      name,
      isIncome.toString(),
      option
    ];

    await prefs.setStringList(id.toString(), inputData);

    return id;
  }

  @override
  Future<void> removeScheduleTask(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(id.toString());
  }

  @override
  Future<void> removeAllSchedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
