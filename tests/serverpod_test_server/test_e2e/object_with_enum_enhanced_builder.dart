import 'package:serverpod_test_client/serverpod_test_client.dart';

class ObjectWithEnumEnhancedBuilder {
  TestEnumEnhanced _testEnumEnhanced;

  TestEnumEnhanced? _nullableEnumEnhanced;

  List<TestEnumEnhanced> _enumEnhancedList;

  ObjectWithEnumEnhancedBuilder()
    : _testEnumEnhanced = TestEnumEnhanced.one,
      _nullableEnumEnhanced = null,
      _enumEnhancedList = [];

  ObjectWithEnumEnhanced build() {
    return ObjectWithEnumEnhanced(
      testEnumEnhanced: _testEnumEnhanced,
      nullableEnumEnhanced: _nullableEnumEnhanced,
      enumEnhancedList: _enumEnhancedList,
    );
  }

  ObjectWithEnumEnhancedBuilder withTestEnumEnhanced(TestEnumEnhanced value) {
    _testEnumEnhanced = value;
    return this;
  }

  ObjectWithEnumEnhancedBuilder withNullableEnumEnhanced(
    TestEnumEnhanced? value,
  ) {
    _nullableEnumEnhanced = value;
    return this;
  }

  ObjectWithEnumEnhancedBuilder withEnumEnhancedList(
    List<TestEnumEnhanced> value,
  ) {
    _enumEnhancedList = value;
    return this;
  }
}
