import 'package:flutter/material.dart';
import '../i18n/i18n.dart';
import '../models/models.dart';
import '../models/localized.dart';

String formatIQD(int v) {
  final s = v.toString();
  final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return s.replaceAll(reg, ',');
}

String currencyLabel(BuildContext context) {
  final lang = I18nProvider.of(context).locale.languageCode;
  return lang == 'ar' ? 'د.ع ' : 'IQD ';
}

String textOf(BuildContext context, LocalizedText t) =>
    t.ofLocale(I18nProvider.of(context).locale);

String formatDate(BuildContext context, DateTime dt) {
  final t = I18nProvider.of(context);
  final month = t.t('month.${dt.month}');
  final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final ampm = dt.hour >= 12 ? (t.locale.languageCode == 'ar' ? 'م' : 'PM')
      : (t.locale.languageCode == 'ar' ? 'ص' : 'AM');
  final min = dt.minute.toString().padLeft(2, '0');
  return '$month ${dt.day} • $h12:$min$ampm';
}

String buildAddOnsText(BuildContext context, List<AddOn> a) {
  final t = I18nProvider.of(context);
  if (a.isEmpty) return t.t('cart.no_addons');
  final sep = t.locale.languageCode == 'ar' ? '، ' : ', ';
  return a
      .map((e) => e.price > 0
      ? '${textOf(context, e.name)} (+${formatIQD(e.price)})'
      : textOf(context, e.name))
      .join(sep);
}

Widget sectionTitle(String t) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
);
