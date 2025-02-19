import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  test(
      'Given the test server, when a simple int record is sent to the server, then it is returned verbatim',
      () async {
    const record = (1,);

    var result = await client.recordParameters.returnIntRecord(record);

    expect(result, record);
  });

  test(
      'Given the test server, when a simple (int, String) record is sent to the server, then it is returned verbatim',
      () async {
    const record = (1, 'hello');

    var result = await client.recordParameters.returnIntStringRecord(record);

    expect(result, record);
  });

  test(
      'Given the test server, when a record is sent to the server, then it is returned verbatim',
      () async {
    var record = (1, data: SimpleData(num: 1000));

    var result = await client.recordParameters.returnRecordTypedef(record);

    expect(result.$1, 1);
    expect(result.data, isA<SimpleData>().having((d) => d.num, 'num', 1000));
  });

  test(
      'Given the test server, when a simple (int, SimpleData) record is sent to the server, then it is returned verbatim',
      () async {
    var record = (1, SimpleData(num: 1000));

    var result =
        await client.recordParameters.returnIntSimpleDataRecord(record);

    expect(result.$1, 1);
    expect(result.$2, isA<SimpleData>().having((d) => d.num, 'num', 1000));
  });

  test(
      'Given the test server, when a complex nested name record is sent to the server, then it is returned verbatim',
      () async {
    var record = (namedSubRecord: (SimpleData(num: 1), 1.234));

    var result =
        await client.recordParameters.returnNamedNullableNestedRecord(record);

    expect(
      result.namedSubRecord?.$1,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );
    expect(result.namedSubRecord?.$2, 1.234);
  });

  test(
      'Given the test server, when a complex nested positioned record is sent to the server, then it is returned verbatim',
      () async {
    var record = (
      SimpleData(num: 1),
      (
        2,
        SimpleData(num: 3),
      )
    );

    var result = await client.recordParameters
        .returnPositionedNullableNestedRecord(record);

    expect(
      result.$1,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );
    expect(result.$2.$1, 2);
    expect(
      result.$2.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 3),
    );
  });

  test(
      'Given the test server, when a `null` complex nested name record is sent to the server, then it is returned verbatim',
      () async {
    var record = (namedSubRecord: null);

    var result =
        await client.recordParameters.returnNamedNullableNestedRecord(record);

    expect(
      result.namedSubRecord?.$1,
      isNull,
    );
  });

  test(
      'Given the test server, when a `null` complex nested positioned record is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.recordParameters
        .returnPositionedNullableNestedRecord((null, (1, null)));

    expect(
      result.$1,
      isNull,
    );
    expect(result.$2.$1, 1);
    expect(
      result.$2.$2,
      isNull,
    );
  });

  test(
      'Given the test server, when a set of records sent to the server, then it is returned verbatim',
      () async {
    var result = await client.recordParameters.returnSetOfIntSimpleDataRecord({
      (1, SimpleData(num: 1)),
      (2, SimpleData(num: 2)),
    });

    expect(result, hasLength(2));

    expect(result.first.$1, 1);
    expect(
      result.first.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );
    expect(result.last.$1, 2);
    expect(
      result.last.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 2),
    );
  });

  test(
      'Given the test server, when a set of nullable records sent to the server, then it is returned verbatim',
      () async {
    var result =
        await client.recordParameters.returnSetOfNullableIntSimpleDataRecord({
      (1, SimpleData(num: 1)),
      null,
      (2, SimpleData(num: 2)),
    });

    expect(result, hasLength(3));

    expect(result.first?.$1, 1);
    expect(
      result.first?.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );
    expect(result.elementAt(1), isNull);
    expect(result.last?.$1, 2);
    expect(
      result.last?.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 2),
    );
  });

  test(
      'Given the test server, when a set of records sent to the server, then it is returned verbatim',
      () async {
    var result =
        await client.recordParameters.returnNullableSetOfIntSimpleDataRecord({
      (1, SimpleData(num: 1)),
      (2, SimpleData(num: 2)),
    });

    expect(result, hasLength(2));

    expect(result?.first.$1, 1);
    expect(
      result?.first.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );
    expect(result?.last.$1, 2);
    expect(
      result?.last.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 2),
    );
  });

  test(
      'Given the test server, when a `null` Set of records sent to the server, then it is returned verbatim',
      () async {
    var result = await client.recordParameters
        .returnNullableSetOfIntSimpleDataRecord(null);

    expect(
      result,
      isNull,
    );
  });

  test(
      'Given the test server, when a list of records is sent to the server, then it is returned verbatim',
      () async {
    var result = await client.recordParameters.returnListOfIntSimpleDataRecord([
      (1, SimpleData(num: 1)),
      (2, SimpleData(num: 2)),
    ]);

    expect(result, hasLength(2));

    expect(result.first.$1, 1);
    expect(
      result.first.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );
    expect(result.last.$1, 2);
    expect(
      result.last.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 2),
    );
  });

  test(
      'Given the test server, when a `Map<String, Record>` is sent to the server, then it is returned verbatim',
      () async {
    var result =
        await client.recordParameters.returnStringMapOfIntSimpleDataRecord({
      'a': (1, SimpleData(num: 1)),
      'b': (2, SimpleData(num: 2)),
    });

    expect(result, hasLength(2));

    expect(result['a']?.$1, 1);
    expect(
      result['a']?.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );

    expect(result['b']?.$1, 2);
    expect(
      result['b']?.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 2),
    );
  });

  test(
      'Given the test server, when a `Map<Record, Record>` is sent to the server, then it is returned verbatim',
      () async {
    var result =
        await client.recordParameters.returnRecordMapOfIntSimpleDataRecord({
      ('1', 1): (1, SimpleData(num: 1)),
      ('2', 2): (2, SimpleData(num: 2)),
    });

    expect(result, hasLength(2));

    expect(result[('1', 1)]?.$1, 1);
    expect(
      result[('1', 1)]?.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 1),
    );

    expect(result[('2', 2)]?.$1, 2);
    expect(
      result[('2', 2)]?.$2,
      isA<SimpleData>().having((d) => d.num, 'num', 2),
    );
  });
}
