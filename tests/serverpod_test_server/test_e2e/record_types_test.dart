import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  group('Record with single positional field', () {
    test(
        'Given the test server, when a simple int record is sent to the server, then it is returned verbatim',
        () async {
      const record = (1,);

      var result = await client.recordParameters.returnRecordOfInt(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a nullable simple int record is sent to the server, then it is returned verbatim',
        () async {
      const record = (1,);

      var result =
          await client.recordParameters.returnRecordOfNullableInt(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a `null` simple int record is sent to the server, then it is returned verbatim',
        () async {
      (int?,) record = (null,);

      var result =
          await client.recordParameters.returnRecordOfNullableInt(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a nullable simple int? record containing `null` is sent to the server, then it is returned verbatim',
        () async {
      const (int?,)? record = (null,);

      var result = await client.recordParameters
          .returnNullableRecordOfNullableInt(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a `null` simple int? record is sent to the server, then it is returned verbatim',
        () async {
      var result =
          await client.recordParameters.returnNullableRecordOfNullableInt(null);

      expect(result, isNull);
    });
  });

  group('Record with multiple positional fields', () {
    test(
        'Given the test server, when a simple (int, String) record is sent to the server, then it is returned verbatim',
        () async {
      const record = (1, 'hello');

      var result = await client.recordParameters.returnIntStringRecord(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a non-`null` simple (int, String)? record is sent to the server, then it is returned verbatim',
        () async {
      const record = (1, 'hello');

      var result =
          await client.recordParameters.returnNullableIntStringRecord(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a `null` simple (int, String)? record is sent to the server, then it is returned verbatim',
        () async {
      var result =
          await client.recordParameters.returnNullableIntStringRecord(null);

      expect(result, isNull);
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
        'Given the test server, when a non-`null` simple (int, String)? record is sent to the server, then it is returned verbatim',
        () async {
      var record = (1, SimpleData(num: 1000));

      var result = await client.recordParameters
          .returnNullableIntSimpleDataRecord(record);

      expect(result?.$1, 1);
      expect(result?.$2, isA<SimpleData>().having((d) => d.num, 'num', 1000));
    });

    test(
        'Given the test server, when a `null` simple (int, SimpleData)? record is sent to the server, then it is returned verbatim',
        () async {
      var result =
          await client.recordParameters.returnNullableIntSimpleDataRecord(null);

      expect(result, isNull);
    });
  });

  group('Record with multiple named fields', () {
    test(
        'Given the test server, when a simple record with named fields is sent to the server, then it is returned verbatim',
        () async {
      var record = (number: 1, text: 'test');

      var result =
          await client.recordParameters.returnNamedIntStringRecord(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a simple nullable record with named fields is sent to the server, then it is returned verbatim',
        () async {
      const ({int number, String text})? record = (number: 1, text: 'test');

      var result = await client.recordParameters
          .returnNamedNullableIntStringRecord(record);

      expect(result, record);
    });

    test(
        'Given the test server, when a simple `null` record with named fields is sent to the server, then it is returned verbatim',
        () async {
      var result = await client.recordParameters
          .returnNamedNullableIntStringRecord(null);

      expect(result, isNull);
    });

    test(
        'Given the test server, when a record with named fields including an object is sent to the server, then it is returned verbatim',
        () async {
      var record = (number: 1, data: SimpleData(num: 1000));

      var result =
          await client.recordParameters.returnRecordOfNamedIntAndObject(record);

      expect(result.number, 1);
      expect(result.data, isA<SimpleData>().having((d) => d.num, 'num', 1000));
    });

    test(
        'Given the test server, when a nullable record with named fields including an object is sent to the server, then it is returned verbatim',
        () async {
      var record = (number: 1, data: SimpleData(num: 1000));

      var result = await client.recordParameters
          .returnNullableRecordOfNamedIntAndObject(record);

      expect(result?.number, 1);
      expect(result?.data, isA<SimpleData>().having((d) => d.num, 'num', 1000));
    });

    test(
        'Given the test server, when a  `null` record with named fields including an object is sent to the server, then it is returned verbatim',
        () async {
      var result = await client.recordParameters
          .returnNullableRecordOfNamedIntAndObject(null);

      expect(result, isNull);
    });

    test(
        'Given the test server, when a  record with nullable named fields including an object is sent to the server, then it is returned verbatim',
        () async {
      var record = (number: 1, data: SimpleData(num: 1000));

      var result = await client.recordParameters
          .returnRecordOfNamedNullableIntAndNullableObject(record);

      expect(result.number, 1);
      expect(result.data, isA<SimpleData>().having((d) => d.num, 'num', 1000));
    });

    test(
        'Given the test server, when a  record with nullable named fields including an object is sent to the server, then it is returned verbatim',
        () async {
      const ({int? number, SimpleData? data}) record = (
        number: null,
        data: null,
      );

      var result = await client.recordParameters
          .returnRecordOfNamedNullableIntAndNullableObject(record);

      expect(result, record);
    });
  });

  group(
      'Record with mixed positional and named parameters defined via a `typedef`',
      () {
    test(
        'Given the test server, when a record is sent to the server, then it is returned verbatim',
        () async {
      var record = (1, data: SimpleData(num: 1000));

      var result = await client.recordParameters.returnRecordTypedef(record);

      expect(result.$1, 1);
      expect(result.data, isA<SimpleData>().having((d) => d.num, 'num', 1000));
    });

    test(
        'Given the test server, when a nullable record is sent to the server, then it is returned verbatim',
        () async {
      var record = (1, data: SimpleData(num: 1000));

      var result =
          await client.recordParameters.returnNullableRecordTypedef(record);

      expect(result?.$1, 1);
      expect(result?.data, isA<SimpleData>().having((d) => d.num, 'num', 1000));
    });

    test(
        'Given the test server, when a `null` record is sent to the server, then it is returned verbatim',
        () async {
      var result =
          await client.recordParameters.returnNullableRecordTypedef(null);

      expect(result, isNull);
    });
  });

  group('List of records', () {
    test(
        'Given the test server, when a list of records is sent to the server, then it is returned verbatim',
        () async {
      var result =
          await client.recordParameters.returnListOfIntSimpleDataRecord([
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
        'Given the test server, when a list of nullable records is sent to the server, then it is returned verbatim',
        () async {
      var result = await client.recordParameters
          .returnListOfNullableIntSimpleDataRecord([
        null,
        (1, SimpleData(num: 1)),
        null,
        (2, SimpleData(num: 2)),
        null,
      ]);

      expect(result, [
        isNull,
        isNot(isNull),
        isNull,
        isNot(isNull),
        isNull,
      ]);

      expect(result.elementAt(1)?.$1, 1);
      expect(
        result.elementAt(1)?.$2,
        isA<SimpleData>().having((d) => d.num, 'num', 1),
      );

      expect(result.elementAt(3)?.$1, 2);
      expect(
        result.elementAt(3)?.$2,
        isA<SimpleData>().having((d) => d.num, 'num', 2),
      );
    });
  });

  group('Set of records', () {
    test(
        'Given the test server, when a set of records sent to the server, then it is returned verbatim',
        () async {
      var result =
          await client.recordParameters.returnSetOfIntSimpleDataRecord({
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
  });

  group('Map of records', () {
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
        'Given the test server, when a `Map<String, Record?>` is sent to the server, then it is returned verbatim',
        () async {
      var result = await client.recordParameters
          .returnStringMapOfNullableIntSimpleDataRecord({
        'foo': (1, SimpleData(num: 2)),
        'bar': null,
      });

      expect(result, hasLength(2));

      expect(result['foo']?.$1, 1);
      expect(
        result['foo']?.$2,
        isA<SimpleData>().having((d) => d.num, 'num', 2),
      );

      expect(result['bar'], isNull);
    });
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

  group('Records inside multiple levels of containers', () {
    test(
        'Given the test server, when a complex nested structure with records is sent to the server, then it is returned in the expected transformation',
        () async {
      var result = await client.recordParameters.returnStringMapOfListOfRecord({
        [
          {'key': (123,)}
        ]
      });

      expect(result.keys.single, 'key');
      expect(result.values.single.single.single.$1, 123);
    });
  });

  group('Record nested inside another record', () {
    test(
        'Given the test server, when a complex nested named record is sent to the server, then it is returned verbatim',
        () async {
      var record = (namedSubRecord: (SimpleData(num: 1), 1.234));

      var result =
          await client.recordParameters.returnNestedNamedRecord(record);

      expect(
        result.namedSubRecord.$1,
        isA<SimpleData>().having((d) => d.num, 'num', 1),
      );
      expect(result.namedSubRecord.$2, 1.234);
    });

    test(
        'Given the test server, when a `null` complex nested named record is sent to the server, then it is returned verbatim',
        () async {
      var result = await client.recordParameters
          .returnNestedNullableNamedRecord((namedSubRecord: null,));

      expect(result.namedSubRecord, isNull);
    });

    test(
        'Given the test server, when a complex nested positioned and named record is sent to the server, then it is returned verbatim',
        () async {
      var record = (
        (1, '2'),
        namedSubRecord: (
          SimpleData(num: 3),
          4.5,
        )
      );

      var result = await client.recordParameters
          .returnNestedPositionalAndNamedRecord(record);

      expect(
        result.$1,
        (1, '2'),
      );
      expect(
        result.namedSubRecord.$1,
        isA<SimpleData>().having((d) => d.num, 'num', 3),
      );
      expect(result.namedSubRecord.$2, 4.5);
    });
  });

  test(
      'Given the test server, when a `null` complex nested positioned record is sent to the server, then it is returned verbatim',
      () async {
    var record = (
      (1, '2'),
      namedSubRecord: (
        SimpleData(num: 3),
        4.5,
      )
    );

    var result = await client.recordParameters
        .returnListOfNestedPositionalAndNamedRecord([record, record]);

    expect(result, hasLength(2));
    expect(
      result.first.$1,
      (1, '2'),
    );
    expect(
      result.first.namedSubRecord.$1,
      isA<SimpleData>().having((d) => d.num, 'num', 3),
    );
    expect(result.first.namedSubRecord.$2, 4.5);
  });
}
