import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('th')
  ];

  /// The language of the app
  ///
  /// In en, this message translates to:
  /// **'English (US)'**
  String get language;

  /// The title of the app
  ///
  /// In en, this message translates to:
  /// **'OscilloUI'**
  String get title;

  /// The description of the app
  ///
  /// In en, this message translates to:
  /// **'App for controlling RIGOL DS1054Z'**
  String get description;

  /// This is a test string
  ///
  /// In en, this message translates to:
  /// **'test'**
  String get test;

  /// The title of the home navigation pane
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNavigationPaneTitle;

  /// The title of the settings navigation pane
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsNavigationPaneTitle;

  /// The title of the gallery navigation pane
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryNavigationPaneTitle;

  /// The title of the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// The subtitle of the settings page
  ///
  /// In en, this message translates to:
  /// **'Change the settings of the app'**
  String get settingsPageSubtitle;

  /// The title of the theme setting
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsPageThemeSettingTitle;

  /// The subtitle of the theme setting
  ///
  /// In en, this message translates to:
  /// **'Change the theme of the app'**
  String get settingsPageThemeSettingSubtitle;

  /// The system theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsPageThemeSettingOptionSystem;

  /// The light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsPageThemeSettingOptionLight;

  /// The dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsPageThemeSettingOptionDark;

  /// The title of the language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsPageLanguageSettingTitle;

  /// The subtitle of the language setting
  ///
  /// In en, this message translates to:
  /// **'Change the language of the app'**
  String get settingsPageLanguageSettingSubtitle;

  /// The title of the connection setting
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get settingsPageConnectionSettingTitle;

  /// The subtitle of the connection setting
  ///
  /// In en, this message translates to:
  /// **'Change the connection settings of the oscilloscope'**
  String get settingsPageConnectionSettingSubtitle;

  /// The title of the hostname setting
  ///
  /// In en, this message translates to:
  /// **'Hostname'**
  String get settingsPageHostSettingTitle;

  /// The subtitle of the host setting
  ///
  /// In en, this message translates to:
  /// **'Change the hostname of the oscilloscope connection'**
  String get settingsPageHostSettingSubtitle;

  /// The hint of the host setting
  ///
  /// In en, this message translates to:
  /// **'Enter the hostname of the oscilloscope'**
  String get settingsPageHostSettingHint;

  /// The title of the port setting
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get settingsPagePortSettingTitle;

  /// The subtitle of the port setting
  ///
  /// In en, this message translates to:
  /// **'Change the port of the oscilloscope connection'**
  String get settingsPagePortSettingSubtitle;

  /// The hint of the port setting
  ///
  /// In en, this message translates to:
  /// **'Enter the port of the oscilloscope'**
  String get settingsPagePortSettingHint;

  /// The title of the capture setting
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get settingsPageCaptureSettingTitle;

  /// The subtitle of the capture setting
  ///
  /// In en, this message translates to:
  /// **'Change the capture settings of the osilloscope'**
  String get settingsPageCaptureSettingSubtitle;

  /// The title of the image save path setting
  ///
  /// In en, this message translates to:
  /// **'Image Save Path'**
  String get settingsPageImageSavePathSettingTitle;

  /// The subtitle of the image save path setting
  ///
  /// In en, this message translates to:
  /// **'Change the image save path of the osilloscope capture'**
  String get settingsPageImageSavePathSettingSubtitle;

  /// The hint of the image save path setting
  ///
  /// In en, this message translates to:
  /// **'Enter the image save path of the oscilloscope'**
  String get settingsPageImageSavePathSettingHint;

  /// The title of the video save path setting
  ///
  /// In en, this message translates to:
  /// **'Video Save Path'**
  String get settingsPageVideoSavePathSettingTitle;

  /// The subtitle of the video save path setting
  ///
  /// In en, this message translates to:
  /// **'Change the video save path of the osilloscope capture'**
  String get settingsPageVideoSavePathSettingSubtitle;

  /// The hint of the video save path setting
  ///
  /// In en, this message translates to:
  /// **'Enter the video save path of the oscilloscope'**
  String get settingsPageVideoSavePathSettingHint;

  /// The error message for required text form field
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get textFormFieldRequiredError;

  /// The error message for invalid text form field
  ///
  /// In en, this message translates to:
  /// **'This field is invalid'**
  String get textFormFieldInvalidError;

  /// The default text
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultText;

  /// The edit text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editText;

  /// The save text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveText;

  /// A capture text
  ///
  /// In en, this message translates to:
  /// **'Capture {Type}'**
  String captureText(String Type);

  /// A stop text
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopText;

  /// An image text
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get imageText;

  /// A video text
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get videoText;

  /// An error text
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorText;

  /// An accept text
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptText;

  /// A cancel text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelText;

  /// An empty text
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get emptyText;

  /// A no data text
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noDataText;

  /// A connect text
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connectText;

  /// A connected text
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connectedText;

  /// A not connected text
  ///
  /// In en, this message translates to:
  /// **'Not Connected'**
  String get notConnectedText;

  /// A disconnect text
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnectText;

  /// A disconnected text
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnectedText;

  /// A waiting text
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get waitingText;

  /// An unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// A timeout error message
  ///
  /// In en, this message translates to:
  /// **'Connection timed out'**
  String get timeoutError;

  /// An unsupported platform error message
  ///
  /// In en, this message translates to:
  /// **'Unsupported platform'**
  String get unsupportedPlatformError;

  /// A request error message
  ///
  /// In en, this message translates to:
  /// **'Request error'**
  String get requestError;

  /// A permission denied error message
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDeniedError;

  /// A fatal error text
  ///
  /// In en, this message translates to:
  /// **'The program has encountered a problem and needs to close. We are sorry for the inconvenience. Please report this error to the developer. Thank you!'**
  String get fatalErrorText;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'th': return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
