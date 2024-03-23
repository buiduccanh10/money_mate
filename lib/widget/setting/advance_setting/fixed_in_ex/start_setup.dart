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
import 'package:money_mate/widget/setting/advance_setting/fixed_in_ex/setup_in_ex_regular.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class start_setup extends StatefulWidget {
  const start_setup({super.key});

  @override
  State<start_setup> createState() => _start_setupState();
}

class _start_setupState extends State<start_setup> {
  List<Map<String, dynamic>> cat_data = [];
  DateRangePickerController date_controller = DateRangePickerController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController money_controller = TextEditingController();
  bool des_validate = false;
  bool money_validate = false;
  bool is_loading = true;
  bool is_mounted = false;
  int? selectedIndex;
  String? cat_id;
  String? icon;
  String? name;
  bool? is_income;
  FToast toast = FToast();
  firestore_helper db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final localization = FlutterLocalization.instance;
  double scale = 1.0;
  int selected_option = 0;
  List<String> option = <String>[
    'never',
    'daily',
    'weekly',
    'monthly',
    'yearly',
  ];

  @override
  void initState() {
    fetch_categories();
    is_mounted = true;
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
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
    return Scaffold(
      appBar: AppBar(title: Text(LocaleData.set_up.getString(context))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: is_dark ? Colors.orange : Colors.amber),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SfDateRangePicker(
                  showNavigationArrow: true,
                  selectionColor: Colors.deepOrangeAccent,
                  selectionMode: DateRangePickerSelectionMode.single,
                  headerHeight: 60,
                  todayHighlightColor: Colors.red,
                  controller: date_controller,
                  headerStyle: const DateRangePickerHeaderStyle(
                      textAlign: TextAlign.center,
                      textStyle:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
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
                controller: description_controller,
                decoration: InputDecoration(
                    errorText: des_validate
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
                    labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                    floatingLabelStyle:
                        TextStyle(color: is_dark ? Colors.white : Colors.black),
                    prefixIcon: const Icon(Icons.description),
                    prefixIconColor: Colors.blue),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                keyboardType: localization.currentLocale.toString() == 'vi'
                    ? const TextInputType.numberWithOptions(decimal: false)
                    : const TextInputType.numberWithOptions(decimal: true),
                controller: money_controller,
                inputFormatters: localization.currentLocale.toString() == 'vi'
                    ? [
                        FilteringTextInputFormatter.digitsOnly,
                        currency_format(),
                      ]
                    : [],
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                    errorText: money_validate
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
                    labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                    floatingLabelStyle:
                        TextStyle(color: is_dark ? Colors.white : Colors.black),
                    prefixIcon: const Icon(Icons.attach_money),
                    prefixIconColor: Colors.green,
                    suffixStyle: const TextStyle(fontSize: 20),
                    suffixText: localization.currentLocale.toString() == 'vi'
                        ? 'đ'
                        : localization.currentLocale.toString() == 'zh'
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
                children: List.generate((cat_data.length), (index) {
                  bool is_selected = index == selectedIndex;
                  return is_loading
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
                            setState(() {
                              selectedIndex = index;
                              cat_id = cat_data[index]['cat_id'];
                              icon = cat_data[index]['icon'];
                              name = cat_data[index]['name'];
                              is_income = cat_data[index]['is_income'];
                            });
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
                                  cat_data[index]['icon'],
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 4),
                                Text(cat_data[index]['name'])
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
                      onPressed: () => _showDialog(
                        CupertinoPicker(
                          magnification: 1.22,
                          squeeze: 1.2,
                          useMagnifier: true,
                          itemExtent: 30,
                          scrollController: FixedExtentScrollController(
                            initialItem: selected_option,
                          ),
                          onSelectedItemChanged: (int selectedItem) {
                            setState(() {
                              selected_option = selectedItem;
                            });
                          },
                          children:
                              List<Widget>.generate(option.length, (int index) {
                            return Center(child: Text(option[index]));
                          }),
                        ),
                      ),
                      child: Text(
                        option[selected_option],
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
        scale: scale,
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
              if (description_controller.text.isEmpty ||
                  money_controller.text.isEmpty ||
                  (selectedIndex == null || cat_id == null)) {
                setState(() {
                  des_validate = description_controller.text.isEmpty;
                  money_validate = money_controller.text.isEmpty;
                });
                toast.showToast(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.orange,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.warning),
                        Text(LocaleData.cat_validator.getString(context)),
                      ],
                    ),
                  ),
                  gravity: ToastGravity.CENTER,
                  toastDuration: const Duration(seconds: 3),
                );
              } else {
                save(
                    date_controller.selectedDate,
                    description_controller.text,
                    money_controller.text,
                    cat_id!,
                    icon!,
                    name!,
                    is_income!,
                    option[selected_option]);
              }

              setState(() {
                scale = 1.1;
              });
              Future.delayed(const Duration(milliseconds: 200), () {
                setState(() {
                  scale = 1.0;
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
  }

  Future<void> fetch_categories() async {
    List<Map<String, dynamic>> temp = await db_helper.fetch_all_categories(uid);
    if (mounted) {
      setState(() {
        cat_data = temp;
        is_loading = false;
      });
    }
  }

  Future<void> save(
      DateTime? date,
      String description,
      String money,
      String cat_id,
      String icon,
      String name,
      bool is_income,
      String option) async {
    try {
      String format_date;
      String format_money = localization.currentLocale.toString() == 'vi'
          ? money.replaceAll('.', '')
          : money.replaceAll(',', '.');
      double money_final = double.parse(format_money);
      if (date_controller.selectedDate == null) {
        format_date =
            DateFormat('dd/MM/yyyy').format(date_controller.displayDate!);
        db_helper.scheduleInputTask(uid, format_date, description, money_final,
            cat_id, icon, name, is_income, option);
      } else {
        format_date =
            DateFormat('dd/MM/yyyy').format(date_controller.selectedDate!);
        db_helper.scheduleInputTask(uid, format_date, description, money_final,
            cat_id, icon, name, is_income, option);
      }

      if (setup_in_ex_regular.getState() != null) {
        setup_in_ex_regular.getState()!.fetch_data_shared_preferences();
      }

      description_controller.clear();
      money_controller.clear();
      setState(() {
        selectedIndex = null;
        this.cat_id = null;
      });

      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.green,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.check),
              Text(LocaleData.toast_add_success.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    } catch (err) {
      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(Icons.do_disturb),
              Text(LocaleData.toast_add_fail.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }
}
