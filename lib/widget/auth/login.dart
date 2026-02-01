import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_mate/bloc/auth/auth_bloc.dart';
import 'package:money_mate/bloc/auth/auth_event.dart';
import 'package:money_mate/bloc/auth/auth_state.dart';
import 'package:money_mate/bloc/setting/setting_cubit.dart';
import 'package:money_mate/bloc/setting/setting_state.dart';
import 'package:money_mate/l10n/app_localizations.dart';
import 'package:money_mate/widget/main_layout.dart';
import 'package:money_mate/widget/auth/forgot_pass.dart';
import 'package:money_mate/widget/auth/sign_up.dart';
import 'package:rive/rive.dart' hide LinearGradient;
import 'package:sign_in_button/sign_in_button.dart';
import 'dart:ui';

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
    stateController = StateMachineController.fromArtboard(
      artboard,
      "Login Machine",
    );
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
    // Check Brightness for Gradient
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    // final backgroundGradient = LinearGradient(
    //   begin: Alignment.topLeft,
    //   end: Alignment.bottomRight,
    //   colors: isDark
    //       ? [
    //           const Color(0xFF0F2027),
    //           const Color(0xFF203A43),
    //           const Color(0xFF2C5364),
    //         ]
    //       : [const Color(0xFF4364F7), const Color(0xFF6FB1FC)],
    // );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          isChecking?.change(false);
          isHandsUp?.change(false);
          trigSuccess?.change(true);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainLayout()),
            (route) => false,
          );
        } else if (state.status == AuthStatus.failure) {
          isChecking?.change(false);
          isHandsUp?.change(false);
          trigFail?.change(true);
        }
      },
      child: Scaffold(
        // Transparent to show gradient
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            BlocBuilder<SettingCubit, SettingState>(
              builder: (context, state) {
                return Container(
                  margin: const EdgeInsets.only(right: 18, top: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      icon: const Icon(
                        Icons.language,
                        color: Colors.black87,
                        size: 24,
                      ),
                      value: state.language,
                      items: [
                        DropdownMenuItem(
                          value: 'vi',
                          child: Text(
                            AppLocalizations.of(context)!.opVi,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'en',
                          child: Text(
                            AppLocalizations.of(context)!.opEn,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'zh',
                          child: Text(
                            AppLocalizations.of(context)!.opCn,
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingCubit>().updateLanguageLocale(
                            value,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // decoration: BoxDecoration(gradient: backgroundGradient),
          decoration: const BoxDecoration(color: Color(0xFFD6E2EA)),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ), // STYLE_GUIDE: 16.0
                child: Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: RiveAnimation.asset(
                        'animations/animated_login_character.riv',
                        stateMachines: const ["Login Machine"],
                        onInit: _onInitAnimation,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20,
                          ), // STYLE_GUIDE: Radius 20
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              offset: Offset(0, 8), // STYLE_GUIDE: Shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.login,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24, // STYLE_GUIDE: Title 24
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                focusNode: emailFocusNode,
                                controller: emailController,
                                onChanged: _onChangedEmail,
                                decoration: InputDecoration(
                                  label: Text(
                                    AppLocalizations.of(context)!.email,
                                  ),
                                  hintText: 'example@gmail.com',
                                  prefixIcon: const Icon(Icons.email_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
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
                                      label: Text(
                                        AppLocalizations.of(context)!.password,
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock_outline,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          context.read<AuthBloc>().add(
                                            TogglePasswordVisibility(),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: state.isShow
                                              ? Colors.black54
                                              : Colors.blue,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text(
                                    AppLocalizations.of(context)!.forgotPass,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ForgotPass(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  context.read<AuthBloc>().add(
                                    LoginRequested(
                                      emailController.text,
                                      passwordController.text,
                                    ),
                                  );
                                  setState(() {
                                    scale = 1.03;
                                  });
                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () {
                                      setState(() {
                                        scale = 1.0;
                                      });
                                    },
                                  );
                                },
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 200),
                                  scale: scale,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF4364F7,
                                      ), // Solid color
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF4364F7,
                                          ).withValues(alpha: 0.4),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    height: 54,
                                    width: double.infinity,
                                    child: Center(
                                      child: BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          if (state.status ==
                                              AuthStatus.loading) {
                                            return const CircularProgressIndicator(
                                              color: Colors.white,
                                            );
                                          }
                                          return Text(
                                            AppLocalizations.of(context)!.login,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.dontHaveAcc,
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                  TextButton(
                                    child: Text(
                                      AppLocalizations.of(context)!.signUp,
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const SignUpPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                AppLocalizations.of(context)!.orSignIn,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SignInButton(
                                Buttons.google,
                                text: AppLocalizations.of(context)!.signInGg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  // context.read<AuthBloc>().add(GoogleLoginRequested());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
