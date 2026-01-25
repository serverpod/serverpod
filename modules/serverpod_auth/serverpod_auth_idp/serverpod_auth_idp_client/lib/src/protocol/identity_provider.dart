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

/// Providers of user identity, each maped to a folder within the
/// `lib/src/providers` directory. This class is used by the
/// `IdpEndpoint.idpAccounts` method, which allows developers to determine which
/// identity providers a user has already linked to their account.
///
/// If developers include their own custom Idps, they should consider creating
/// an entirely new enum with values for all of the providers they use,
/// including any custom ones, and mimic the `IdpEndpoint.idpAccounts` method
/// to return values from that new enum.
enum IdentityProvider implements _i1.SerializableModel {
  anonymous,
  apple,
  email,
  firebase,
  google,
  passkey;

  static IdentityProvider fromJson(String name) {
    switch (name) {
      case 'anonymous':
        return IdentityProvider.anonymous;
      case 'apple':
        return IdentityProvider.apple;
      case 'email':
        return IdentityProvider.email;
      case 'firebase':
        return IdentityProvider.firebase;
      case 'google':
        return IdentityProvider.google;
      case 'passkey':
        return IdentityProvider.passkey;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "IdentityProvider"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
