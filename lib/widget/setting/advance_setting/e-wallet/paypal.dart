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
import 'package:money_mate/view_model/setting_view_model.dart';
import 'package:money_mate/widget/setting/advance_setting/e-wallet/qrcode.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    var setting_vm = Provider.of<setting_view_model>(context, listen: false);
    setting_vm.init(context);
    setting_vm.get_value_qr(
        widget.account_holder, widget.content_billing, widget.money);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool is_dark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<setting_view_model>(
      builder: (BuildContext context, setting_vm, Widget? child) {
        setting_vm.toast.init(context);
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
                      controller: setting_vm.account_holder_controller,
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
                          labelStyle:
                              TextStyle(color: Colors.grey.withOpacity(1)),
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
                      controller: setting_vm.description_controller,
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
                            LocaleData.paypal_content_billing
                                .getString(context),
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
                        readOnly: true,
                        keyboardType:
                            setting_vm.localization.currentLocale.toString() ==
                                    'vi'
                                ? const TextInputType.numberWithOptions(
                                    decimal: false)
                                : const TextInputType.numberWithOptions(
                                    decimal: true),
                        controller: setting_vm.money_controller,
                        inputFormatters:
                            setting_vm.localization.currentLocale.toString() ==
                                    'vi'
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
                          labelStyle:
                              TextStyle(color: Colors.grey.withOpacity(1)),
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
                        children: List.generate((setting_vm.cat_data.length),
                            (index) {
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
                                            .primaries[Random().nextInt(
                                                Colors.primaries.length)]
                                            .shade100
                                            .withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.all(8),
                                  ),
                                )
                              : InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    setting_vm.onChooseCatPay(index);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.5,
                                            color: is_selected
                                                ? Colors.orange
                                                : Colors.transparent),
                                        color: Colors
                                            .primaries[Random().nextInt(
                                                Colors.primaries.length)]
                                            .shade100
                                            .withOpacity(0.35),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: AnimatedScale(
            scale: setting_vm.scale,
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
                  setting_vm.paypal_checkout(context);

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
      },
    );
  }
}
