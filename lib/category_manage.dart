import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_mate/model/income_cat.dart';
import 'package:money_mate/model/outcome_cat.dart';
import 'package:money_mate/widget/category/cat_add_dialog.dart';
import 'package:money_mate/widget/category/cat_edit.dart';

typedef void cat_callback();

class category_manage extends StatefulWidget {
  bool is_income;
  final cat_callback cat_reload_callback;
  category_manage(
      {super.key, required this.is_income, required this.cat_reload_callback});

  @override
  State<category_manage> createState() => _category_manageState();
}

class _category_manageState extends State<category_manage> {
  List<Map<String, dynamic>> outcome_categories = [];
  List<Map<String, dynamic>> income_categories = [];

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

      income_snapshot.docs.forEach((doc) {
        income_temp.add(doc.data());
      });

      setState(() {
        income_categories = income_temp;
      });

      QuerySnapshot<Map<String, dynamic>> outcome_snapshot =
          await FirebaseFirestore.instance
              .collection("category")
              .where('is_income', isEqualTo: false)
              .get();

      outcome_snapshot.docs.forEach((doc) {
        outcome_temp.add(doc.data());
      });
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return cat_add_dialog(
                    is_income: widget.is_income,
                    cat_reload_callback: () {
                      fetchData();
                    },
                  );
                });
          },
          backgroundColor: const Color.fromARGB(255, 63, 148, 66),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          height: 110,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.orange],
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  padding: const EdgeInsets.all(15),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.cat_reload_callback();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              const SizedBox(
                width: 30,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Swipe right to take action',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: widget.is_income
                      ? income_categories.length
                      : outcome_categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    final cat_item = widget.is_income
                        ? income_categories[index]
                        : outcome_categories[index] as Map<String, dynamic>;

                    return Slidable(
                      closeOnScroll: true,
                      startActionPane:
                          const ActionPane(motion: BehindMotion(), children: [
                        SlidableAction(
                          onPressed: _handleEdit,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          icon: Icons.edit,
                          label: 'Edit',
                        ),
                        SlidableAction(
                          onPressed: _handleDelete,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ]),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    cat_edit(cat_id: (cat_item['cat_id']))),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black, width: 0))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      cat_item['icon'],
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      cat_item['name'],
                                      style: const TextStyle(fontSize: 18),
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
                  }),
            )),
      ]),
    );
  }
}

void _handleEdit(BuildContext context) {
  // Implement your edit logic here
}
void _handleDelete(BuildContext context) {
  // Implement your edit logic here
}
