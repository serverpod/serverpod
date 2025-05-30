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

/// A pair of refresh and access tokens, in their external format.
abstract class TokenPair
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TokenPair._({
    required this.refreshToken,
    required this.accessToken,
  });

  factory TokenPair({
    required String refreshToken,
    required String accessToken,
  }) = _TokenPairImpl;

  factory TokenPair.fromJson(Map<String, dynamic> jsonSerialization) {
    return TokenPair(
      refreshToken: jsonSerialization['refreshToken'] as String,
      accessToken: jsonSerialization['accessToken'] as String,
    );
  }

  /// The refresh token to be used to create new access tokens and rotate itself.
  ///
  /// The client should handle this as an opaque string.
  String refreshToken;

  /// The latest access token, encoded as a JWT.
  String accessToken;

  /// Returns a shallow copy of this [TokenPair]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TokenPair copyWith({
    String? refreshToken,
    String? accessToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'refreshToken': refreshToken,
      'accessToken': accessToken,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TokenPairImpl extends TokenPair {
  _TokenPairImpl({
    required String refreshToken,
    required String accessToken,
  }) : super._(
          refreshToken: refreshToken,
          accessToken: accessToken,
        );

  /// Returns a shallow copy of this [TokenPair]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TokenPair copyWith({
    String? refreshToken,
    String? accessToken,
  }) {
    return TokenPair(
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
