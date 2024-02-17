import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class sign_up_page extends StatefulWidget {
  const sign_up_page({super.key});

  @override
  State<sign_up_page> createState() => _sign_up_pageState();
}

class _sign_up_pageState extends State<sign_up_page> {
  final email = TextEditingController();
  final pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign up')),
      body: Column(children: [
        TextField(
          controller: email,
        ),
        TextField(
          controller: pass,
        ),
        TextButton(
            onPressed: () async {
              try {
                final credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email.text,
                  password: pass.text,
                );
                print('Sign up success');
                Navigator.pop(context);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            },
            child: Text('Save'))
      ]),
    );
  }
}
