import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class firestore_helper {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> init_database() async {
    CollectionReference cat_collection = db.collection('category');

    QuerySnapshot snapshot = await cat_collection.limit(1).get();

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
        DocumentReference docRef = cat_collection.doc();
        await docRef.set({
          ...data,
          'cat_id': docRef.id,
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetch_categories(bool is_income) async {
    try {
      List<Map<String, dynamic>> categories = [];

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("category")
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

  Future<List<Map<String, dynamic>>> fetch_input() async {
    try {
      List<Map<String, dynamic>> inputData = [];

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('input').get();

      for (var inputDoc in snapshot.docs) {
        String catId = inputDoc.data()['cat_id'];

        DocumentSnapshot<Map<String, dynamic>> categorySnapshot =
            await FirebaseFirestore.instance
                .collection('category')
                .doc(catId)
                .get();

        if (categorySnapshot.exists) {
          Map<String, dynamic> inputDataWithIcon = {
            'icon': categorySnapshot.data()!['icon'],
            'name': categorySnapshot.data()!['name'],
            'is_income': categorySnapshot.data()!['is_income'],
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

  Future<void> add_category(String icon, String name, bool is_income) async {
    DocumentReference doc_ref = db.collection("category").doc();
    String cat_id = doc_ref.id;

    final cat = <String, dynamic>{
      "cat_id": cat_id,
      "icon": icon,
      "name": name,
      "is_income": is_income
    };

    await doc_ref.set(cat);
  }

  Future<void> add_input(
      String date, String description, String money, String cat_id) async {
    DocumentReference doc_ref = db.collection("input").doc();
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
}
