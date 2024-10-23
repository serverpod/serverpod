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

/// A request for creating an phone number signin. Created during the sign up process
/// to keep track of the user's details and verification code.
abstract class PhoneCreateAccountRequest implements _i1.SerializableModel {
  PhoneCreateAccountRequest._({
    this.id,
    required this.userName,
    required this.phoneNumber,
    required this.hash,
    required this.verificationCode,
  });

  factory PhoneCreateAccountRequest({
    int? id,
    required String userName,
    required String phoneNumber,
    required String hash,
    required String verificationCode,
  }) = _PhoneCreateAccountRequestImpl;

  factory PhoneCreateAccountRequest.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PhoneCreateAccountRequest(
      id: jsonSerialization['id'] as int?,
      userName: jsonSerialization['userName'] as String,
      phoneNumber: jsonSerialization['phoneNumber'] as String,
      hash: jsonSerialization['hash'] as String,
      verificationCode: jsonSerialization['verificationCode'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The name of the user.
  String userName;

  /// The phone number of the user.
  String phoneNumber;

  /// Hash of the user's requested password.
  String hash;

  /// The verification code sent to the user.
  String verificationCode;

  PhoneCreateAccountRequest copyWith({
    int? id,
    String? userName,
    String? phoneNumber,
    String? hash,
    String? verificationCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'hash': hash,
      'verificationCode': verificationCode,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PhoneCreateAccountRequestImpl extends PhoneCreateAccountRequest {
  _PhoneCreateAccountRequestImpl({
    int? id,
    required String userName,
    required String phoneNumber,
    required String hash,
    required String verificationCode,
  }) : super._(
          id: id,
          userName: userName,
          phoneNumber: phoneNumber,
          hash: hash,
          verificationCode: verificationCode,
        );

  @override
  PhoneCreateAccountRequest copyWith({
    Object? id = _Undefined,
    String? userName,
    String? phoneNumber,
    String? hash,
    String? verificationCode,
  }) {
    return PhoneCreateAccountRequest(
      id: id is int? ? id : this.id,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      hash: hash ?? this.hash,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
