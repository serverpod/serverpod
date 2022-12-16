class StringValidators {
  static final _pascalCaseTester =
      RegExp(r'^([A-Z][a-z0-9]+)((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?$');
  static final _camelCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9][a-z0-9]+))*([A-Z])?$');
  static final _snakeCaseTester = RegExp(r'^[a-z]+[a-z0-9_]*$');
  static final _mixedSnakeCaseTester =
      RegExp(r'^[a-z]+((\d)|([A-Z0-9_][a-z0-9_]+))*([A-Z])?$');

  static bool isValidFieldName(String name) =>
      _camelCaseTester.hasMatch(name) || _snakeCaseTester.hasMatch(name);

  static bool isValidClassName(String name) => _pascalCaseTester.hasMatch(name);

  static bool isValidTableName(String name) => _snakeCaseTester.hasMatch(name);

  static bool isValidTableIndexName(String name) =>
      _mixedSnakeCaseTester.hasMatch(name);
}
