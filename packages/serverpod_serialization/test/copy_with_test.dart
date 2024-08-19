import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

// Fake objects to verify behavior on.
enum TestEnum {
  one,
  two,
  three,
}

class SimpleData {
  int num;

  SimpleData({required this.num});

  SimpleData copyWith({int? num}) => SimpleData(num: num ?? this.num);
}

void main() {
  group('Given ByteData when calling strictShallowClone', () {
    test(
        'when modifying the original after creating a copy then the copy is left unmodified',
        () {
      ByteData byteData =
          Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var copy = strictShallowClone(byteData);

      byteData.setUint8(0, 9);

      expect(
        copy.buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
    });

    group(
        'when specifying a slice of the buffer and modifying the original after creating a copy',
        () {
      ByteBuffer buffer = Uint8List.fromList([0, 1, 2, 3, 4]).buffer;

      var offsetInBytes = 2;
      var lengthInBytes = 1;

      ByteData byteDataView = ByteData.view(
        buffer,
        offsetInBytes,
        lengthInBytes,
      );

      var clone = strictShallowClone(byteDataView);

      buffer.asByteData().setUint8(0, 9);

      test('then the copy buffer has the full original data.', () {
        expect(clone.buffer.asUint8List(), Uint8List.fromList([0, 1, 2, 3, 4]));
      });

      test('then the view is preserved.', () {
        expect(clone.getInt8(0), byteDataView.getInt8(0));
      });

      test('then the offsetInBytes is preserved.', () {
        expect(clone.offsetInBytes, offsetInBytes);
      });

      test('then the lengthInBytes is preserved', () {
        expect(clone.lengthInBytes, lengthInBytes);
      });
    });
  });

  test('Given an Enum when calling strictShallowClone then a clone is returned',
      () {
    var original = TestEnum.one;

    var clone = strictShallowClone(original);

    expect(clone, equals(original));
  });

  test('Given a Model when calling strictShallowClone then a clone is returned',
      () {
    var original = SimpleData(num: 1);

    SimpleData clone = strictShallowClone(original);

    expect(clone, isNot(equals(original)));
    expect(clone.num, equals(original.num));
  });

  test(
      'Given a Model when the copyWith method is not defined and calling strictShallowClone then an exception is thrown',
      () {
    Object missingCopyWith = Object();

    expect(
        () => strictShallowClone(missingCopyWith), throwsA(isA<Exception>()));
  });

  test(
      'Given a List when calling strictShallowClone then an exception is thrown',
      () {
    var original = [SimpleData(num: 1), SimpleData(num: 2)];

    expect(() => strictShallowClone(original), throwsA(isA<Exception>()));
  });

  test(
      'Given a Map when calling strictShallowClone then an exception is thrown',
      () {
    var original = {'one': SimpleData(num: 1)};

    expect(() => strictShallowClone(original), throwsA(isA<Exception>()));
  });
}
