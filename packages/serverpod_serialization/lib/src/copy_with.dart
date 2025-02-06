import 'dart:typed_data';

import 'package:uuid/uuid.dart';

/// Adds clone method that create a deep copy of a ByteData.
extension CloneByteData on ByteData {
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
final nonMutableTypeNames = _nonMutableTypes.map((t) => t.toString()).toList();

/// List of types that has a clone method extension and therefore can be
/// copied by calling clone().
const hasCloneExtensionTypes = [
  'ByteData',
];

const _nonMutableTypes = [
  Null,
  String,
  int,
  double,
  bool,
  DateTime,
  Duration,
  UuidValue,
  BigInt,
];
