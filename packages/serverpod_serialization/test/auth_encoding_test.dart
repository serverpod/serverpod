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
  ];

  /// standard non-basic auth schemes' key formats
  var standardNonBasicAuthKeys = [
    'Bearer dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
    'Digest dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
    'HOBA dGVzd ,;.<>_-/\\|"\'`~!@#\$%^&*()+=[]{}',
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

  group('isValidAuthHeaderValue()', () {
    for (var key in [
      ...standardBasicAuthKeys,
      ...standardNonBasicAuthKeys,
    ]) {
      group(
          'Given an auth key in valid HTTP auth header format ${_stripControlCharacters(key)}',
          () {
        test(
            'then isValidAuthHeaderValue should correctly recognize it as valid',
            () {
          expect(isValidAuthHeaderValue(key), true);
        });
      });
    }

    for (var key in [
      ...conventionalAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      group(
          'Given an auth key in invalid HTTP auth header format ${_stripControlCharacters(key)}',
          () {
        test(
            'then isValidAuthHeaderValue should correctly recognize it as invalid',
            () {
          expect(isValidAuthHeaderValue(key), false);
        });
      });
    }
  });

  group('isWrappedAuthValue()', () {
    for (var key in standardBasicAuthKeys) {
      group(
          'Given an auth key in "Basic" HTTP auth header format ${_stripControlCharacters(key)}',
          () {
        test(
            'then isWrappedAuthValue should correctly recognize it as a wrapped auth key',
            () {
          expect(isWrappedAuthValue(key), true);
        });
      });
    }

    for (var key in [
      ...conventionalAuthKeys,
      ...standardNonBasicAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      group(
          'Given an auth key not in "Basic" HTTP auth header format ${_stripControlCharacters(key)}',
          () {
        test(
            'then isWrappedAuthValue should correctly recognize it as not wrapped',
            () {
          expect(isWrappedAuthValue(key), false);
        });
      });
    }
  });

  group('Auth key wrapping and unwrapping', () {
    for (var key in [
      ...conventionalAuthKeys,
      ...standardBasicAuthKeys,
      ...standardNonBasicAuthKeys,
      ...arbitraryAuthKeys,
    ]) {
      group('Given auth key ${_stripControlCharacters(key)}', () {
        test(
            'then wrapping should result in an HTTP "authorization" compliant value format',
            () {
          var wrapped = wrapAuthValue(key);
          expect(isValidAuthHeaderValue(wrapped), true);
        });

        test('then wrapping and unwrapping should result in the same value',
            () {
          var wrapped = wrapAuthValue(key);
          var unwrapped = unwrapAuthValue(wrapped);
          expect(unwrapped, key);
        });
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
