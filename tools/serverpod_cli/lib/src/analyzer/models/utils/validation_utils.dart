/// The Dart types that are supported for serialization.
const whiteListedTypes = [
  'String',
  'bool',
  'int',
  'double',
  'DateTime',
  'Duration',
  'UuidValue',
  'Uri',
  'BigInt',
  'ByteData',
  'Vector',
  'HalfVector',
  'SparseVector',
  'Bit',
  'List',
  'Map',
  'Set',
];

/// Checks whether [type] is supported for serialization.
bool isValidSerializableDartType(String type) {
  return whiteListedTypes.contains(type);
}
