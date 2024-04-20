import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/local_notification.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/auth_view_model.dart';
import 'package:money_mate/view_model/category_view_model.dart';
import 'package:money_mate/view_model/chart_view_model.dart';
import 'package:money_mate/view_model/home_view_model.dart';
import 'package:money_mate/view_model/input_view_model.dart';
import 'package:money_mate/view_model/search_view_model.dart';
import 'package:money_mate/view_model/setting_view_model.dart';
import 'package:money_mate/widget/chart/chart.dart';
import 'package:money_mate/firebase_options.dart';
import 'package:money_mate/widget/home/home.dart';
import 'package:money_mate/widget/input/input.dart';
import 'package:money_mate/widget/auth/login.dart';
import 'package:money_mate/widget/search/search.dart';
import 'package:money_mate/widget/setting/setting.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setAppTheme(BuildContext context, ThemeData newTheme) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setAppTheme(newTheme);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final localization = FlutterLocalization.instance;
  String? uid;
  User? user;
  final db_helper = firestore_helper();
  ThemeData? theme;
  String language = 'en';
  bool? is_dark;

  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser != null) {
      user = FirebaseAuth.instance.currentUser;
      uid = user!.uid;
      get_language();
      get_dark_mode();
      config_localization();
    } else {
      config_localization();
      setAppTheme(ThemeData.light());
    }
    super.initState();
  }

  Future<void> get_language() async {
    String temp = (await db_helper.get_language(uid!))!;
    setState(() {
      localization.translate(temp);
    });
  }

  setAppTheme(ThemeData newtheme) {
    setState(() {
      theme = newtheme;
    });
  }

  Future<void> get_dark_mode() async {
    bool temp = (await db_helper.get_dark_mode(uid!))!;
    setState(() {
      is_dark = temp;
      set_dark_mode();
    });
  }

  void set_dark_mode() {
    if (is_dark!) {
      setState(() {
        theme = ThemeData.dark();
      });
    } else {
      setState(() {
        theme = ThemeData.light();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => home_view_model()),
        ChangeNotifierProvider(create: (context) => category_view_model()),
        ChangeNotifierProvider(create: (context) => input_view_model()),
        ChangeNotifierProvider(create: (context) => search_view_model()),
        ChangeNotifierProvider(create: (context) => chart_view_model()),
        ChangeNotifierProvider(create: (context) => setting_view_model()),
        ChangeNotifierProvider(create: (context) => auth_view_model()),
      ],
      child: PopScope(
        canPop: false,
        child: MaterialApp(
          theme: theme,
          title: 'Money Mate',
          debugShowCheckedModeBanner: false,
          home: user != null ? Main() : const login(),
          builder: FToastBuilder(),
          supportedLocales: localization.supportedLocales,
          localizationsDelegates: localization.localizationsDelegates,
          locale: localization.currentLocale,
        ),
      ),
    );
  }

  void config_localization() {
    localization.init(mapLocales: LOCALES, initLanguageCode: language);
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}

class Main extends StatefulWidget {
  static final main_globalkey = GlobalKey<_MainState>();

  static _MainState? getState() {
    return main_globalkey.currentState;
  }

  Main() : super(key: Main.main_globalkey);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  int index = 0;
  bool extendBody = true;
  late List<Widget> page;
  final LocalAuthentication local_auth = LocalAuthentication();
  bool auth = false;
  bool is_lock = false;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final db_helper = firestore_helper();
  FToast toast = FToast();

  Future<void> check_authentication() async {
    await local_auth.authenticate(
      localizedReason: LocaleData.local_auth_title.getString(context),
    );

    setState(() {
      auth = true;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    get_is_lock();

    page = [
      const Home(),
      const input(),
      search(),
      const chart(),
      const setting(),
    ];
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (is_lock == true) {
      if (state == AppLifecycleState.hidden ||
          state == AppLifecycleState.paused && auth == true) {
        setState(() {
          auth = false;
        });
      }
      if (state == AppLifecycleState.resumed && auth == false) {
        if (await local_auth.isDeviceSupported()) {
          check_authentication();
        } else {
          setState(() {
            auth = false;
            is_lock = false;
            db_helper.update_is_lock(uid, false);
          });
        }
      }
    }
  }

  Future<void> get_is_lock() async {
    if (await local_auth.isDeviceSupported()) {
      bool temp = (await db_helper.get_is_lock(uid))!;
      setState(() {
        is_lock = temp;
        if (is_lock == true) {
          check_authentication();
        }
      });
    } else {
      await db_helper.update_is_lock(uid, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    if (!auth && is_lock == true) {
      return Scaffold(
        backgroundColor: is_dark
            ? ThemeData.dark().canvasColor
            : ThemeData.light().canvasColor,
      );
    }

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
                  color: is_dark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.2),
                  spreadRadius: 7,
                  blurRadius: 8,
                  offset: const Offset(0, 7),
                ),
              ],
              color: is_dark
                  ? Colors.grey[500]
                  : const Color.fromARGB(255, 216, 216, 216),
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
                tabBackgroundGradient: is_dark
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 203, 122, 0),
                          Color.fromARGB(255, 0, 112, 204),
                        ],
                      )
                    : const LinearGradient(
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
