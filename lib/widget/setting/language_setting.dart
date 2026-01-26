import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/bloc/setting/setting_state.dart';

class LanguageSetting extends StatelessWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(LocaleData.language_appbar.getString(context)),
          ),
          body: Column(
            children: [
              RadioListTile<String>(
                title: Text(LocaleData.op_vi.getString(context)),
                value: "vi",
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null)
                    context.read<SettingCubit>().changeLanguage(value);
                },
              ),
              RadioListTile<String>(
                title: Text(LocaleData.op_en.getString(context)),
                value: "en",
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null)
                    context.read<SettingCubit>().changeLanguage(value);
                },
              ),
              RadioListTile<String>(
                title: Text(LocaleData.op_cn.getString(context)),
                value: "zh",
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null)
                    context.read<SettingCubit>().changeLanguage(value);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
