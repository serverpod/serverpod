/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Blocking extends _i1.SerializableEntity {
  Blocking._({
    this.id,
    required this.blockedId,
    this.blocked,
    required this.blockedById,
    this.blockedBy,
  });

  factory Blocking({
    int? id,
    required int blockedId,
    _i2.Member? blocked,
    required int blockedById,
    _i2.Member? blockedBy,
  }) = _BlockingImpl;

  factory Blocking.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Blocking(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      blockedId:
          serializationManager.deserialize<int>(jsonSerialization['blockedId']),
      blocked: serializationManager
          .deserialize<_i2.Member?>(jsonSerialization['blocked']),
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

  int blockedId;

  _i2.Member? blocked;

  int blockedById;

  _i2.Member? blockedBy;

  Blocking copyWith({
    int? id,
    int? blockedId,
    _i2.Member? blocked,
    int? blockedById,
    _i2.Member? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockedId': blockedId,
      'blocked': blocked,
      'blockedById': blockedById,
      'blockedBy': blockedBy,
    };
  }
}

class _Undefined {}

class _BlockingImpl extends Blocking {
  _BlockingImpl({
    int? id,
    required int blockedId,
    _i2.Member? blocked,
    required int blockedById,
    _i2.Member? blockedBy,
  }) : super._(
          id: id,
          blockedId: blockedId,
          blocked: blocked,
          blockedById: blockedById,
          blockedBy: blockedBy,
        );

  @override
  Blocking copyWith({
    Object? id = _Undefined,
    int? blockedId,
    Object? blocked = _Undefined,
    int? blockedById,
    Object? blockedBy = _Undefined,
  }) {
    return Blocking(
      id: id is int? ? id : this.id,
      blockedId: blockedId ?? this.blockedId,
      blocked: blocked is _i2.Member? ? blocked : this.blocked?.copyWith(),
      blockedById: blockedById ?? this.blockedById,
      blockedBy:
          blockedBy is _i2.Member? ? blockedBy : this.blockedBy?.copyWith(),
    );
  }
}
