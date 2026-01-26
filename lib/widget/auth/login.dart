import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:money_mate/services/locales.dart';
import 'package:money_mate/bloc/auth/auth_bloc.dart';
import 'package:money_mate/bloc/auth/auth_event.dart';
import 'package:money_mate/bloc/auth/auth_state.dart';
import 'package:money_mate/widget/auth/forgot_pass.dart';
import 'package:money_mate/widget/auth/sign_up.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:sign_in_button/sign_in_button.dart';
import 'package:money_mate/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  StateMachineController? stateController;
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  SMIInput<double>? numLook;

  double scale = 1.0;

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(_emailFocus);
    passwordFocusNode.addListener(_passwordFocus);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(_emailFocus);
    passwordFocusNode.removeListener(_passwordFocus);
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void _passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  void _onInitAnimation(Artboard artboard) {
    stateController =
        StateMachineController.fromArtboard(artboard, "Login Machine");
    if (stateController == null) return;
    artboard.addController(stateController!);
    isChecking = stateController?.findInput("isChecking");
    isHandsUp = stateController?.findInput("isHandsUp");
    numLook = stateController?.findInput("numLook");
    trigSuccess = stateController?.findInput("trigSuccess");
    trigFail = stateController?.findInput("trigFail");
  }

  void _onChangedEmail(String value) {
    isHandsUp?.change(false);
    isChecking?.change(true);
    numLook?.change(value.length.toDouble() * 5);
  }

  void _onChangedPassword(String value) {
    isChecking?.change(false);
    isHandsUp?.change(true);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.success) {
            isChecking?.change(false);
            isHandsUp?.change(false);
            trigSuccess?.change(true);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Main()));
          } else if (state.status == AuthStatus.failure) {
            isChecking?.change(false);
            isHandsUp?.change(false);
            trigFail?.change(true);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xffD6E2EA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            actions: [
              BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) =>
                    previous.currentLocale != current.currentLocale,
                builder: (context, state) {
                  return DropdownButton<String>(
                    underline: Container(),
                    borderRadius: BorderRadius.circular(10),
                    icon: const Icon(Icons.language,
                        color: Colors.blue, size: 28),
                    padding: const EdgeInsets.all(14),
                    value: state.currentLocale,
                    items: [
                      DropdownMenuItem(
                          value: 'vi',
                          child: Text(LocaleData.op_vi.getString(context))),
                      DropdownMenuItem(
                          value: 'en',
                          child: Text(LocaleData.op_en.getString(context))),
                      DropdownMenuItem(
                          value: 'zh',
                          child: Text(LocaleData.op_cn.getString(context))),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        context.read<AuthBloc>().add(LocaleChanged(value));
                      }
                    },
                  );
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    SizedBox(
                      height: 250,
                      child: RiveAnimation.asset(
                        'animations/animated_login_character.riv',
                        stateMachines: const ["Login Machine"],
                        onInit: _onInitAnimation,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                focusNode: emailFocusNode,
                                controller: emailController,
                                onChanged: _onChangedEmail,
                                decoration: InputDecoration(
                                  label:
                                      Text(LocaleData.email.getString(context)),
                                  hintText: 'example@gmail.com',
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              BlocBuilder<AuthBloc, AuthState>(
                                buildWhen: (previous, current) =>
                                    previous.isShow != current.isShow,
                                builder: (context, state) {
                                  return TextField(
                                    controller: passwordController,
                                    obscureText: state.isShow,
                                    focusNode: passwordFocusNode,
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: _onChangedPassword,
                                    decoration: InputDecoration(
                                      label: Text(LocaleData.password
                                          .getString(context)),
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          context
                                              .read<AuthBloc>()
                                              .add(TogglePasswordVisibility());
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          color: state.isShow
                                              ? Colors.black
                                              : Colors.blue,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    child: Text(
                                      LocaleData.forgot_pass.getString(context),
                                      style: const TextStyle(
                                          decoration: TextDecoration.underline),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const ForgotPass()));
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthBloc>().add(LoginRequested(
                                        emailController.text,
                                        passwordController.text,
                                      ));
                                  setState(() {
                                    scale = 1.03;
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    setState(() {
                                      scale = 1.0;
                                    });
                                  });
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
                                    width: double.infinity,
                                    child: Center(
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          if (state.status ==
                                              AuthStatus.loading) {
                                            return const CircularProgressIndicator(
                                                color: Colors.white);
                                          }
                                          return Text(
                                            LocaleData.login.getString(context),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          );
                                        },
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
                                                  const SignUpPage()));
                                    },
                                  )
                                ],
                              ),
                              Center(
                                  child: Text(LocaleData.or_sign_in
                                      .getString(context))),
                              SignInButton(
                                Buttons.google,
                                text: LocaleData.sign_in_gg.getString(context),
                                onPressed: () {
                                  // context.read<AuthBloc>().add(GoogleLoginRequested());
                                },
                              ),
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
      ),
    );
  }
}
