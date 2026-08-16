import 'package:serverpod_test_client/serverpod_test_client.dart';

class ObjectWithEnumEnhancedBuilder {
  TestEnumEnhanced _byIndex;
  TestEnumEnhanced? _nullableByIndex;
  List<TestEnumEnhanced> _byIndexList;
  TestEnumEnhancedByName _byName;
  TestEnumEnhancedByName? _nullableByName;
  List<TestEnumEnhancedByName> _byNameList;

  ObjectWithEnumEnhancedBuilder()
    : _byIndex = TestEnumEnhanced.one,
      _nullableByIndex = null,
      _byIndexList = [],
      _byName = TestEnumEnhancedByName.one,
      _nullableByName = null,
      _byNameList = [];

  ObjectWithEnumEnhanced build() {
    return ObjectWithEnumEnhanced(
      byIndex: _byIndex,
      nullableByIndex: _nullableByIndex,
      byIndexList: _byIndexList,
      byName: _byName,
      nullableByName: _nullableByName,
      byNameList: _byNameList,
    );
  }

  ObjectWithEnumEnhancedBuilder withByIndex(TestEnumEnhanced value) {
    _byIndex = value;
    return this;
  }

  ObjectWithEnumEnhancedBuilder withNullableByIndex(TestEnumEnhanced? value) {
    _nullableByIndex = value;
    return this;
  }

  ObjectWithEnumEnhancedBuilder withByIndexList(List<TestEnumEnhanced> value) {
    _byIndexList = value;
    return this;
  }

  ObjectWithEnumEnhancedBuilder withByName(TestEnumEnhancedByName value) {
    _byName = value;
    return this;
  }

  ObjectWithEnumEnhancedBuilder withNullableByName(
    TestEnumEnhancedByName? value,
  ) {
    _nullableByName = value;
    return this;
  }

  ObjectWithEnumEnhancedBuilder withByNameList(
    List<TestEnumEnhancedByName> value,
  ) {
    _byNameList = value;
    return this;
  }
}
