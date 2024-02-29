import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/widget/chart/chart.dart';
import 'package:money_mate/widget/chart/chart_item_detail.dart';
import 'package:money_mate/widget/chart/chart_widget.dart';
import 'package:money_mate/widget/home/home.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/currency.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/widget/category/category_manage.dart';
import 'package:money_mate/widget/home/home_appbar.dart';
import 'package:money_mate/widget/home/home_list_item.dart';
import 'package:money_mate/widget/search/search.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class update_input extends StatefulWidget {
  final input_item;
  update_input({super.key, required this.input_item});

  @override
  State<update_input> createState() => _update_inputState();
}

class _update_inputState extends State<update_input> {
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
  bool is_loading = true;
  bool is_mounted = false;
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    //date_controller.selectedDate = widget.input_item['date'];
    description_controller.text = widget.input_item['description'];
    final money_update = NumberFormat("###,###,###", "vi_VN");
    money_controller.text = money_update.format(widget.input_item['money']);
    cat_id = widget.input_item['cat_id'];

    is_mounted = true;
    toast.init(context);
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> income_temp =
        await db_helper.fetch_categories(uid, true);

    List<Map<String, dynamic>> expense_temp =
        await db_helper.fetch_categories(uid, false);

    if (is_mounted) {
      setState(() {
        income_categories = income_temp;
        expense_categories = expense_temp;
        is_loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 115),
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
                            ? 'Description can not be blank'
                            : null,
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
                        labelStyle:
                            TextStyle(color: Colors.grey.withOpacity(1)),
                        floatingLabelStyle:
                            const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.description),
                        prefixIconColor: Colors.blue),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    controller: money_controller,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      Currency()
                    ],
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
                        labelStyle:
                            TextStyle(color: Colors.grey.withOpacity(1)),
                        floatingLabelStyle:
                            const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.attach_money),
                        prefixIconColor: Colors.green,
                        suffixText: 'VND'),
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
                    widget.input_item['is_income']
                        ? 'Income category'
                        : 'Expense category',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => category_manage(
                                    is_income: widget.input_item['is_income'],
                                  )),
                        );
                      },
                      child: const Text('More...'))
                ],
              ),
            ),
            is_loading
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 16 / 10,
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 85),
                    itemCount: 5,
                    shrinkWrap: true, // Adjusts the height based on content
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
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
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 85),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 16 / 10,
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: widget.input_item['is_income']
                        ? income_categories.length
                        : expense_categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool is_selected = index == selectedIndex;
                      final cat_item = widget.input_item['is_income']
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
                                    color: is_selected
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
        Container(
          height: 100,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange, Colors.blue],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  BackButton(onPressed: () {
                    Navigator.pop(context);
                  }),
                  Text(
                    widget.input_item['is_income'] ? 'Income' : 'Expense',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      '(${widget.input_item['description']})',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
      floatingActionButton: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 140,
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
                  money_controller.text.isEmpty) {
                setState(() {
                  des_validate = description_controller.text.isEmpty;
                  money_validate = money_controller.text.isEmpty;
                });
              } else {
                update_input(
                    widget.input_item['id'],
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
                  Icons.edit_calendar,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Update',
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

  Future<void> update_input(String id, DateTime? date, String description,
      String money, String cat_id) async {
    try {
      String format_date;
      String format_money = money.replaceAll('.', '');
      double money_final = double.parse(format_money);
      if (date_controller.selectedDate == null) {
        format_date = widget.input_item['date'];
        await db_helper
            .update_input(
                uid, id, format_date, description, money_final, cat_id)
            .then((value) => Navigator.pop(context));
      } else {
        format_date =
            DateFormat('dd/MM/yyyy').format(date_controller.selectedDate!);
        await db_helper
            .update_input(
                uid, id, format_date, description, money_final, cat_id)
            .then((value) => Navigator.pop(context));
      }

      if (home_appbar.getState() != null && home_list_item.getState() != null) {
        home_appbar.getState()!.fetchData();
        home_list_item.getState()!.fetch_data_list();
      } else if (chart_widget.getState() != null &&
          chart_item_detail.getState() != null) {
        chart_widget.getState()!.is_month();
        chart_item_detail.getState()!.fetchData();
      } else {
        final test = await db_helper.fetch_categories(
            uid, widget.input_item['is_income']);

        Map<String, dynamic> item = {
          "id": widget.input_item['id'],
          "date": format_date,
          "description": description,
          "money": money_final,
        };

        if (test.isNotEmpty) {
          final test_item =
              test.firstWhere((category) => category['cat_id'] == cat_id);
          item['cat_id'] = test_item['cat_id'];
          item['icon'] = test_item['icon'];
          item['name'] = test_item['name'];
          item['is_income'] = test_item['is_income'];
        }

        search.getState()!.updated_item(item);
      }

      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.green,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.check),
              Text("Update success!"),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    } catch (err) {
      print(err);
      toast.showToast(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.red,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.do_disturb),
              Text("Update fail!"),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }
}
