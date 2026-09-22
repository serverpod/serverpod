/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import '../../../models_with_relations/self_relation/many_to_many/member.dart'
    as _iubhvl5a;

abstract class Blocking
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _iubhvl5a.Member? blocked,
    required int blockedById,
    _iubhvl5a.Member? blockedBy,
  }) = _BlockingImpl;

  factory Blocking.fromJson(Map<String, dynamic> jsonSerialization) {
    return Blocking(
      id: jsonSerialization['id'] as int?,
      blockedId: jsonSerialization['blockedId'] as int,
      blocked: jsonSerialization['blocked'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iubhvl5a.Member>(
              jsonSerialization['blocked'],
            ),
      blockedById: jsonSerialization['blockedById'] as int,
      blockedBy: jsonSerialization['blockedBy'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iubhvl5a.Member>(
              jsonSerialization['blockedBy'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int blockedId;

  _iubhvl5a.Member? blocked;

  int blockedById;

  _iubhvl5a.Member? blockedBy;

  /// Returns a shallow copy of this [Blocking]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Blocking copyWith({
    int? id,
    int? blockedId,
    _iubhvl5a.Member? blocked = const _UndefinedBlocking$blocked(),
    int? blockedById,
    _iubhvl5a.Member? blockedBy = const _UndefinedBlocking$blockedBy(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Blocking',
      if (id != null) 'id': id,
      'blockedId': blockedId,
      if (blocked != null) 'blocked': blocked?.toJson(),
      'blockedById': blockedById,
      if (blockedBy != null) 'blockedBy': blockedBy?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Blocking',
      if (id != null) 'id': id,
      'blockedId': blockedId,
      if (blocked != null) 'blocked': blocked?.toJsonForProtocol(),
      'blockedById': blockedById,
      if (blockedBy != null) 'blockedBy': blockedBy?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedBlocking$blocked extends _isc.UndefinedSentinel
    implements _iubhvl5a.Member {
  const _UndefinedBlocking$blocked();
}

class _UndefinedBlocking$blockedBy extends _isc.UndefinedSentinel
    implements _iubhvl5a.Member {
  const _UndefinedBlocking$blockedBy();
}

class _BlockingImpl extends Blocking {
  _BlockingImpl({
    int? id,
    required int blockedId,
    _iubhvl5a.Member? blocked,
    required int blockedById,
    _iubhvl5a.Member? blockedBy,
  }) : super._(
         id: id,
         blockedId: blockedId,
         blocked: blocked,
         blockedById: blockedById,
         blockedBy: blockedBy,
       );

  /// Returns a shallow copy of this [Blocking]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Blocking copyWith({
    Object? id = _Undefined,
    int? blockedId,
    _iubhvl5a.Member? blocked = const _UndefinedBlocking$blocked(),
    int? blockedById,
    _iubhvl5a.Member? blockedBy = const _UndefinedBlocking$blockedBy(),
  }) {
    return Blocking(
      id: id is int? ? id : this.id,
      blockedId: blockedId ?? this.blockedId,
      blocked: blocked is _isc.UndefinedSentinel
          ? this.blocked?.copyWith()
          : blocked,
      blockedById: blockedById ?? this.blockedById,
      blockedBy: blockedBy is _isc.UndefinedSentinel
          ? this.blockedBy?.copyWith()
          : blockedBy,
    );
  }
}
