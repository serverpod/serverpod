import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given the "ObjectWithEnum" database-roundtrip/echo endpoint', () {
    test(
        'When writing an object with enum-based fields, then it\'s persisted and retrievable later',
        () async {
      var object = ObjectWithEnum(
        testEnum: TestEnum.two,
        nullableEnum: null,
        enumList: [TestEnum.one, TestEnum.two, TestEnum.three],
        nullableEnumList: [TestEnum.one, null, TestEnum.three],
        enumListList: [
          [TestEnum.one, TestEnum.two],
          [TestEnum.two, TestEnum.one]
        ],
      );

      object = await client.basicDatabase.storeObjectWithEnum(object);
      expect(object.id, isNotNull);

      var returnedObject =
          await client.basicDatabase.getObjectWithEnum(object.id!);
      expect(returnedObject, isNotNull);
      expect(returnedObject!.testEnum, equals(TestEnum.two));
      expect(returnedObject.enumListList.length, equals(2));
      expect(returnedObject.enumListList[0].length, equals(2));
      expect(returnedObject.enumListList[0][0], equals(TestEnum.one));
      expect(returnedObject.enumListList[0][1], equals(TestEnum.two));
      expect(returnedObject.enumListList[1].length, equals(2));
      expect(returnedObject.enumListList[1][0], equals(TestEnum.two));
      expect(returnedObject.enumListList[1][1], equals(TestEnum.one));
    });
  });
}
