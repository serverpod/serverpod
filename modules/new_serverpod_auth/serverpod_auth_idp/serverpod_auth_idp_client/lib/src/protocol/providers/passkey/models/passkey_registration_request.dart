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
import 'dart:typed_data' as _i2;

/// Data to be sent when adding a Passkey to an existing user.
abstract class PasskeyRegistrationRequest implements _i1.SerializableModel {
  PasskeyRegistrationRequest._({
    required this.challengeId,
    required this.keyId,
    required this.clientDataJSON,
    required this.attestationObject,
  });

  factory PasskeyRegistrationRequest({
    required _i1.UuidValue challengeId,
    required _i2.ByteData keyId,
    required _i2.ByteData clientDataJSON,
    required _i2.ByteData attestationObject,
  }) = _PasskeyRegistrationRequestImpl;

  factory PasskeyRegistrationRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PasskeyRegistrationRequest(
      challengeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      keyId: _i1.ByteDataJsonExtension.fromJson(jsonSerialization['keyId']),
      clientDataJSON: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['clientDataJSON'],
      ),
      attestationObject: _i1.ByteDataJsonExtension.fromJson(
        jsonSerialization['attestationObject'],
      ),
    );
  }

  /// The ID of the solved challenge.
  _i1.UuidValue challengeId;

  /// The ID of the public key.
  _i2.ByteData keyId;

  /// The authenticator's JSON data.
  _i2.ByteData clientDataJSON;

  /// The authenticator's attestation object.
  _i2.ByteData attestationObject;

  /// Returns a shallow copy of this [PasskeyRegistrationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasskeyRegistrationRequest copyWith({
    _i1.UuidValue? challengeId,
    _i2.ByteData? keyId,
    _i2.ByteData? clientDataJSON,
    _i2.ByteData? attestationObject,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId.toJson(),
      'keyId': keyId.toJson(),
      'clientDataJSON': clientDataJSON.toJson(),
      'attestationObject': attestationObject.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PasskeyRegistrationRequestImpl extends PasskeyRegistrationRequest {
  _PasskeyRegistrationRequestImpl({
    required _i1.UuidValue challengeId,
    required _i2.ByteData keyId,
    required _i2.ByteData clientDataJSON,
    required _i2.ByteData attestationObject,
  }) : super._(
         challengeId: challengeId,
         keyId: keyId,
         clientDataJSON: clientDataJSON,
         attestationObject: attestationObject,
       );

  /// Returns a shallow copy of this [PasskeyRegistrationRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasskeyRegistrationRequest copyWith({
    _i1.UuidValue? challengeId,
    _i2.ByteData? keyId,
    _i2.ByteData? clientDataJSON,
    _i2.ByteData? attestationObject,
  }) {
    return PasskeyRegistrationRequest(
      challengeId: challengeId ?? this.challengeId,
      keyId: keyId ?? this.keyId.clone(),
      clientDataJSON: clientDataJSON ?? this.clientDataJSON.clone(),
      attestationObject: attestationObject ?? this.attestationObject.clone(),
    );
  }
}
