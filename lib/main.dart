import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_mate/chart.dart';
import 'package:money_mate/home.dart';
import 'package:money_mate/model/income_cat.dart';
import 'package:money_mate/planning.dart';
import 'package:money_mate/setting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await add_initial_category();
  runApp(const MyApp());
}

Future<void> add_initial_category() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference categoryCollection = db.collection('category');

  QuerySnapshot snapshot = await categoryCollection.limit(1).get();

  if (snapshot.docs.isEmpty) {
    List<Map<String, dynamic>> initialData = [
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

    for (var data in initialData) {
      DocumentReference docRef = categoryCollection.doc();
      await docRef.set({
        ...data,
        'cat_id': docRef.id,
      });
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoneyMate',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const Main(),
      builder: FToastBuilder(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  int index = 0;
  bool extendBody = true;
  final page = [const Home(), planning(), const chart(), const setting()];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: page[index],
        extendBody: extendBody,
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 7,
                  blurRadius: 8,
                  offset: const Offset(0, 7),
                ),
              ],
              color: Colors.grey[500],
              // gradient: const LinearGradient(
              //   begin: Alignment.topRight,
              //   end: Alignment.bottomLeft,
              //   colors: [
              //     Colors.blue,
              //     Colors.orange,
              //   ],
              // ),
            ),
            child: GNav(
                selectedIndex: index,
                onTabChange: (index) {
                  setState(() {
                    this.index = index;
                  });
                  if (index == 1) {
                    setState(() {
                      extendBody = false;
                    });
                  } else {
                    setState(() {
                      extendBody = true;
                    });
                  }
                },
                tabBackgroundGradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.orange, Colors.blue],
                ),
                padding: const EdgeInsets.all(20),
                gap: 5,
                activeColor: Colors.white,
                tabBorderRadius: 20,
                curve: Curves.easeInToLinear,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 16),
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    iconColor: Colors.black87,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.mode_edit_outline_rounded,
                    text: 'Planning',
                    iconColor: Colors.black87,
                  ),
                  GButton(
                    icon: Icons.pie_chart,
                    text: 'Chart',
                    iconColor: Colors.black87,
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: 'Setting',
                    iconColor: Colors.black87,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
