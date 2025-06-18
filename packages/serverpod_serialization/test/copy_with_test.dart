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
  group('on ByteData', () {
    test(
        'Given a ByteData when modifying the original after creating a copy then the copy is left unmodified',
        () {
      ByteData byteData =
          Uint8List.fromList([0, 1, 2, 3, 4]).buffer.asByteData();

      var copy = byteData.clone();

      byteData.setUint8(0, 9);

      expect(
        copy.buffer.asUint8List(),
        Uint8List.fromList([0, 1, 2, 3, 4]),
      );
    });

    group(
        'Given a ByteData when specifying a slice of the buffer and modifying the original after creating a copy',
        () {
      ByteBuffer buffer = Uint8List.fromList([0, 1, 2, 3, 4]).buffer;

      var offsetInBytes = 2;
      var lengthInBytes = 1;

      ByteData byteDataView = ByteData.view(
        buffer,
        offsetInBytes,
        lengthInBytes,
      );

      var clone = byteDataView.clone();

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

  group('Given a Vector', () {
    test(
        'when both the original and copy are serialized then they produce identical results.',
        () {
      Vector originalVector = const Vector([1.0, 2.0, 3.0]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
    });

    test(
        'when clone is created, then the clone and original are deeply equal but not the same instance.',
        () {
      Vector originalVector = const Vector([1.0, 2.0, 3.0]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
      expect(identical(copy, originalVector), isFalse);
      expect(identical(copy.toList(), originalVector.toList()), isFalse);
    });
  });

  group('Given a HalfVector', () {
    test(
        'when both the original and copy are serialized then they produce identical results.',
        () {
      HalfVector originalVector = const HalfVector([1.0, 2.0, 3.0]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
    });

    test(
        'when clone is created, then the clone and original are deeply equal but not the same instance.',
        () {
      HalfVector originalVector = const HalfVector([1.0, 2.0, 3.0]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
      expect(identical(copy, originalVector), isFalse);
      expect(identical(copy.toList(), originalVector.toList()), isFalse);
    });
  });

  group('Given a SparseVector', () {
    test(
        'when both the original and copy are serialized then they produce identical results.',
        () {
      SparseVector originalVector = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
    });

    test(
        'when clone is created, then the clone and original are deeply equal but not the same instance.',
        () {
      SparseVector originalVector = SparseVector([1.0, 0.0, 2.0, 0.0, 3.0]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
      expect(identical(copy, originalVector), isFalse);
      expect(identical(copy.toList(), originalVector.toList()), isFalse);

      // Check SparseVector-specific properties
      expect(copy.dimensions, originalVector.dimensions);
      expect(copy.indices, originalVector.indices);
      expect(copy.values, originalVector.values);
      expect(identical(copy.indices, originalVector.indices), isFalse);
      expect(identical(copy.values, originalVector.values), isFalse);
    });
  });

  group('Given a Bit vector', () {
    test(
        'when both the original and copy are serialized then they produce identical results.',
        () {
      Bit originalVector = Bit([true, false, true, false, true]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
    });

    test(
        'when clone is created, then the clone and original are deeply equal but not the same instance.',
        () {
      Bit originalVector = Bit([true, false, true, false, true]);

      var copy = originalVector.clone();

      expect(copy.toJson(), originalVector.toJson());
      expect(identical(copy, originalVector), isFalse);
      expect(identical(copy.toList(), originalVector.toList()), isFalse);
    });
  });
}
