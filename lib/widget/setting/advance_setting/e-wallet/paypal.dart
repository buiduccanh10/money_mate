import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/currency_format.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/setting/advance_setting/e-wallet/qrcode.dart';
import 'package:shimmer/shimmer.dart';

class paypal extends StatefulWidget {
  String account_holder;
  String content_billing;
  String money;
  paypal(
      {super.key,
      required this.account_holder,
      required this.content_billing,
      required this.money});

  @override
  State<paypal> createState() => _paypalState();
}

class _paypalState extends State<paypal> {
  TextEditingController description_controller = TextEditingController();
  TextEditingController money_controller = TextEditingController();
  TextEditingController account_holder_controller = TextEditingController();
  int? selectedIndex;
  String? cat_id;
  double scale = 1.0;
  final localization = FlutterLocalization.instance;
  firestore_helper db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool is_loading = true;
  bool is_mounted = false;
  List<Map<String, dynamic>> cat_data = [];
  FToast toast = FToast();

  @override
  void initState() {
    get_value_qr(widget.account_holder, widget.content_billing, widget.money);
    fetch_categories();
    is_mounted = true;
    super.initState();
  }

  Future<void> fetch_categories() async {
    List<Map<String, dynamic>> temp =
        await db_helper.fetch_categories(uid, false);
    if (mounted) {
      setState(() {
        cat_data = temp;
        is_loading = false;
      });
    }
  }

  void get_value_qr(String account_holder, String des, String money) {
    setState(() {
      account_holder_controller.text = account_holder;
      description_controller.text = des;
      money_controller.text = money;
    });
  }

  @override
  void dispose() {
    is_mounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    toast.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Paypal",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/paypal.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                ),
                TextField(
                  readOnly: true,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  controller: account_holder_controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: is_dark ? Colors.orange : Colors.amber),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10)),
                      label: Text(
                        LocaleData.paypal_account_holder.getString(context),
                      ),
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                      floatingLabelStyle: TextStyle(
                          color: is_dark ? Colors.white : Colors.black),
                      prefixIcon: const Icon(Icons.person),
                      prefixIconColor: Colors.brown),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  readOnly: true,
                  minLines: 1,
                  maxLines: 2,
                  keyboardType: TextInputType.text,
                  controller: description_controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: is_dark ? Colors.orange : Colors.amber),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.amber),
                          borderRadius: BorderRadius.circular(10)),
                      label: Text(
                        LocaleData.paypal_content_billing.getString(context),
                      ),
                      labelStyle: TextStyle(color: Colors.grey.withOpacity(1)),
                      floatingLabelStyle: TextStyle(
                          color: is_dark ? Colors.white : Colors.black),
                      prefixIcon: const Icon(Icons.description),
                      prefixIconColor: Colors.blue),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                    readOnly: true,
                    keyboardType: localization.currentLocale.toString() == 'vi'
                        ? const TextInputType.numberWithOptions(decimal: false)
                        : const TextInputType.numberWithOptions(decimal: true),
                    controller: money_controller,
                    inputFormatters:
                        localization.currentLocale.toString() == 'vi'
                            ? [
                                FilteringTextInputFormatter.digitsOnly,
                                currency_format(),
                              ]
                            : [],
                    decoration: InputDecoration(
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
                      floatingLabelStyle: TextStyle(
                          color: is_dark ? Colors.white : Colors.black),
                      prefixIcon: const Icon(Icons.attach_money),
                      prefixIconColor: Colors.green,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocaleData.option_category.getString(context),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0, bottom: 12),
                  child: Wrap(
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
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 130,
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
              paypal_checkout();

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
                  Icons.payment,
                  size: 35,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  LocaleData.check_out.getString(context),
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

  Future<void> paypal_checkout() async {
    if (cat_id != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckout(
          sandboxMode: true,
          clientId:
              "AfgGaYrVY1a8sz81Gxv0ZAcy1JhH9pmWxp90OQ_oB9IODqGiOZZ17qruwVpqhx8jF473KtlvV5JLW7Hg",
          secretKey:
              "EBH-aksQ9DIwhNaKS4RhoqJEa4JdGk3xcSpj9y89q0lXzcPz9hs6-CinZayi2R9MdWk7ZYkiHN4uK4Z9",
          returnURL: "success.snippetcoder.com",
          cancelURL: "cancel.snippetcoder.com",
          transactions: [
            {
              "amount": {
                "total": money_controller.text,
                "currency": "USD",
              },
              "description":
                  '${description_controller.text} to {$account_holder_controller.text}',
            }
          ],
          note: description_controller.text,
          onSuccess: (Map params) {
            on_pay_success(uid, description_controller.text,
                money_controller.text, cat_id!);
          },
          onError: (error) {
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
                    Text(LocaleData.paypal_fail.getString(context)),
                  ],
                ),
              ),
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 2),
            );
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onCancel: () {
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
                    Text(LocaleData.paypal_cancel.getString(context)),
                  ],
                ),
              ),
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 2),
            );
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ));
    } else {
      String? paypal_id = await db_helper.get_paypal_cat_id(uid);
      setState(() {
        cat_id = paypal_id;
      });
      paypal_checkout();
    }
  }

  Future<void> on_pay_success(
      String uid, String description, String money, String cat_id) async {
    try {
      double money_format = double.parse(money);
      String format_date = DateFormat('dd/MM/yyyy').format(DateTime.now());

      await db_helper.add_input(
          uid, format_date, description, money_format, cat_id);

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
              Text(LocaleData.paypal_success.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (err) {
      print(err);
    }
  }
}
