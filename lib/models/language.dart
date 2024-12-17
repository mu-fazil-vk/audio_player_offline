class LanguageModel {
  final String name;
  final String code;
  final String? englishName;
  final String? countryCode;
  LanguageModel({
    required this.name,
    required this.code,
    this.englishName,
    this.countryCode,
  });
}
