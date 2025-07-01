import 'package:serverpod_serialization/src/pgvector.dart';
import 'package:test/test.dart';
import 'dart:typed_data';
import 'dart:math' as math;

void main() {
  test(
      'Given HalfVector with values when created then toString and toList work correctly.',
      () {
    const vec = HalfVector([1, 2, 3]);
    expect(vec.toString(), equals('[1.0, 2.0, 3.0]'));
    expect(vec.toList(), equals([1, 2, 3]));
  });

  test('Given two HalfVectors when comparing then equality works correctly.',
      () {
    const a = HalfVector([1, 2, 3]);
    const b = HalfVector([1, 2, 3]);
    const c = HalfVector([1, 2, 4]);

    expect(a, equals(b));
    expect(a, isNot(equals(c)));
  });

  test(
      'Given HalfVector when converted to binary and back then original values are preserved.',
      () {
    const original = HalfVector([1.5, -2.25, 3.0, 0.0, -0.0]);
    final binary = original.toBinary();
    final decoded = HalfVector.fromBinary(binary);

    expect(decoded, equals(original));
    expect(decoded.toList(), equals([1.5, -2.25, 3.0, 0.0, -0.0]));
  });

  test(
      'Given HalfVector when converted to binary then binary format structure is correct.',
      () {
    const vector = HalfVector([1.0, 2.0]);
    final binary = vector.toBinary();
    expect(binary.length, equals(8));

    final buf = ByteData.view(binary.buffer, binary.offsetInBytes);
    expect(buf.getInt16(0), equals(2));
    expect(buf.getInt16(2), equals(0));

    final decodedVec = HalfVector.fromBinary(binary);
    expect(decodedVec.toList(), equals([1.0, 2.0]));
  });

  test(
      'Given empty HalfVector when converted to binary then binary contains only header.',
      () {
    const empty = HalfVector([]);
    final binary = empty.toBinary();
    expect(binary.length, equals(4));

    final decoded = HalfVector.fromBinary(binary);
    expect(decoded.toList(), isEmpty);
  });

  test(
      'Given HalfVector with special floating-point values when converted to binary then special values are preserved.',
      () {
    const special = HalfVector([
      0.0,
      -0.0,
      double.infinity,
      double.negativeInfinity,
      double.nan,
    ]);

    final binary = special.toBinary();
    final decoded = HalfVector.fromBinary(binary);

    expect(decoded.toList()[0], equals(0.0));
    expect(decoded.toList()[1], equals(-0.0));
    expect(decoded.toList()[2].isInfinite, isTrue);
    expect(decoded.toList()[2].isNegative, isFalse);
    expect(decoded.toList()[3].isInfinite, isTrue);
    expect(decoded.toList()[3].isNegative, isTrue);
    expect(decoded.toList()[4].isNaN, isTrue);
  });

  test(
      'Given HalfVector with extreme float16 range values when converted to binary then values are within expected precision.',
      () {
    const limits = HalfVector([
      65504.0, // max representable value
      -65504.0, // min representable value
      6.1e-5, // min positive normal
      -6.1e-5, // max negative normal
      1.0e-7, // subnormal (will be close to zero)
    ]);

    final binary = limits.toBinary();
    final decoded = HalfVector.fromBinary(binary);
    const tolerance = 1.0e-5;

    expect(decoded.toList()[0], closeTo(65504.0, tolerance));
    expect(decoded.toList()[1], closeTo(-65504.0, tolerance));
    expect(decoded.toList()[2], closeTo(6.1e-5, tolerance));
    expect(decoded.toList()[3], closeTo(-6.1e-5, tolerance));
    expect(decoded.toList()[4].abs() < 6.1e-5, isTrue);
  });

  test(
      'Given HalfVector with various numeric values when converted to binary then precision is maintained within float16 limits.',
      () {
    final values = [
      0.5,
      1.0,
      1.5,
      2.0,
      3.0,
      4.0,
      5.0,
      10.0,
      100.0,
      1000.0,
      -0.5,
      -1.0,
      -1.5,
      -2.0,
      -3.0,
      -4.0,
      -5.0,
      -10.0,
      -100.0,
      -1000.0,
      0.33333,
      0.66667,
      math.pi,
      math.e,
    ];

    final original = HalfVector(values);
    final binary = original.toBinary();
    final decodedValues = HalfVector.fromBinary(binary).toList();

    for (var i = 0; i < values.length; i++) {
      expect(decodedValues[i], closeTo(values[i], 0.001));
    }
  });
}
