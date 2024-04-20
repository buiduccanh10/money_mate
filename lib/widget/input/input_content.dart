import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:money_mate/view_model/home_view_model.dart';
import 'package:money_mate/view_model/input_view_model.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class input_content extends StatefulWidget {
  bool is_income;

  input_content({super.key, required this.is_income});

  @override
  State<input_content> createState() => _input_contentState();
}

class _input_contentState extends State<input_content> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var input_vm = Provider.of<input_view_model>(context);
    input_vm.toast.init(context);
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<input_view_model>(
      builder: (BuildContext context, input_vm, Widget? child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 135),
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
                        controller: input_vm.date_controller,
                        headerStyle: const DateRangePickerHeaderStyle(
                            textAlign: TextAlign.center,
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20)),
                        monthViewSettings:
                            const DateRangePickerMonthViewSettings(
                                firstDayOfWeek: 1,
                                viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16))),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      minLines: 1,
                      maxLines: 2,
                      keyboardType: TextInputType.text,
                      controller: input_vm.description_controller,
                      decoration: InputDecoration(
                          errorText: input_vm.des_validate
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
                      keyboardType:
                          input_vm.localization.currentLocale.toString() == 'vi'
                              ? const TextInputType.numberWithOptions(
                                  decimal: false)
                              : const TextInputType.numberWithOptions(
                                  decimal: true),
                      controller: input_vm.money_controller,
                      inputFormatters:
                          input_vm.localization.currentLocale.toString() == 'vi'
                              ? [
                                  FilteringTextInputFormatter.digitsOnly,
                                  currency_format(),
                                ]
                              : [],
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                          errorText: input_vm.money_validate
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
                              input_vm.localization.currentLocale.toString() ==
                                      'vi'
                                  ? 'đ'
                                  : input_vm.localization.currentLocale
                                              .toString() ==
                                          'zh'
                                      ? '¥'
                                      : '\$'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.is_income
                          ? LocaleData.income_category.getString(context)
                          : LocaleData.expense_category.getString(context),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => category_manage(
                                      is_income: widget.is_income,
                                    )),
                          );
                        },
                        child: Text(
                          LocaleData.more.getString(context),
                        ))
                  ],
                ),
              ),
              input_vm.is_loading
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 16 / 10,
                        crossAxisCount: 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 85),
                      itemCount: 5,
                      shrinkWrap: true, // Adjusts the height based on content
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                          baseColor:
                              is_dark ? Colors.grey[700]! : Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 7.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            height: 50.0,
                          ),
                        );
                      },
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 85),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 16 / 10,
                        crossAxisCount: 4,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: widget.is_income
                          ? input_vm.income_categories.length
                          : input_vm.expense_categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        bool is_selected = index == input_vm.selectedIndex;
                        final cat_item = widget.is_income
                            ? input_vm.income_categories[index]
                            : input_vm.expense_categories[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() {
                              input_vm.selectedIndex = index;
                              input_vm.cat_id = cat_item['cat_id'];
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5,
                                  color: is_selected
                                      ? is_dark
                                          ? Colors.orange
                                          : Colors.amber
                                      : Colors.transparent),
                              color: Colors
                                  .primaries[
                                      Random().nextInt(Colors.primaries.length)]
                                  .shade100
                                  .withOpacity(0.35),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(cat_item['icon'],
                                    style: const TextStyle(fontSize: 20)),
                                Text(
                                  cat_item['name'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis,
                                      color: is_dark
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ]),
          ),
          floatingActionButton: AnimatedScale(
            scale: input_vm.scale,
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
                onPressed: () async {
                  await input_vm.addInput(
                      input_vm.date_controller.selectedDate,
                      input_vm.description_controller.text,
                      input_vm.money_controller.text,
                      input_vm.cat_id,
                      context);
                  setState(() {
                    input_vm.scale = 1.1;
                  });
                  Future.delayed(const Duration(milliseconds: 200), () {
                    setState(() {
                      input_vm.scale = 1.0;
                    });
                  });
                },
                label: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      LocaleData.input_save.getString(context),
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
