import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/bloc/setting/setting_state.dart';

class PrivacySetting extends StatelessWidget {
  const PrivacySetting({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.privacy),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              _buildPrivacyItem(
                context: context,
                isDark: isDark,
                icon: Icons.folder_delete,
                label: AppLocalizations.of(context)!.deleteAllDataAcc,
                subLabel: AppLocalizations.of(context)!.deleteAllDataAccDes,
                onTap: () => _confirmDelete(
                  context,
                  AppLocalizations.of(context)!.deleteAllDataAcc,
                  () => context.read<SettingCubit>().deleteAllData(),
                ),
              ),
              const SizedBox(height: 8),
              _buildPrivacyItem(
                context: context,
                isDark: isDark,
                icon: Icons.person_off,
                label: AppLocalizations.of(context)!.deleteAcc,
                subLabel: AppLocalizations.of(context)!.deleteAccDes,
                onTap: () => _confirmDelete(
                  context,
                  AppLocalizations.of(context)!.deleteAcc,
                  () => context.read<SettingCubit>().deleteUser(),
                ),
              ),
            ]),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        color: isDark ? Colors.grey[700] : Colors.grey[200],
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 18),
                  child: Icon(icon, color: Colors.red, size: 26),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16)),
                      Text(subLabel,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.confirm,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
