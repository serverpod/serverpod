import 'dart:convert';

import 'package:test/test.dart';
import 'package:serverpod_serialization/src/auth_encoding.dart';

void main() {
  /// conventional serverpod auth key format user:pwd
  var conventionalAuthKeys = [
    ('joe:pwd', 'valid username:password'),
    (
      'joe,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}\r\n : pwd,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}\r\n',
      'valid username:password that contain allowed special characters',
    ),
  ];

  /// standard basic auth schemes' key formats, which is also equivalent to the wrapped key format
  var standardBasicAuthKeys = [
    ('Basic dGVzd', 'valid basic scheme with base64 encoded value'),
    ('Basic dGVzdA==', 'valid basic scheme with base64 encoded value'),
    ('Basic dGVzd02348+/', 'valid basic scheme with base64 encoded value'),
    ('Basic dGVzd==', 'valid basic scheme with base64 encoded value'),
    ('Basic ', 'valid basic scheme with an empty base64 encoded value'),
    ('basic dGVzd', 'valid basic scheme name in lowercase'),
    ('BASIC dGVzd', 'valid basic scheme name in uppercase'),
    ('basiC dGVzd', 'valid basic scheme name in mixed case'),
  ];

  /// standard non-basic auth schemes' key formats
  var standardNonBasicAuthKeys = [
    (
      'Bearer dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
      'valid non-basic scheme'
    ),
    (
      'bearer dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
      'valid non-basic scheme'
    ),
    (
      'BEARER dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
      'valid non-basic scheme'
    ),
    (
      'Digest dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
      'valid non-basic scheme'
    ),
    ('HOBA dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}', 'valid non-basic scheme'),
  ];

  /// basic auth schemes' keys with invalid content
  var invalidBasicAuthKeys = [
    ('Basic dGVzd dGVzd dGVzd', 'invalid basic scheme with multiple values'),
    ('Basic dGVzd dGVzd', 'invalid basic scheme with multiple values'),
    ('Basic dGVzd ', 'invalid basic scheme with trailing space'),
    ('Basic dGVz=d', 'basic scheme with invalid position of = character'),
    ('Basic dGVzd*', 'basic scheme with invalid character in value'),
    ('Basic d#', 'basic scheme with invalid character in value'),
    ('Basic #', 'basic scheme with invalid character in value'),
    ('Basic \t', 'basic scheme with invalid character in value'),
    ('Basic  ', 'invalid basic scheme with space in place of value'),
    ('Basic', 'invalid basic scheme with missing value'),
  ];

  /// arbitrary auth key formats
  var arbitraryAuthKeys = [
    ('', 'empty string is valid'),
    (' ', 'space is valid'),
    ('\t', 'white space is valid'),
    ('\n', 'line break is valid'),
    ('\r', 'line break is valid'),
    (':', 'colon is valid'),
    (':::::::::::::::', 'colon is valid'),
    (',;.:<>_-/\\|"\'`~!@#\$%^&*()+=[]{}\r\n', 'special characters are valid'),
    (
      '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',
      'long values are valid',
    ),
    (json.encode({'key': 'value'}), 'simple json-encoded values are valid'),
    (
      json.encode({
        'key': 'value',
        'key2': {
          'key3': 'value3',
          'key4': {
            'key5': 'value5',
            'key6': 'value6',
            'key7': 'value7',
            'key8': 'value8',
            'key9': 'value9',
            'key10': 'value10',
          },
        },
        'key10': [],
        'key11': [1, 2],
        'key12': null,
      }),
      'complex json-encoded values are valid',
    ),
  ];

  group('Auth header validity checking:', () {
    for (var (key, descr) in [
      ...standardBasicAuthKeys,
      ...standardNonBasicAuthKeys,
    ]) {
      test(
          'Given an auth key in valid HTTP auth header format '
          '"${_stripControlCharacters(key)}" ($descr) '
          'when checking its validity '
          'then it should correctly be recognized as valid', () {
        expect(isValidAuthHeaderValue(key), isTrue);
      });
    }

    for (var (key, descr) in [
      ...conventionalAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      test(
          'Given an auth key in invalid HTTP auth header format '
          '"${_stripControlCharacters(key)}" ($descr) '
          'when checking its validity '
          'then it should correctly recognize it as invalid', () {
        expect(isValidAuthHeaderValue(key), isFalse);
      });
    }
  });

  group('Auth header wrapping checking:', () {
    for (var (key, descr) in standardBasicAuthKeys) {
      test(
          'Given an auth key in "Basic" HTTP auth header format '
          '"${_stripControlCharacters(key)}" ($descr) '
          'when checking if it is wrapped '
          'then it should correctly recognize it as a wrapped auth key', () {
        expect(isWrappedBasicAuthHeaderValue(key), isTrue);
      });
    }

    for (var (key, descr) in invalidBasicAuthKeys) {
      test(
          'Given an auth key in "Basic" HTTP auth header with invalid format '
          '"${_stripControlCharacters(key)}" ($descr) '
          'when checking if it is wrapped '
          'then it should reject it with the proper exception', () {
        expect(
          () => isWrappedBasicAuthHeaderValue(key),
          throwsA(isA<AuthHeaderEncodingException>()),
        );
      });
    }

    for (var (key, descr) in [
      ...conventionalAuthKeys,
      ...standardNonBasicAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      test(
          'Given an auth key not in "Basic" HTTP auth header format '
          '"${_stripControlCharacters(key)}" ($descr) '
          'when checking if it is wrapped '
          'then it should correctly recognize it as not wrapped', () {
        expect(isWrappedBasicAuthHeaderValue(key), isFalse);
      });
    }
  });

  group('When using auth key wrapping and unwrapping:', () {
    for (var (key, descr) in [
      ...conventionalAuthKeys,
      ...standardBasicAuthKeys,
      ...standardNonBasicAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      test(
          'Given auth key "${_stripControlCharacters(key)}" ($descr) '
          'when wrapping it '
          'then it should result in an HTTP "authorization" compliant value format',
          () {
        var wrapped = wrapAsBasicAuthHeaderValue(key);
        expect(isValidAuthHeaderValue(wrapped), isTrue);
      });

      test(
          'Given auth key "${_stripControlCharacters(key)}" ($descr) '
          'when wrapping and unwrapping it '
          'then it should result in the same value', () {
        var wrapped = wrapAsBasicAuthHeaderValue(key);
        var unwrapped = unwrapAuthHeaderValue(wrapped);
        expect(unwrapped, key);
      });
    }
  });
}

/// In order to print a string representation of test cases containing control characters,
/// strip them out before including them in test output messages.
String _stripControlCharacters(String input) {
  var buffer = StringBuffer();
  for (var codeUnit in input.codeUnits) {
    if (codeUnit >= 32 && codeUnit <= 126) {
      buffer.writeCharCode(codeUnit);
    }
  }
  return buffer.toString();
}
