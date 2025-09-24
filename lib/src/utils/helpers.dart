import 'dart:ui';

import 'package:flutter/cupertino.dart';

import '../models/models.dart';

String formatIQD(int v) {
  final s = v.toString();
  final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return s.replaceAll(reg, ',');
}

String formatDate(DateTime dt) {
  const months = ['ينا','فبر','مار','أبر','ماي','يون','يول','آغس','سبت','أكت','نوف','ديس'];
  final h12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
  final ampm = dt.hour >= 12 ? 'م' : 'ص';
  final min = dt.minute.toString().padLeft(2, '0');
  return '${months[dt.month - 1]} ${dt.day} • $h12:$min$ampm';
}

String buildAddOnsText(List<AddOn> a) {
  if (a.isEmpty) return 'بدون إضافات';
  return a
      .map((e) => e.price > 0 ? '${e.name} (+${formatIQD(e.price)})' : e.name)
      .join('، ');
}

Widget sectionTitle(String t) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)));
