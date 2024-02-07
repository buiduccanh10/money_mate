import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/firestore_helper.dart';

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
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  firestore_helper db_helper = firestore_helper();
  bool is_loading = true;
  bool is_mounted = false;

  @override
  void initState() {
    is_mounted = true;
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> temp =
        await db_helper.fetch_categories(widget.is_income);

    if (is_mounted) {
      setState(() {
        if (widget.is_income) {
          income_categories = temp;
          is_loading = false;
        } else {
          expense_categories = temp;
          is_loading = false;
        }
      });
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              // const SizedBox(
              //   width: 30,
              // ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  'Swipe left to take action',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              IconButton(
                  padding: const EdgeInsets.all(15),
                  onPressed: () {},
                  icon: const Icon(Icons.delete_sweep, color: Colors.red, size: 28))
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: is_loading
                  ? const Center(
                      child: SizedBox(
                          height: 100.0,
                          width: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircularProgressIndicator(),
                              Text('Loading...')
                            ],
                          )),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: widget.is_income
                          ? income_categories.length
                          : expense_categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        final cat_item = widget.is_income
                            ? income_categories[index]
                            : expense_categories[index] as Map<String, dynamic>;

                        return Slidable(
                          closeOnScroll: true,
                          endActionPane:
                              ActionPane(motion: const ScrollMotion(), children: [
                            SlidableAction(
                              onPressed: (context) {
                                edit_cat(context, index);
                              },
                              foregroundColor: Colors.blue,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                delete_cat(context, index);
                              },
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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

  void edit_cat(BuildContext context, int index) {}

  void delete_cat(BuildContext context, int index) async {
    try {
      if (widget.is_income) {
        await FirebaseFirestore.instance
            .collection("category")
            .doc(income_categories[index]['cat_id'])
            .delete();
        setState(() {
          income_categories.removeAt(index);
        });
        Fluttertoast.showToast(
            msg: 'Delete category successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        await FirebaseFirestore.instance
            .collection("category")
            .doc(expense_categories[index]['cat_id'])
            .delete();
        setState(() {
          expense_categories.removeAt(index);
        });
        Fluttertoast.showToast(
            msg: 'Delete category successful!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      Fluttertoast.showToast(
          msg: 'Fail at delete category',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
