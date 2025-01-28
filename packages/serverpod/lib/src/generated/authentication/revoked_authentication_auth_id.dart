/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Message sent when an authentication key id is revoked.
abstract class RevokedAuthenticationAuthId
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RevokedAuthenticationAuthId._({required this.authId});

  factory RevokedAuthenticationAuthId({required String authId}) =
      _RevokedAuthenticationAuthIdImpl;

  factory RevokedAuthenticationAuthId.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RevokedAuthenticationAuthId(
        authId: jsonSerialization['authId'] as String);
  }

  String authId;

  /// Returns a shallow copy of this [RevokedAuthenticationAuthId]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RevokedAuthenticationAuthId copyWith({String? authId});
  @override
  Map<String, dynamic> toJson() {
    return {'authId': authId};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RevokedAuthenticationAuthIdImpl extends RevokedAuthenticationAuthId {
  _RevokedAuthenticationAuthIdImpl({required String authId})
      : super._(authId: authId);

  /// Returns a shallow copy of this [RevokedAuthenticationAuthId]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RevokedAuthenticationAuthId copyWith({String? authId}) {
    return RevokedAuthenticationAuthId(authId: authId ?? this.authId);
  }
}
