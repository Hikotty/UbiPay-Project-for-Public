import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja')
  ];

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @charge.
  ///
  /// In en, this message translates to:
  /// **'Charge'**
  String get charge;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @payed.
  ///
  /// In en, this message translates to:
  /// **'Payed'**
  String get payed;

  /// No description provided for @deposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @how_to_use.
  ///
  /// In en, this message translates to:
  /// **'How to use'**
  String get how_to_use;

  /// No description provided for @send_inquiry.
  ///
  /// In en, this message translates to:
  /// **'Send inquiry'**
  String get send_inquiry;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get user_name;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @common.
  ///
  /// In en, this message translates to:
  /// **'common'**
  String get common;

  /// No description provided for @request_of_withdraw_form.
  ///
  /// In en, this message translates to:
  /// **'Request of withdraw form'**
  String get request_of_withdraw_form;

  /// No description provided for @your_name.
  ///
  /// In en, this message translates to:
  /// **'your name'**
  String get your_name;

  /// No description provided for @your_email_address.
  ///
  /// In en, this message translates to:
  /// **'your e-mail address'**
  String get your_email_address;

  /// No description provided for @input_the_amount_of_withdraw.
  ///
  /// In en, this message translates to:
  /// **'Input the amount of withdraw'**
  String get input_the_amount_of_withdraw;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @change_user_name.
  ///
  /// In en, this message translates to:
  /// **'Change user name'**
  String get change_user_name;

  /// No description provided for @please_enter_username.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Username'**
  String get please_enter_username;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @inquiry_form.
  ///
  /// In en, this message translates to:
  /// **'Inquiry form'**
  String get inquiry_form;

  /// No description provided for @input_your_inquiry.
  ///
  /// In en, this message translates to:
  /// **'Input your inquiry'**
  String get input_your_inquiry;

  /// No description provided for @tx_info.
  ///
  /// In en, this message translates to:
  /// **'Transaction Info'**
  String get tx_info;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @recieved.
  ///
  /// In en, this message translates to:
  /// **'recieved'**
  String get recieved;

  /// No description provided for @txid.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get txid;

  /// No description provided for @tx_class.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get tx_class;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @withdraw_popup_title.
  ///
  /// In en, this message translates to:
  /// **'Accepted your request'**
  String get withdraw_popup_title;

  /// No description provided for @withdraw_popup_content.
  ///
  /// In en, this message translates to:
  /// **'We will send a message from ubipay.manager@gmail.com, right after confirm your request.'**
  String get withdraw_popup_content;

  /// No description provided for @remittance_form_title.
  ///
  /// In en, this message translates to:
  /// **'Request of Remittance form'**
  String get remittance_form_title;

  /// No description provided for @remittance_from_input.
  ///
  /// In en, this message translates to:
  /// **'Input the amount of withdraw'**
  String get remittance_from_input;

  /// No description provided for @remittance_form_pupup_exceed.
  ///
  /// In en, this message translates to:
  /// **'exceed your balance'**
  String get remittance_form_pupup_exceed;

  /// No description provided for @setting_key.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get setting_key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ja': return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
