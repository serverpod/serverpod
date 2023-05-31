/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ObjectWithUuid extends _i1.SerializableEntity {
  ObjectWithUuid({
    this.id,
    required this.uuid,
    this.uuidNullable,
  });

  factory ObjectWithUuid.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithUuid(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      uuid: serializationManager
          .deserialize<_i1.UuidValue>(jsonSerialization['uuid']),
      uuidNullable: serializationManager
          .deserialize<_i1.UuidValue?>(jsonSerialization['uuidNullable']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue uuid;

  _i1.UuidValue? uuidNullable;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'uuidNullable': uuidNullable,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ObjectWithUuid &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.uuid,
                  uuid,
                ) ||
                other.uuid == uuid) &&
            (identical(
                  other.uuidNullable,
                  uuidNullable,
                ) ||
                other.uuidNullable == uuidNullable));
  }

  @override
  int get hashCode => Object.hash(
        id,
        uuid,
        uuidNullable,
      );

  ObjectWithUuid copyWith({
    int? id,
    _i1.UuidValue? uuid,
    _i1.UuidValue? uuidNullable,
  }) {
    return ObjectWithUuid(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      uuidNullable: uuidNullable ?? this.uuidNullable,
    );
  }
}
