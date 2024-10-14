import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:intl/intl.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/widget/input/update_input.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class home_view_model with ChangeNotifier {
  var month = DateTime.now().month;
  var year = DateTime.now().year;
  String formattedDate = '';
  List<Map<String, dynamic>> expense_categories = [];
  List<Map<String, dynamic>> income_categories = [];
  List<Map<String, dynamic>> input_data = [];
  firestore_helper db_helper = firestore_helper();
  bool is_loading = true;
  double total_income = 0;
  double total_expense = 0;
  double total_saving = 0;
  String? user_name;
  FToast toast = FToast();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final localization = FlutterLocalization.instance;

  SpeechToText speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  home_view_model() {
    init();
  }

  void init() {
    formattedDate = get_month_year_string(month, year);
    fetch_data();
    fetch_user_name();
    fetch_data_list();
    // initSpeech();
  }

  // void initSpeech() async {
  //   speechEnabled = await speechToText.initialize();
  //   notifyListeners();
  // }

  // void startListening() async {
  //   await speechToText.listen(
  //       onResult: onSpeechResult,
  //       listenMode: ListenMode.confirmation,
  //       localeId: 'vi-VN',
  //       listenFor: Duration(seconds: 10));
  //   notifyListeners();
  // }

  // void stopListening() async {
  //   await speechToText.stop();
  //   notifyListeners();
  // }

  // void onSpeechResult(SpeechRecognitionResult result) {
  //   lastWords = result.recognizedWords;
  //   handleVoiceInput(lastWords);
  //   notifyListeners();
  // }

  // void handleVoiceInput(String input) {
  //   RegExp exp = RegExp(r'(.+?) mục (.+?) tiền (.+)');
  //   var match = exp.firstMatch(input);

  //   if (match != null) {
  //     String description = match.group(1) ?? ''; // Mô tả chi tiêu
  //     String category = match.group(2) ?? ''; // Danh mục chi tiêu
  //     String amountText = match.group(3) ?? ''; // Số tiền
  //     double amount =
  //         double.parse(amountText.replaceAll('.', '')); // Chuyển về double

  //     print('Description: $description'); // In ra mô tả
  //     print('Category: $category'); // In ra danh mục
  //     print('Amount text: $amount'); // In ra số tiền ở dạng văn bản
  //   }
  //   // else {
  //   //   toast.showToast(
  //   //     child: Container(
  //   //       padding: const EdgeInsets.all(8),
  //   //       decoration: BoxDecoration(
  //   //         borderRadius: BorderRadius.circular(10.0),
  //   //         color: Colors.red,
  //   //       ),
  //   //       child: Row(
  //   //         mainAxisSize: MainAxisSize.min,
  //   //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //   //         children: [
  //   //           const Icon(Icons.do_disturb),
  //   //           Text('Not match pattern'),
  //   //         ],
  //   //       ),
  //   //     ),
  //   //     gravity: ToastGravity.CENTER,
  //   //     toastDuration: const Duration(seconds: 2),
  //   //   );
  //   // }
  // }

  //home appbar
  String get_month_year_string(int month, int year) {
    final DateTime dateTime = DateTime(year, month);
    final DateFormat formatter = DateFormat('MMMM yyyy');
    return formatter.format(dateTime);
  }

  Future<void> fetch_user_name() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      user_name = user.email;
      notifyListeners();
    }
  }

  Future<void> fetch_data() async {
    List<Map<String, dynamic>> income_temp = await db_helper
        .fetch_data_cat_bymonth(uid, formattedDate, isIncome: true);
    List<Map<String, dynamic>> expense_temp = await db_helper
        .fetch_data_cat_bymonth(uid, formattedDate, isIncome: false);

    income_categories = income_temp;
    expense_categories = expense_temp;
    calculate_totals();
    is_loading = false;
    notifyListeners();
  }

  void calculate_totals() {
    total_income = income_categories
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_expense = expense_categories
        .map<double>((catItem) => (catItem['money']))
        .fold<double>(0, (prev, amount) => prev + amount);

    total_saving =
        double.parse((total_income - total_expense).toStringAsFixed(2));

    notifyListeners();
  }

  void onChangedMonth(newMonth) {
    month = int.parse(newMonth!);
    formattedDate = get_month_year_string(month, year);
    notifyListeners();
    fetch_data();
    fetch_data_list();
  }

  void onChangedYear(newYear) {
    year = int.parse(newYear!);
    formattedDate = get_month_year_string(month, year);
    notifyListeners();
    fetch_data();
    fetch_data_list();
  }

  //home list
  Future<void> fetch_data_list() async {
    List<Map<String, dynamic>> temp =
        await db_helper.fetch_input(uid, formattedDate);

    input_data = temp;
    is_loading = false;
    notifyListeners();
  }

  void handle_edit(Map<String, dynamic> input_item, context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                update_input(input_item: input_item)));
  }

  void handle_delete(String input_id, String uid, context) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection("input")
          .doc(input_id)
          .delete();

      fetch_data();
      fetch_data_list();

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
}
