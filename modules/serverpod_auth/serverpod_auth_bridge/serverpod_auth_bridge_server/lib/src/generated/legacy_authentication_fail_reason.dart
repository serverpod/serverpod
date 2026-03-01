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
import 'package:serverpod/serverpod.dart' as _i1;

enum LegacyAuthenticationFailReason implements _i1.SerializableModel {
  invalidCredentials,
  userCreationDenied,
  internalError,
  tooManyFailedAttempts,
  blocked;

  static LegacyAuthenticationFailReason fromJson(int index) {
    switch (index) {
      case 0:
        return LegacyAuthenticationFailReason.invalidCredentials;
      case 1:
        return LegacyAuthenticationFailReason.userCreationDenied;
      case 2:
        return LegacyAuthenticationFailReason.internalError;
      case 3:
        return LegacyAuthenticationFailReason.tooManyFailedAttempts;
      case 4:
        return LegacyAuthenticationFailReason.blocked;
      default:
        throw ArgumentError(
          'Value "$index" cannot be converted to "LegacyAuthenticationFailReason"',
        );
    }
  }

  @override
  int toJson() => index;

  @override
  String toString() => name;
}
