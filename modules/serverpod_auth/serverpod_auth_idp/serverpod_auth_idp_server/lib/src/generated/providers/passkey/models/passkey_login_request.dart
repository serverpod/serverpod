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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

/// Data to be sent for a Passkey login.
abstract class PasskeyLoginRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PasskeyLoginRequest._({
    required this.challengeId,
    required this.keyId,
    required this.authenticatorData,
    required this.clientDataJSON,
    required this.signature,
  });

  factory PasskeyLoginRequest({
    required _is.UuidValue challengeId,
    required _idt.ByteData keyId,
    required _idt.ByteData authenticatorData,
    required _idt.ByteData clientDataJSON,
    required _idt.ByteData signature,
  }) = _PasskeyLoginRequestImpl;

  factory PasskeyLoginRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return PasskeyLoginRequest(
      challengeId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      keyId: _is.ByteDataJsonExtension.fromJson(jsonSerialization['keyId']),
      authenticatorData: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['authenticatorData'],
      ),
      clientDataJSON: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['clientDataJSON'],
      ),
      signature: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['signature'],
      ),
    );
  }

  /// The ID of the solved challenge.
  _is.UuidValue challengeId;

  /// The ID of the key used.
  _idt.ByteData keyId;

  /// The client authenticator's response data.
  _idt.ByteData authenticatorData;

  /// The client authenticator's JSON data.
  _idt.ByteData clientDataJSON;

  /// The signature of the client's key on the challenge.
  _idt.ByteData signature;

  /// Returns a shallow copy of this [PasskeyLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PasskeyLoginRequest copyWith({
    _is.UuidValue? challengeId,
    _idt.ByteData? keyId,
    _idt.ByteData? authenticatorData,
    _idt.ByteData? clientDataJSON,
    _idt.ByteData? signature,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.PasskeyLoginRequest',
      'challengeId': challengeId.toJson(),
      'keyId': keyId.toJson(),
      'authenticatorData': authenticatorData.toJson(),
      'clientDataJSON': clientDataJSON.toJson(),
      'signature': signature.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.PasskeyLoginRequest',
      'challengeId': challengeId.toJson(),
      'keyId': keyId.toJson(),
      'authenticatorData': authenticatorData.toJson(),
      'clientDataJSON': clientDataJSON.toJson(),
      'signature': signature.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PasskeyLoginRequestImpl extends PasskeyLoginRequest {
  _PasskeyLoginRequestImpl({
    required _is.UuidValue challengeId,
    required _idt.ByteData keyId,
    required _idt.ByteData authenticatorData,
    required _idt.ByteData clientDataJSON,
    required _idt.ByteData signature,
  }) : super._(
         challengeId: challengeId,
         keyId: keyId,
         authenticatorData: authenticatorData,
         clientDataJSON: clientDataJSON,
         signature: signature,
       );

  /// Returns a shallow copy of this [PasskeyLoginRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PasskeyLoginRequest copyWith({
    _is.UuidValue? challengeId,
    _idt.ByteData? keyId,
    _idt.ByteData? authenticatorData,
    _idt.ByteData? clientDataJSON,
    _idt.ByteData? signature,
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
