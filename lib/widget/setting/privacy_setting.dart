import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
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
            title: Text(LocaleData.privacy.getString(context)),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              _buildPrivacyItem(
                context: context,
                isDark: isDark,
                icon: Icons.folder_delete,
                label: LocaleData.deleteAllDataAcc.getString(context),
                subLabel: LocaleData.deleteAllDataAccDes.getString(context),
                onTap: () => _confirmDelete(
                  context,
                  LocaleData.deleteAllDataAcc.getString(context),
                  () => context.read<SettingCubit>().deleteAllData(),
                ),
              ),
              const SizedBox(height: 8),
              _buildPrivacyItem(
                context: context,
                isDark: isDark,
                icon: Icons.person_off,
                label: LocaleData.deleteAcc.getString(context),
                subLabel: LocaleData.deleteAccDes.getString(context),
                onTap: () => _confirmDelete(
                  context,
                  LocaleData.deleteAcc.getString(context),
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
              child: Text(LocaleData.cancel.getString(context))),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: Text(LocaleData.confirm.getString(context),
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
