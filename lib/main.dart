import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_mate/services/currency.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/chart/chart.dart';
import 'package:money_mate/firebase_options.dart';
import 'package:money_mate/widget/home/home.dart';
import 'package:money_mate/widget/input/input.dart';
import 'package:money_mate/widget/accounts/login.dart';
import 'package:money_mate/widget/search/search.dart';
import 'package:money_mate/widget/setting/setting.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final localization = FlutterLocalization.instance;

  @override
  void initState() {
    configureLocalization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      theme: ThemeData.light(useMaterial3: true),
      title: 'Money Mate',
      debugShowCheckedModeBanner: false,
      home: user != null ? const Main() : const login(),
      builder: FToastBuilder(),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      locale: localization.currentLocale,
    );
  }

  void configureLocalization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: "en");
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
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
      search(),
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
          minimum: EdgeInsets.all(width / 20),
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
              color: const Color.fromARGB(255, 216, 216, 216),
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
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 16, right: 16),
                gap: width * 0.01,
                activeColor: Colors.white,
                tabBorderRadius: 20,
                curve: Curves.easeInToLinear,
                textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 16),
                tabs: [
                  GButton(
                    icon: Icons.home,
                    iconColor: Colors.black87,
                    text: LocaleData.home.getString(context),
                  ),
                  GButton(
                    icon: Icons.mode_edit_outline_rounded,
                    text: LocaleData.input.getString(context),
                    iconColor: Colors.black87,
                  ),
                  GButton(
                    icon: Icons.search_outlined,
                    text: LocaleData.search.getString(context),
                    iconColor: Colors.black87,
                  ),
                  GButton(
                    icon: Icons.pie_chart,
                    text: LocaleData.chart.getString(context),
                    iconColor: Colors.black87,
                  ),
                  GButton(
                    icon: Icons.settings,
                    text: LocaleData.setting.getString(context),
                    iconColor: Colors.black87,
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
