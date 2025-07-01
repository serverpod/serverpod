/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A serialized future call with bindings to the database.
abstract class FutureCallEntry implements _i1.SerializableModel {
  FutureCallEntry._({
    this.id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
    this.identifier,
    String? status,
    int? retryCount,
    this.lastError,
    this.createdAt,
    this.updatedAt,
  })  : status = status ?? 'pending',
        retryCount = retryCount ?? 0;

  factory FutureCallEntry({
    int? id,
    required String name,
    required DateTime time,
    String? serializedObject,
    required String serverId,
    String? identifier,
    String? status,
    int? retryCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FutureCallEntryImpl;

  factory FutureCallEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return FutureCallEntry(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      serializedObject: jsonSerialization['serializedObject'] as String?,
      serverId: jsonSerialization['serverId'] as String,
      identifier: jsonSerialization['identifier'] as String?,
      status: jsonSerialization['status'] as String?,
      retryCount: jsonSerialization['retryCount'] as int?,
      lastError: jsonSerialization['lastError'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Name of the future call. Used to find the correct method to call.
  String name;

  /// Time to execute the call.
  DateTime time;

  /// The serialized object, used as a parameter to the call.
  String? serializedObject;

  /// The id of the server where the call was created.
  String serverId;

  /// An optional identifier which can be used to cancel the call.
  String? identifier;

  /// Current state of the job. Possible values: pending, running, completed, failed, paused, canceled.
  String? status;

  /// Number of times the job has been retried, either manually or programmatically.
  int? retryCount;

  /// Stores the error message from the last failed execution, if any.
  String? lastError;

  /// Timestamp of when the job was created.
  DateTime? createdAt;

  /// Timestamp of the last update to the job (status change, retry, error, etc.).
  DateTime? updatedAt;

  /// Returns a shallow copy of this [FutureCallEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FutureCallEntry copyWith({
    int? id,
    String? name,
    DateTime? time,
    String? serializedObject,
    String? serverId,
    String? identifier,
    String? status,
    int? retryCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'time': time.toJson(),
      if (serializedObject != null) 'serializedObject': serializedObject,
      'serverId': serverId,
      if (identifier != null) 'identifier': identifier,
      if (status != null) 'status': status,
      if (retryCount != null) 'retryCount': retryCount,
      if (lastError != null) 'lastError': lastError,
      if (createdAt != null) 'createdAt': createdAt?.toJson(),
      if (updatedAt != null) 'updatedAt': updatedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FutureCallEntryImpl extends FutureCallEntry {
  _FutureCallEntryImpl({
    int? id,
    required String name,
    required DateTime time,
    String? serializedObject,
    required String serverId,
    String? identifier,
    String? status,
    int? retryCount,
    String? lastError,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
          id: id,
          name: name,
          time: time,
          serializedObject: serializedObject,
          serverId: serverId,
          identifier: identifier,
          status: status,
          retryCount: retryCount,
          lastError: lastError,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [FutureCallEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FutureCallEntry copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? time,
    Object? serializedObject = _Undefined,
    String? serverId,
    Object? identifier = _Undefined,
    Object? status = _Undefined,
    Object? retryCount = _Undefined,
    Object? lastError = _Undefined,
    Object? createdAt = _Undefined,
    Object? updatedAt = _Undefined,
  }) {
    return FutureCallEntry(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      time: time ?? this.time,
      serializedObject: serializedObject is String?
          ? serializedObject
          : this.serializedObject,
      serverId: serverId ?? this.serverId,
      identifier: identifier is String? ? identifier : this.identifier,
      status: status is String? ? status : this.status,
      retryCount: retryCount is int? ? retryCount : this.retryCount,
      lastError: lastError is String? ? lastError : this.lastError,
      createdAt: createdAt is DateTime? ? createdAt : this.createdAt,
      updatedAt: updatedAt is DateTime? ? updatedAt : this.updatedAt,
    );
  }
}
