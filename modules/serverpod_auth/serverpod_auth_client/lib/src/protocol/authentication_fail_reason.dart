/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Defines a reason for a failed sign in.
enum AuthenticationFailReason with _i1.SerializableEntity {
  invalidCredentials,
  userCreationDenied,
  internalError,
  tooManyFailedAttempts,
  blocked;

  static AuthenticationFailReason fromJson(int index) {
    switch (index) {
      case 0:
        return invalidCredentials;
      case 1:
        return userCreationDenied;
      case 2:
        return internalError;
      case 3:
        return tooManyFailedAttempts;
      case 4:
        return blocked;
      default:
        throw ArgumentError(
            'Value "$index" cannot be converted to "AuthenticationFailReason"');
    }
  }

  @override
  int toJson() => index;
}
