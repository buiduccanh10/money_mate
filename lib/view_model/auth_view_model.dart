import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/main.dart';
import 'package:money_mate/services/firestore_helper.dart';
import 'package:money_mate/services/locales.dart';
import 'package:rive/rive.dart';

class auth_view_model with ChangeNotifier {
  bool? is_show;
  double scale = 1.0;
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  late String uid;
  String? email;
  String? image;
  final db_helper = firestore_helper();
  FocusNode email_focus_node = FocusNode();
  FocusNode password_focus_node = FocusNode();
  StateMachineController? state_controller;
  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;
  SMIInput<double>? numLook;
  final flutter_localization = FlutterLocalization.instance;
  late String current_locale;

  auth_view_model() {
    is_show = true;
    email_focus_node.addListener(email_focus);
    password_focus_node.addListener(password_focus);
    current_locale = flutter_localization.currentLocale!.languageCode;

    notifyListeners();
  }

  @override
  void dispose() {
    email_focus_node.removeListener(email_focus);
    password_focus_node.removeListener(password_focus);
    super.dispose();
  }

  void email_focus() {
    isChecking?.change(email_focus_node.hasFocus);
    notifyListeners();
  }

  void password_focus() {
    isHandsUp?.change(password_focus_node.hasFocus);
    notifyListeners();
  }

  void onInitAnimation(artboard) {
    state_controller =
        StateMachineController.fromArtboard(artboard, "Login Machine");
    if (state_controller == null) return;

    artboard.addController(state_controller!);
    isChecking = state_controller?.findInput("isChecking");
    isHandsUp = state_controller?.findInput("isHandsUp");
    numLook = state_controller?.findInput("numLook");
    trigSuccess = state_controller?.findInput("trigSuccess");
    trigFail = state_controller?.findInput("trigFail");

    notifyListeners();
  }

  void onChangedEmail(value) {
    if (isHandsUp != null) {
      isHandsUp!.change(false);
    }
    if (isChecking == null) {
      return;
    } else {
      isChecking!.change(true);
      numLook?.change(value.length.toDouble() * 5);
    }

    notifyListeners();
  }

  void onChangedPassword(value) {
    if (isChecking != null) {
      isChecking!.change(false);
    }
    if (isHandsUp == null) return;

    isHandsUp!.change(true);

    notifyListeners();
  }

  void onPressedIsShow() {
    is_show = !is_show!;
    notifyListeners();
  }

  void set_locale(String? value) {
    if (value == null) return;
    if (value == 'vi') {
      flutter_localization.translate('vi');
    } else if (value == 'en') {
      flutter_localization.translate('en');
    } else if (value == 'zh') {
      flutter_localization.translate('zh');
    } else {
      return;
    }

    current_locale = value;
    notifyListeners();
  }

  Future<void> login_facebook(context) async {
    try {
      FacebookAuthProvider facebookAuthProvider = FacebookAuthProvider();
      final FirebaseAuth auth = FirebaseAuth.instance;
      await auth
          .signInWithProvider(facebookAuthProvider)
          .then((value) => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Main()),
              ));
    } catch (err) {}
  }

  Future<void> login_google(context) async {
    GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
    final FirebaseAuth auth = FirebaseAuth.instance;

    final cre = await auth.signInWithProvider(googleAuthProvider);

    uid = cre.user!.uid;
    email = cre.user!.email;
    image = cre.user!.photoURL;

    if (cre.additionalUserInfo!.isNewUser) {
      db_helper.get_user(uid, email!, image!);
    }

    Fluttertoast.showToast(
            msg: LocaleData.toast_login_success.getString(context),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0)
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            ));
  }

  Future<void> login(context) async {
    try {
      final cre = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email_controller.text, password: password_controller.text);

      if (cre.additionalUserInfo!.isNewUser) {
        db_helper.get_user(uid, email!, image!);
      }

      if (cre.user!.emailVerified) {
        Fluttertoast.showToast(
                msg: LocaleData.toast_login_success.getString(context),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0)
            .then((value) => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Main())));
      } else {
        Fluttertoast.showToast(
            msg: LocaleData.toast_verify_email.getString(context),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (isChecking != null && isHandsUp != null) {
        isChecking!.change(false);
        isHandsUp!.change(false);
      }

      if (trigSuccess == null) return;

      trigSuccess!.change(true);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        if (isHandsUp != null) {
          isChecking!.change(false);
          isHandsUp!.change(false);
        }
        if (trigFail == null) return;

        trigFail!.change(true);
        notifyListeners();

        Fluttertoast.showToast(
            msg: LocaleData.toast_user_not_exist.getString(context),
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
        notifyListeners();

        Fluttertoast.showToast(
            msg: LocaleData.toast_login_fail.getString(context),
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
