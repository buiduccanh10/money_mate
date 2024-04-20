import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';

class sign_up_page extends StatefulWidget {
  const sign_up_page({super.key});

  @override
  _sign_up_pageState createState() => _sign_up_pageState();
}

class _sign_up_pageState extends State<sign_up_page> {
  final db_helper = firestore_helper();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirm_password = TextEditingController();
  GlobalKey<FormState> sign_up_key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleData.sign_up.getString(context))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: sign_up_key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email can not empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleData.email.getString(context),
                    hintText: 'example@gmail.com',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password can not empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: LocaleData.password.getString(context),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  controller: password,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password can not empty';
                    }
                    if (value != password.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm password',
                    prefixIcon: const Icon(Icons.lock_reset),
                  ),
                  controller: confirm_password,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (sign_up_key.currentState!.validate()) {
                      sign_up_submit();
                    }
                  },
                  child: Text(LocaleData.sign_up.getString(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sign_up_submit() async {
    try {
      final UserCredential cre =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      String uid = cre.user!.uid;
      await cre.user!.sendEmailVerification();

      await db_helper
          .get_user(uid, email.text, '')
          .then((value) => Fluttertoast.showToast(
                msg: LocaleData.toast_sign_up_success.getString(context),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              ))
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: LocaleData.toast_sign_up_weakpass.getString(context),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: LocaleData.toast_user_exist.getString(context),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }
}
