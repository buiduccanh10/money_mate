import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:money_mate/data/repository/auth_repository.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'package:money_mate/data/repository/settings_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:money_mate/data/repository/user_repository.dart';
import 'package:money_mate/services/local_notification.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/auth/auth_bloc.dart';
import 'package:money_mate/bloc/auth/auth_state.dart';
import 'package:money_mate/bloc/category/category_cubit.dart';
import 'package:money_mate/bloc/chart/chart_cubit.dart';
import 'package:money_mate/bloc/home/home_cubit.dart';
import 'package:money_mate/bloc/input/input_cubit.dart';
import 'package:money_mate/bloc/search/search_cubit.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/bloc/setting/setting_state.dart';
import 'package:money_mate/bloc/schedule/schedule_cubit.dart';
import 'package:money_mate/data/repository/schedule_repository.dart';
import 'package:money_mate/widget/chart/chart.dart';
import 'package:money_mate/widget/home/home.dart';
import 'package:money_mate/widget/input/input.dart';
import 'package:money_mate/widget/auth/login.dart';
import 'package:money_mate/widget/search/search.dart';
import 'package:money_mate/widget/setting/setting.dart';

import 'package:money_mate/data/network/api_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterLocalization.instance.ensureInitialized();
  await NotificationService.initializeNotification();

  ApiClient.init(baseUrl: 'http://localhost:3000');

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
    super.initState();
    localization.init(mapLocales: locales, initLanguageCode: 'en');
    localization.onTranslatedLanguage = (_) => setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepo: AuthRepositoryImpl())),
        BlocProvider(
          create: (_) => HomeCubit(
            transactionRepo: TransactionRepositoryImpl(),
            userRepo: UserRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) => CategoryCubit(categoryRepo: CategoryRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) => InputCubit(
            categoryRepo: CategoryRepositoryImpl(),
            transactionRepo: TransactionRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) =>
              SearchCubit(transactionRepo: TransactionRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) =>
              ChartCubit(transactionRepo: TransactionRepositoryImpl()),
        ),
        BlocProvider(
          create: (_) => SettingCubit(
            settingsRepo: SettingsRepositoryImpl(),
            userRepo: UserRepositoryImpl(),
            transactionRepo: TransactionRepositoryImpl(),
          ),
        ),
        BlocProvider(
          create: (_) => ScheduleCubit(scheduleRepo: ScheduleRepositoryImpl()),
        ),
      ],
      child: BlocBuilder<SettingCubit, SettingState>(
        builder: (context, state) {
          return MaterialApp(
            theme: state.isDark ? ThemeData.dark() : ThemeData.light(),
            title: 'Money Mate',
            debugShowCheckedModeBanner: false,
            home: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState.status == AuthStatus.success) {
                  return const Main();
                }
                return const Login();
              },
            ),
            builder: FToastBuilder(),
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            locale: localization.currentLocale,
          );
        },
      ),
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  int index = 0;
  bool extendBody = true;
  final List<Widget> pages = [
    const Home(),
    const Input(),
    const Search(),
    const Chart(),
    const Setting(),
  ];

  final LocalAuthentication localAuth = LocalAuthentication();
  bool isAuthorized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkLock() async {
    final state = context.read<SettingCubit>().state;
    if (state.isLock) {
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to access Money Mate',
      );
      setState(() {
        isAuthorized = authenticated;
      });
    } else {
      setState(() {
        isAuthorized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthorized) {
      return Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _checkLock,
            child: const Text('Unlock'),
          ),
        ),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: pages[index],
      extendBody: extendBody,
      bottomNavigationBar: SafeArea(
        minimum: EdgeInsets.all(width / 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.2),
                spreadRadius: 7,
                blurRadius: 8,
                offset: const Offset(0, 7),
              ),
            ],
            color: isDark
                ? Colors.grey[500]
                : const Color.fromARGB(255, 216, 216, 216),
          ),
          child: GNav(
            selectedIndex: index,
            onTabChange: (i) {
              setState(() {
                index = i;
                extendBody = i != 1;
              });
            },
            tabBackgroundGradient: isDark
                ? const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 203, 122, 0),
                      Color.fromARGB(255, 0, 112, 204),
                    ],
                  )
                : const LinearGradient(colors: [Colors.orange, Colors.blue]),
            padding: const EdgeInsets.all(20),
            gap: width * 0.01,
            activeColor: Colors.white,
            tabBorderRadius: 20,
            tabs: [
              GButton(
                icon: Icons.home,
                text: LocaleData.home.getString(context),
              ),
              GButton(
                icon: Icons.mode_edit_outline_rounded,
                text: LocaleData.input.getString(context),
              ),
              GButton(
                icon: Icons.search_outlined,
                text: LocaleData.search.getString(context),
              ),
              GButton(
                icon: Icons.pie_chart,
                text: LocaleData.chart.getString(context),
              ),
              GButton(
                icon: Icons.settings,
                text: LocaleData.setting.getString(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
