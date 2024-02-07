import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/widget/category/category_manage.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class input_content extends StatefulWidget {
  bool is_income;
  input_content({super.key, required this.is_income});

  @override
  State<input_content> createState() => _input_contentState();
}

class _input_contentState extends State<input_content> {
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  DateRangePickerController date_controller = DateRangePickerController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController money_controller = TextEditingController();
  String? cat_id;
  firestore_helper db_helper = firestore_helper();
  int? selectedIndex;
  double scale = 1.0;
  bool des_validate = false;
  bool money_validate = false;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> income_temp =
        await db_helper.fetch_categories(true);

    List<Map<String, dynamic>> outcome_temp =
        await db_helper.fetch_categories(false);

    setState(() {
      income_categories = income_temp;
    });

    setState(() {
      expense_categories = outcome_temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 135),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber),
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
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20)),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                        firstDayOfWeek: 1,
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                            textStyle: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16))),

                    // cellBuilder: (BuildContext context,
                    //     DateRangePickerCellDetails cellDetails) {
                    //   DateTime date = cellDetails.date;

                    //   bool is_selected = date_controller.selectedDate != null &&
                    //       date.isAtSameMomentAs(date_controller.selectedDate!);

                    //   bool is_today = date.year == DateTime.now().year &&
                    //       date.month == DateTime.now().month &&
                    //       date.day == DateTime.now().day;

                    //   return Container(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(
                    //         color: is_today ? Colors.red : Colors.transparent,
                    //       ),
                    //       shape: BoxShape.circle,
                    //       gradient: is_selected
                    //           ? const LinearGradient(
                    //               colors: [Colors.blue, Colors.orange],
                    //               begin: Alignment.topLeft,
                    //               end: Alignment.bottomRight,
                    //             )
                    //           : null,
                    //     ),
                    //     child: Center(
                    //       child: Text(
                    //         date.day.toString(),
                    //         style: TextStyle(
                    //           color: is_selected ? Colors.white : null,
                    //         ),
                    //       ),
                    //     ),
                    //   );
                    // },
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
                      errorText:
                          des_validate ? 'Description can not be blank' : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10)),
                      label: const Text(
                        'Description',
                      ),
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.description),
                      prefixIconColor: Colors.blue),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  controller: money_controller,
                  decoration: InputDecoration(
                      errorText:
                          money_validate ? 'Money can not be blank' : null,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10)),
                      label: const Text('Money'),
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      prefixIcon: const Icon(Icons.attach_money),
                      prefixIconColor: Colors.green,
                      suffixText: 'VND'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.is_income ? 'Income category' : 'Expense category',
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
                                cat_reload_callback: () {
                                  fetchData();
                                })),
                      );
                    },
                    child: const Text('More...'))
              ],
            ),
          ),
          SizedBox(
            height: 320,
            child: GridView.builder(
              padding: const EdgeInsets.only(left: 15, right: 15, bottom: 85),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 16 / 10,
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: widget.is_income
                  ? income_categories.length
                  : expense_categories.length,
              itemBuilder: (BuildContext context, int index) {
                bool is_selected = index == selectedIndex;
                final cat_item = widget.is_income
                    ? income_categories[index]
                    : expense_categories[index] as Map<String, dynamic>;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      cat_id = cat_item['cat_id'];
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: is_selected
                              ? [Colors.blue, Colors.orange]
                              : [Colors.white, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
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
                              color: is_selected ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ]),
      ),
      floatingActionButton: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        child: SizedBox(
          width: 110,
          height: 60,
          child: FloatingActionButton.extended(
            backgroundColor: const Color.fromARGB(255, 63, 148, 66),
            onPressed: () {
              if (description_controller.text.isEmpty ||
                  money_controller.text.isEmpty) {
                setState(() {
                  des_validate = description_controller.text.isEmpty;
                  money_validate = money_controller.text.isEmpty;
                });
              } else {
                add_input(
                    date_controller.selectedDate,
                    description_controller.text,
                    money_controller.text,
                    cat_id!);
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
            label: const Row(
              children: [
                Icon(
                  Icons.add,
                  size: 35,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Save',
                  style: TextStyle(
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

  Future<void> add_input(
      DateTime? date, String description, String money, String cat_id) async {
    try {
      String format_date;
      if (date_controller.selectedDate == null) {
        format_date =
            DateFormat('dd/MM/yyyy').format(date_controller.displayDate!);
        await db_helper.add_input(format_date, description, money, cat_id);
      } else {
        format_date =
            DateFormat('dd/MM/yyyy').format(date_controller.selectedDate!);
        await db_helper.add_input(format_date, description, money, cat_id);
      }

      description_controller.clear();
      money_controller.clear();

      Fluttertoast.showToast(
          msg: 'Input successful!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (err) {
      Fluttertoast.showToast(
          msg: 'Fail to input',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
