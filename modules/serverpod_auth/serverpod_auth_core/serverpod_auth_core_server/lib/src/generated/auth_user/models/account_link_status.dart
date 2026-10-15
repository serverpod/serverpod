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
import 'package:serverpod/serverpod.dart' as _is;

/// The outcome of executing an account link request.
enum AccountLinkStatus implements _is.SerializableModel {
  /// Unknown outcome; the server returned a status this client does not know.
  unknown,

  /// The sign-in method was attached to the current account.
  ///
  /// No pre-existing account owned this sign-in method, so nothing was merged
  /// and no account data was discarded.
  linked,

  /// A pre-existing account was merged into the current account and removed.
  merged,

  /// A pre-existing account owns this sign-in method and the merge has not been
  /// approved yet. Nothing has been changed.
  ///
  /// Present the account described by the result's conflict to the user, and
  /// execute the request again with `approveMerge` set to `true` to merge it
  /// into the current account.
  mergeRequired;

  static AccountLinkStatus fromJson(String name) {
    switch (name) {
      case 'unknown':
        return AccountLinkStatus.unknown;
      case 'linked':
        return AccountLinkStatus.linked;
      case 'merged':
        return AccountLinkStatus.merged;
      case 'mergeRequired':
        return AccountLinkStatus.mergeRequired;
      default:
        return AccountLinkStatus.unknown;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
