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
            title: Text(LocaleData.languageAppbar.getString(context)),
          ),
          body: Column(
            children: [
              RadioGroup<String>(
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingCubit>().changeLanguage(value);
                  }
                },
                child: Text(LocaleData.opVi.getString(context)),
              ),
              RadioGroup<String>(
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingCubit>().changeLanguage(value);
                  }
                },
                child: Text(LocaleData.opEn.getString(context)),
              ),
              RadioGroup<String>(
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingCubit>().changeLanguage(value);
                  }
                },
                child: Text(LocaleData.opCn.getString(context)),
              ),
            ],
          ),
        );
      },
    );
  }
}
