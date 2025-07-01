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

abstract class EmailAccountPasswordResetTooManyAttemptsException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  EmailAccountPasswordResetTooManyAttemptsException._();

  factory EmailAccountPasswordResetTooManyAttemptsException() =
      _EmailAccountPasswordResetTooManyAttemptsExceptionImpl;

  factory EmailAccountPasswordResetTooManyAttemptsException.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return EmailAccountPasswordResetTooManyAttemptsException();
  }

  /// Returns a shallow copy of this [EmailAccountPasswordResetTooManyAttemptsException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAccountPasswordResetTooManyAttemptsException copyWith();
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

class _EmailAccountPasswordResetTooManyAttemptsExceptionImpl
    extends EmailAccountPasswordResetTooManyAttemptsException {
  _EmailAccountPasswordResetTooManyAttemptsExceptionImpl() : super._();

  /// Returns a shallow copy of this [EmailAccountPasswordResetTooManyAttemptsException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAccountPasswordResetTooManyAttemptsException copyWith() {
    return EmailAccountPasswordResetTooManyAttemptsException();
  }
}
