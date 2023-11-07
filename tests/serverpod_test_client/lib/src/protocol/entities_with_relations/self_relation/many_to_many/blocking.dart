/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Blocking extends _i1.SerializableEntity {
  Blocking._({
    this.id,
    required this.blockingId,
    this.blocking,
    required this.blockedById,
    this.blockedBy,
  });

  factory Blocking({
    int? id,
    required int blockingId,
    _i2.Member? blocking,
    required int blockedById,
    _i2.Member? blockedBy,
  }) = _BlockingImpl;

  factory Blocking.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Blocking(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      blockingId: serializationManager
          .deserialize<int>(jsonSerialization['blockingId']),
      blocking: serializationManager
          .deserialize<_i2.Member?>(jsonSerialization['blocking']),
      blockedById: serializationManager
          .deserialize<int>(jsonSerialization['blockedById']),
      blockedBy: serializationManager
          .deserialize<_i2.Member?>(jsonSerialization['blockedBy']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int blockingId;

  _i2.Member? blocking;

  int blockedById;

  _i2.Member? blockedBy;

  Blocking copyWith({
    int? id,
    int? blockingId,
    _i2.Member? blocking,
    int? blockedById,
    _i2.Member? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockingId': blockingId,
      'blocking': blocking,
      'blockedById': blockedById,
      'blockedBy': blockedBy,
    };
  }
}

class _Undefined {}

class _BlockingImpl extends Blocking {
  _BlockingImpl({
    int? id,
    required int blockingId,
    _i2.Member? blocking,
    required int blockedById,
    _i2.Member? blockedBy,
  }) : super._(
          id: id,
          blockingId: blockingId,
          blocking: blocking,
          blockedById: blockedById,
          blockedBy: blockedBy,
        );

  @override
  Blocking copyWith({
    Object? id = _Undefined,
    int? blockingId,
    Object? blocking = _Undefined,
    int? blockedById,
    Object? blockedBy = _Undefined,
  }) {
    return Blocking(
      id: id is int? ? id : this.id,
      blockingId: blockingId ?? this.blockingId,
      blocking: blocking is _i2.Member? ? blocking : this.blocking?.copyWith(),
      blockedById: blockedById ?? this.blockedById,
      blockedBy:
          blockedBy is _i2.Member? ? blockedBy : this.blockedBy?.copyWith(),
    );
  }
}
