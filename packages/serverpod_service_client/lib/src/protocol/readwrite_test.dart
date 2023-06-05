/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database mapping for a read/write test that is performed by the default
/// health checks.
abstract class ReadWriteTestEntry extends _i1.SerializableEntity {
  const ReadWriteTestEntry._();

  const factory ReadWriteTestEntry({
    int? id,
    required int number,
  }) = _ReadWriteTestEntry;

  factory ReadWriteTestEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ReadWriteTestEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      number:
          serializationManager.deserialize<int>(jsonSerialization['number']),
    );
  }

  ReadWriteTestEntry copyWith({
    int? id,
    int? number,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// A random number, to verify that the write/read was performed correctly.
  int get number;
}

class _Undefined {}

/// Database mapping for a read/write test that is performed by the default
/// health checks.
class _ReadWriteTestEntry extends ReadWriteTestEntry {
  const _ReadWriteTestEntry({
    this.id,
    required this.number,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// A random number, to verify that the write/read was performed correctly.
  @override
  final int number;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ReadWriteTestEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.number,
                  number,
                ) ||
                other.number == number));
  }

  @override
  int get hashCode => Object.hash(
        id,
        number,
      );

  @override
  ReadWriteTestEntry copyWith({
    Object? id = _Undefined,
    int? number,
  }) {
    return ReadWriteTestEntry(
      id: id == _Undefined ? this.id : (id as int?),
      number: number ?? this.number,
    );
  }
}
