/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Database table for tracking failed email sign-ins. Saves IP-address, time,
/// and email to be prevent brute force attacks.
abstract class EmailFailedSignIn extends _i1.SerializableEntity {
  const EmailFailedSignIn._();

  const factory EmailFailedSignIn({
    int? id,
    required String email,
    required DateTime time,
    required String ipAddress,
  }) = _EmailFailedSignIn;

  factory EmailFailedSignIn.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return EmailFailedSignIn(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      email:
          serializationManager.deserialize<String>(jsonSerialization['email']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      ipAddress: serializationManager
          .deserialize<String>(jsonSerialization['ipAddress']),
    );
  }

  EmailFailedSignIn copyWith({
    int? id,
    String? email,
    DateTime? time,
    String? ipAddress,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// Email attempting to sign in with.
  String get email;

  /// The time of the sign in attempt.
  DateTime get time;

  /// The IP address of the sign in attempt.
  String get ipAddress;
}

class _Undefined {}

/// Database table for tracking failed email sign-ins. Saves IP-address, time,
/// and email to be prevent brute force attacks.
class _EmailFailedSignIn extends EmailFailedSignIn {
  const _EmailFailedSignIn({
    this.id,
    required this.email,
    required this.time,
    required this.ipAddress,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// Email attempting to sign in with.
  @override
  final String email;

  /// The time of the sign in attempt.
  @override
  final DateTime time;

  /// The IP address of the sign in attempt.
  @override
  final String ipAddress;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'time': time,
      'ipAddress': ipAddress,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is EmailFailedSignIn &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.email,
                  email,
                ) ||
                other.email == email) &&
            (identical(
                  other.time,
                  time,
                ) ||
                other.time == time) &&
            (identical(
                  other.ipAddress,
                  ipAddress,
                ) ||
                other.ipAddress == ipAddress));
  }

  @override
  int get hashCode => Object.hash(
        id,
        email,
        time,
        ipAddress,
      );

  @override
  EmailFailedSignIn copyWith({
    Object? id = _Undefined,
    String? email,
    DateTime? time,
    String? ipAddress,
  }) {
    return EmailFailedSignIn(
      id: id == _Undefined ? this.id : (id as int?),
      email: email ?? this.email,
      time: time ?? this.time,
      ipAddress: ipAddress ?? this.ipAddress,
    );
  }
}
