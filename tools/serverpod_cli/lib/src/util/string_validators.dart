class StringValidators {
  static final _pascalCaseTester =
      RegExp(r'^([A-Z][a-z0-9]+)((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?$');
  static final _camelCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?$');
  static final _snakeCaseTester = RegExp(r'^[a-z]+[a-z0-9_]*$');
  static final _mixedSnakeCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9_][a-z0-9_]+))*([A-Z])?$');
  static final _lowerCaseWithDashesTester =
      RegExp(r'^[a-z0-9]+([-][a-z0-9]+)*$');

  static bool isValidFieldName(String name) =>
      _camelCaseTester.hasMatch(name) || _snakeCaseTester.hasMatch(name);

  static bool isValidClassName(String name) => _pascalCaseTester.hasMatch(name);

  static bool isValidTableName(String name) => _snakeCaseTester.hasMatch(name);

  static bool isValidTableIndexName(String name) =>
      _mixedSnakeCaseTester.hasMatch(name);

  static bool isValidTagName(String name) =>
      _lowerCaseWithDashesTester.hasMatch(name);

  /// This function with regex, that will let you allow only name starting with smalls
  /// and contains only `_` special char and ending with smalls or numbers
  static bool isValidProjectName(String name) =>
      RegExp(r'^[a-z]+(?:[0-9a-z]+|_[0-9a-z]+)*$').hasMatch(name);
}
