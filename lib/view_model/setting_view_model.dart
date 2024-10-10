import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
// import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/setting/advance_setting/e-wallet/paypal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class setting_view_model with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  String? user_name;
  String? image;
  bool is_dark = false;
  bool is_lock = false;
  late String current_locale;
  final db_helper = firestore_helper();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final localization = FlutterLocalization.instance;
  final LocalAuthentication local_auth = LocalAuthentication();
  FToast toast = FToast();
  List<Map<String, dynamic>> data = [];
  bool is_loading = true;
  List<Map<String, dynamic>> cat_data = [];
  DateRangePickerController date_controller = DateRangePickerController();
  TextEditingController description_controller = TextEditingController();
  TextEditingController money_controller = TextEditingController();
  TextEditingController account_holder_controller = TextEditingController();
  bool des_validate = false;
  bool money_validate = false;
  int? selectedIndex;
  String? cat_id;
  String? icon;
  String? name;
  bool? is_income;
  double scale = 1.0;
  int selected_option = 0;
  List<String> option = <String>[
    'never',
    'daily',
    'weekly',
    'monthly',
    'yearly',
  ];

  void init(context) {
    user_name = auth.currentUser!.email;
    image = auth.currentUser!.photoURL;
    get_language();
    get_dark_mode(context);
    get_is_lock();
    current_locale = localization.currentLocale!.languageCode;
    fetch_data_shared_preferences();
    fetch_categories();
  }

  //setting content
  void onChangedTheme(value, context) {
    is_dark = value;
    update_dark_mode(uid, is_dark);
    update_theme(context);
    notifyListeners();
  }

  Future<void> onChangedLock(value, context) async {
    if (await local_auth.isDeviceSupported()) {
      is_lock = value;
      update_is_lock(uid, is_lock);
      if (Main.getState() != null) {
        Main.getState()!.get_is_lock();
      }
      notifyListeners();
    } else {
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
              Flexible(
                child: Text(
                  LocaleData.local_auth_warning.getString(context),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> get_is_lock() async {
    bool temp = (await db_helper.get_is_lock(uid))!;

    is_lock = temp;
    notifyListeners();
  }

  Future<void> get_dark_mode(context) async {
    bool temp = (await db_helper.get_dark_mode(uid))!;

    is_dark = temp;
    update_theme(context);
    notifyListeners();
  }

  Future<void> update_dark_mode(String uid, bool is_dark) async {
    await db_helper.update_dark_mode(uid, is_dark);
  }

  Future<void> update_is_lock(String uid, bool is_lock) async {
    await db_helper.update_is_lock(uid, is_lock);
  }

  void update_theme(context) {
    if (is_dark) {
      MyApp.setAppTheme(context, ThemeData.dark());
    } else {
      MyApp.setAppTheme(context, ThemeData.light());
    }
  }

  void show_curpetino_action(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          LocaleData.log_out_dialog.getString(context),
          style: const TextStyle(fontSize: 16),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      ));
            },
            child: Text(LocaleData.log_out.getString(context)),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(LocaleData.cancel.getString(context)),
          ),
        ],
      ),
    );
  }

  //language setting
  Future<void> get_language() async {
    String temp = (await db_helper.get_language(uid))!;

    current_locale = temp;
    set_locale(current_locale);
    notifyListeners();
  }

  void set_locale(String value) {
    if (value == 'vi') {
      localization.translate('vi');
    } else if (value == 'en') {
      localization.translate('en');
    } else if (value == 'zh') {
      localization.translate('zh');
    } else {
      return;
    }

    current_locale = value;
    update_language(uid, current_locale);
    notifyListeners();
  }

  Future<void> update_language(String uid, String language) async {
    await db_helper.update_language(uid, language);
  }

  //privacy setting
  void delete_all_data(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title:
                Text('${LocaleData.delete_all_data_acc.getString(context)} ?'),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocaleData.cancel.getString(context),
                  )),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    try {
                      await db_helper
                          .delete_all_data(uid)
                          .then((value) => toast.showToast(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.green,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Icon(Icons.check),
                                      Text(LocaleData.toast_delete_success
                                          .getString(context)),
                                    ],
                                  ),
                                ),
                                gravity: ToastGravity.CENTER,
                                toastDuration: const Duration(seconds: 2),
                              ))
                          .then((value) => Navigator.of(context).pop());
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
                              Text(LocaleData.toast_delete_fail
                                  .getString(context)),
                            ],
                          ),
                        ),
                        gravity: ToastGravity.CENTER,
                        toastDuration: const Duration(seconds: 2),
                      );
                    }
                  },
                  child: Text(
                    LocaleData.confirm.getString(context),
                  )),
            ],
          );
        });
  }

  void delete_user(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('${LocaleData.delete_acc.getString(context)} ?'),
            actions: [
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocaleData.cancel.getString(context),
                  )),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () async {
                    try {
                      await db_helper.delete_user(uid).then((value) =>
                          FirebaseAuth.instance
                              .signOut()
                              .then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const MyApp()),
                                  )));
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
                              const Icon(Icons.person_off_outlined),
                              Text(LocaleData.toast_delete_user_fail
                                  .getString(context)),
                            ],
                          ),
                        ),
                        gravity: ToastGravity.CENTER,
                        toastDuration: const Duration(seconds: 4),
                      );
                    }
                  },
                  child: Text(
                    LocaleData.confirm.getString(context),
                  )),
            ],
          );
        });
  }

  //fixed in ex

  Future<void> fetch_data_shared_preferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      var value = prefs.get(key);
      if (value is! List || (value).isEmpty) {
        await prefs.remove(key);
      }
    }

    keys = prefs.getKeys();
    data.clear();

    if (keys.isNotEmpty) {
      for (String key in keys) {
        List<String>? inputData = prefs.getStringList(key);

        String uid = inputData![0];
        String date = inputData[1];
        String description = inputData[2];
        double money = double.parse(inputData[3]);
        String cat_id = inputData[4];
        String icon = inputData[5];
        String name = inputData[6];
        bool is_income = bool.parse(inputData[7]);
        String option = inputData[8];

        Map<String, dynamic> content = {
          'id': key,
          'uid': uid,
          'date': date,
          'description': description,
          'money': money,
          'cat_id': cat_id,
          'icon': icon,
          'name': name,
          'is_income': is_income,
          'option': option
        };

        data.add(content);
        is_loading = false;
      }
    }
    notifyListeners();
  }

  Future<void> remove_schedule_input_task(int idNotification) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    for (String key in keys) {
      if (int.parse(key) == idNotification) {
        AwesomeNotifications().cancel(int.parse(key));

        await prefs.remove(key);
      }
    }
  }

  Future<void> remove_all_schedule() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    AwesomeNotifications().cancelAllSchedules();
    AwesomeNotifications().cancelAll();
    await prefs.clear();
  }

  void handle_delete(int input_id, int index, context) async {
    try {
      remove_schedule_input_task(input_id);

      data.removeAt(index);
      notifyListeners();

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
              Text(LocaleData.toast_delete_success.getString(context)),
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
              Text(LocaleData.toast_delete_fail.getString(context)),
            ],
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 2),
      );
    }
  }

  void delete_all_schedule(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(LocaleData.delete_all_schedule.getString(context)),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  LocaleData.cancel.getString(context),
                ),
              ),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    data.clear();

                    remove_all_schedule();
                    notifyListeners();

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
                            Text(LocaleData.toast_delete_success
                                .getString(context)),
                          ],
                        ),
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: const Duration(seconds: 2),
                    );
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    LocaleData.confirm.getString(context),
                  )),
            ],
          );
        });
  }

  // add fixed inex
  Future<void> fetch_categories() async {
    List<Map<String, dynamic>> temp = await db_helper.fetch_all_categories(uid);

    cat_data = temp;
    is_loading = false;
    notifyListeners();
  }

  void showDialogRepeat(context) {
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
          child: CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.2,
            useMagnifier: true,
            itemExtent: 30,
            scrollController: FixedExtentScrollController(
              initialItem: selected_option,
            ),
            onSelectedItemChanged: (int selectedItem) {
              selected_option = selectedItem;
              notifyListeners();
            },
            children: List<Widget>.generate(option.length, (int index) {
              return Center(child: Text(option[index]));
            }),
          ),
        ),
      ),
    );
  }

  void onChooseCat(int index) {
    selectedIndex = index;
    cat_id = cat_data[index]['cat_id'];
    icon = cat_data[index]['icon'];
    name = cat_data[index]['name'];
    is_income = cat_data[index]['is_income'];
    notifyListeners();
  }

  Future<void> save(
      DateTime? date,
      String description,
      String money,
      String? cat_id,
      String? icon,
      String? name,
      bool? is_income,
      String option,
      context) async {
    if (description_controller.text.isEmpty ||
        money_controller.text.isEmpty ||
        (selectedIndex == null || cat_id == null)) {
      des_validate = description_controller.text.isEmpty;
      money_validate = money_controller.text.isEmpty;
      notifyListeners();
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
      try {
        String format_date;
        String format_money = localization.currentLocale.toString() == 'vi'
            ? money.replaceAll('.', '')
            : money.replaceAll(',', '.');
        double money_final = double.parse(format_money);
        if (date_controller.selectedDate == null) {
          format_date =
              DateFormat('dd/MM/yyyy').format(date_controller.displayDate!);
          db_helper.scheduleInputTask(uid, format_date, description,
              money_final, cat_id, icon!, name!, is_income!, option);
        } else {
          format_date =
              DateFormat('dd/MM/yyyy').format(date_controller.selectedDate!);
          db_helper.scheduleInputTask(uid, format_date, description,
              money_final, cat_id, icon!, name!, is_income!, option);
        }

        fetch_data_shared_preferences();

        description_controller.clear();
        money_controller.clear();

        selectedIndex = null;
        this.cat_id = null;
        notifyListeners();

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

  //pay
  // void onDetect(capture, context) {
  //   final List<Barcode> barcodes = capture.barcodes;
  //   //final Uint8List? image = capture.image;
  //   for (final barcode in barcodes) {
  //     debugPrint('Barcode found! ${barcode.rawValue}');

  //     Navigator.pop(context);
  //     Uri uri = Uri.parse(barcode.rawValue!);

  //     String? business = uri.queryParameters['business'];
  //     String? amount = uri.queryParameters['amount'];
  //     String? itemName = uri.queryParameters['item_name'];

  //     if (amount != null && itemName != null && business != null) {
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => paypal(
  //                   account_holder: business,
  //                   content_billing: itemName,
  //                   money: amount)));
  //     }
  //   }
  // }

  // Future<void> paypal_checkout(context) async {
  //   if (cat_id != null) {
  //     Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) => PaypalCheckout(
  //         sandboxMode: true,
  //         clientId:
  //             "AfgGaYrVY1a8sz81Gxv0ZAcy1JhH9pmWxp90OQ_oB9IODqGiOZZ17qruwVpqhx8jF473KtlvV5JLW7Hg",
  //         secretKey:
  //             "EBH-aksQ9DIwhNaKS4RhoqJEa4JdGk3xcSpj9y89q0lXzcPz9hs6-CinZayi2R9MdWk7ZYkiHN4uK4Z9",
  //         returnURL: "success.snippetcoder.com",
  //         cancelURL: "cancel.snippetcoder.com",
  //         transactions: [
  //           {
  //             "amount": {
  //               "total": money_controller.text,
  //               "currency": "USD",
  //             },
  //             "description":
  //                 '${description_controller.text} to {$account_holder_controller.text}',
  //           }
  //         ],
  //         note: description_controller.text,
  //         onSuccess: (Map params) {
  //           on_pay_success(uid, description_controller.text,
  //               money_controller.text, cat_id!, context);
  //         },
  //         onError: (error) {
  //           toast.showToast(
  //             child: Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 color: Colors.red,
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   const Icon(Icons.do_disturb),
  //                   Text(LocaleData.paypal_fail.getString(context)),
  //                 ],
  //               ),
  //             ),
  //             gravity: ToastGravity.CENTER,
  //             toastDuration: const Duration(seconds: 2),
  //           );
  //           Navigator.pop(context);
  //           Navigator.pop(context);
  //         },
  //         onCancel: () {
  //           toast.showToast(
  //             child: Container(
  //               padding: const EdgeInsets.all(8),
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 color: Colors.orange,
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   const Icon(Icons.warning),
  //                   Text(LocaleData.paypal_cancel.getString(context)),
  //                 ],
  //               ),
  //             ),
  //             gravity: ToastGravity.CENTER,
  //             toastDuration: const Duration(seconds: 2),
  //           );
  //           Navigator.pop(context);
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ));
  //   } else {
  //     String? paypal_id = await db_helper.get_paypal_cat_id(uid);

  //     cat_id = paypal_id;

  //     paypal_checkout(context);

  //     notifyListeners();
  //   }
  // }

  Future<void> on_pay_success(String uid, String description, String money,
      String cat_id, context) async {
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

  void get_value_qr(String account_holder, String des, String money) {
    account_holder_controller.text = account_holder;
    description_controller.text = des;
    money_controller.text = money;
  }

  void onChooseCatPay(int index) {
    selectedIndex = index;
    cat_id = cat_data[index]['cat_id'];
    notifyListeners();
  }
}
