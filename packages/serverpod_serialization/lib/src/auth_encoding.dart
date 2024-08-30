/// Serverpod's default authentication key encoding and decoding.
library serverpod_serialization.auth_encoding;

import 'dart:convert';

/// The name of the default Serverpod scheme for HTTP "authorization" headers.
/// Note, the scheme name is case-insensitive and should be compared in a case-insensitive manner.
const serverpodDefaultAuthSchemeName = 'Basic';

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
final _authValueRegExp =
    RegExp('^$_authSchemeRegExpStr $_httpHeaderValueRegExpStr\$');

/// Returns true if the provided value is a valid HTTP "authorization" header value
/// (which includes starting with an authentication scheme name).
bool isValidAuthHeaderValue(String value) => _authValueRegExp.hasMatch(value);

/// The regular expression for the format of a base64-encoded string.
final _base64RegExp = RegExp('^$_base64RegExpStr\$');

/// Returns true if the provided value is a Serverpod-wrapped auth key.
bool isWrappedBasicAuthHeaderValue(String value) {
  var parts = value.split(' ');
  if (parts[0].toLowerCase() == 'basic') {
    // if the value starts with the basic scheme, it must be valid and wrapped or we throw for invalid query
    if (parts.length == 2 && _base64RegExp.hasMatch(parts[1])) {
      return true;
    } else {
      throw Exception('Invalid basic auth value "$value"');
    }
  }
  return false;
}

/// Returns a value that is compliant with the HTTP auth header format
/// by encoding and wrapping the provided auth key as a Basic auth value.
String wrapAsBasicAuthHeaderValue(String key) {
  // Encode the key as Base64 and prepend the default scheme name.
  var encodedKey = base64.encode(utf8.encode(key));
  return '$serverpodDefaultAuthSchemeName $encodedKey';
}

/// Returns the auth key from an auth value that has potentially been wrapped.
/// This operation is the inverse of [wrapAsBasicAuthHeaderValue].
/// If null is provided, null is returned.
String? unwrapAuthHeaderValue(String? authValue) {
  if (authValue == null) return null;
  if (isWrappedBasicAuthHeaderValue(authValue)) {
    // auth value was wrapped, unbake
    var parts = authValue.split(' ');
    return utf8.decode(base64.decode(parts[1]));
  } else {
    // auth value was not wrapped, return as is
    return authValue;
  }
}
