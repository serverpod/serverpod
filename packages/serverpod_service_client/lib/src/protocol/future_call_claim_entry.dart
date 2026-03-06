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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Bindings to a future call claim entry in the database.
abstract class FutureCallClaimEntry implements _i1.SerializableModel {
  FutureCallClaimEntry._({
    this.id,
    this.futureCallId,
    required this.time,
    required this.serverId,
  });

  factory FutureCallClaimEntry({
    int? id,
    int? futureCallId,
    required DateTime time,
    required String serverId,
  }) = _FutureCallClaimEntryImpl;

  factory FutureCallClaimEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FutureCallClaimEntry(
      id: jsonSerialization['id'] as int?,
      futureCallId: jsonSerialization['futureCallId'] as int?,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      serverId: jsonSerialization['serverId'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the future call this claim entry is associated with
  int? futureCallId;

  /// Timestamp of this claim entry
  DateTime time;

  /// The id of the server where the claim was created.
  String serverId;

  /// Returns a shallow copy of this [FutureCallClaimEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FutureCallClaimEntry copyWith({
    int? id,
    int? futureCallId,
    DateTime? time,
    String? serverId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.FutureCallClaimEntry',
      if (id != null) 'id': id,
      if (futureCallId != null) 'futureCallId': futureCallId,
      'time': time.toJson(),
      'serverId': serverId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FutureCallClaimEntryImpl extends FutureCallClaimEntry {
  _FutureCallClaimEntryImpl({
    int? id,
    int? futureCallId,
    required DateTime time,
    required String serverId,
  }) : super._(
         id: id,
         futureCallId: futureCallId,
         time: time,
         serverId: serverId,
       );

  /// Returns a shallow copy of this [FutureCallClaimEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FutureCallClaimEntry copyWith({
    Object? id = _Undefined,
    Object? futureCallId = _Undefined,
    DateTime? time,
    String? serverId,
  }) {
    return FutureCallClaimEntry(
      id: id is int? ? id : this.id,
      futureCallId: futureCallId is int? ? futureCallId : this.futureCallId,
      time: time ?? this.time,
      serverId: serverId ?? this.serverId,
    );
  }
}
