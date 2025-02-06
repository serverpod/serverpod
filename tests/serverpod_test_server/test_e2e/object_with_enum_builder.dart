import 'package:serverpod_test_client/serverpod_test_client.dart';

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
