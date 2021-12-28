import 'package:weather/weather.dart';

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty || this == null) return this;

    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

Map<Language, String> _languageCode = {
  Language.AFRIKAANS: 'af',
  Language.ALBANIAN: 'al',
  Language.ARABIC: 'ar',
  Language.AZERBAIJANI: 'az',
  Language.BULGARIAN: 'bg',
  Language.CATALAN: 'ca',
  Language.CZECH: 'cz',
  Language.DANISH: 'da',
  Language.GERMAN: 'de',
  Language.GREEK: 'el',
  Language.ENGLISH: 'en',
  Language.BASQUE: 'eu',
  Language.PERSIAN: 'fa',
  Language.FARSI: 'fa',
  Language.FINNISH: 'fi',
  Language.FRENCH: 'fr',
  Language.GALICIAN: 'gl',
  Language.HEBREW: 'he',
  Language.HINDI: 'hi',
  Language.CROATIAN: 'hr',
  Language.HUNGARIAN: 'hu',
  Language.INDONESIAN: 'id',
  Language.ITALIAN: 'it',
  Language.JAPANESE: 'ja',
  Language.KOREAN: 'kr',
  Language.LATVIAN: 'la',
  Language.LITHUANIAN: 'lt',
  Language.MACEDONIAN: 'mk',
  Language.NORWEGIAN: 'no',
  Language.DUTCH: 'nl',
  Language.POLISH: 'pl',
  Language.PORTUGUESE: 'pt',
  Language.PORTUGUESE_BRAZIL: 'pt_br',
  Language.ROMANIAN: 'ro',
  Language.RUSSIAN: 'ru',
  Language.SWEDISH: 'sv',
  Language.SLOVAK: 'sk',
  Language.SLOVENIAN: 'sl',
  Language.SPANISH: 'sp',
  Language.SERBIAN: 'sr',
  Language.THAI: 'th',
  Language.TURKISH: 'tr',
  Language.UKRAINIAN: 'ua',
  Language.VIETNAMESE: 'vi',
  Language.CHINESE_SIMPLIFIED: 'zh_cn',
  Language.CHINESE_TRADITIONAL: 'zh_tw',
  Language.ZULU: 'zu',
};

Language languageFromCode(String code) {
  for (var entry in _languageCode.entries) {
    if (entry.value == code) return entry.key;
  }

  return Language.ENGLISH;
}
