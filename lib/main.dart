import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_mate/chart.dart';
import 'package:money_mate/firebase_options.dart';
import 'package:money_mate/home.dart';
import 'package:money_mate/input.dart';
import 'package:money_mate/login.dart';
import 'package:money_mate/search.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/setting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      title: 'MoneyMate',
      debugShowCheckedModeBanner: false,
      home: user != null ? const Main() : const login(),
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
  late List<Widget> page;

  @override
  void initState() {
    super.initState();
    page = [
      const Home(),
      const input(),
      const search(),
      const chart(),
      const setting(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: page[index],
        extendBody: extendBody,
        bottomNavigationBar: SafeArea(
          minimum: EdgeInsets.all(width / 50),
          child: Container(
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
              color: const Color.fromARGB(255, 181, 181, 181),
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
                gap: width * 0.01,
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
                    text: 'Input',
                    iconColor: Colors.black87,
                  ),
                  GButton(
                    icon: Icons.search_outlined,
                    text: 'Input',
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
