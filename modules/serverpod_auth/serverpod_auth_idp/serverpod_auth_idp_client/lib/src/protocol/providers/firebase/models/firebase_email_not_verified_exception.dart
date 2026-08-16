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

/// Exception to be thrown when a Firebase account's email has not been
/// verified, but the configured validation requires it.
///
/// This is only thrown when the Firebase identity provider is configured with
/// `FirebaseIdpConfig.requireVerifiedEmail` (or a custom validation that
/// throws it). Clients can catch this to prompt the user to verify their
/// email address.
abstract class FirebaseEmailNotVerifiedException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  FirebaseEmailNotVerifiedException._();

  factory FirebaseEmailNotVerifiedException() =
      _FirebaseEmailNotVerifiedExceptionImpl;

  factory FirebaseEmailNotVerifiedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FirebaseEmailNotVerifiedException();
  }

  /// Returns a shallow copy of this [FirebaseEmailNotVerifiedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FirebaseEmailNotVerifiedException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_auth_idp.FirebaseEmailNotVerifiedException',
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_auth_idp.FirebaseEmailNotVerifiedException',
    };
  }

  @override
  String toString() {
    return 'FirebaseEmailNotVerifiedException';
  }
}

class _FirebaseEmailNotVerifiedExceptionImpl
    extends FirebaseEmailNotVerifiedException {
  _FirebaseEmailNotVerifiedExceptionImpl() : super._();

  /// Returns a shallow copy of this [FirebaseEmailNotVerifiedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FirebaseEmailNotVerifiedException copyWith() {
    return FirebaseEmailNotVerifiedException();
  }
}
