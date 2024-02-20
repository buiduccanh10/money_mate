import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class firestore_helper {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> get_user(String user_id, String email, String image_url) async {
    DocumentReference user_ref = db.collection('users').doc(user_id);

    final users = <String, dynamic>{"email": email, "image": image_url};

    await user_ref.set(users);
    String uid = user_ref.id;

    initUserDatabase(uid);
  }

  Future<void> initUserDatabase(String userId) async {
    CollectionReference user_collection =
        db.collection('users').doc(userId).collection('category');

    QuerySnapshot snapshot = await user_collection.limit(1).get();

    if (snapshot.docs.isEmpty) {
      List<Map<String, dynamic>> cat_default = [
        {'name': 'Salary', 'icon': '💵', 'is_income': true},
        {'name': 'Business', 'icon': '🤝🏻', 'is_income': true},
        {'name': 'Others', 'icon': '🗒️', 'is_income': true},
        {"name": "Shopping", "icon": "🛒", "is_income": false},
        {"name": "Food", "icon": "🍔", "is_income": false},
        {"name": "Vegetable", "icon": "🥬", "is_income": false},
        {"name": "Clothes", "icon": "👕", "is_income": false},
        {"name": "Travel", "icon": "🏖️", "is_income": false},
        {"name": "Moving", "icon": "🚘", "is_income": false},
        {"name": "Others", "icon": "🗒️", "is_income": false}
      ];

      for (var data in cat_default) {
        DocumentReference docRef = user_collection.doc();
        await docRef.set({
          ...data,
          'cat_id': docRef.id,
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetch_categories(
      String uid, bool is_income) async {
    try {
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
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetch_input(String uid) async {
    try {
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

        if (cat_snapshot.exists) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': cat_snapshot.data()!['icon'],
            'name': cat_snapshot.data()!['name'],
            'is_income': cat_snapshot.data()!['is_income'],
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      }

      return inputData;
    } catch (error) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetch_data_by_cat(String uid,
      {required bool isIncome}) async {
    try {
      List<Map<String, dynamic>> inputData = [];

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(uid)
          .collection('category')
          .where('is_income', isEqualTo: isIncome)
          .get();

      for (var catDoc in snapshot.docs) {
        String catId = catDoc.data()['cat_id'];

        QuerySnapshot<Map<String, dynamic>> inputSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('input')
                .where('cat_id', isEqualTo: catId)
                .get();

        for (var inputDoc in inputSnapshot.docs) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': catDoc.data()['icon'],
            'name': catDoc.data()['name'],
            'is_income': catDoc.data()['is_income'],
            ...inputDoc.data(),
          };
          inputData.add(inputDataWithIcon);
        }
      }

      return inputData;
    } catch (error) {
      return [];
    }
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
    try {
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
    } catch (error) {}
  }

  Future<void> add_input(String uid, String date, String description,
      double money, String cat_id) async {
    DocumentReference doc_ref =
        db.collection('users').doc(uid).collection("input").doc();
    String id = doc_ref.id;

    final data = <String, dynamic>{
      "id": id,
      "date": date,
      "description": description,
      "money": money,
      "cat_id": cat_id
    };

    await doc_ref.set(data);
  }

  Future<void> update_input(String uid, String id, String date,
      String description, double money, String cat_id) async {
    try {
      DocumentReference doc_ref =
          db.collection('users').doc(uid).collection("input").doc(id);

      final data = <String, dynamic>{
        "date": date,
        "description": description,
        "money": money,
        "cat_id": cat_id
      };

      await doc_ref.update(data);
    } catch (error) {
      print("Error updating input: $error");
    }
  }
}
