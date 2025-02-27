// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English (US)';

  @override
  String get title => 'OscilloUI';

  @override
  String get description => 'App for controlling RIGOL DS1054Z';

  @override
  String get test => 'test';

  @override
  String get homeNavigationPaneTitle => 'Home';

  @override
  String get settingsNavigationPaneTitle => 'Settings';

  @override
  String get galleryNavigationPaneTitle => 'Gallery';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get settingsPageSubtitle => 'Change the settings of the app';

  @override
  String get settingsPageThemeSettingTitle => 'Theme';

  @override
  String get settingsPageThemeSettingSubtitle => 'Change the theme of the app';

  @override
  String get settingsPageThemeSettingOptionSystem => 'System';

  @override
  String get settingsPageThemeSettingOptionLight => 'Light';

  @override
  String get settingsPageThemeSettingOptionDark => 'Dark';

  @override
  String get settingsPageLanguageSettingTitle => 'Language';

  @override
  String get settingsPageLanguageSettingSubtitle => 'Change the language of the app';

  @override
  String get settingsPageConnectionSettingTitle => 'Connection';

  @override
  String get settingsPageConnectionSettingSubtitle => 'Change the connection settings of the oscilloscope';

  @override
  String get settingsPageHostSettingTitle => 'Hostname';

  @override
  String get settingsPageHostSettingSubtitle => 'Change the hostname of the oscilloscope connection';

  @override
  String get settingsPageHostSettingHint => 'Enter the hostname of the oscilloscope';

  @override
  String get settingsPagePortSettingTitle => 'Port';

  @override
  String get settingsPagePortSettingSubtitle => 'Change the port of the oscilloscope connection';

  @override
  String get settingsPagePortSettingHint => 'Enter the port of the oscilloscope';

  @override
  String get settingsPageCaptureSettingTitle => 'Capture';

  @override
  String get settingsPageCaptureSettingSubtitle => 'Change the capture settings of the osilloscope';

  @override
  String get settingsPageImageSavePathSettingTitle => 'Image Save Path';

  @override
  String get settingsPageImageSavePathSettingSubtitle => 'Change the image save path of the osilloscope capture';

  @override
  String get settingsPageImageSavePathSettingHint => 'Enter the image save path of the oscilloscope';

  @override
  String get settingsPageVideoSavePathSettingTitle => 'Video Save Path';

  @override
  String get settingsPageVideoSavePathSettingSubtitle => 'Change the video save path of the osilloscope capture';

  @override
  String get settingsPageVideoSavePathSettingHint => 'Enter the video save path of the oscilloscope';

  @override
  String get textFormFieldRequiredError => 'This field is required';

  @override
  String get textFormFieldInvalidError => 'This field is invalid';

  @override
  String get defaultText => 'Default';

  @override
  String get editText => 'Edit';

  @override
  String get saveText => 'Save';

  @override
  String captureText(String Type) {
    return 'Capture $Type';
  }

  @override
  String get stopText => 'Stop';

  @override
  String get imageText => 'Image';

  @override
  String get videoText => 'Video';

  @override
  String get errorText => 'Error';

  @override
  String get acceptText => 'Accept';

  @override
  String get cancelText => 'Cancel';

  @override
  String get emptyText => 'Empty';

  @override
  String get noDataText => 'No data';

  @override
  String get connectText => 'Connect';

  @override
  String get connectedText => 'Connected';

  @override
  String get notConnectedText => 'Not Connected';

  @override
  String get disconnectText => 'Disconnect';

  @override
  String get disconnectedText => 'Disconnected';

  @override
  String get waitingText => 'Please wait';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get timeoutError => 'Connection timed out';

  @override
  String get unsupportedPlatformError => 'Unsupported platform';

  @override
  String get requestError => 'Request error';

  @override
  String get permissionDeniedError => 'Permission denied';

  @override
  String get fatalErrorText => 'The program has encountered a problem and needs to close. We are sorry for the inconvenience. Please report this error to the developer. Thank you!';
}
