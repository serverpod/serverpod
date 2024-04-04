import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with nullable fields and null values provided when calling fromJson, then it throws an exception.',
      () {
    expect(
      () => SimpleData.fromJson({"num": null}),
      throwsA(isA<FormatException>()),
    );
  });

  test(
      'Given a class with nullable fields and missing values provided when calling fromJson, then it throws a FormatException.',
      () {
    expect(
      () => SimpleData.fromJson({}),
      throwsA(isA<FormatException>()),
    );
  });

  test(
    'Given a class with nullable fields and missing values provided when calling fromJson, then it throws a FormatException.',
    () {
      final oWithO = ObjectWithObject.fromJson({
        "data": SimpleData.fromJson({
          "num": 1,
        }),
      });

      expect(oWithO.nullableData, isNotNull);
    },
  );
}
