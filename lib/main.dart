import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:money_mate/data/repository/auth_repository.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'package:money_mate/data/repository/settings_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:money_mate/data/repository/user_repository.dart';
import 'package:money_mate/services/local_notification.dart';
import 'package:money_mate/bloc/auth/auth_bloc.dart';
import 'package:money_mate/bloc/auth/auth_event.dart';
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
import 'package:money_mate/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthBloc(authRepo: AuthRepositoryImpl())..add(AppStarted()),
        ),
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
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(state.language),
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
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          ),
          child: GNav(
            selectedIndex: index,
            onTabChange: (i) {
              setState(() {
                index = i;
                extendBody = i != 1;
              });
            },
            duration: const Duration(milliseconds: 200),
            tabBackgroundGradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [const Color(0xFF4364F7), const Color(0xFF6FB1FC)]
                  : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
            ),
            padding: const EdgeInsets.all(18),
            gap: width * 0.01,
            activeColor: Colors.white,
            tabBorderRadius: 20,
            tabs: [
              GButton(
                icon: Icons.home,
                text: AppLocalizations.of(context)!.home,
                iconSize: index == 0 ? 18 : 24,
              ),
              GButton(
                icon: Icons.mode_edit_outline_rounded,
                text: AppLocalizations.of(context)!.input,
                iconSize: index == 1 ? 18 : 24,
              ),
              GButton(
                icon: Icons.search_outlined,
                text: AppLocalizations.of(context)!.search,
                iconSize: index == 2 ? 18 : 24,
              ),
              GButton(
                icon: Icons.pie_chart,
                text: AppLocalizations.of(context)!.chart,
                iconSize: index == 3 ? 18 : 24,
              ),
              GButton(
                icon: Icons.settings,
                text: AppLocalizations.of(context)!.setting,
                iconSize: index == 4 ? 18 : 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
