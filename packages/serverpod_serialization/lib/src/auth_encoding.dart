/// Serverpod's default authentication key encoding and decoding.
library serverpod_serialization.auth_encoding;

import 'dart:convert';

/// The name of the default Serverpod scheme for HTTP "authorization" headers.
/// Note, the scheme name is case-insensitive and should be compared in a case-insensitive manner.
const serverpodDefaultAuthSchemeName = 'Basic';

/// Regexp for a non-empty string adhering to the RFC 4648 base64 encoding alphabet.
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
final _authValueRegExp =
    RegExp('^$_authSchemeRegExpStr $_httpHeaderValueRegExpStr\$');

/// Returns true if the provided value is a valid HTTP "authorization" header value
/// (which includes starting with an authentication scheme name).
bool isValidAuthHeaderValue(String value) => _authValueRegExp.hasMatch(value);

/// The regular expression for the format of Serverpod-wrapped auth keys.
final _wrappedAuthValueRegExp =
    RegExp('^$serverpodDefaultAuthSchemeName $_base64RegExpStr\$');

/// Returns true if the provided value is a Serverpod-wrapped auth key.
bool isWrappedAuthValue(String value) =>
    _wrappedAuthValueRegExp.hasMatch(value);

/// Returns a value that is compliant with the HTTP auth header format
/// by encoding and wrapping the provided auth key as a Basic auth value.
String wrapAuthHeaderValue(String key) {
  // Encode the key as Base64 and prepend the default scheme name.
  var encodedKey = base64.encode(utf8.encode(key));
  return '$serverpodDefaultAuthSchemeName $encodedKey';
}

/// Returns the auth key from an auth value that has potentially been wrapped.
/// This operation is the inverse of [wrapAuthHeaderValue].
/// If null is provided, null is returned.
String? unwrapAuthHeaderValue(String? authValue) {
  if (authValue == null) return null;
  if (isWrappedAuthValue(authValue)) {
    // auth value was wrapped, unbake
    var parts = authValue.split(' ');
    return utf8.decode(base64.decode(parts[1]));
  } else {
    // auth value was not wrapped, return as is
    return authValue;
  }
}
