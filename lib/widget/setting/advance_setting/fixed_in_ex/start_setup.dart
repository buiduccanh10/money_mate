import 'dart:math';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/setting_view_model.dart';
import 'package:money_mate/widget/setting/advance_setting/fixed_in_ex/setup_in_ex_regular.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class start_setup extends StatefulWidget {
  const start_setup({super.key});

  @override
  State<start_setup> createState() => _start_setupState();
}

class _start_setupState extends State<start_setup> {
  @override
  void initState() {
    var setting_vm = Provider.of<setting_view_model>(context, listen: false);
    setting_vm.init(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<String> option = <String>[
    //   LocaleData.never_repeat.getString(context),
    //   LocaleData.daily.getString(context),
    //   LocaleData.weekly.getString(context),
    //   LocaleData.yearly.getString(context),
    // ];
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<setting_view_model>(
      builder: (BuildContext context, setting_vm, Widget? child) {
        return Scaffold(
          appBar: AppBar(title: Text(LocaleData.set_up.getString(context))),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: is_dark ? Colors.orange : Colors.amber),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SfDateRangePicker(
                      showNavigationArrow: true,
                      selectionColor: Colors.deepOrangeAccent,
                      selectionMode: DateRangePickerSelectionMode.single,
                      headerHeight: 60,
                      todayHighlightColor: Colors.red,
                      controller: setting_vm.date_controller,
                      headerStyle: const DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20)),
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                          firstDayOfWeek: 1,
                          viewHeaderStyle: DateRangePickerViewHeaderStyle(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    minLines: 1,
                    maxLines: 2,
                    keyboardType: TextInputType.text,
                    controller: setting_vm.description_controller,
                    decoration: InputDecoration(
                        errorText: setting_vm.des_validate
                            ? LocaleData.des_validator.getString(context)
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: is_dark ? Colors.orange : Colors.amber),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.amber),
                            borderRadius: BorderRadius.circular(10)),
                        label: Text(
                          LocaleData.input_description.getString(context),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.grey.withOpacity(1)),
                        floatingLabelStyle: TextStyle(
                            color: is_dark ? Colors.white : Colors.black),
                        prefixIcon: const Icon(Icons.description),
                        prefixIconColor: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: setting_vm.localization.currentLocale
                                .toString() ==
                            'vi'
                        ? const TextInputType.numberWithOptions(decimal: false)
                        : const TextInputType.numberWithOptions(decimal: true),
                    controller: setting_vm.money_controller,
                    inputFormatters:
                        setting_vm.localization.currentLocale.toString() == 'vi'
                            ? [
                                FilteringTextInputFormatter.digitsOnly,
                                currency_format(),
                              ]
                            : [],
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                        errorText: setting_vm.money_validate
                            ? LocaleData.money_validator.getString(context)
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: is_dark ? Colors.orange : Colors.amber),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.amber),
                            borderRadius: BorderRadius.circular(10)),
                        label: Text(
                          LocaleData.input_money.getString(context),
                        ),
                        labelStyle:
                            TextStyle(color: Colors.grey.withOpacity(1)),
                        floatingLabelStyle: TextStyle(
                            color: is_dark ? Colors.white : Colors.black),
                        prefixIcon: const Icon(Icons.attach_money),
                        prefixIconColor: Colors.green,
                        suffixStyle: const TextStyle(fontSize: 20),
                        suffixText:
                            setting_vm.localization.currentLocale.toString() ==
                                    'vi'
                                ? 'đ'
                                : setting_vm.localization.currentLocale
                                            .toString() ==
                                        'zh'
                                    ? '¥'
                                    : '\$'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14.0, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          LocaleData.select_category.getString(context),
                          style: const TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        List.generate((setting_vm.cat_data.length), (index) {
                      bool is_selected = index == setting_vm.selectedIndex;
                      return setting_vm.is_loading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 70,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors
                                        .primaries[Random()
                                            .nextInt(Colors.primaries.length)]
                                        .shade100
                                        .withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(8),
                              ),
                            )
                          : InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setting_vm.onChooseCat(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.5,
                                        color: is_selected
                                            ? Colors.orange
                                            : Colors.transparent),
                                    color: Colors
                                        .primaries[Random()
                                            .nextInt(Colors.primaries.length)]
                                        .shade100
                                        .withOpacity(0.35),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      setting_vm.cat_data[index]['icon'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(setting_vm.cat_data[index]['name'])
                                  ],
                                ),
                              ),
                            );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          LocaleData.repeat.getString(context),
                          style: const TextStyle(fontSize: 22),
                        ),
                        CupertinoButton(
                          padding: const EdgeInsets.all(8),
                          onPressed: () => setting_vm.showDialogRepeat(context),
                          child: Text(
                            setting_vm.option[setting_vm.selected_option],
                            style: const TextStyle(
                                fontSize: 24.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: AnimatedScale(
            scale: setting_vm.scale,
            duration: const Duration(milliseconds: 200),
            child: Container(
              width: 120,
              height: 60,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.lightGreen,
                    Colors.lightGreenAccent,
                  ],
                ),
              ),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                onPressed: () {
                  setting_vm.save(
                      setting_vm.date_controller.selectedDate,
                      setting_vm.description_controller.text,
                      setting_vm.money_controller.text,
                      setting_vm.cat_id,
                      setting_vm.icon,
                      setting_vm.name,
                      setting_vm.is_income,
                      setting_vm.option[setting_vm.selected_option],
                      context);

                  setState(() {
                    setting_vm.scale = 1.1;
                  });
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      setting_vm.scale = 1.0;
                    });
                  });
                },
                label: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      size: 35,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      LocaleData.set_up.getString(context),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
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
