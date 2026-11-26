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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// Exception thrown when an account link request cannot be used.
///
/// This covers every way a link flow can go stale: no request was started, it
/// expired, it was started on a different device, no sign-in has been attached
/// to it yet, or the proof token does not match the attached sign-in. In all
/// cases the remedy is the same, which is to start the linking flow again.
abstract class AccountLinkRequestNotFoundException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  AccountLinkRequestNotFoundException._({this.message});

  factory AccountLinkRequestNotFoundException({String? message}) =
      _AccountLinkRequestNotFoundExceptionImpl;

  factory AccountLinkRequestNotFoundException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AccountLinkRequestNotFoundException(
      message: jsonSerialization['message'] as String?,
    );
  }

  /// A description of why the request could not be used.
  String? message;

  /// Returns a shallow copy of this [AccountLinkRequestNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AccountLinkRequestNotFoundException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__':
          'serverpod_auth_core.AccountLinkRequestNotFoundException',
      if (message != null) 'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__':
          'serverpod_auth_core.AccountLinkRequestNotFoundException',
      if (message != null) 'message': message,
    };
  }

  @override
  String toString() {
    return 'AccountLinkRequestNotFoundException(message: $message)';
  }
}

class _Undefined {}

class _AccountLinkRequestNotFoundExceptionImpl
    extends AccountLinkRequestNotFoundException {
  _AccountLinkRequestNotFoundExceptionImpl({String? message})
    : super._(message: message);

  /// Returns a shallow copy of this [AccountLinkRequestNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AccountLinkRequestNotFoundException copyWith({Object? message = _Undefined}) {
    return AccountLinkRequestNotFoundException(
      message: message is String? ? message : this.message,
    );
  }
}
