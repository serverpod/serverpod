class StringValidators {
  static final _upperCamelCaseTester =
      RegExp(r'^([A-Z][a-z0-9]+)((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?$');
  static final _lowerCamelCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?$');
  static final _lowerSnakeCaseTester = RegExp(r'^[a-z]+[a-z0-9_]*$');
  static final _mixedSnakeCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9_][a-z0-9_]+))*([A-Z])?$');

  static bool isValidFieldName(String name) =>
      _lowerCamelCaseTester.hasMatch(name);

  static bool isValidClassName(String name) =>
      _upperCamelCaseTester.hasMatch(name);

  static bool isValidTableName(String name) =>
      _lowerSnakeCaseTester.hasMatch(name);

  static bool isValidViewName(String name) =>
      _lowerSnakeCaseTester.hasMatch(name);

  static bool isValidTableIndexName(String name) =>
      _mixedSnakeCaseTester.hasMatch(name);
}
