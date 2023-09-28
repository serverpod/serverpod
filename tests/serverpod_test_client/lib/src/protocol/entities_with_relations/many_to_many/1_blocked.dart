/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Blocked extends _i1.SerializableEntity {
  Blocked._({
    this.id,
    required this.blockerId,
    this.blocker,
    required this.blockeeId,
    this.blockee,
  });

  factory Blocked({
    int? id,
    required int blockerId,
    _i2.Author? blocker,
    required int blockeeId,
    _i2.Author? blockee,
  }) = _BlockedImpl;

  factory Blocked.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Blocked(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      blockerId:
          serializationManager.deserialize<int>(jsonSerialization['blockerId']),
      blocker: serializationManager
          .deserialize<_i2.Author?>(jsonSerialization['blocker']),
      blockeeId:
          serializationManager.deserialize<int>(jsonSerialization['blockeeId']),
      blockee: serializationManager
          .deserialize<_i2.Author?>(jsonSerialization['blockee']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int blockerId;

  _i2.Author? blocker;

  int blockeeId;

  _i2.Author? blockee;

  Blocked copyWith({
    int? id,
    int? blockerId,
    _i2.Author? blocker,
    int? blockeeId,
    _i2.Author? blockee,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'blockerId': blockerId,
      'blocker': blocker,
      'blockeeId': blockeeId,
      'blockee': blockee,
    };
  }
}

class _Undefined {}

class _BlockedImpl extends Blocked {
  _BlockedImpl({
    int? id,
    required int blockerId,
    _i2.Author? blocker,
    required int blockeeId,
    _i2.Author? blockee,
  }) : super._(
          id: id,
          blockerId: blockerId,
          blocker: blocker,
          blockeeId: blockeeId,
          blockee: blockee,
        );

  @override
  Blocked copyWith({
    Object? id = _Undefined,
    int? blockerId,
    Object? blocker = _Undefined,
    int? blockeeId,
    Object? blockee = _Undefined,
  }) {
    return Blocked(
      id: id is int? ? id : this.id,
      blockerId: blockerId ?? this.blockerId,
      blocker: blocker is _i2.Author? ? blocker : this.blocker?.copyWith(),
      blockeeId: blockeeId ?? this.blockeeId,
      blockee: blockee is _i2.Author? ? blockee : this.blockee?.copyWith(),
    );
  }
}
