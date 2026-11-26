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
import 'package:auth_client/src/protocol/protocol.dart' as _id9sbq8j;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// A user click event recorded by the example counter.
abstract class Click
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Click._({
    this.id,
    required this.authUserId,
    this.authUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Click({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    DateTime? timestamp,
  }) = _ClickImpl;

  factory Click.fromJson(Map<String, dynamic> jsonSerialization) {
    return Click(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _id9sbq8j.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  /// The [AuthUser] that recorded this click.
  _iacc.AuthUser? authUser;

  /// The timestamp when the click occurred.
  DateTime timestamp;

  /// Returns a shallow copy of this [Click]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Click copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser = const _UndefinedClick$authUser(),
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Click',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Click',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedClick$authUser extends _isc.UndefinedSentinel
    implements _iacc.AuthUser {
  const _UndefinedClick$authUser();
}

class _ClickImpl extends Click {
  _ClickImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    DateTime? timestamp,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [Click]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Click copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser = const _UndefinedClick$authUser(),
    DateTime? timestamp,
  }) {
    return Click(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _isc.UndefinedSentinel
          ? this.authUser?.copyWith()
          : authUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
