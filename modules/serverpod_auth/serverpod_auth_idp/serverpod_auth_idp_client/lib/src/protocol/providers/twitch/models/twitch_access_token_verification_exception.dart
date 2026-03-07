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

/// Exception to be thrown if the GitHub access token verification fails.
///
/// This is a generic exception that does not expose any details regarding the
/// cause of the failure to avoid leaking information to potential attackers.
abstract class TwitchAccessTokenVerificationException
    implements _i1.SerializableException, _i1.SerializableModel {
  TwitchAccessTokenVerificationException._();

  factory TwitchAccessTokenVerificationException() =
      _TwitchAccessTokenVerificationExceptionImpl;

  factory TwitchAccessTokenVerificationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return TwitchAccessTokenVerificationException();
  }

  /// Returns a shallow copy of this [TwitchAccessTokenVerificationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TwitchAccessTokenVerificationException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__':
          'serverpod_auth_idp.TwitchAccessTokenVerificationException',
    };
  }

  @override
  String toString() {
    return 'TwitchAccessTokenVerificationException';
  }
}

class _TwitchAccessTokenVerificationExceptionImpl
    extends TwitchAccessTokenVerificationException {
  _TwitchAccessTokenVerificationExceptionImpl() : super._();

  /// Returns a shallow copy of this [TwitchAccessTokenVerificationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TwitchAccessTokenVerificationException copyWith() {
    return TwitchAccessTokenVerificationException();
  }
}
