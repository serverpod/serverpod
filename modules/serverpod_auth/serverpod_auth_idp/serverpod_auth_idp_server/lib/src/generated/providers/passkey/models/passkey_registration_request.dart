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

/// Data to be sent when adding a Passkey to an existing user.
abstract class PasskeyRegistrationRequest
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PasskeyRegistrationRequest._({
    required this.challengeId,
    required this.keyId,
    required this.clientDataJSON,
    required this.attestationObject,
  });

  factory PasskeyRegistrationRequest({
    required _is.UuidValue challengeId,
    required _idt.ByteData keyId,
    required _idt.ByteData clientDataJSON,
    required _idt.ByteData attestationObject,
  }) = _PasskeyRegistrationRequestImpl;

  factory PasskeyRegistrationRequest.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PasskeyRegistrationRequest(
      challengeId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['challengeId'],
      ),
      keyId: _is.ByteDataJsonExtension.fromJson(jsonSerialization['keyId']),
      clientDataJSON: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['clientDataJSON'],
      ),
      attestationObject: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['attestationObject'],
      ),
    );
  }

  /// The ID of the solved challenge.
  _is.UuidValue challengeId;

  /// The ID of the public key.
  _idt.ByteData keyId;

  /// The authenticator's JSON data.
  _idt.ByteData clientDataJSON;

  /// The authenticator's attestation object.
  _idt.ByteData attestationObject;

  /// Returns a shallow copy of this [PasskeyRegistrationRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PasskeyRegistrationRequest copyWith({
    _is.UuidValue? challengeId,
    _idt.ByteData? keyId,
    _idt.ByteData? clientDataJSON,
    _idt.ByteData? attestationObject,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.PasskeyRegistrationRequest',
      'challengeId': challengeId.toJson(),
      'keyId': keyId.toJson(),
      'clientDataJSON': clientDataJSON.toJson(),
      'attestationObject': attestationObject.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.PasskeyRegistrationRequest',
      'challengeId': challengeId.toJson(),
      'keyId': keyId.toJson(),
      'clientDataJSON': clientDataJSON.toJson(),
      'attestationObject': attestationObject.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PasskeyRegistrationRequestImpl extends PasskeyRegistrationRequest {
  _PasskeyRegistrationRequestImpl({
    required _is.UuidValue challengeId,
    required _idt.ByteData keyId,
    required _idt.ByteData clientDataJSON,
    required _idt.ByteData attestationObject,
  }) : super._(
         challengeId: challengeId,
         keyId: keyId,
         clientDataJSON: clientDataJSON,
         attestationObject: attestationObject,
       );

  /// Returns a shallow copy of this [PasskeyRegistrationRequest]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PasskeyRegistrationRequest copyWith({
    _is.UuidValue? challengeId,
    _idt.ByteData? keyId,
    _idt.ByteData? clientDataJSON,
    _idt.ByteData? attestationObject,
  }) {
    return PasskeyRegistrationRequest(
      challengeId: challengeId ?? this.challengeId,
      keyId: keyId ?? this.keyId.clone(),
      clientDataJSON: clientDataJSON ?? this.clientDataJSON.clone(),
      attestationObject: attestationObject ?? this.attestationObject.clone(),
    );
  }
}
