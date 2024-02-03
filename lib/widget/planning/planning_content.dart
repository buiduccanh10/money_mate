import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:money_mate/category_manage.dart';
import 'package:money_mate/model/income_cat.dart';
import 'package:money_mate/model/outcome_cat.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class planning_content extends StatefulWidget {
  bool is_income;
  planning_content({super.key, required this.is_income});

  @override
  State<planning_content> createState() => _planning_contentState();
}

class _planning_contentState extends State<planning_content> {
  List<Map<String, dynamic>> outcome_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  DateRangePickerController date_controller = DateRangePickerController();
  int? selectedIndex;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    try {
      List<Map<String, dynamic>> income_temp = [];
      List<Map<String, dynamic>> outcome_temp = [];

      QuerySnapshot<Map<String, dynamic>> income_snapshot =
          await FirebaseFirestore.instance
              .collection("category")
              .where('is_income', isEqualTo: true)
              .get();

      for (var doc in income_snapshot.docs) {
        income_temp.add(doc.data());
      }

      setState(() {
        income_categories = income_temp;
      });

      QuerySnapshot<Map<String, dynamic>> outcome_snapshot =
          await FirebaseFirestore.instance
              .collection("category")
              .where('is_income', isEqualTo: false)
              .get();

      for (var doc in outcome_snapshot.docs) {
        outcome_temp.add(doc.data());
      }
      setState(() {
        outcome_categories = outcome_temp;
      });
    } catch (error) {
      print("Failed to fetch data: $error");
    }
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
                    selectionColor: Colors.transparent,
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
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      print(date_controller.displayDate);
                    },
                    cellBuilder: (BuildContext context,
                        DateRangePickerCellDetails cellDetails) {
                      DateTime date = cellDetails.date;
                      bool is_selected = date_controller.selectedDate != null &&
                          date.isAtSameMomentAs(date_controller.selectedDate!);

                      bool is_today = date.year == DateTime.now().year &&
                          date.month == DateTime.now().month &&
                          date.day == DateTime.now().day;

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: is_today ? Colors.red : Colors.transparent,
                          ),
                          shape: BoxShape.circle,
                          gradient: is_selected
                              ? const LinearGradient(
                                  colors: [Colors.blue, Colors.orange],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: is_selected ? Colors.white : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
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
                  widget.is_income ? 'Income category' : 'Outcome category',
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
                  : outcome_categories.length,
              itemBuilder: (BuildContext context, int index) {
                bool isSelected = index == selectedIndex;
                final cat_item = widget.is_income
                    ? income_categories[index]
                    : outcome_categories[index] as Map<String, dynamic>;
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: isSelected
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
                              color: isSelected ? Colors.white : Colors.black),
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
    );
  }
}
