import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/widget/accounts/login.dart';

class privacy_setting extends StatefulWidget {
  const privacy_setting({super.key});

  @override
  State<privacy_setting> createState() => _privacy_settingState();
}

class _privacy_settingState extends State<privacy_setting> {
  final db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  FToast? toast;

  @override
  void initState() {
    toast = FToast();
    toast!.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  delete_all_data();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 18),
                        child: Icon(
                          Icons.folder_delete,
                          color: Colors.red,
                          size: 26,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete all data of account',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          Text(
                            'Your input, category,... data will be delete',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  delete_user();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 18),
                        child: Icon(
                          Icons.person_off,
                          color: Colors.red,
                          size: 26,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Delete account',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),
                          ),
                          Text(
                            'Your account will no longer exist',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void delete_all_data() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete all data?'),
            actions: [
              Container(
                width: 90,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () async {
                      try {
                        await db_helper
                            .delete_all_data(uid)
                            .then((value) => toast!.showToast(
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.green,
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.check),
                                        Text("Delete all success!"),
                                      ],
                                    ),
                                  ),
                                  gravity: ToastGravity.CENTER,
                                  toastDuration: const Duration(seconds: 2),
                                ))
                            .then((value) => Navigator.of(context).pop());
                      } catch (err) {
                        toast!.showToast(
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
                                Text("Delete all data fail!"),
                              ],
                            ),
                          ),
                          gravity: ToastGravity.CENTER,
                          toastDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: const Text(
                      'Comfirm',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 127, 127, 127)),
                    )),
              ),
              Container(
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              )
            ],
          );
        });
  }

  void delete_user() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete account?'),
            actions: [
              Container(
                width: 90,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () async {
                      try {
                        await db_helper.delete_user(uid).then((value) =>
                            FirebaseAuth.instance
                                .signOut()
                                .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const login()),
                                    )));
                      } catch (err) {
                        toast!.showToast(
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
                                Text(
                                    "Delete user fail! (Try login again and delete)"),
                              ],
                            ),
                          ),
                          gravity: ToastGravity.CENTER,
                          toastDuration: const Duration(seconds: 2),
                        );
                      }
                    },
                    child: const Text(
                      'Comfirm',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 127, 127, 127)),
                    )),
              ),
              Container(
                width: 90,
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )),
              )
            ],
          );
        });
  }
}
