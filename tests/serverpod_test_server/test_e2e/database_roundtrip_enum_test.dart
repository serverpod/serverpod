import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

import 'object_with_enum_builder.dart';

void main() {
  var client = Client(serverUrl);

  test(
      'Given an enum when sending and writing it to the database then the returned value is contains an ID',
      () async {
    var object = ObjectWithEnumBuilder().withTestEnum(TestEnum.two).build();

    var result = await client.basicDatabase.storeObjectWithEnum(object);

    expect(result.id, isNotNull);
  });

  test(
      'Given an enum when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().withTestEnum(TestEnum.two).build();

    var result = await client.basicDatabase.storeObjectWithEnum(object);

    expect(result.testEnum, equals(TestEnum.two));
  });

  test(
      'Given a `null` nullable enum when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().build();

    var result = await client.basicDatabase.storeObjectWithEnum(object);

    expect(result.nullableEnum, isNull);
  });

  test(
      'Given an enum list when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().witheEumList(
      [TestEnum.one, TestEnum.two, TestEnum.three],
    ).build();

    var result = await client.basicDatabase.storeObjectWithEnum(object);

    expect(
      result.enumList,
      equals([TestEnum.one, TestEnum.two, TestEnum.three]),
    );
  });

  test(
      'Given a nullable enum list when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().withNullableEnumList(
      [TestEnum.one, null, TestEnum.three],
    ).build();

    var result = await client.basicDatabase.storeObjectWithEnum(object);

    expect(
      result.nullableEnumList,
      equals([TestEnum.one, null, TestEnum.three]),
    );
  });

  test(
      'Given a nested enum list list when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().withEnumListList(
      [
        [TestEnum.one, TestEnum.two],
        [TestEnum.two, TestEnum.one],
      ],
    ).build();

    var result = await client.basicDatabase.storeObjectWithEnum(object);

    expect(result.enumListList, hasLength(2));
    expect(
      result.enumListList.first,
      equals([TestEnum.one, TestEnum.two]),
    );
    expect(
      result.enumListList.last,
      equals([TestEnum.two, TestEnum.one]),
    );
  });
}
