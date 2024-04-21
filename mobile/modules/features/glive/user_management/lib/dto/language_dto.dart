class LanguageDto {
  /// the country code (US,VN..)
  String? code;

  /// the locale (en, vi)
  String? locale;

  /// the full name of language (English, Danish..)
  String? language;

  /// map of keys used based on industry type (service worker, route etc)
  Map<String, String>? dictionary;

  LanguageDto({this.code, this.locale, this.language, this.dictionary});
}
