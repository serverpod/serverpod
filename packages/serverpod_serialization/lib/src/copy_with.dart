import 'dart:typed_data';

import 'package:uuid/uuid.dart';

/// Adds clone method that create a deep copy of a ByteData.
extension CloneByteData on ByteData {
  /// Creates a deep copy of the ByteData, mutations to the original will
  /// not affect the copy.
  ByteData clone() {
    Int8List uint8ListView = buffer.asInt8List();
    return Int8List.fromList(uint8ListView).buffer.asByteData();
  }
}

/// Adds clone method that create a deep copy of a list.
extension CloneList on List {
  /// Creates a deep copy of the List, mutations to the original will
  /// not affect the copy.
  List<T> clone<T>() {
    return map((e) => _guardedCopyWith(e)).whereType<T>().toList();
  }
}

/// Adds clone method that create a deep copy of a map.
extension CloneMap on Map {
  /// Creates a deep copy of the Map, mutations to the original will
  /// not affect the copy.
  Map<K, V> clone<K, V>() {
    return map((key, value) => MapEntry(key, _guardedCopyWith(value)))
        .cast<K, V>();
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

dynamic _guardedCopyWith(dynamic element) {
  if (_noneMutableTypes.contains(element.runtimeType)) {
    return element;
  }

  // Runtime type is never Enum but Enum is always inherited.
  if (element is Enum) return element;

  // Required as the extension with clone() is not found otherwise.
  if (element is ByteData) return element.clone();
  if (element is List) return element.clone();
  if (element is Map) return element.clone();

  try {
    return element.copyWith();
  } on NoSuchMethodError {
    throw 'No copyWith method found on ${element.runtimeType}';
  }
}
