import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/view_model/auth_view_model.dart';
import 'package:money_mate/widget/auth/forgot_pass.dart';
import 'package:money_mate/widget/home/home.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/widget/auth/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:sign_in_button/sign_in_button.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer<auth_view_model>(
        builder: (BuildContext context, auth_vm, Widget? child) {
          return Scaffold(
            backgroundColor: const Color(0xffD6E2EA),
            appBar: AppBar(
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                actions: [
                  DropdownButton(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(10),
                    icon: const Icon(
                      Icons.language,
                      color: Colors.blue,
                      size: 28,
                    ),
                    padding: const EdgeInsets.all(14),
                    items: [
                      DropdownMenuItem(
                        value: 'vi',
                        alignment: AlignmentDirectional.center,
                        child: Text(LocaleData.op_vi.getString(context)),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        alignment: AlignmentDirectional.center,
                        child: Text(LocaleData.op_en.getString(context)),
                      ),
                      DropdownMenuItem(
                        value: 'zh',
                        alignment: AlignmentDirectional.center,
                        child: Text(LocaleData.op_cn.getString(context)),
                      ),
                    ],
                    onChanged: (value) {
                      auth_vm.set_locale(value);
                    },
                  )
                ]),
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
                              auth_vm.onInitAnimation(artboard);
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
                                  focusNode: auth_vm.email_focus_node,
                                  controller: auth_vm.email_controller,
                                  onChanged: (value) {
                                    auth_vm.onChangedEmail(value);
                                  },
                                  decoration: InputDecoration(
                                      label: Text(
                                          LocaleData.email.getString(context)),
                                      hintText: 'example@gmail.com',
                                      prefixIcon: const Icon(
                                        Icons.email,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextField(
                                  controller: auth_vm.password_controller,
                                  obscureText: auth_vm.is_show! ? true : false,
                                  focusNode: auth_vm.password_focus_node,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: (value) {
                                    auth_vm.onChangedPassword(value);
                                  },
                                  decoration: InputDecoration(
                                      label: Text(LocaleData.password
                                          .getString(context)),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          auth_vm.onPressedIsShow();
                                        },
                                        icon: const Icon(Icons.remove_red_eye),
                                        color: auth_vm.is_show!
                                            ? Colors.black
                                            : Colors.blue,
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        LocaleData.forgot_pass
                                            .getString(context),
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const forgot_pass()));
                                      },
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    auth_vm.login(context);
                                    setState(() {
                                      auth_vm.scale = 1.03;
                                    });
                                    Future.delayed(
                                        const Duration(milliseconds: 200), () {
                                      setState(() {
                                        auth_vm.scale = 1.0;
                                      });
                                    });
                                  },
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 200),
                                    scale: auth_vm.scale,
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
                                      child: Center(
                                        child: Text(
                                          LocaleData.login.getString(context),
                                          style: const TextStyle(
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
                                    Text(LocaleData.dont_have_acc
                                        .getString(context)),
                                    TextButton(
                                      child: Text(
                                        LocaleData.sign_up.getString(context),
                                        style: const TextStyle(
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
                                Center(
                                  child: Text(
                                      LocaleData.or_sign_in.getString(context)),
                                ),
                                SignInButton(
                                  Buttons.google,
                                  text:
                                      LocaleData.sign_in_gg.getString(context),
                                  onPressed: () {
                                    auth_vm.login_google(context);
                                  },
                                ),
                                // SignInButton(
                                //   Buttons.facebook,
                                //   text: 'Sign up with Facebook',
                                //   onPressed: () {
                                //     login_facebook();
                                //   },
                                // )
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
          );
        },
      ),
    );
  }
}
