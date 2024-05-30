/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithUuid implements _i1.SerializableModel {
  ObjectWithUuid._({
    this.id,
    required this.uuid,
    this.uuidNullable,
  });

  factory ObjectWithUuid({
    int? id,
    required _i1.UuidValue uuid,
    _i1.UuidValue? uuidNullable,
  }) = _ObjectWithUuidImpl;

  factory ObjectWithUuid.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithUuid(
      id: jsonSerialization['id'] as int?,
      uuid: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['uuid']),
      uuidNullable: jsonSerialization['uuidNullable'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidNullable']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue uuid;

  _i1.UuidValue? uuidNullable;

  ObjectWithUuid copyWith({
    int? id,
    _i1.UuidValue? uuid,
    _i1.UuidValue? uuidNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'uuid': uuid.toJson(),
      if (uuidNullable != null) 'uuidNullable': uuidNullable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithUuidImpl extends ObjectWithUuid {
  _ObjectWithUuidImpl({
    int? id,
    required _i1.UuidValue uuid,
    _i1.UuidValue? uuidNullable,
  }) : super._(
          id: id,
          uuid: uuid,
          uuidNullable: uuidNullable,
        );

  @override
  ObjectWithUuid copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? uuid,
    Object? uuidNullable = _Undefined,
  }) {
    return ObjectWithUuid(
      id: id is int? ? id : this.id,
      uuid: uuid ?? this.uuid,
      uuidNullable:
          uuidNullable is _i1.UuidValue? ? uuidNullable : this.uuidNullable,
    );
  }
}
