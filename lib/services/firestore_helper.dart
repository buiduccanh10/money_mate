import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class firestore_helper {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> get_user(String user_id, String email, String image_url) async {
    DocumentReference user_ref = db.collection('users').doc(user_id);

    String language = Platform.localeName.split('_').first;
    bool is_dark = ui.window.platformBrightness == ui.Brightness.dark;

    final users = <String, dynamic>{
      'email': email,
      'image': image_url,
      'language': language,
      'is_dark': is_dark,
      'is_lock': false,
    };

    await user_ref.set(users);

    String uid = user_ref.id;

    init_user_database(uid);
  }

  Future<void> init_user_database(String userId) async {
    CollectionReference cat_collection =
        db.collection('users').doc(userId).collection('category');

    QuerySnapshot snapshot = await cat_collection.get();

    if (snapshot.docs.isEmpty) {
      List<Map<String, dynamic>> cat_default = [
        {'name': 'Salary', 'icon': '💵', 'is_income': true},
        {'name': 'Business', 'icon': '🤝🏻', 'is_income': true},
        {'name': 'Others', 'icon': '🗒️', 'is_income': true},
        {"name": "Medical", "icon": "💊", "is_income": false},
        {"name": "Food", "icon": "🍽️", "is_income": false},
        {"name": "Clothes", "icon": "👕", "is_income": false},
        {"name": "Transportation", "icon": "🚘", "is_income": false},
      ];

      for (var data in cat_default) {
        DocumentReference docRef = cat_collection.doc();
        await docRef.set({
          ...data,
          'cat_id': docRef.id,
        });
      }
    }
  }

  Future<String?> get_language(String uid) async {
    DocumentSnapshot userDocument =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDocument.exists) {
      Map<String, dynamic>? data = userDocument.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('language')) {
        String? language = data['language'];
        return language;
      }
    }
    return null;
  }

  Future<void> update_language(String uid, String language) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'language': language,
    });
  }

  Future<bool?> get_dark_mode(String uid) async {
    DocumentSnapshot userDocument =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDocument.exists) {
      Map<String, dynamic>? data = userDocument.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('is_dark')) {
        bool? is_dark = data['is_dark'];
        return is_dark;
      }
    }
    return null;
  }

  Future<void> update_dark_mode(String uid, bool is_dark) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'is_dark': is_dark,
    });
  }

  Future<bool?> get_is_lock(String uid) async {
    DocumentSnapshot userDocument =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDocument.exists) {
      Map<String, dynamic>? data = userDocument.data() as Map<String, dynamic>?;
      if (data != null && data.containsKey('is_lock')) {
        bool? is_lock = data['is_lock'];
        return is_lock;
      }
    }
    return null;
  }

  Future<void> update_is_lock(String uid, bool is_lock) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'is_lock': is_lock,
    });
  }

  Future<List<Map<String, dynamic>>> fetch_categories(
      String uid, bool is_income) async {
    List<Map<String, dynamic>> categories = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .collection('category')
        .where('is_income', isEqualTo: is_income)
        .get();

    for (var doc in snapshot.docs) {
      categories.add(doc.data());
    }

    return categories;
  }

  Future<List<Map<String, dynamic>>> fetch_all_categories(String uid) async {
    List<Map<String, dynamic>> categories = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(uid)
        .collection('category')
        .get();

    for (var doc in snapshot.docs) {
      categories.add(doc.data());
    }

    return categories;
  }

  Future<List<Map<String, dynamic>>> fetch_input(
      String uid, String monthYear) async {
    final DateTime date = DateFormat('MMMM yyyy').parse(monthYear);
    final int month = date.month;
    final int year = date.year;

    List<Map<String, dynamic>> inputData = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('input')
        .orderBy('money', descending: true)
        .get();

    for (var inputDoc in snapshot.docs) {
      String catId = inputDoc.data()['cat_id'];

      DocumentSnapshot<Map<String, dynamic>> cat_snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('category')
              .doc(catId)
              .get();
      DateTime inputDate =
          DateFormat('dd/MM/yyyy').parse(inputDoc.data()['date']);

      if (cat_snapshot.exists) {
        if (inputDate.month == month && inputDate.year == year) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': cat_snapshot.data()!['icon'],
            'name': cat_snapshot.data()!['name'],
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      } else {
        if (inputDate.month == month && inputDate.year == year) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': '🚫',
            'name': 'No available',
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      }
    }

    return inputData;
  }

  Future<List<Map<String, dynamic>>> fetch_input_month_by_cat_id(
      String uid, String monthYear, String cat_id,
      {required bool isIncome}) async {
    final DateTime date = DateFormat('MMMM yyyy').parse(monthYear);
    final int month = date.month;
    final int year = date.year;

    List<Map<String, dynamic>> inputData = [];

    QuerySnapshot<Map<String, dynamic>> inputSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('input')
        .where('is_income', isEqualTo: isIncome)
        .where('cat_id', isEqualTo: cat_id)
        .get();

    for (var inputDoc in inputSnapshot.docs) {
      String catId = inputDoc.data()['cat_id'];
      DocumentSnapshot<Map<String, dynamic>> catSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(catId)
          .get();

      DateTime inputDate =
          DateFormat('dd/MM/yyyy').parse(inputDoc.data()['date']);
      if (inputDate.month == month && inputDate.year == year) {
        if (catSnapshot.exists) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': catSnapshot.data()!['icon'],
            'name': catSnapshot.data()!['name'],
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        } else {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': '🚫',
            'name': 'No available',
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      }
    }

    return inputData;
  }

  Future<List<Map<String, dynamic>>> fetch_input_year_by_cat_id(
      String uid, String year, String cat_id,
      {required bool isIncome}) async {
    final int parsedYear = int.parse(year);

    List<Map<String, dynamic>> inputData = [];

    QuerySnapshot<Map<String, dynamic>> inputSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('input')
        .where('is_income', isEqualTo: isIncome)
        .where('cat_id', isEqualTo: cat_id)
        .get();

    for (var inputDoc in inputSnapshot.docs) {
      String catId = inputDoc.data()['cat_id'];
      DocumentSnapshot<Map<String, dynamic>> catSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(catId)
          .get();

      DateTime inputDate =
          DateFormat('dd/MM/yyyy').parse(inputDoc.data()['date']);
      if (inputDate.year == parsedYear) {
        if (catSnapshot.exists) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': catSnapshot.data()!['icon'],
            'name': catSnapshot.data()!['name'],
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        } else {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': '🚫',
            'name': 'No available',
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      }
    }

    return inputData;
  }

  Future<List<Map<String, dynamic>>> fetch_data_cat_bymonth(
      String uid, String monthYear,
      {required bool isIncome}) async {
    final DateTime date = DateFormat('MMMM yyyy').parse(monthYear);
    final int month = date.month;
    final int year = date.year;

    List<Map<String, dynamic>> inputData = [];
    QuerySnapshot<Map<String, dynamic>> inputSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('input')
        .where('is_income', isEqualTo: isIncome)
        .get();

    for (var inputDoc in inputSnapshot.docs) {
      String catId = inputDoc.data()['cat_id'];

      DocumentSnapshot<Map<String, dynamic>> catSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(catId)
          .get();

      DateTime inputDate =
          DateFormat('dd/MM/yyyy').parse(inputDoc.data()['date']);
      if (inputDate.month == month && inputDate.year == year) {
        if (catSnapshot.exists) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': catSnapshot.data()!['icon'],
            'name': catSnapshot.data()!['name'],
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        } else {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': '🚫',
            'name': 'No available',
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      }
    }

    return inputData;
  }

  Future<List<Map<String, dynamic>>> fetch_data_cat_byyear(
      String uid, String year,
      {required bool isIncome}) async {
    final int parsedYear = int.parse(year);

    List<Map<String, dynamic>> inputData = [];

    QuerySnapshot<Map<String, dynamic>> inputSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('input')
        .where('is_income', isEqualTo: isIncome)
        .get();

    for (var inputDoc in inputSnapshot.docs) {
      String catId = inputDoc.data()['cat_id'];
      DocumentSnapshot<Map<String, dynamic>> catSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(catId)
          .get();

      DateTime inputDate =
          DateFormat('dd/MM/yyyy').parse(inputDoc.data()['date']);
      if (inputDate.year == parsedYear) {
        if (catSnapshot.exists) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': catSnapshot.data()!['icon'],
            'name': catSnapshot.data()!['name'],
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        } else {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': '🚫',
            'name': 'No available',
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      }
    }

    return inputData;
  }

  Future<void> add_category(
      String uid, String icon, String name, bool is_income) async {
    DocumentReference doc_ref =
        db.collection('users').doc(uid).collection("category").doc();
    String cat_id = doc_ref.id;

    final cat = <String, dynamic>{
      "cat_id": cat_id,
      "icon": icon,
      "name": name,
      "is_income": is_income
    };

    await doc_ref.set(cat);
  }

  Future<void> update_category(
      String uid, String catId, String icon, String name, bool isIncome) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("category")
        .doc(catId);

    Map<String, dynamic> updatedData = {
      "icon": icon,
      "name": name,
      "is_income": isIncome,
    };

    await docRef.update(updatedData);
  }

  Future<void> delete_all_category(String uid, bool isIncome) async {
    CollectionReference categoryCollectionRef =
        db.collection('users').doc(uid).collection('category');

    QuerySnapshot querySnapshot = await categoryCollectionRef
        .where('is_income', isEqualTo: isIncome)
        .get();

    querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) async {
      await documentSnapshot.reference.delete();
    });
  }

  Future<String?> get_paypal_cat_id(String uid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("category")
        .where("name", isEqualTo: 'PayPal')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      await add_category(uid, '💳', 'PayPal', false);
      get_paypal_cat_id(uid);
      return null;
    }
  }

  Future<void> scheduleInputTask(
      String uid,
      String date,
      String description,
      double money,
      String cat_id,
      String icon,
      String name,
      bool is_income,
      String option) async {
    DateTime schedule = DateFormat('dd/MM/yyyy').parse(date);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prefs_id = DateTime.now().millisecond.hashCode.toString();
    List<String> inputData = [
      uid,
      date,
      description,
      money.toString(),
      cat_id,
      icon,
      name,
      is_income.toString(),
      option
    ];

    await prefs.setStringList(prefs_id, inputData);

    switch (option) {
      case 'never':
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: int.parse(prefs_id),
            channelKey: 'input_channel',
            groupKey: 'input_channel_group',
            title: 'Money Mate',
            body: 'Auto add input successful !',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'DISMISS',
              label: 'OK',
              actionType: ActionType.Default,
            ),
          ],
          schedule: NotificationCalendar.fromDate(
            date: schedule,
            allowWhileIdle: true,
          ),
        );
        break;
      case 'daily':
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: int.parse(prefs_id),
            channelKey: 'input_channel',
            groupKey: 'input_channel_group',
            title: 'Money Mate',
            body: 'Auto add input successful !',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'DISMISS',
              label: 'OK',
              actionType: ActionType.Default,
            ),
          ],
          schedule: NotificationCalendar(
            hour: 0,
            minute: 0,
            second: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
        break;
      case 'weekly':
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: int.parse(prefs_id),
            channelKey: 'input_channel',
            groupKey: 'input_channel_group',
            title: 'Money Mate',
            body: 'Auto add input successful !',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'DISMISS',
              label: 'OK',
              actionType: ActionType.Default,
            ),
          ],
          schedule: NotificationCalendar(
            weekday: schedule.weekday,
            hour: 0,
            minute: 0,
            second: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
        break;
      case 'monthly':
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: int.parse(prefs_id),
            channelKey: 'input_channel',
            groupKey: 'input_channel_group',
            title: 'Money Mate',
            body: 'Auto add input successful !',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'DISMISS',
              label: 'OK',
              actionType: ActionType.Default,
            ),
          ],
          schedule: NotificationCalendar(
            weekday: schedule.day,
            hour: 0,
            minute: 0,
            second: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
        break;
      case 'yearly':
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: int.parse(prefs_id),
            channelKey: 'input_channel',
            groupKey: 'input_channel_group',
            title: 'Money Mate',
            body: 'Auto add input successful !',
          ),
          actionButtons: [
            NotificationActionButton(
              key: 'DISMISS',
              label: 'OK',
              actionType: ActionType.Default,
            ),
          ],
          schedule: NotificationCalendar(
            weekday: schedule.month,
            hour: 0,
            minute: 0,
            second: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
        break;
    }

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationDisplayedMethod: on_notification_displayed_method);
  }

  static Future<void> on_notification_displayed_method(
      ReceivedNotification receivedNotification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();
    String id = '';
    for (String key in keys) {
      if (key == receivedNotification.id.toString()) {
        id = key;
        if (receivedNotification.channelKey == 'input_channel') {
          List<String>? inputData = prefs.getStringList(id);

          String uid = inputData![0];
          String date = DateFormat('dd/MM/yyyy').format(DateTime.now());
          String description = inputData[2];
          double money = double.parse(inputData[3]);
          String cat_id = inputData[4];

          await firestore_helper()
              .add_input(uid, date, description, money, cat_id);
        }
      }
    }
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction ReceivedAction) async {}

  Future<void> add_input(String uid, String date, String description,
      double money, String cat_id) async {
    DocumentReference doc_ref =
        db.collection('users').doc(uid).collection("input").doc();
    String id = doc_ref.id;

    DocumentSnapshot categorySnapshot = await db
        .collection('users')
        .doc(uid)
        .collection('category')
        .doc(cat_id)
        .get();
    Map<String, dynamic>? categoryData =
        categorySnapshot.data() as Map<String, dynamic>?;
    bool is_income = categoryData!['is_income'];

    final data = <String, dynamic>{
      "id": id,
      "date": date,
      "description": description,
      "money": money,
      "cat_id": cat_id,
      'is_income': is_income
    };

    await doc_ref.set(data);
  }

  Future<void> update_input(String uid, String id, String date,
      String description, double money, String cat_id) async {
    DocumentReference doc_ref =
        db.collection('users').doc(uid).collection("input").doc(id);

    final data = <String, dynamic>{
      "date": date,
      "description": description,
      "money": money,
      "cat_id": cat_id
    };

    await doc_ref.update(data);
  }

  Future<void> delete_all_data(String uid) async {
    CollectionReference cat_ref =
        db.collection('users').doc(uid).collection('category');

    QuerySnapshot cat_snapshot = await cat_ref.get();

    cat_snapshot.docs.forEach((DocumentSnapshot documentSnapshot) async {
      await documentSnapshot.reference.delete();
    });

    CollectionReference input_ref =
        db.collection('users').doc(uid).collection('input');

    QuerySnapshot input_snapshot = await input_ref.get();

    input_snapshot.docs.forEach((DocumentSnapshot documentSnapshot) async {
      await documentSnapshot.reference.delete();
    });
  }

  Future<void> delete_user(String uid) async {
    WriteBatch batch = db.batch();

    QuerySnapshot inputSnapshot = await db.collection('users/$uid/input').get();
    for (var doc in inputSnapshot.docs) {
      batch.delete(doc.reference);
    }

    QuerySnapshot categorySnapshot =
        await db.collection('users/$uid/category').get();
    for (var doc in categorySnapshot.docs) {
      batch.delete(doc.reference);
    }

    batch.delete(db.collection('users').doc(uid));

    await batch.commit();
    await FirebaseAuth.instance.currentUser!.delete();
    // await FirebaseAuth.instance.currentUser!
    //     .reauthenticateWithProvider(GoogleAuthProvider())
    //     .whenComplete(() => FirebaseAuth.instance.currentUser!.delete());
  }

  Future<List<Map<String, dynamic>>> search(String uid, String query) async {
    List<Map<String, dynamic>> results = [];

    QuerySnapshot<Map<String, dynamic>> inputSnapshot =
        await db.collection('users').doc(uid).collection('input').get();

    final cleanedQuery = query.trim().toLowerCase().replaceAll(' ', '');

    for (var inputDoc in inputSnapshot.docs) {
      String description = inputDoc
          .data()['description']
          .toString()
          .trim()
          .toLowerCase()
          .replaceAll(' ', '');
      String date = inputDoc
          .data()['date']
          .toString()
          .trim()
          .toLowerCase()
          .replaceAll(' ', '');
      String money = inputDoc
          .data()['money']
          .toString()
          .trim()
          .toLowerCase()
          .replaceAll(' ', '');

      var searchableText = description + date + money;

      final catId = inputDoc.data()['cat_id'];

      DocumentSnapshot<Map<String, dynamic>> catSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(catId)
          .get();

      String categoryName =
          catSnapshot.data()!['name'].toString().trim().toLowerCase();
      searchableText += categoryName;

      if (searchableText.contains(cleanedQuery)) {
        if (catSnapshot.exists) {
          Map<String, dynamic> result = {
            'icon': catSnapshot.data()!['icon'],
            'name': catSnapshot.data()!['name'],
            'is_income': catSnapshot.data()!['is_income'],
            ...inputDoc.data(),
          };
          results.add(result);
        } else {
          Map<String, dynamic> result = {
            'icon': '🚫',
            'name': 'No available',
            ...inputDoc.data(),
          };
          results.add(result);
        }
      }
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> search_by_cat(
      String uid, String cat_id) async {
    List<Map<String, dynamic>> results = [];

    QuerySnapshot<Map<String, dynamic>> inputSnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(uid)
        .collection('input')
        .where('cat_id', isEqualTo: cat_id)
        .get();

    for (var inputDoc in inputSnapshot.docs) {
      String catId = inputDoc.data()['cat_id'];
      DocumentSnapshot<Map<String, dynamic>> catSnapshot = await db
          .collection('users')
          .doc(uid)
          .collection('category')
          .doc(catId)
          .get();

      if (catSnapshot.exists) {
        Map<String, dynamic> result = {
          'icon': catSnapshot.data()!['icon'],
          'name': catSnapshot.data()!['name'],
          ...inputDoc.data(),
        };
        results.add(result);
      } else {
        Map<String, dynamic> result = {
          'icon': '🚫',
          'name': 'No available',
          ...inputDoc.data(),
        };
        results.add(result);
      }
    }

    return results;
  }
}
