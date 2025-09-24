import 'package:flutter/widgets.dart';

class LocalizedText {
  final String en;
  final String ar;
  const LocalizedText({required this.en, required this.ar});

  factory LocalizedText.fromJson(Map<String, dynamic> json,
      {String enKey = 'nameEn', String arKey = 'nameAr'}) {
    return LocalizedText(
      en: (json[enKey] ?? '').toString(),
      ar: (json[arKey] ?? '').toString(),
    );
  }

  /// helper when the JSON uses custom keys like titleEn/titleAr or descEn/descAr
  factory LocalizedText.custom(Map<String, dynamic> json,
      {required String enKey, required String arKey}) {
    return LocalizedText(
      en: (json[enKey] ?? '').toString(),
      ar: (json[arKey] ?? '').toString(),
    );
  }

  String ofLocale(Locale locale) => locale.languageCode == 'ar' ? ar : en;
}
