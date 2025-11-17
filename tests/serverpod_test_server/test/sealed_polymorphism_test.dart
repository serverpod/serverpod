import 'package:serverpod_test_server/src/generated/inheritance/sealed_parent.dart';
import 'package:test/test.dart';

void main() {
  test('Sealed class polymorphic copyWith', () {
    final child = SealedChild(
      sealedInt: 42,
      sealedString: 'hello',
      nullableInt: 10,
    );
    
    // Use parent type reference
    final SealedParent parent = child;
    final copied = parent.copyWith(sealedInt: 100);
    
    expect(copied.sealedInt, equals(100));
    expect(copied.sealedString, equals('hello'));
    expect(copied, isA<SealedChild>());
  });

  test('Sealed class polymorphic fromJson', () {
    final child = SealedChild(
      sealedInt: 42,
      sealedString: 'hello',
      nullableInt: 10,
    );
    
    final json = child.toJson();
    
    // Use parent type reference
    final SealedParent parent = child;
    final fromJson = parent.fromJson(json);
    
    expect(fromJson.sealedInt, equals(42));
    expect(fromJson.sealedString, equals('hello'));
    expect(fromJson, isA<SealedChild>());
  });
}
