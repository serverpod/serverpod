import 'dart:typed_data';

import 'package:uuid/uuid.dart';

/// Adds clone method that create a deep copy of a ByteData.
extension _CloneByteData on ByteData {
  /// Creates a deep copy of the ByteData, mutations to the original will
  /// not affect the copy.
  ByteData clone() {
    Int8List uint8ListView = buffer.asInt8List();
    return Int8List.fromList(uint8ListView).buffer.asByteData(
          offsetInBytes,
          lengthInBytes,
        );
  }
}

/// List of types that are not mutable and therefore do not need to be
/// copied or handled in a copyWith method.
final noneMutableTypeNames =
    _noneMutableTypes.map((t) => t.toString()).toList();

/// List of types that has a clone method extension and therefore can be
/// copied by calling clone().
const clonableTypeNames = [
  'ByteData',
  'List',
  'Map',
];

const _noneMutableTypes = [
  Null,
  String,
  int,
  double,
  bool,
  DateTime,
  Duration,
  UuidValue,
];

/// Clones all types except `List` and `Map`, which can't be deep copied in a type safe manner.
/// See https://github.com/serverpod/serverpod/pull/2612 for more information.
T strictShallowClone<T>(T element) {
  if (_noneMutableTypes.contains(element.runtimeType)) {
    return element;
  }

  // Runtime type is never Enum but Enum is always inherited.
  if (element is Enum) return element;

  // Required as the extension with clone() is not found otherwise.
  if (element is ByteData) return element.clone() as T;
  if (element is List || element is Map) {
    throw UnimplementedError("Can't clone `List` or `Map` types");
  }

  return (element as dynamic).copyWith() as T;
}
