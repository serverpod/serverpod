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
    required this.heartbeat,
  });

  factory FutureCallClaimEntry({
    int? id,
    int? futureCallId,
    required DateTime heartbeat,
  }) = _FutureCallClaimEntryImpl;

  factory FutureCallClaimEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FutureCallClaimEntry(
      id: jsonSerialization['id'] as int?,
      futureCallId: jsonSerialization['futureCallId'] as int?,
      heartbeat: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['heartbeat'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the future call this claim entry is associated with
  int? futureCallId;

  /// Heartbeat timestamp for this claim entry.
  /// Used to detect stale claims that should be cleaned up.
  DateTime heartbeat;

  /// Returns a shallow copy of this [FutureCallClaimEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FutureCallClaimEntry copyWith({
    int? id,
    int? futureCallId,
    DateTime? heartbeat,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.FutureCallClaimEntry',
      if (id != null) 'id': id,
      if (futureCallId != null) 'futureCallId': futureCallId,
      'heartbeat': heartbeat.toJson(),
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
    required DateTime heartbeat,
  }) : super._(
         id: id,
         futureCallId: futureCallId,
         heartbeat: heartbeat,
       );

  /// Returns a shallow copy of this [FutureCallClaimEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FutureCallClaimEntry copyWith({
    Object? id = _Undefined,
    Object? futureCallId = _Undefined,
    DateTime? heartbeat,
  }) {
    return FutureCallClaimEntry(
      id: id is int? ? id : this.id,
      futureCallId: futureCallId is int? ? futureCallId : this.futureCallId,
      heartbeat: heartbeat ?? this.heartbeat,
    );
  }
}
