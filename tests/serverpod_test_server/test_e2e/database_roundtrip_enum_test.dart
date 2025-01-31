import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/test.dart';

void main() {
  var client = Client(serverUrl);

  test(
      'Given an enum when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().withTestEnum(TestEnum.two).build();

    object = await client.basicDatabase.storeObjectWithEnum(object);
    expect(object.id, isNotNull);

    var result = await client.basicDatabase.getObjectWithEnum(object.id!);

    expect(result, isNotNull);
    expect(result!.testEnum, equals(TestEnum.two));
  });

  test(
      'Given a `null` nullable enum when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().build();

    object = await client.basicDatabase.storeObjectWithEnum(object);
    expect(object.id, isNotNull);

    var result = await client.basicDatabase.getObjectWithEnum(object.id!);

    expect(result, isNotNull);
    expect(result!.nullableEnum, isNull);
  });

  test(
      'Given an enum list when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().witheEumList(
      [TestEnum.one, TestEnum.two, TestEnum.three],
    ).build();

    object = await client.basicDatabase.storeObjectWithEnum(object);
    expect(object.id, isNotNull);

    var result = await client.basicDatabase.getObjectWithEnum(object.id!);

    expect(result, isNotNull);
    expect(
      result!.enumList,
      equals([TestEnum.one, TestEnum.two, TestEnum.three]),
    );
  });

  test(
      'Given a nullable enum llist when sending and writing it to the database then the returned value is unmodified',
      () async {
    var object = ObjectWithEnumBuilder().withNullableEnumList(
      [TestEnum.one, null, TestEnum.three],
    ).build();

    object = await client.basicDatabase.storeObjectWithEnum(object);
    expect(object.id, isNotNull);

    var result = await client.basicDatabase.getObjectWithEnum(object.id!);

    expect(result, isNotNull);
    expect(
      result!.nullableEnumList,
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

    object = await client.basicDatabase.storeObjectWithEnum(object);
    expect(object.id, isNotNull);

    var result = await client.basicDatabase.getObjectWithEnum(object.id!);

    expect(result, isNotNull);

    expect(result!.enumListList, hasLength(2));
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

class ObjectWithEnumBuilder {
  TestEnum _testEnum;

  TestEnum? _nullableEnum;

  List<TestEnum> _enumList;

  List<TestEnum?> _nullableEnumList;

  List<List<TestEnum>> _enumListList;

  ObjectWithEnumBuilder()
      : _testEnum = TestEnum.one,
        _nullableEnum = null,
        _enumList = [],
        _nullableEnumList = [],
        _enumListList = [];

  ObjectWithEnum build() {
    return ObjectWithEnum(
      testEnum: _testEnum,
      nullableEnum: _nullableEnum,
      enumList: _enumList,
      nullableEnumList: _nullableEnumList,
      enumListList: _enumListList,
    );
  }

  ObjectWithEnumBuilder withTestEnum(TestEnum value) {
    _testEnum = value;
    return this;
  }

  ObjectWithEnumBuilder withNullableEnum(TestEnum? value) {
    _nullableEnum = value;
    return this;
  }

  ObjectWithEnumBuilder witheEumList(List<TestEnum> value) {
    _enumList = value;
    return this;
  }

  ObjectWithEnumBuilder withNullableEnumList(List<TestEnum?> value) {
    _nullableEnumList = value;
    return this;
  }

  ObjectWithEnumBuilder withEnumListList(List<List<TestEnum>> value) {
    _enumListList = value;
    return this;
  }
}
