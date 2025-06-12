/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class EmailAccountPasswordResetRequestTooManyAttemptsException
    implements _i1.SerializableException, _i1.SerializableModel {
  EmailAccountPasswordResetRequestTooManyAttemptsException._();

  factory EmailAccountPasswordResetRequestTooManyAttemptsException() =
      _EmailAccountPasswordResetRequestTooManyAttemptsExceptionImpl;

  factory EmailAccountPasswordResetRequestTooManyAttemptsException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetRequestTooManyAttemptsException();
  }

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequestTooManyAttemptsException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetRequestTooManyAttemptsException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _EmailAccountPasswordResetRequestTooManyAttemptsExceptionImpl
    extends EmailAccountPasswordResetRequestTooManyAttemptsException {
  _EmailAccountPasswordResetRequestTooManyAttemptsExceptionImpl() : super._();

  /// Returns a shallow copy of this [EmailAccountPasswordResetRequestTooManyAttemptsException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetRequestTooManyAttemptsException copyWith() {
    return EmailAccountPasswordResetRequestTooManyAttemptsException();
  }
}
