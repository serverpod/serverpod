import 'dart:convert';
import 'package:collection/collection.dart';

/// The key used for the Authorization header.
const authorizationHeaderKey = "authorization";

/// An abstract base class representing an HTTP Authorization header.
/// Subclasses should define specific types of authorization such as Bearer or Basic.
abstract class AuthorizationHeader {
  /// Returns the value of the Authorization header.
  String headerValue();

  /// Returns the full Authorization header in "key: value" format.
  @override
  String toString() => '$authorizationHeaderKey: ${headerValue()}';

  /// Static method to safely parse and create the appropriate [AuthorizationHeader]
  /// subclass based on the provided authorization string.
  static AuthorizationHeader? tryParse(
    List<MapEntry<String, List<String>>> headers,
  ) {
    var values = headers
        .firstWhereOrNull(
          (entry) => entry.key.toLowerCase() == authorizationHeaderKey,
        )
        ?.value;

    if (values == null || values.isEmpty) return null;

    String value = values.first.trim();
    if (value.isEmpty) return null;

    /// Determine if it's Bearer or Basic based on the prefix
    if (value.startsWith(BearerAuthorizationHeader.prefix)) {
      return BearerAuthorizationHeader.fromHeaderValue(value);
    } else if (value.startsWith(BasicAuthorizationHeader.prefix)) {
      return BasicAuthorizationHeader.fromHeaderValue(value);
    } else {
      return null;
    }
  }
}

/// A class representing an HTTP Authorization header using the Bearer token scheme.
class BearerAuthorizationHeader extends AuthorizationHeader {
  /// The default prefix used for Bearer token authentication.
  static const String prefix = 'Bearer ';

  /// The prefix used in the authorization header, e.g., "Bearer ".
  /// This can be customized, but defaults to [prefix].
  final String prefixValue;

  /// The actual value of the authorization token.
  /// This should never be empty.
  final String tokenValue;

  /// Constructs a [BearerAuthorizationHeader] with the specified [value].
  /// The [prefix] defaults to "Bearer " but can be customized.
  ///
  /// An assertion ensures that the [value] is not empty.
  BearerAuthorizationHeader({
    this.prefixValue = prefix,
    required this.tokenValue,
  }) : assert(
          tokenValue.isNotEmpty,
          'Authorization value cannot be empty',
        );

  /// Factory constructor to create a [BearerAuthorizationHeader] from a token string.
  ///
  /// If the token starts with the default prefix ("Bearer "), the prefix is
  /// stripped from the token value and the default prefix is used.
  /// Otherwise, the token is used as is without any prefix.
  factory BearerAuthorizationHeader.fromHeaderValue(String value) {
    if (value.startsWith(prefix)) {
      return BearerAuthorizationHeader(
        tokenValue: value.substring(prefix.length).trim(),
      );
    }
    return BearerAuthorizationHeader(
      prefixValue: '',
      tokenValue: value.trim(),
    );
  }

  @override
  String headerValue() => '$prefixValue$tokenValue';
}

/// A class representing an HTTP Authorization header using the Basic authentication scheme.
class BasicAuthorizationHeader extends AuthorizationHeader {
  /// The default prefix used for Basic authentication.
  static const String prefix = 'Basic ';

  /// The prefix used in the authorization header, e.g., "Basic ".
  /// This can be customized, but defaults to [prefix].
  final String prefixValue;

  /// The username for Basic authentication.
  final String username;

  /// The password for Basic authentication.
  final String password;

  /// Constructs a [BasicAuthorizationHeader] with the specified [username] and [password].
  ///
  /// The credentials are encoded as "username:password" in Base64 and prefixed
  /// with "Basic ".
  BasicAuthorizationHeader({
    this.prefixValue = prefix,
    required this.username,
    required this.password,
  })  : assert(username.isNotEmpty, 'Username cannot be empty'),
        assert(password.isNotEmpty, 'Password cannot be empty');

  /// Factory constructor to create a [BasicAuthorizationHeader] from a token string.
  ///
  /// If the token starts with the "Basic " prefix, the prefix is stripped
  /// from the token value. If the token is invalid (empty or not properly formatted),
  /// it returns an instance with empty username and password.
  factory BasicAuthorizationHeader.fromHeaderValue(String value) {
    if (value.startsWith(prefix)) {
      final parts = utf8
          .decode(base64Decode(value.substring(prefix.length).trim()))
          .split(':');

      if (parts.length == 2) {
        return BasicAuthorizationHeader(
          username: parts[0],
          password: parts[1],
        );
      }
    }
    return BasicAuthorizationHeader(
      username: '',
      password: '',
    );
  }

  /// Returns the full authorization string, including the prefix.
  /// This is used when sending the authorization header in an HTTP request.
  @override
  String headerValue() {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    return '$prefixValue$credentials';
  }
}
