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
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF5F7FA),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: width * 0.04,
              top: 280,
              right: width * 0.04,
              bottom: height * 0.15,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCardContainer(
                  isDark,
                  child: _buildItem(
                    context,
                    isDark,
                    icon: Icons.settings_suggest,
                    iconColor: Colors.brown,
                    label: AppLocalizations.of(context)!.advancedSettings,
                    subLabel: '',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdvanceSetting()),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCardContainer(
                  isDark,
                  child: Column(
                    children: [
                      _buildItem(
                        context,
                        isDark,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                        ),
                      ),
                      _buildSwitchItem(
                        context,
                        isDark,
                        icon: Icons.dark_mode,
                        iconColor: Colors.purple,
                        label: AppLocalizations.of(context)!.appearance,
                        subLabel: state.isDark
                            ? AppLocalizations.of(context)!.darkmodeDarkDes
                            : AppLocalizations.of(context)!.darkmodeLightDes,
                        value: state.isDark,
                        onChanged: (val) =>
                            context.read<SettingCubit>().toggleDarkMode(val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCardContainer(
                  isDark,
                  child: Column(
                    children: [
                      _buildSwitchItem(
                        context,
                        isDark,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                        ),
                      ),
                      _buildItem(
                        context,
                        isDark,
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
                _buildCardContainer(
                  isDark,
                  child: Column(
                    children: [
                      _buildItem(
                        context,
                        isDark,
                        icon: Icons.info,
                        iconColor: Colors.orange,
                        label: AppLocalizations.of(context)!.about,
                        subLabel: AppLocalizations.of(context)!.aboutDes,
                        onTap: () => showAboutDialog(context: context),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          height: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey[200],
                        ),
                      ),
                      _buildItem(
                        context,
                        isDark,
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
                _buildLogoutButton(context, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContainer(bool isDark, {required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildItem(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subLabel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 3,
                  ),
                  if (subLabel.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      subLabel,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isDark ? Colors.grey[500] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subLabel,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      subLabel,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF4364F7),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.logOut,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.redAccent,
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
