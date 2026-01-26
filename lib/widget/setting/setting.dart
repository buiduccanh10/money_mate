import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/bloc/setting/setting_state.dart';
import 'package:money_mate/widget/setting/setting_content.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              const SettingContent(),
              Container(
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            const Color.fromARGB(255, 203, 122, 0),
                            const Color.fromARGB(255, 0, 112, 204)
                          ]
                        : [Colors.orange, Colors.blue],
                  ),
                ),
                child: SafeArea(
                  maintainBottomViewPadding: true,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: state.image == null
                                ? const AssetImage('assets/avt.png')
                                    as ImageProvider
                                : NetworkImage(state.image!),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              state.userName ?? 'User',
                              style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildModifyCard(context, isDark),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModifyCard(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        color: isDark ? Colors.grey[500] : Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.0),
                      child: Icon(Icons.edit_square,
                          size: 26, color: Colors.black),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleData.modify.getString(context),
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white : Colors.black,
                              fontSize: 16),
                        ),
                        Text(
                          LocaleData.modifyDes.getString(context),
                          style: TextStyle(
                              color: isDark ? Colors.grey[100] : Colors.grey),
                        )
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.navigate_next)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
