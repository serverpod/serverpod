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

/// Message sent when all authentication for a user is revoked.
abstract class RevokedAuthenticationUser
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RevokedAuthenticationUser._();

  factory RevokedAuthenticationUser() = _RevokedAuthenticationUserImpl;

  factory RevokedAuthenticationUser.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RevokedAuthenticationUser();
  }

  /// Returns a shallow copy of this [RevokedAuthenticationUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RevokedAuthenticationUser copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
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

class _RevokedAuthenticationUserImpl extends RevokedAuthenticationUser {
  _RevokedAuthenticationUserImpl() : super._();

  /// Returns a shallow copy of this [RevokedAuthenticationUser]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RevokedAuthenticationUser copyWith() {
    return RevokedAuthenticationUser();
  }
}
