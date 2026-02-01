import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @chart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get chart;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @helloHomeAppbar.
  ///
  /// In en, this message translates to:
  /// **'Hi, '**
  String get helloHomeAppbar;

  /// No description provided for @totalSaving.
  ///
  /// In en, this message translates to:
  /// **'Total: '**
  String get totalSaving;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @noInputData.
  ///
  /// In en, this message translates to:
  /// **'No input data yet !'**
  String get noInputData;

  /// No description provided for @slideEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get slideEdit;

  /// No description provided for @slideDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get slideDelete;

  /// No description provided for @inputDescription.
  ///
  /// In en, this message translates to:
  /// **'Description (Optional)'**
  String get inputDescription;

  /// No description provided for @inputMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get inputMoney;

  /// No description provided for @incomeCategory.
  ///
  /// In en, this message translates to:
  /// **'Income category'**
  String get incomeCategory;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense category'**
  String get expenseCategory;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More...'**
  String get more;

  /// No description provided for @inputVave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get inputVave;

  /// No description provided for @inCategoryManageAppbar.
  ///
  /// In en, this message translates to:
  /// **'Income category manage'**
  String get inCategoryManageAppbar;

  /// No description provided for @exCategoryManageAppbar.
  ///
  /// In en, this message translates to:
  /// **'Expense category manage'**
  String get exCategoryManageAppbar;

  /// No description provided for @inDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all income category ?'**
  String get inDeleteAllTitle;

  /// No description provided for @exDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all expense category ?'**
  String get exDeleteAllTitle;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @addCatDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new category'**
  String get addCatDialogTitle;

  /// No description provided for @chooseAnIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an icon'**
  String get chooseAnIcon;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryName;

  /// No description provided for @updateCatTitle.
  ///
  /// In en, this message translates to:
  /// **'Update category'**
  String get updateCatTitle;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @typeAnyToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type any to search...'**
  String get typeAnyToSearch;

  /// No description provided for @switchMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get switchMonthly;

  /// No description provided for @switchYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get switchYearly;

  /// No description provided for @modify.
  ///
  /// In en, this message translates to:
  /// **'Modify'**
  String get modify;

  /// No description provided for @modifyDes.
  ///
  /// In en, this message translates to:
  /// **'Tap to change your profile'**
  String get modifyDes;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @applicationLock.
  ///
  /// In en, this message translates to:
  /// **'Application lock'**
  String get applicationLock;

  /// No description provided for @applicationLockDes.
  ///
  /// In en, this message translates to:
  /// **'Use Passwork or FaceID when open'**
  String get applicationLockDes;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @privacyDes.
  ///
  /// In en, this message translates to:
  /// **'More privacy options'**
  String get privacyDes;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutDes.
  ///
  /// In en, this message translates to:
  /// **'Learn more about Money Mate'**
  String get aboutDes;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackDes.
  ///
  /// In en, this message translates to:
  /// **'Let us know your experience about app'**
  String get sendFeedbackDes;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @noCatYet.
  ///
  /// In en, this message translates to:
  /// **'No category yet !'**
  String get noCatYet;

  /// No description provided for @logOutDialog.
  ///
  /// In en, this message translates to:
  /// **'Sign out your account ?'**
  String get logOutDialog;

  /// No description provided for @languageAppbar.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageAppbar;

  /// No description provided for @languageDes.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageDes;

  /// No description provided for @opEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get opEn;

  /// No description provided for @opVi.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get opVi;

  /// No description provided for @opCn.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get opCn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPass.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password ?'**
  String get forgotPass;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @dontHaveAcc.
  ///
  /// In en, this message translates to:
  /// **'Don\'t you have account ?'**
  String get dontHaveAcc;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @orSignIn.
  ///
  /// In en, this message translates to:
  /// **'Or sign in with:'**
  String get orSignIn;

  /// No description provided for @signInGg.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInGg;

  /// No description provided for @deleteAllDataAcc.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAllDataAcc;

  /// No description provided for @deleteAllDataAccDes.
  ///
  /// In en, this message translates to:
  /// **'Your input, category,... data will be delete'**
  String get deleteAllDataAccDes;

  /// No description provided for @deleteAcc.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAcc;

  /// No description provided for @deleteAccDes.
  ///
  /// In en, this message translates to:
  /// **'Your account will no longer exist'**
  String get deleteAccDes;

  /// No description provided for @toastAddSuccess.
  ///
  /// In en, this message translates to:
  /// **'Create successfull !'**
  String get toastAddSuccess;

  /// No description provided for @toastUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Update successfull !'**
  String get toastUpdateSuccess;

  /// No description provided for @toastDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Delete successfull !'**
  String get toastDeleteSuccess;

  /// No description provided for @toastAddFail.
  ///
  /// In en, this message translates to:
  /// **'Create fail !'**
  String get toastAddFail;

  /// No description provided for @toastUpdateFail.
  ///
  /// In en, this message translates to:
  /// **'Update fail !'**
  String get toastUpdateFail;

  /// No description provided for @toastDeleteFail.
  ///
  /// In en, this message translates to:
  /// **'Delete fail !'**
  String get toastDeleteFail;

  /// No description provided for @toastDeleteUserFail.
  ///
  /// In en, this message translates to:
  /// **'Delete user fail ! (Login and try again)'**
  String get toastDeleteUserFail;

  /// No description provided for @toastLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful !'**
  String get toastLoginSuccess;

  /// No description provided for @toastLoginFail.
  ///
  /// In en, this message translates to:
  /// **'Wrong user or password !'**
  String get toastLoginFail;

  /// No description provided for @toastSignupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sign up successful, check the link in your email to verify !'**
  String get toastSignupSuccess;

  /// No description provided for @toastSignupFail.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed !'**
  String get toastSignupFail;

  /// No description provided for @toastSignupWeakpass.
  ///
  /// In en, this message translates to:
  /// **'Password too weak !'**
  String get toastSignupWeakpass;

  /// No description provided for @toastUserExist.
  ///
  /// In en, this message translates to:
  /// **'Email already exists'**
  String get toastUserExist;

  /// No description provided for @toastNotFound.
  ///
  /// In en, this message translates to:
  /// **'Not found !'**
  String get toastNotFound;

  /// No description provided for @toastVerifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Your account not verify, check the link in your email !'**
  String get toastVerifyEmail;

  /// No description provided for @toastUserNotExist.
  ///
  /// In en, this message translates to:
  /// **'User is not exist !'**
  String get toastUserNotExist;

  /// No description provided for @catValidator.
  ///
  /// In en, this message translates to:
  /// **'No category selected yet !'**
  String get catValidator;

  /// No description provided for @moneyValidator.
  ///
  /// In en, this message translates to:
  /// **'Money field can not be blank'**
  String get moneyValidator;

  /// No description provided for @darkmodeLightDes.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get darkmodeLightDes;

  /// No description provided for @darkmodeDarkDes.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkmodeDarkDes;

  /// No description provided for @localAuthTitle.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to access the app'**
  String get localAuthTitle;

  /// No description provided for @localAuthWarning.
  ///
  /// In en, this message translates to:
  /// **'Your device don\'t have any security method, set it again !'**
  String get localAuthWarning;

  /// No description provided for @noAvailable.
  ///
  /// In en, this message translates to:
  /// **'No available'**
  String get noAvailable;

  /// No description provided for @catIconValidator.
  ///
  /// In en, this message translates to:
  /// **'Please choose an icon'**
  String get catIconValidator;

  /// No description provided for @catNameValidator.
  ///
  /// In en, this message translates to:
  /// **'Please enter category name'**
  String get catNameValidator;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get advancedSettings;

  /// No description provided for @fixedInEx.
  ///
  /// In en, this message translates to:
  /// **'Set up fixed income and expense'**
  String get fixedInEx;

  /// No description provided for @fixedInExDes.
  ///
  /// In en, this message translates to:
  /// **'Automating recurring income and expense entries'**
  String get fixedInExDes;

  /// No description provided for @deleteAllSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete all schedule ?'**
  String get deleteAllSchedule;

  /// No description provided for @noSetUpYet.
  ///
  /// In en, this message translates to:
  /// **'No set up yet !'**
  String get noSetUpYet;

  /// No description provided for @setUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get setUp;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category:'**
  String get selectCategory;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat:'**
  String get repeat;

  /// No description provided for @neverRepeat.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get neverRepeat;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @payByEWallet.
  ///
  /// In en, this message translates to:
  /// **'Pay by e-wallet'**
  String get payByEWallet;

  /// No description provided for @payByEWalletDes.
  ///
  /// In en, this message translates to:
  /// **'Payment is via e-wallet, and saved as an expense'**
  String get payByEWalletDes;

  /// No description provided for @payByEWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a e-wallet'**
  String get payByEWalletTitle;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethodTitle;

  /// No description provided for @paymentMethodQr.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get paymentMethodQr;

  /// No description provided for @paymentMethodNew.
  ///
  /// In en, this message translates to:
  /// **'New beneficiary'**
  String get paymentMethodNew;

  /// No description provided for @paypalAccountHolder.
  ///
  /// In en, this message translates to:
  /// **'Account holder'**
  String get paypalAccountHolder;

  /// No description provided for @paypalContentBilling.
  ///
  /// In en, this message translates to:
  /// **'Content billing'**
  String get paypalContentBilling;

  /// No description provided for @optionCategory.
  ///
  /// In en, this message translates to:
  /// **'Category (optional):'**
  String get optionCategory;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get checkOut;

  /// No description provided for @paypalSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment success'**
  String get paypalSuccess;

  /// No description provided for @paypalFail.
  ///
  /// In en, this message translates to:
  /// **'Payment fail'**
  String get paypalFail;

  /// No description provided for @paypalCancel.
  ///
  /// In en, this message translates to:
  /// **'Payment cancel'**
  String get paypalCancel;

  /// No description provided for @settingLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Spending limit'**
  String get settingLimitTitle;

  /// No description provided for @settingLimitDes.
  ///
  /// In en, this message translates to:
  /// **'Set limit for each spending category'**
  String get settingLimitDes;

  /// No description provided for @restoreAllLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore all limit'**
  String get restoreAllLimitTitle;

  /// No description provided for @restoreLimit.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreLimit;

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit yet'**
  String get noLimit;

  /// No description provided for @limitDialog.
  ///
  /// In en, this message translates to:
  /// **'Set limit for'**
  String get limitDialog;

  /// No description provided for @overLimit.
  ///
  /// In en, this message translates to:
  /// **'Exceeded the expense limit of'**
  String get overLimit;

  /// No description provided for @over.
  ///
  /// In en, this message translates to:
  /// **'over'**
  String get over;

  /// No description provided for @limitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Set limit success'**
  String get limitSuccess;

  /// No description provided for @limitFail.
  ///
  /// In en, this message translates to:
  /// **'Set limit fail'**
  String get limitFail;

  /// No description provided for @restorelimitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore limit success'**
  String get restorelimitSuccess;

  /// No description provided for @restorelimitFail.
  ///
  /// In en, this message translates to:
  /// **'Restore limit fail'**
  String get restorelimitFail;

  /// No description provided for @restoreAllLimitSuccess.
  ///
  /// In en, this message translates to:
  /// **'Restore all limit success'**
  String get restoreAllLimitSuccess;

  /// No description provided for @restoreAllLimitFail.
  ///
  /// In en, this message translates to:
  /// **'Restore all limit fail'**
  String get restoreAllLimitFail;

  /// No description provided for @updateAvatar.
  ///
  /// In en, this message translates to:
  /// **'Update Avatar'**
  String get updateAvatar;

  /// No description provided for @tapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap on the image to upload a new avatar'**
  String get tapToUpload;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password (Optional)'**
  String get newPassword;

  /// No description provided for @avatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated successfully'**
  String get avatarUpdated;

  /// No description provided for @avatarUpdateFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to update avatar'**
  String get avatarUpdateFail;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @deleteTransactionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction?'**
  String get deleteTransactionConfirm;

  /// No description provided for @deleteCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this category?'**
  String get deleteCategoryConfirm;

  /// No description provided for @deleteDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all data?'**
  String get deleteDataConfirm;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountConfirm;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTime;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
