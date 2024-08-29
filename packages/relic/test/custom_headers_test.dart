import 'package:relic/src/headers/custom_headers.dart';
import 'package:test/test.dart';

const _customHeaderPrefix = 'custom-header-';

void main() {
  group('CustomHeaders', () {
    test('from - should not require custom prefix in keys', () {
      var header = CustomHeaders.from({
        'FoO': ['x', 'y'],
        'bAr': ['z'],
      });

      // Accessing headers should not include the prefix
      expect(header['foo'], equals(['x', 'y']));
      expect(header['bar'], equals(['z']));

      // When retrieving httpRequestEntries, the prefix should be added back
      var httpRequestEntries = header.httpRequestEntries.toList();
      expect(httpRequestEntries.first.key, equals('custom-header-foo'));
      expect(httpRequestEntries.first.value, equals(['x', 'y']));
      expect(httpRequestEntries.last.key, equals('custom-header-bar'));
      expect(httpRequestEntries.last.value, equals(['z']));

      // Header should remain immutable
      expect(() => header['foo'] = ['new_value'],
          throwsA(isA<UnsupportedError>()));
    });

    test('fromEntries - should not require custom prefix in keys', () {
      var header = CustomHeaders.fromEntries({
        'FoO': ['x', 'y'],
        'bAr': ['z'],
      }.entries);

      // Accessing headers should not include the prefix
      expect(header['foo'], equals(['x', 'y']));
      expect(header['bar'], equals(['z']));

      // When retrieving httpRequestEntries, the prefix should be added back
      var httpRequestEntries = header.httpRequestEntries.toList();
      expect(httpRequestEntries.first.key, equals('custom-header-foo'));
      expect(httpRequestEntries.first.value, equals(['x', 'y']));
      expect(httpRequestEntries.last.key, equals('custom-header-bar'));
      expect(httpRequestEntries.last.value, equals(['z']));

      // Header should remain immutable
      expect(() => header['foo'] = ['new_value'],
          throwsA(isA<UnsupportedError>()));
    });

    test(
        'fromHttpRequestEntries - should filter and require custom prefix in keys',
        () {
      var header = CustomHeaders.fromHttpRequestEntries({
        '${_customHeaderPrefix}FoO': ['x', 'y'],
        '${_customHeaderPrefix}bAr': ['z'],
        'CommonHeader': ['commonValue'], // This should be ignored
      }.entries);

      // Prefix should be removed in the map keys after parsing
      expect(header['foo'], equals(['x', 'y']));
      expect(header['bar'], equals(['z']));
      expect(header.containsKey('CommonHeader'), isFalse);

      // When retrieving httpRequestEntries, the prefix should be added back
      var httpRequestEntries = header.httpRequestEntries.toList();
      expect(httpRequestEntries.first.key, equals('custom-header-foo'));
      expect(httpRequestEntries.first.value, equals(['x', 'y']));
      expect(httpRequestEntries.last.key, equals('custom-header-bar'));
      expect(httpRequestEntries.last.value, equals(['z']));

      // Header should remain immutable
      expect(() => header['foo'] = ['new_value'],
          throwsA(isA<UnsupportedError>()));
    });

    test('CustomHeaders should ignore empty lists', () {
      var header = CustomHeaders.from({
        'FoO': ['x', 'y'],
        'bAr': [],
      });

      // 'bAr' should not be included since it has an empty list
      expect(header['foo'], equals(['x', 'y']));
      expect(header.containsKey('bar'), isFalse);

      // Ensure httpRequestEntries behaves the same way
      var httpRequestEntries = header.httpRequestEntries.toList();
      expect(httpRequestEntries.length, equals(1));
      expect(httpRequestEntries.first.key, equals('custom-header-foo'));
      expect(httpRequestEntries.first.value, equals(['x', 'y']));
    });

    test('CustomHeaders should correctly remove prefix on decoding', () {
      var headersWithPrefix = {
        '${_customHeaderPrefix}FoO': ['x', 'y'],
        '${_customHeaderPrefix}bAr': ['z'],
      };

      var header =
          CustomHeaders.fromHttpRequestEntries(headersWithPrefix.entries);

      // Prefix should be removed in the parsed object
      expect(header['foo'], equals(['x', 'y']));
      expect(header['bar'], equals(['z']));
    });

    test('httpRequestEntries should correctly add prefix', () {
      var header = CustomHeaders.from({
        'FoO': ['x', 'y'],
        'bAr': ['z'],
      });

      // Check that httpRequestEntries adds the custom prefix correctly
      var httpRequestEntries = header.httpRequestEntries.toList();
      expect(httpRequestEntries.first.key, equals('custom-header-foo'));
      expect(httpRequestEntries.first.value, equals(['x', 'y']));
      expect(httpRequestEntries.last.key, equals('custom-header-bar'));
      expect(httpRequestEntries.last.value, equals(['z']));
    });

    test('Normal case - without prefix involved', () {
      var header = CustomHeaders.from({
        'Content-Type': ['application/json'],
        'Authorization': ['Bearer token'],
      });

      // Access headers normally without custom prefix
      expect(header['content-type'], equals(['application/json']));
      expect(header['authorization'], equals(['Bearer token']));

      // No prefix should be added in httpRequestEntries since we're not using custom headers
      var httpRequestEntries = header.entries.toList();
      expect(httpRequestEntries.first.key, equals('content-type'));
      expect(httpRequestEntries.first.value, equals(['application/json']));
      expect(httpRequestEntries.last.key, equals('authorization'));
      expect(httpRequestEntries.last.value, equals(['Bearer token']));
    });
  });
}
