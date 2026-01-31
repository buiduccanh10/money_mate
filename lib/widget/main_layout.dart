import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:money_mate/bloc/app_lock/app_lock_cubit.dart';
import 'package:money_mate/bloc/app_lock/app_lock_state.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/widget/chart/chart.dart';
import 'package:money_mate/widget/home/home.dart';
import 'package:money_mate/widget/input/input.dart';
import 'package:money_mate/widget/search/search.dart';
import 'package:money_mate/widget/setting/setting.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with WidgetsBindingObserver {
  int index = 0;
  bool extendBody = true;
  bool _needsLock = false;

  final List<Widget> pages = [
    const Home(),
    const Input(),
    const Search(),
    const Chart(),
    const Setting(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLock();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final appLockCubit = context.read<AppLockCubit>();
    final settingState = context.read<SettingCubit>().state;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      if (!appLockCubit.state.isAuthenticating) {
        _needsLock = true;
      }
    } else if (state == AppLifecycleState.resumed) {
      if (appLockCubit.state.isAuthenticating) return;

      if (_needsLock && settingState.isLock) {
        appLockCubit.lock();
        _needsLock = false;
        _checkLock();
      } else {
        _needsLock = false;
      }
    }
  }

  void _checkLock() {
    if (!mounted) return;
    final settingState = context.read<SettingCubit>().state;
    context.read<AppLockCubit>().authenticate(
      AppLocalizations.of(context)!.localAuthTitle,
      settingState.isLock,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLockCubit, AppLockState>(
      builder: (context, lockState) {
        if (!lockState.isAuthorized) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: _checkLock,
                child: Text(AppLocalizations.of(context)!.unlock),
              ),
            ),
          );
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          body: pages[index],
          extendBody: extendBody,
          bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        ? [const Color(0xFF0F2027), const Color(0xFF2C5364)]
                        : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  gap: 8,
                  activeColor: Colors.white,
                  tabBorderRadius: 15,
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: AppLocalizations.of(context)!.home,
                      iconSize: 24,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GButton(
                      icon: Icons.mode_edit_outline_rounded,
                      text: AppLocalizations.of(context)!.input,
                      iconSize: 24,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GButton(
                      icon: Icons.search_outlined,
                      text: AppLocalizations.of(context)!.search,
                      iconSize: 24,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GButton(
                      icon: Icons.pie_chart,
                      text: AppLocalizations.of(context)!.chart,
                      iconSize: 24,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GButton(
                      icon: Icons.settings,
                      text: AppLocalizations.of(context)!.setting,
                      iconSize: 24,
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
