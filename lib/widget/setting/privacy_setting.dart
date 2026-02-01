import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/bloc/setting/setting_state.dart';
import 'package:money_mate/widget/common/confirm_delete_dialog.dart';

class PrivacySetting extends StatelessWidget {
  const PrivacySetting({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF5F7FA),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          const Color(0xFF0F2027),
                          const Color(0xFF203A43),
                          const Color(0xFF2C5364),
                        ]
                      : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
                ),
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.privacy,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPrivacyItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.folder_delete,
                  label: AppLocalizations.of(context)!.deleteAllDataAcc,
                  subLabel: AppLocalizations.of(context)!.deleteAllDataAccDes,
                  onTap: () => _confirmDelete(
                    context,
                    AppLocalizations.of(context)!.deleteAllDataAcc,
                    AppLocalizations.of(context)!.deleteDataConfirm,
                    () => context.read<SettingCubit>().deleteAllData(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPrivacyItem(
                  context: context,
                  isDark: isDark,
                  icon: Icons.person_off,
                  label: AppLocalizations.of(context)!.deleteAcc,
                  subLabel: AppLocalizations.of(context)!.deleteAccDes,
                  onTap: () => _confirmDelete(
                    context,
                    AppLocalizations.of(context)!.deleteAcc,
                    AppLocalizations.of(context)!.deleteAccountConfirm,
                    () => context.read<SettingCubit>().deleteUser(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrivacyItem({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required String label,
    required String subLabel,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.red, size: 24),
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
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subLabel,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
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

  void _confirmDelete(
    BuildContext context,
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    ConfirmDeleteDialog.show(
      context,
      title: title,
      content: content,
      onConfirm: onConfirm,
    );
  }
}
