import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/bloc/app_lock/app_lock_cubit.dart';
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
import 'package:money_mate/data/network/api_client.dart';
import 'package:money_mate/data/repository/auth_repository.dart';
import 'package:money_mate/data/repository/category_repository.dart';
import 'package:money_mate/data/repository/local_auth_repository.dart';
import 'package:money_mate/data/repository/schedule_repository.dart';
import 'package:money_mate/data/repository/settings_repository.dart';
import 'package:money_mate/data/repository/transaction_repository.dart';
import 'package:money_mate/data/repository/user_repository.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/services/local_notification.dart';
import 'package:money_mate/widget/auth/login.dart';
import 'package:money_mate/widget/main_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  ApiClient.init(baseUrl: 'http://localhost:3000');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
        RepositoryProvider<UserRepository>(create: (_) => UserRepositoryImpl()),
        RepositoryProvider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(),
        ),
        RepositoryProvider<TransactionRepository>(
          create: (_) => TransactionRepositoryImpl(),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (_) => CategoryRepositoryImpl(),
        ),
        RepositoryProvider<ScheduleRepository>(
          create: (_) => ScheduleRepositoryImpl(),
        ),
        RepositoryProvider<LocalAuthRepository>(
          create: (_) => LocalAuthRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepo: context.read<AuthRepository>())
                  ..add(AppStarted()),
          ),
          BlocProvider(
            create: (context) => HomeCubit(
              transactionRepo: context.read<TransactionRepository>(),
              userRepo: context.read<UserRepository>(),
              scheduleRepo: context.read<ScheduleRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CategoryCubit(
              categoryRepo: context.read<CategoryRepository>(),
              transactionRepo: context.read<TransactionRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => InputCubit(
              categoryRepo: context.read<CategoryRepository>(),
              transactionRepo: context.read<TransactionRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SearchCubit(
              transactionRepo: context.read<TransactionRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChartCubit(
              transactionRepo: context.read<TransactionRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => SettingCubit(
              settingsRepo: context.read<SettingsRepository>(),
              userRepo: context.read<UserRepository>(),
              transactionRepo: context.read<TransactionRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) =>
                ScheduleCubit(scheduleRepo: context.read<ScheduleRepository>()),
          ),
          BlocProvider(
            create: (context) => AppLockCubit(
              localAuthRepo: context.read<LocalAuthRepository>(),
            ),
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
                    return const MainLayout();
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
      ),
    );
  }
}
