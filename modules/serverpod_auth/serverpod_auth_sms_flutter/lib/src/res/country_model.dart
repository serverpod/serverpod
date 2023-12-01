class CountryModel {
  String e164Cc;
  String iso2Cc;
  int e164Sc;
  bool geographic;
  int level;
  String name;
  String example;
  String displayName;
  String? fullExampleWithPlusSign;
  String displayNameNoE164Cc;
  String e164Key;

  CountryModel({
    required this.e164Cc,
    required this.iso2Cc,
    required this.e164Sc,
    required this.geographic,
    required this.level,
    required this.name,
    required this.example,
    required this.displayName,
    required this.fullExampleWithPlusSign,
    required this.displayNameNoE164Cc,
    required this.e164Key,
  });
}
