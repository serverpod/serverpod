import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Given the database-roundtrip/echo server', () {
    test(
        'When a type with nested object is stored in the server, then it can be retrieved later',
        () async {
      var object = ObjectWithObject(
        data: SimpleData(num: 42),
        dataList: [SimpleData(num: 10), SimpleData(num: 20)],
        listWithNullableData: [SimpleData(num: 10), null],
      );

      object = await client.basicDatabase.storeObjectWithObject(object);
      expect(object.id, isNotNull);

      var result = await client.basicDatabase.getObjectWithObject(object.id!);

      expect(result, isNotNull);
      expect(result!.data.num, equals(42));
      expect(result.nullableData, isNull);

      expect(result.dataList.length, equals(2));
      expect(result.dataList[0].num, equals(10));
      expect(result.dataList[1].num, equals(20));

      expect(result.listWithNullableData.length, equals(2));
      expect(result.listWithNullableData[0]!.num, equals(10));
      expect(result.listWithNullableData[1], isNull);

      expect(result.nullableDataList, isNull);
      expect(result.nullableListWithNullableData, isNull);
    });
  });
}
