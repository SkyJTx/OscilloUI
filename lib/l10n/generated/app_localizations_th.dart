// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get language => 'ไทย';

  @override
  String get title => 'ออสซิโลยูไอ';

  @override
  String get description => 'แอปสำหรับควบคุม RIGOL DS1054Z';

  @override
  String get test => 'ทดสอบ';

  @override
  String get homeNavigationPaneTitle => 'หน้าหลัก';

  @override
  String get settingsNavigationPaneTitle => 'การตั้งค่า';

  @override
  String get galleryNavigationPaneTitle => 'แกลเลอรี';

  @override
  String get settingsPageTitle => 'การตั้งค่า';

  @override
  String get settingsPageSubtitle => 'ปรับแต่งการตั้งค่า';

  @override
  String get settingsPageThemeSettingTitle => 'ธีม';

  @override
  String get settingsPageThemeSettingSubtitle => 'เลือกธีมที่คุณต้องการ';

  @override
  String get settingsPageThemeSettingOptionSystem => 'ระบบ';

  @override
  String get settingsPageThemeSettingOptionLight => 'สว่าง';

  @override
  String get settingsPageThemeSettingOptionDark => 'มืด';

  @override
  String get settingsPageLanguageSettingTitle => 'ภาษา';

  @override
  String get settingsPageLanguageSettingSubtitle => 'เลือกภาษาที่คุณต้องการ';

  @override
  String get settingsPageConnectionSettingTitle => 'การตั้งค่าการเชื่อมต่อ';

  @override
  String get settingsPageConnectionSettingSubtitle => 'ตั้งค่าการเชื่อมต่อ';

  @override
  String get settingsPageHostSettingTitle => 'โฮสต์เนม';

  @override
  String get settingsPageHostSettingSubtitle => 'ตั้งค่าโฮสต์เนม';

  @override
  String get settingsPageHostSettingHint => 'กรุณาใส่โฮสต์เนม';

  @override
  String get settingsPagePortSettingTitle => 'พอร์ต';

  @override
  String get settingsPagePortSettingSubtitle => 'ตั้งค่าพอร์ต';

  @override
  String get settingsPagePortSettingHint => 'กรุณาใส่พอร์ต';

  @override
  String get settingsPageCaptureSettingTitle => 'การตั้งค่าการจับภาพและวิดีโอ';

  @override
  String get settingsPageCaptureSettingSubtitle => 'ตั้งค่าการจับภาพและวิดีโอ';

  @override
  String get settingsPageImageSavePathSettingTitle => 'เส้นทางบันทึกรูปภาพ';

  @override
  String get settingsPageImageSavePathSettingSubtitle => 'ตั้งค่าเส้นทางบันทึกรูปภาพ';

  @override
  String get settingsPageImageSavePathSettingHint => 'กรุณาใส่เส้นทางบันทึกรูปภาพ';

  @override
  String get settingsPageVideoSavePathSettingTitle => 'เส้นทางบันทึกวิดีโอ';

  @override
  String get settingsPageVideoSavePathSettingSubtitle => 'ตั้งค่าเส้นทางบันทึกวิดีโอ';

  @override
  String get settingsPageVideoSavePathSettingHint => 'กรุณาใส่เส้นทางบันทึกวิดีโอ';

  @override
  String get textFormFieldRequiredError => 'จำเป็นต้องกรอกข้อมูล';

  @override
  String get textFormFieldInvalidError => 'ข้อมูลไม่ถูกต้อง';

  @override
  String get defaultText => 'ค่าเริ่มต้น';

  @override
  String get editText => 'แก้ไข';

  @override
  String get saveText => 'บันทึก';

  @override
  String captureText(String Type) {
    return 'จับ$Type';
  }

  @override
  String get stopText => 'หยุด';

  @override
  String get imageText => 'รูปภาพ';

  @override
  String get videoText => 'วิดีโอ';

  @override
  String get errorText => 'ข้อผิดพลาด';

  @override
  String get acceptText => 'ยอมรับ';

  @override
  String get cancelText => 'ยกเลิก';

  @override
  String get emptyText => 'ว่างเปล่า';

  @override
  String get noDataText => 'ไม่มีข้อมูล';

  @override
  String get connectText => 'เชื่อมต่อ';

  @override
  String get connectedText => 'เชื่อมต่อแล้ว';

  @override
  String get notConnectedText => 'ไม่ได้เชื่อมต่อ';

  @override
  String get disconnectText => 'ตัดการเชื่อมต่อ';

  @override
  String get disconnectedText => 'ตัดการเชื่อมต่อแล้ว';

  @override
  String get waitingText => 'กรุณารอสักครู่';

  @override
  String get unknownError => 'ข้อผิดพลาดที่ไม่รู้จัก';

  @override
  String get timeoutError => 'หมดเวลาเชื่อมต่อ';

  @override
  String get unsupportedPlatformError => 'แพลตฟอร์มไม่รองรับ';

  @override
  String get requestError => 'ข้อผิดพลาดในการร้องขอ';

  @override
  String get permissionDeniedError => 'การเข้าถึงถูกปฏิเสธ';

  @override
  String get fatalErrorText => 'โปรแกรมพบปัญหาและจำเป็นต้องปิด เราขออภัยในความไม่สะดวก กรุณารายงานข้อผิดพลาดนี้ให้กับนักพัฒนา ขอบคุณ';
}
