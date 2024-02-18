import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/sign_up.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:sign_in_button/sign_in_button.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool? is_show;
  double scale = 1.0;

  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  FocusNode email_focus_node = FocusNode();
  FocusNode password_focus_node = FocusNode();
  StateMachineController? state_controller;
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  SMIInput<double>? numLook;

  @override
  void initState() {
    is_show = true;
    email_focus_node.addListener(email_focus);
    password_focus_node.addListener(password_focus);
    super.initState();
  }

  @override
  void dispose() {
    email_focus_node.removeListener(email_focus);
    password_focus_node.removeListener(password_focus);
    super.dispose();
  }

  void email_focus() {
    isChecking?.change(email_focus_node.hasFocus);
  }

  void password_focus() {
    isHandsUp?.change(password_focus_node.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xffD6E2EA),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 14, right: 14),
              child: Column(
                children: [
                  SizedBox(
                      height: 250,
                      child: RiveAnimation.asset(
                        'animations/animated_login_character.riv',
                        stateMachines: ["Login Machine"],
                        onInit: (artboard) {
                          state_controller =
                              StateMachineController.fromArtboard(
                                  artboard, "Login Machine");
                          if (state_controller == null) return;

                          artboard.addController(state_controller!);
                          isChecking =
                              state_controller?.findInput("isChecking");
                          isHandsUp = state_controller?.findInput("isHandsUp");
                          numLook = state_controller?.findInput("numLook");
                          trigSuccess =
                              state_controller?.findInput("trigSuccess");
                          trigFail = state_controller?.findInput("trigFail");
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              focusNode: email_focus_node,
                              controller: email_controller,
                              onChanged: (value) {
                                if (isHandsUp != null) {
                                  isHandsUp!.change(false);
                                }
                                if (isChecking == null) {
                                  return;
                                } else {
                                  isChecking!.change(true);
                                  numLook?.change(value.length.toDouble() * 5);
                                }
                              },
                              decoration: InputDecoration(
                                  label: const Text('Email'),
                                  prefixIcon: const Icon(
                                    Icons.email,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: password_controller,
                              obscureText: is_show! ? true : false,
                              focusNode: password_focus_node,
                              keyboardType: TextInputType.visiblePassword,
                              onChanged: (value) {
                                if (isChecking != null) {
                                  isChecking!.change(false);
                                }
                                if (isHandsUp == null) return;

                                isHandsUp!.change(true);
                              },
                              decoration: InputDecoration(
                                  label: const Text('Password'),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        is_show = !is_show!;
                                      });
                                    },
                                    icon: const Icon(Icons.remove_red_eye),
                                    color:
                                        is_show! ? Colors.black : Colors.blue,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: const Text(
                                    'Forgot your password?',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                login();
                              },
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 200),
                                scale: scale,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.blueAccent,
                                        Colors.orangeAccent
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  height: 50,
                                  width: 350,
                                  child: const Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Text("Don't you have account?"),
                                TextButton(
                                  child: const Text(
                                    'Sign up',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const sign_up_page()));
                                  },
                                )
                              ],
                            ),
                            const Center(
                              child: Text('Or sign with:'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SignInButton(
                                    Buttons.google,
                                    onPressed: () {
                                      try {
                                        GoogleAuthProvider googleAuthProvider =
                                            GoogleAuthProvider();
                                        final FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        auth.signInWithProvider(
                                            googleAuthProvider);
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           Main()), // Assuming Login is your login screen
                                        // );
                                      } catch (err) {
                                        print(err);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    setState(() {
      scale = 1.03;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        scale = 1.0;
      });
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email_controller.text, password: password_controller.text);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Main()));

      if (isChecking != null && isHandsUp != null) {
        isChecking!.change(false);
        isHandsUp!.change(false);
      }

      if (trigSuccess == null) return;

      trigSuccess!.change(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (isHandsUp != null) {
          isChecking!.change(false);
          isHandsUp!.change(false);
        }
        if (trigFail == null) return;

        trigFail!.change(true);

        Fluttertoast.showToast(
            msg: 'Please try email or password again!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.code == 'wrong-password') {
        if (isHandsUp != null) {
          isChecking!.change(false);
          isHandsUp!.change(false);
        }
        if (trigFail == null) return;

        trigFail!.change(true);

        Fluttertoast.showToast(
            msg: 'Please try email or password again!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
