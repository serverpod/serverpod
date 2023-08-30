/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database mapping for a read/write test that is performed by the default
/// health checks.
class ReadWriteTestEntry extends _i1.SerializableEntity {
  ReadWriteTestEntry({
    this.id,
    required this.number,
  });

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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// A random number, to verify that the write/read was performed correctly.
  int number;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
    };
  }
}
