import 'dart:convert';

import 'package:test/test.dart';
import 'package:serverpod_serialization/src/auth_encoding.dart';

void main() {
  /// conventional serverpod auth key format user:pwd
  var conventionalAuthKeys = [
    'joe:pwd',
    'joe,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}\r\n : pwd,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}\r\n',
  ];

  /// standard basic auth schemes' key formats, which is also equivalent to the wrapped key format
  var standardBasicAuthKeys = [
    'Basic dGVzd',
    'Basic dGVzd02348+/',
    'Basic dGVzd==',
    'Basic ',
    'basic dGVzd',
    'BASIC dGVzd',
    'basiC dGVzd',
  ];

  /// standard non-basic auth schemes' key formats
  var standardNonBasicAuthKeys = [
    'Bearer dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
    'bearer dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
    'BEARER dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
    'Digest dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
    'HOBA dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
  ];

  /// basic auth schemes' keys with invalid content
  var invalidBasicAuthKeys = [
    'Basic dGVzd dGVzd dGVzd',
    'Basic dGVzd dGVzd',
    'Basic dGVzd ',
    'Basic dGVzd*',
    'Basic dGVz=d',
    'Basic d#',
    'Basic #',
    'Basic \t',
    'Basic  ',
    'Basic',
  ];

  /// arbitrary auth key formats
  var arbitraryAuthKeys = [
    '',
    ' ',
    '\t',
    '\n',
    '\r',
    ':',
    ':::::::::::::::',
    ',;.:<>_-/\\|"\'`~!@#\$%^&*()+=[]{}\r\n',
    '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',
    json.encode({'key': 'value'}),
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
  ];

  group('When using isValidAuthHeaderValue()', () {
    for (var key in [
      ...standardBasicAuthKeys,
      ...standardNonBasicAuthKeys,
    ]) {
      test(
          'Given an auth key in valid HTTP auth header format ${_stripControlCharacters(key)} '
          'then isValidAuthHeaderValue should correctly recognize it as valid',
          () {
        expect(isValidAuthHeaderValue(key), isTrue);
      });
    }

    for (var key in [
      ...conventionalAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      test(
          'Given an auth key in invalid HTTP auth header format ${_stripControlCharacters(key)} '
          'then isValidAuthHeaderValue should correctly recognize it as invalid',
          () {
        expect(isValidAuthHeaderValue(key), isFalse);
      });
    }
  });

  group('When using isWrappedBasicAuthHeaderValue()', () {
    for (var key in standardBasicAuthKeys) {
      test(
          'Given an auth key in "Basic" HTTP auth header format ${_stripControlCharacters(key)} '
          'then isWrappedBasicAuthHeaderValue should correctly recognize it as a wrapped auth key',
          () {
        expect(isWrappedBasicAuthHeaderValue(key), isTrue);
      });
    }

    for (var key in invalidBasicAuthKeys) {
      test(
          'Given an auth key in "Basic" HTTP auth header with invalid format ${_stripControlCharacters(key)} '
          'then isWrappedBasicAuthHeaderValue should reject it with an exception',
          () {
        expect(() => isWrappedBasicAuthHeaderValue(key), throwsException);
      });
    }

    for (var key in [
      ...conventionalAuthKeys,
      ...standardNonBasicAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      test(
          'Given an auth key not in "Basic" HTTP auth header format ${_stripControlCharacters(key)} '
          'then isWrappedBasicAuthHeaderValue should correctly recognize it as not wrapped',
          () {
        expect(isWrappedBasicAuthHeaderValue(key), isFalse);
      });
    }
  });

  group('When using auth key wrapping and unwrapping', () {
    for (var key in [
      ...conventionalAuthKeys,
      ...standardBasicAuthKeys,
      ...standardNonBasicAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      test(
          'Given auth key "${_stripControlCharacters(key)}" '
          'then wrapping should result in an HTTP "authorization" compliant value format',
          () {
        var wrapped = wrapAsBasicAuthHeaderValue(key);
        expect(isValidAuthHeaderValue(wrapped), isTrue);
      });

      test(
          'Given auth key "${_stripControlCharacters(key)}" '
          'then wrapping and unwrapping should result in the same value', () {
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
