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

/// Data to be sent for a Passkey login.
abstract class PasskeyLoginRequest implements _i1.SerializableModel {
  PasskeyLoginRequest._({
    required this.challengeId,
    required this.keyId,
    required this.authenticatorData,
    required this.clientDataJSON,
    required this.signature,
  });

  factory PasskeyLoginRequest({
    required _i1.UuidValue challengeId,
    required _i2.ByteData keyId,
    required _i2.ByteData authenticatorData,
    required _i2.ByteData clientDataJSON,
    required _i2.ByteData signature,
  }) = _PasskeyLoginRequestImpl;

  factory PasskeyLoginRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PasskeyLoginRequest(
      challengeId:
          _i1.UuidValueJsonExtension.fromJson(jsonSerialization['challengeId']),
      keyId: _i1.ByteDataJsonExtension.fromJson(jsonSerialization['keyId']),
      authenticatorData: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['authenticatorData']),
      clientDataJSON: _i1.ByteDataJsonExtension.fromJson(
          jsonSerialization['clientDataJSON']),
      signature:
          _i1.ByteDataJsonExtension.fromJson(jsonSerialization['signature']),
    );
  }

  /// The ID of the solved challenge.
  _i1.UuidValue challengeId;

  /// The ID of the key used.
  _i2.ByteData keyId;

  /// The client authenticator's response data.
  _i2.ByteData authenticatorData;

  /// The client authenticator's JSON data.
  _i2.ByteData clientDataJSON;

  /// The signature of the client's key on the challenge.
  _i2.ByteData signature;

  /// Returns a shallow copy of this [PasskeyLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PasskeyLoginRequest copyWith({
    _i1.UuidValue? challengeId,
    _i2.ByteData? keyId,
    _i2.ByteData? authenticatorData,
    _i2.ByteData? clientDataJSON,
    _i2.ByteData? signature,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'challengeId': challengeId.toJson(),
      'keyId': keyId.toJson(),
      'authenticatorData': authenticatorData.toJson(),
      'clientDataJSON': clientDataJSON.toJson(),
      'signature': signature.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PasskeyLoginRequestImpl extends PasskeyLoginRequest {
  _PasskeyLoginRequestImpl({
    required _i1.UuidValue challengeId,
    required _i2.ByteData keyId,
    required _i2.ByteData authenticatorData,
    required _i2.ByteData clientDataJSON,
    required _i2.ByteData signature,
  }) : super._(
          challengeId: challengeId,
          keyId: keyId,
          authenticatorData: authenticatorData,
          clientDataJSON: clientDataJSON,
          signature: signature,
        );

  /// Returns a shallow copy of this [PasskeyLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PasskeyLoginRequest copyWith({
    _i1.UuidValue? challengeId,
    _i2.ByteData? keyId,
    _i2.ByteData? authenticatorData,
    _i2.ByteData? clientDataJSON,
    _i2.ByteData? signature,
  }) {
    return PasskeyLoginRequest(
      challengeId: challengeId ?? this.challengeId,
      keyId: keyId ?? this.keyId.clone(),
      authenticatorData: authenticatorData ?? this.authenticatorData.clone(),
      clientDataJSON: clientDataJSON ?? this.clientDataJSON.clone(),
      signature: signature ?? this.signature.clone(),
    );
  }
}
