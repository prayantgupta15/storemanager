import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoLocalization {
  final Locale locale;
  DemoLocalization(this.locale);

  static DemoLocalization of(BuildContext context) {
    return Localizations.of<DemoLocalization>(context, DemoLocalization);
  }

  Map<String, String> _localizedValues;

  Future load() async {
    print("loading json files for " + locale.languageCode);
    String jsonStringValues =
        await rootBundle.loadString('lib/lang/${locale.languageCode}.json');

    Map<String, dynamic> fromJson = json.decode(jsonStringValues);
    print(locale.languageCode + fromJson.length.toString());
    _localizedValues =
        fromJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslatedValue(String key) {
    return _localizedValues[key];
  }

  static const LocalizationsDelegate<DemoLocalization> delegate =
      _DemoLocalizationDelegate();
}

class _DemoLocalizationDelegate
    extends LocalizationsDelegate<DemoLocalization> {
  const _DemoLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'hi', 'fr', 'es'].contains(locale.languageCode);
  }

  @override
  Future<DemoLocalization> load(Locale locale) async {
    print("loading demo");
    DemoLocalization localization = DemoLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_DemoLocalizationDelegate old) => false;
}
