import 'package:relic/src/headers.dart';
import 'package:test/test.dart';

void main() {
  test('Headers.from', () {
    var header = Headers.from({
      'FoO': ['x', 'y'],
      'bAr': ['z'],
    });

    expect(header['foo'], equals(['x', 'y']));
    expect(header['BAR'], equals(['z']));

    expect(() => header['X'] = ['x'], throwsA(isA<UnsupportedError>()));
  });

  test('Headers.fromEntries', () {
    var header = Headers.fromEntries({
      'FoO': ['x', 'y'],
      'bAr': ['z'],
    }.entries);

    expect(header['foo'], equals(['x', 'y']));
    expect(header['BAR'], equals(['z']));

    expect(() => header['X'] = ['x'], throwsA(isA<UnsupportedError>()));
  });
}
