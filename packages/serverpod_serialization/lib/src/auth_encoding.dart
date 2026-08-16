/// Serverpod's default authentication key encoding and decoding.
library;

import 'dart:convert';

/// The name of the default Serverpod scheme for HTTP "authorization" headers.
/// Note, the scheme name is case-insensitive and should be compared in a case-insensitive manner.
const basicAuthSchemeName = 'Basic';

/// The name of the Bearer scheme for HTTP "authorization" headers.
/// Note, the scheme name is case-insensitive and should be compared in a case-insensitive manner.
const bearerAuthSchemeName = 'Bearer';

/// Regexp for a string adhering to the RFC 4648 base64 encoding alphabet.
const _base64RegExpStr = r'[a-zA-Z0-9+/]*=*';

/// The regular expression for the format of the authentication scheme.
const _authSchemeRegExpStr = r'[a-zA-Z0-9_-]+';

/// The regular expression for the format of the value in an HTTP header.
/// This also applies to the authentication data payload / key.
/// It consists of:
/// - \t (tab character)
/// - \x20-\x7E (printable ASCII characters, including space)
/// - \x80-\xFF (extended ASCII characters)
const _httpHeaderValueRegExpStr = r'[\t\x20-\x7E\x80-\xFF]*';

/// The regular expression for the format of the HTTP "authorization" header value,
/// including starting with an authentication scheme name.
final _authValueRegExp = RegExp(
  '^$_authSchemeRegExpStr $_httpHeaderValueRegExpStr\$',
);

/// Returns true if the provided value is a valid HTTP "authorization" header value
/// (which includes starting with an authentication scheme name).
bool isValidAuthHeaderValue(String value) => _authValueRegExp.hasMatch(value);

/// The regular expression for the format of a base64-encoded string.
final _base64RegExp = RegExp('^$_base64RegExpStr\$');

/// Returns true if the provided value is a Serverpod-wrapped auth key.
bool isWrappedBasicAuthHeaderValue(String value) {
  var parts = value.split(' ');
  if (parts[0].toLowerCase() != basicAuthSchemeName.toLowerCase()) return false;
  // if the value starts with the basic scheme, it must be valid and wrapped or we throw for invalid query
  if (parts.length == 2 && _base64RegExp.hasMatch(parts[1])) {
    return true;
  } else {
    throw AuthHeaderEncodingException(
      'Invalid "basic" auth scheme value "$value"',
    );
  }
}

/// Returns true if the provided value is a Bearer auth header value.
bool isWrappedBearerAuthHeaderValue(String value) {
  var parts = value.split(' ');
  if (parts[0].toLowerCase() != bearerAuthSchemeName.toLowerCase()) {
    return false;
  }
  // if the value starts with the bearer scheme, it must be valid and wrapped or we throw for invalid query
  if (parts.length == 2) {
    return true;
  } else {
    throw AuthHeaderEncodingException(
      'Invalid "bearer" auth scheme value "$value"',
    );
  }
}

/// Returns a value that is compliant with the HTTP auth header format
/// by encoding and wrapping the provided auth key as a Basic auth value.
String wrapAsBasicAuthHeaderValue(String key) {
  // Encode the key as Base64 and prepend the default scheme name.
  var encodedKey = base64.encode(utf8.encode(key));
  return '$basicAuthSchemeName $encodedKey';
}

/// Returns a value that is compliant with the HTTP auth header format
/// by wrapping the provided token as a Bearer auth value.
/// Unlike Basic auth, Bearer tokens are not Base64 encoded as they are
/// expected to already be in the correct format.
String wrapAsBearerAuthHeaderValue(String token) {
  return '$bearerAuthSchemeName $token';
}

/// Returns the auth key from an auth value that has potentially been wrapped.
/// This operation is the inverse of [wrapAsBasicAuthHeaderValue] and
/// [wrapAsBearerAuthHeaderValue]. If null is provided, null is returned.
String? unwrapAuthHeaderValue(String? authValue) {
  if (authValue == null) return null;
  if (isWrappedBasicAuthHeaderValue(authValue)) {
    // Basic auth value was wrapped, decode from base64.
    var parts = authValue.split(' ');
    return utf8.decode(base64.decode(parts[1]));
  } else if (isWrappedBearerAuthHeaderValue(authValue)) {
    // Bearer auth value was wrapped, just return the token part.
    var parts = authValue.split(' ');
    return parts[1];
  } else {
    // auth value was not wrapped, return as is
    return authValue;
  }
}

/// An exception thrown upon erroneous encoding of an auth header.
class AuthHeaderEncodingException implements Exception {
  /// A message indicating the error.
  final String message;

  /// Creates a new [AuthHeaderEncodingException].
  AuthHeaderEncodingException(this.message);

  @override
  String toString() {
    return 'AuthHeaderEncodingException: $message';
  }
}
