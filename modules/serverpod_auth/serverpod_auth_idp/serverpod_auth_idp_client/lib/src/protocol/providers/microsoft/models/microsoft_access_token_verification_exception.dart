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

/// Exception to be thrown if the Microsoft access token verification fails.
///
/// This is a generic exception that does not expose any details regarding the
/// cause of the failure to avoid leaking information to potential attackers.
abstract class MicrosoftAccessTokenVerificationException
    implements _i1.SerializableException, _i1.SerializableModel {
  MicrosoftAccessTokenVerificationException._();

  factory MicrosoftAccessTokenVerificationException() =
      _MicrosoftAccessTokenVerificationExceptionImpl;

  factory MicrosoftAccessTokenVerificationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MicrosoftAccessTokenVerificationException();
  }

  /// Returns a shallow copy of this [MicrosoftAccessTokenVerificationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MicrosoftAccessTokenVerificationException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__':
          'serverpod_auth_idp.MicrosoftAccessTokenVerificationException',
    };
  }

  @override
  String toString() {
    return 'MicrosoftAccessTokenVerificationException';
  }
}

class _MicrosoftAccessTokenVerificationExceptionImpl
    extends MicrosoftAccessTokenVerificationException {
  _MicrosoftAccessTokenVerificationExceptionImpl() : super._();

  /// Returns a shallow copy of this [MicrosoftAccessTokenVerificationException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MicrosoftAccessTokenVerificationException copyWith() {
    return MicrosoftAccessTokenVerificationException();
  }
}
