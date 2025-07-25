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

/// Exception to be thrown when an attempt was made to complete a password reset
/// with an invalid verification code.
abstract class EmailAccountPasswordResetRequestUnauthorizedException
    implements _i1.SerializableException, _i1.SerializableModel {
  EmailAccountPasswordResetRequestUnauthorizedException._();

  factory EmailAccountPasswordResetRequestUnauthorizedException() =
      _EmailAccountPasswordResetRequestUnauthorizedExceptionImpl;

  factory EmailAccountPasswordResetRequestUnauthorizedException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetRequestUnauthorizedException();
  }

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequestUnauthorizedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetRequestUnauthorizedException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EmailAccountPasswordResetRequestUnauthorizedExceptionImpl
    extends EmailAccountPasswordResetRequestUnauthorizedException {
  _EmailAccountPasswordResetRequestUnauthorizedExceptionImpl() : super._();

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequestUnauthorizedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetRequestUnauthorizedException copyWith() {
    return EmailAccountPasswordResetRequestUnauthorizedException();
  }
}
