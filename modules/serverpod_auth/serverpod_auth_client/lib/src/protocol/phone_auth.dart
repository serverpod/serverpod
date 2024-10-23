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

/// Database bindings for a sign in with phone number.
abstract class PhoneAuth implements _i1.SerializableModel {
  PhoneAuth._({
    this.id,
    required this.userId,
    required this.phoneNumber,
    required this.hash,
  });

  factory PhoneAuth({
    int? id,
    required int userId,
    required String phoneNumber,
    required String hash,
  }) = _PhoneAuthImpl;

  factory PhoneAuth.fromJson(Map<String, dynamic> jsonSerialization) {
    return PhoneAuth(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      hash: jsonSerialization['hash'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The id of the user, corresponds to the id field in [UserInfo].
  int userId;

  /// The phone number of the user.
  String phoneNumber;

  /// The hashed password of the user.
  String hash;

  PhoneAuth copyWith({
    int? id,
    int? userId,
    String? phoneNumber,
    String? hash,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'hash': hash,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PhoneAuthImpl extends PhoneAuth {
  _PhoneAuthImpl({
    int? id,
    required int userId,
    required String phoneNumber,
    required String hash,
  }) : super._(
          id: id,
          userId: userId,
          phoneNumber: phoneNumber,
          hash: hash,
        );

  @override
  PhoneAuth copyWith({
    Object? id = _Undefined,
    int? userId,
    String? phoneNumber,
    String? hash,
  }) {
    return PhoneAuth(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hash: hash ?? this.hash,
    );
  }
}
