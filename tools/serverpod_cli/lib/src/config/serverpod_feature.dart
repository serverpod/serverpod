enum ServerpodFeature {
  database(defaultValue: true, missingFileDefault: false);

  const ServerpodFeature({
    required this.defaultValue,
    required this.missingFileDefault,
  });
  final bool defaultValue;
  final bool missingFileDefault;
}
