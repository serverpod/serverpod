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
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;

/// Message sent when authentication scopes for a user are revoked.
abstract class RevokedAuthenticationScope
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RevokedAuthenticationScope._({required this.scopes});

  factory RevokedAuthenticationScope({required List<String> scopes}) =
      _RevokedAuthenticationScopeImpl;

  factory RevokedAuthenticationScope.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RevokedAuthenticationScope(
      scopes: _ic00rqxb.Protocol().deserialize<List<String>>(
        jsonSerialization['scopes'],
      ),
    );
  }

  List<String> scopes;

  /// Returns a shallow copy of this [RevokedAuthenticationScope]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RevokedAuthenticationScope copyWith({List<String>? scopes});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.RevokedAuthenticationScope',
      'scopes': scopes.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RevokedAuthenticationScopeImpl extends RevokedAuthenticationScope {
  _RevokedAuthenticationScopeImpl({required List<String> scopes})
    : super._(scopes: scopes);

  /// Returns a shallow copy of this [RevokedAuthenticationScope]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RevokedAuthenticationScope copyWith({List<String>? scopes}) {
    return RevokedAuthenticationScope(
      scopes: scopes ?? this.scopes.map((e0) => e0).toList(),
    );
  }
}
