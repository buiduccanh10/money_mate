import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';

class forgot_pass extends StatefulWidget {
  const forgot_pass({super.key});

  @override
  _forgot_passState createState() => _forgot_passState();
}

class _forgot_passState extends State<forgot_pass> {
  final db_helper = firestore_helper();
  final forgot_email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot your password')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: InputDecoration(
                    labelText: LocaleData.email.getString(context),
                    prefixIcon: const Icon(Icons.email),
                    hintText: 'example@gmail.com'),
                controller: forgot_email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  send_request();
                },
                child: Text('Send request'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> send_request() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: forgot_email.text)
          .then((value) => Navigator.pop(context));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(
          msg: LocaleData.toast_user_not_exist.getString(context),
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
