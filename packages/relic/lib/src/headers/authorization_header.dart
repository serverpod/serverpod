part of '../headers.dart';

/// An abstract base class representing an HTTP Authorization header.
///
/// This class provides a blueprint for different types of authorization headers,
/// such as Bearer and Basic, by defining a method to return the header value.
/// The concrete subclasses handle specific header formats.
abstract class AuthorizationHeader {
  /// Returns the value of the Authorization header.
  String headerValue();

  /// Returns the full Authorization header in "key: value" format.
  /// This method constructs the complete header string for use in HTTP requests.
  @override
  String toString() => '${Headers._authorizationHeader}: ${headerValue()}';

  /// Safely parses and creates the appropriate [AuthorizationHeader]
  /// subclass based on the provided authorization string from HTTP headers.
  ///
  /// This method checks the header's prefix to determine whether it's a Bearer
  /// or Basic authorization type and returns the corresponding header object.
  ///
  /// Returns `null` if the header is missing or if it doesn't match any known format.
  static AuthorizationHeader? _tryParseHttpHeaders(
    io.HttpHeaders headers,
  ) {
    var value = headers[Headers._authorizationHeader]?.firstOrNull;
    if (value == null) return null;

    if (value.startsWith(BearerAuthorizationHeader.prefix)) {
      return BearerAuthorizationHeader._fromHeaderValue(value);
    } else if (value.startsWith(BasicAuthorizationHeader.prefix)) {
      return BasicAuthorizationHeader._fromHeaderValue(value);
    }

    throw ArgumentError('Invalid Authorization header');
  }
}

/// A class representing an HTTP Authorization header using the Bearer token scheme.
///
/// This class is used to manage Bearer tokens, which are commonly used for
/// stateless authentication in web APIs.
class BearerAuthorizationHeader extends AuthorizationHeader {
  /// The default prefix used for Bearer token authentication.
  static const String prefix = 'Bearer ';

  /// The actual value of the authorization token.
  /// This should never be empty.
  final String token;

  /// Constructs a [BearerAuthorizationHeader] with the specified token.
  ///
  /// The token should not be empty, and this constructor is private to ensure
  /// that the token is correctly managed and only accessible via internal methods.
  BearerAuthorizationHeader._({
    required this.token,
  }) : assert(
          token.isNotEmpty,
          'Authorization value cannot be empty',
        );

  /// Factory constructor to create a [BearerAuthorizationHeader] from a token string.
  ///
  /// If the token starts with the "Bearer " prefix, the prefix is stripped
  /// from the token value. Otherwise, it throws an [ArgumentError].
  factory BearerAuthorizationHeader._fromHeaderValue(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Bearer token cannot be empty.');
    }
    if (value.startsWith(prefix)) {
      return BearerAuthorizationHeader._(
        token: value.substring(prefix.length).trim(),
      );
    }
    throw ArgumentError('Invalid Bearer token format.');
  }

  /// Returns the full authorization string, including the "Bearer " prefix.
  ///
  /// This method ensures the token is always properly formatted when sending
  /// the authorization header in an HTTP request.
  @override
  String headerValue() {
    if (token.startsWith(prefix)) return token;
    return '$prefix$token';
  }
}

/// A class representing an HTTP Authorization header using the Basic authentication scheme.
///
/// This class is used to manage Basic authentication headers, which consist of
/// a username and password encoded in Base64.
class BasicAuthorizationHeader extends AuthorizationHeader {
  /// The default prefix used for Basic authentication.
  static const String prefix = 'Basic ';

  /// The username for Basic authentication.
  final String username;

  /// The password for Basic authentication.
  final String password;

  /// Constructs a [BasicAuthorizationHeader] with the specified [username] and [password].
  ///
  /// The credentials are encoded as "username:password" in Base64 and prefixed
  /// with "Basic ". This constructor is private to ensure controlled creation of the object.
  BasicAuthorizationHeader._({
    required this.username,
    required this.password,
  })  : assert(username.isNotEmpty, 'Username cannot be empty'),
        assert(password.isNotEmpty, 'Password cannot be empty');

  /// Factory constructor to create a [BasicAuthorizationHeader] from a token string.
  ///
  /// The token should start with the "Basic " prefix, followed by Base64-encoded
  /// credentials. This method validates the Base64 format and splits the decoded
  /// string into username and password. If the token is invalid, it throws an error.
  factory BasicAuthorizationHeader._fromHeaderValue(String value) {
    if (!value.startsWith(prefix)) {
      throw ArgumentError('Token does not start with the Basic prefix');
    }

    final base64Part = value.substring(prefix.length).trim();

    if (!_isValidBase64(base64Part)) {
      throw FormatException('Invalid Base64 encoding');
    }

    final decoded = utf8.decode(base64Decode(base64Part));
    final parts = decoded.split(':');

    if (parts.length != 2) {
      throw ArgumentError('Invalid Basic token format');
    }

    return BasicAuthorizationHeader._(
      username: parts[0],
      password: parts[1],
    );
  }

  /// Returns the full authorization string, including the "Basic " prefix.
  ///
  /// This method ensures the credentials are always properly formatted and encoded
  /// when sending the authorization header in an HTTP request.
  @override
  String headerValue() {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    return '$prefix$credentials';
  }
}

/// Helper method to check if a string is valid Base64.
///
/// This method is used internally to validate that the Base64-encoded credentials
/// are correctly formatted before attempting to decode them.
bool _isValidBase64(String str) {
  final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
  return str.length % 4 == 0 && base64Pattern.hasMatch(str);
}
