class StringValidators {
  static final _pascalCaseTester =
      RegExp(r'^[A-Z][a-zA-Z0-9]*((?<=.)([A-Z][a-z0-9]*)+)?$');
  static final _pascalCaseWithUppercaseTester =
      RegExp(r'^[A-Z]([A-Z0-9]*[a-z0-9]*)*([A-Z])?$');
  static final _camelCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?$');
  static final _camelCaseWithUppercaseTester =
      RegExp(r'^[a-z]+([A-Z][a-z0-9]*)*$');
  static final _snakeCaseTester = RegExp(r'^[a-z]+[a-z0-9_]*$');
  static final _mixedSnakeCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9_][a-z0-9_]+))*([A-Z])?$');
  static final _lowerCaseWithDashesTester =
      RegExp(r'^[a-z0-9]+([-][a-z0-9]+)*$');
  static final _fullUpperCaseTester = RegExp(r'^[A-Z]+$');

  static bool isValidFieldName(String name) {
    if (name.length == 1) return true;
    if (_camelCaseTester.hasMatch(name)) return true;
    if (_camelCaseWithUppercaseTester.hasMatch(name)) return true;

    return false;
  }

  static bool isInvalidFieldValueInfoSeverity(String name) {
    if (isValidFieldName(name)) return false;

    if (_fullUpperCaseTester.hasMatch(name)) return true;
    if (_pascalCaseTester.hasMatch(name)) return true;
    if (_snakeCaseTester.hasMatch(name)) return true;

    return false;
  }

  static bool isValidFieldType(String type) =>
      RegExp(r'^([a-zA-Z_:][a-zA-Z0-9_:]*\??)$').hasMatch(type);

  static bool isValidClassName(String name) =>
      _pascalCaseWithUppercaseTester.hasMatch(name);

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
