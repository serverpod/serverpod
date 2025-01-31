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

/// Message sent when authentication scopes for a user are revoked.
abstract class RevokedAuthenticationScope
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  RevokedAuthenticationScope._({required this.scopes});

  factory RevokedAuthenticationScope({required List<String> scopes}) =
      _RevokedAuthenticationScopeImpl;

  factory RevokedAuthenticationScope.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RevokedAuthenticationScope(
        scopes: (jsonSerialization['scopes'] as List)
            .map((e) => e as String)
            .toList());
  }

  List<String> scopes;

  /// Returns a shallow copy of this [RevokedAuthenticationScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RevokedAuthenticationScope copyWith({List<String>? scopes});
  @override
  Map<String, dynamic> toJson() {
    return {'scopes': scopes.toJson()};
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

class _RevokedAuthenticationScopeImpl extends RevokedAuthenticationScope {
  _RevokedAuthenticationScopeImpl({required List<String> scopes})
      : super._(scopes: scopes);

  /// Returns a shallow copy of this [RevokedAuthenticationScope]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RevokedAuthenticationScope copyWith({List<String>? scopes}) {
    return RevokedAuthenticationScope(
        scopes: scopes ?? this.scopes.map((e0) => e0).toList());
  }
}
