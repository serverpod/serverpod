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

/// Database table for tracking failed anonymous sign-ins. Saves IP-address,
/// time, and email to be prevent brute force attacks.
abstract class AnonymousFailedSignIn implements _i1.SerializableModel {
  AnonymousFailedSignIn._({
    this.id,
    required this.userId,
    required this.time,
    required this.ipAddress,
  });

  factory AnonymousFailedSignIn({
    int? id,
    required int userId,
    required DateTime time,
    required String ipAddress,
  }) = _AnonymousFailedSignInImpl;

  factory AnonymousFailedSignIn.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return AnonymousFailedSignIn(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      ipAddress: jsonSerialization['ipAddress'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// UserId attempting to sign in with.
  int userId;

  /// The time of the sign in attempt.
  DateTime time;

  /// The IP address of the sign in attempt.
  String ipAddress;

  /// Returns a shallow copy of this [AnonymousFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AnonymousFailedSignIn copyWith({
    int? id,
    int? userId,
    DateTime? time,
    String? ipAddress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'time': time.toJson(),
      'ipAddress': ipAddress,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AnonymousFailedSignInImpl extends AnonymousFailedSignIn {
  _AnonymousFailedSignInImpl({
    int? id,
    required int userId,
    required DateTime time,
    required String ipAddress,
  }) : super._(
          id: id,
          userId: userId,
          time: time,
          ipAddress: ipAddress,
        );

  /// Returns a shallow copy of this [AnonymousFailedSignIn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AnonymousFailedSignIn copyWith({
    Object? id = _Undefined,
    int? userId,
    DateTime? time,
    String? ipAddress,
  }) {
    return AnonymousFailedSignIn(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
