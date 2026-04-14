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

abstract class TaskClaim implements _i1.SerializableModel {
  TaskClaim._({
    this.id,
    required this.server,
  });

  factory TaskClaim({
    int? id,
    required String server,
  }) = _TaskClaimImpl;

  factory TaskClaim.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskClaim(
      id: jsonSerialization['id'] as int?,
      server: jsonSerialization['server'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String server;

  /// Returns a shallow copy of this [TaskClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskClaim copyWith({
    int? id,
    String? server,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskClaim',
      if (id != null) 'id': id,
      'server': server,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskClaimImpl extends TaskClaim {
  _TaskClaimImpl({
    int? id,
    required String server,
  }) : super._(
         id: id,
         server: server,
       );

  /// Returns a shallow copy of this [TaskClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskClaim copyWith({
    Object? id = _Undefined,
    String? server,
  }) {
    return TaskClaim(
      id: id is int? ? id : this.id,
      server: server ?? this.server,
    );
  }
}
