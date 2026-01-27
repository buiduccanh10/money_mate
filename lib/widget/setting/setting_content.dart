import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/bloc/setting/setting_state.dart';
import 'package:money_mate/bloc/auth/auth_bloc.dart';
import 'package:money_mate/bloc/auth/auth_event.dart';
import 'package:money_mate/widget/setting/advance_setting/advance_setting.dart';
import 'package:money_mate/widget/setting/language_setting.dart';
import 'package:money_mate/widget/setting/privacy_setting.dart';
import 'package:money_mate/widget/auth/login.dart';

class SettingContent extends StatelessWidget {
  const SettingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        bool isDark = state.isDark;
        final bgColor = isDark ? Colors.grey[700] : Colors.grey[200];

        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: width * 0.04,
              top: 250,
              right: width * 0.04,
              bottom: height * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSettingItem(
                  context,
                  icon: Icons.settings_suggest,
                  iconColor: isDark ? Colors.brown[100]! : Colors.brown,
                  label: AppLocalizations.of(context)!.advancedSettings,
                  bgColor: bgColor!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdvanceSetting()),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildSubItem(
                        context,
                        icon: Icons.language,
                        iconColor: Colors.blue,
                        label: AppLocalizations.of(context)!.language,
                        subLabel: AppLocalizations.of(context)!.languageDes,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguageSetting(),
                          ),
                        ),
                      ),
                      _buildSwitchItem(
                        context,
                        icon: Icons.dark_mode,
                        iconColor: Colors.purple[700]!,
                        label: AppLocalizations.of(context)!.appearance,
                        subLabel: isDark
                            ? AppLocalizations.of(context)!.darkmodeDarkDes
                            : AppLocalizations.of(context)!.darkmodeLightDes,
                        value: isDark,
                        onChanged: (val) =>
                            context.read<SettingCubit>().toggleDarkMode(val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildSwitchItem(
                        context,
                        icon: Icons.lock,
                        iconColor: Colors.green,
                        label: AppLocalizations.of(context)!.applicationLock,
                        subLabel: AppLocalizations.of(
                          context,
                        )!.applicationLockDes,
                        value: state.isLock,
                        onChanged: (val) =>
                            context.read<SettingCubit>().toggleLock(val),
                      ),
                      _buildSubItem(
                        context,
                        icon: Icons.privacy_tip,
                        iconColor: Colors.red,
                        label: AppLocalizations.of(context)!.privacy,
                        subLabel: AppLocalizations.of(context)!.privacyDes,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PrivacySetting(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _buildSubItem(
                        context,
                        icon: Icons.info,
                        iconColor: Colors.orange,
                        label: AppLocalizations.of(context)!.about,
                        subLabel: AppLocalizations.of(context)!.aboutDes,
                        onTap: () => showAboutDialog(context: context),
                      ),
                      _buildSubItem(
                        context,
                        icon: Icons.feedback,
                        iconColor: Colors.cyan,
                        label: AppLocalizations.of(context)!.sendFeedback,
                        subLabel: AppLocalizations.of(context)!.sendFeedbackDes,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildLogoutButton(context, isDark, bgColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Icon(icon, color: iconColor, size: 30),
                  ),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.navigate_next),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subLabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Icon(icon, color: iconColor, size: 26),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subLabel,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subLabel,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      subLabel,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
              (states) => states.contains(WidgetState.selected)
                  ? const Icon(Icons.check)
                  : const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark, Color bgColor) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showLogoutDialog(context),
        child: SizedBox(
          height: 50,
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.logOut,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: isDark ? Colors.redAccent : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(AppLocalizations.of(context)!.logOut),
        message: Text(AppLocalizations.of(context)!.logOutDialog),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
              );
            },
            isDestructiveAction: true,
            child: Text(AppLocalizations.of(context)!.logOut),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
      ),
    );
  }
}
