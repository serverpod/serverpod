import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

import 'object_with_object_builder.dart';

void main() {
  var client = Client(serverUrl);

  group('Given the database-roundtrip/echo server', () {
    test(
        'When a type with a nested data object is sent to in the server, then it is returned',
        () async {
      var object =
          ObjectWithObjectBuilder().withData(SimpleData(num: 42)).build();

      final result = await client.basicDatabase.storeObjectWithObject(object);

      expect(result.id, isNotNull);
      expect(result.data.num, equals(42));
      expect(result.nullableData, isNull);
    });

    test(
        'When a type with a `null` nested data object is sent to the server, then it is returned',
        () async {
      var object = ObjectWithObjectBuilder().build();

      final result = await client.basicDatabase.storeObjectWithObject(object);

      expect(result.nullableData, isNull);
    });

    test(
        'When a type with a nested object list is sent to the server, then it is returned',
        () async {
      var object = ObjectWithObjectBuilder()
          .withDataList([SimpleData(num: 10), SimpleData(num: 20)]).build();

      var result = await client.basicDatabase.storeObjectWithObject(object);

      expect(result.dataList.length, equals(2));
      expect(result.dataList[0].num, equals(10));
      expect(result.dataList[1].num, equals(20));
    });

    test(
        'When a type with a nested nullable list is sent to the server, then it is returned',
        () async {
      var object = ObjectWithObjectBuilder().withListWithNullableData(
        [SimpleData(num: 10), null],
      ).build();

      var result = await client.basicDatabase.storeObjectWithObject(object);

      expect(result.listWithNullableData.length, equals(2));
      expect(result.listWithNullableData[0]?.num, equals(10));
      expect(result.listWithNullableData[1], isNull);
    });

    test(
        'When a type with a `null` nested list is sent to the server, then it is returned',
        () async {
      var object = ObjectWithObjectBuilder().withListWithNullableData(
        [SimpleData(num: 10), null],
      ).build();

      var result = await client.basicDatabase.storeObjectWithObject(object);

      expect(result.nullableListWithNullableData, isNull);
    });
  });
}
