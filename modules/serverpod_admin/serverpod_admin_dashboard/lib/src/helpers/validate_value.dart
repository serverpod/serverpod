String? validateValue(
  String? raw,
  bool requiresValue,
  String typeToken,
  bool isDateType,
) {
  final value = raw?.trim() ?? '';
  if (requiresValue && value.isEmpty) {
    return 'Required';
  }
  if (value.isEmpty) return null;

  switch (typeToken) {
    case 'int':
    case 'integer':
    case 'bigint':
    case 'smallint':
      return int.tryParse(value) == null ? 'Enter a valid integer.' : null;
    case 'double':
    case 'decimal':
    case 'float':
    case 'numeric':
      return double.tryParse(value) == null ? 'Enter a valid number.' : null;
    case 'bool':
    case 'boolean':
      final lowered = value.toLowerCase();
      return ['true', 'false', '1', '0', 'yes', 'no'].contains(lowered)
          ? null
          : 'Enter true/false.';
    default:
      if (isDateType && DateTime.tryParse(value) == null) {
        return 'Pick a valid date & time.';
      }
      return null;
  }
}
