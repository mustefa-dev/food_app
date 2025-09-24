import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class I18n extends ChangeNotifier {
  Locale _locale;
  Map<String, dynamic> _map = {};
  Map<String, dynamic> _fallback = {};

  I18n(this._locale);

  Locale get locale => _locale;

  Future<void> load(Locale locale) async {
    _locale = locale;
    _fallback = await _loadJson('assets/i18n/en.json');
    _map = await _loadJson('assets/i18n/${locale.languageCode}.json');
    notifyListeners();
  }

  Future<Map<String, dynamic>> _loadJson(String path) async {
    final s = await rootBundle.loadString(path);
    return jsonDecode(s) as Map<String, dynamic>;
  }

  String t(String key, {Map<String, Object?> params = const {}}) {
    final raw = _lookup(key) ?? key;
    var out = raw;
    params.forEach((k, v) => out = out.replaceAll('{$k}', '$v'));
    return out;
  }

  String? _lookup(String key) {
    // flat first
    if (_map[key] is String) return _map[key] as String;
    if (_fallback[key] is String) return _fallback[key] as String;

    // dotted path
    String? getFrom(Map<String, dynamic> m) {
      dynamic cur = m;
      for (final part in key.split('.')) {
        if (cur is Map<String, dynamic> && cur.containsKey(part)) {
          cur = cur[part];
        } else {
          return null;
        }
      }
      return cur is String ? cur : null;
    }

    return getFrom(_map) ?? getFrom(_fallback);
  }
}

class I18nProvider extends InheritedNotifier<I18n> {
  const I18nProvider({super.key, required I18n i18n, required Widget child})
      : super(notifier: i18n, child: child);

  static I18n of(BuildContext context) {
    final w = context.dependOnInheritedWidgetOfExactType<I18nProvider>();
    assert(w != null, 'No I18nProvider found in context');
    return w!.notifier!;
  }
}

extension I18nX on BuildContext {
  String tr(String key, {Map<String, Object?> params = const {}}) =>
      I18nProvider.of(this).t(key, params: params);
}
