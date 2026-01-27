import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/l10n/app_localizations.dart';
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
            title: Text(AppLocalizations.of(context)!.languageAppbar),
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
                child: Text(AppLocalizations.of(context)!.opVi),
              ),
              RadioGroup<String>(
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingCubit>().changeLanguage(value);
                  }
                },
                child: Text(AppLocalizations.of(context)!.opEn),
              ),
              RadioGroup<String>(
                groupValue: state.language,
                onChanged: (value) {
                  if (value != null) {
                    context.read<SettingCubit>().changeLanguage(value);
                  }
                },
                child: Text(AppLocalizations.of(context)!.opCn),
              ),
            ],
          ),
        );
      },
    );
  }
}
