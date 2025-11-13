import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

typedef _MixedRecordTypeDef = (int number, {SimpleData data});

class RecordParametersEndpoint extends Endpoint {
  // #region Records with single positional parameter (required and nullable)
  Future<(int,)> returnRecordOfInt(Session session, (int,) record) async {
    return record;
  }

  Future<(int,)?> returnNullableRecordOfInt(
    Session session,
    (int,)? record,
  ) async {
    return record;
  }

  Future<(int?,)> returnRecordOfNullableInt(
    Session session,
    (int?,) record,
  ) async {
    return record;
  }

  Future<(int?,)?> returnNullableRecordOfNullableInt(
    Session session,
    (int?,)? record,
  ) async {
    return record;
  }

  Stream<(int?,)?> streamNullableRecordOfNullableInt(
    Session session,
    Stream<(int?,)?> values,
  ) async* {
    await for (var value in values) {
      yield value;
    }
  }
  // #endregion

  // #region Records with multiple positional parameters
  Future<(int, String)> returnIntStringRecord(
    Session session,
    (int, String) record,
  ) async {
    return record;
  }

  Future<(int, String)?> returnNullableIntStringRecord(
    Session session,
    (int, String)? record,
  ) async {
    return record;
  }

  Future<(int, SimpleData)> returnIntSimpleDataRecord(
    Session session,
    (int, SimpleData) record,
  ) async {
    return record;
  }

  Future<(int, SimpleData)?> returnNullableIntSimpleDataRecord(
    Session session,
    (int, SimpleData)? record,
  ) async {
    return record;
  }

  Future<(Map<String, int>,)> returnStringKeyedMapRecord(
    Session session,
    (Map<String, int>,) record,
  ) async {
    return record;
  }

  Future<(Map<int, int>,)> returnNonStringKeyedMapRecord(
    Session session,
    (Map<int, int>,) record,
  ) async {
    return record;
  }

  Future<(Set<(int,)>,)> returnSetWithNestedRecordRecord(
    Session session,
    (Set<(int,)>,) record,
  ) async {
    return record;
  }
  // #endregion

  // #region Records with named parameters
  Future<({int number, String text})> returnNamedIntStringRecord(
    Session session,
    ({int number, String text}) record,
  ) async {
    return record;
  }

  Future<({int number, String text})?> returnNamedNullableIntStringRecord(
    Session session,
    ({int number, String text})? record,
  ) async {
    return record;
  }

  Future<({int number, SimpleData data})> returnRecordOfNamedIntAndObject(
    Session session,
    ({int number, SimpleData data}) record,
  ) async {
    return record;
  }

  Future<({int number, SimpleData data})?>
  returnNullableRecordOfNamedIntAndObject(
    Session session,
    ({int number, SimpleData data})? record,
  ) async {
    return record;
  }

  Future<({int? number, SimpleData? data})>
  returnRecordOfNamedNullableIntAndNullableObject(
    Session session,
    ({int? number, SimpleData? data}) record,
  ) async {
    return record;
  }

  Future<({Map<int, int> intIntMap})> returnNamedNonStringKeyedMapRecord(
    Session session,
    ({Map<int, int> intIntMap}) record,
  ) async {
    return record;
  }

  Future<({Set<(bool,)> boolSet})> returnNamedSetWithNestedRecordRecord(
    Session session,
    ({Set<(bool,)> boolSet}) record,
  ) async {
    return record;
  }

  Future<(Map<(Map<int, String>, String), String>,)>
  returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord(
    Session session,
    (Map<(Map<int, String>, String), String>,) map,
  ) async {
    return map;
  }
  // #endregion

  // #region Records using a `typedef`, pointing to positional and named parameters
  Future<_MixedRecordTypeDef> returnRecordTypedef(
    Session session,
    _MixedRecordTypeDef record,
  ) async {
    return record;
  }

  Future<_MixedRecordTypeDef?> returnNullableRecordTypedef(
    Session session,
    _MixedRecordTypeDef? record,
  ) async {
    return record;
  }
  // #endregion

  // #region Records inside `List`s
  Future<List<(int, SimpleData)>> returnListOfIntSimpleDataRecord(
    Session session,
    List<(int, SimpleData)> recordList,
  ) async {
    return recordList;
  }

  Future<List<(int, SimpleData)?>> returnListOfNullableIntSimpleDataRecord(
    Session session,
    List<(int, SimpleData)?> record,
  ) async {
    return record;
  }
  // #endregion

  // #region Records inside `Set`s
  Future<Set<(int, SimpleData)>> returnSetOfIntSimpleDataRecord(
    Session session,
    Set<(int, SimpleData)> recordSet,
  ) async {
    return recordSet;
  }

  Future<Set<(int, SimpleData)?>> returnSetOfNullableIntSimpleDataRecord(
    Session session,
    Set<(int, SimpleData)?> set,
  ) async {
    return set;
  }

  Future<Set<(int, SimpleData)>?> returnNullableSetOfIntSimpleDataRecord(
    Session session,
    Set<(int, SimpleData)>? recordSet,
  ) async {
    return recordSet;
  }
  // #endregion

  // #region Records inside `Map`s
  Future<Map<String, (int, SimpleData)>> returnStringMapOfIntSimpleDataRecord(
    Session session,
    Map<String, (int, SimpleData)> map,
  ) async {
    return map;
  }

  Future<Map<String, (int, SimpleData)?>>
  returnStringMapOfNullableIntSimpleDataRecord(
    Session session,
    Map<String, (int, SimpleData)?> map,
  ) async {
    return map;
  }

  Future<Map<(String, int), (int, SimpleData)>>
  returnRecordMapOfIntSimpleDataRecord(
    Session session,
    Map<(String, int), (int, SimpleData)> map,
  ) async {
    return map;
  }
  // #endregion

  // #region Complex nested container structure
  /// Returns the first and only input value mapped into the return structure (basically reversed)
  Future<Map<String, List<Set<(int,)>>>> returnStringMapOfListOfRecord(
    Session session,
    // This type is only used in a parameter postion, ensuring that we generate those as well
    Set<List<Map<String, (int,)>>> input,
  ) async {
    var key = input.single.single.keys.single;
    var value = input.single.single.values.single.$1;

    return {
      key: [
        {
          (value,),
        },
      ],
    };
  }
  // #endregion

  // #region Records with nested records
  Future<({(SimpleData, double) namedSubRecord})> returnNestedNamedRecord(
    Session session,
    ({(SimpleData, double) namedSubRecord}) record,
  ) async {
    return record;
  }

  Future<({(SimpleData, double)? namedSubRecord})>
  returnNestedNullableNamedRecord(
    Session session,
    ({(SimpleData, double)? namedSubRecord}) record,
  ) async {
    return record;
  }

  Future<((int, String), {(SimpleData, double) namedSubRecord})>
  returnNestedPositionalAndNamedRecord(
    Session session,
    ((int, String), {(SimpleData, double) namedSubRecord}) record,
  ) async {
    return record;
  }

  Future<List<((int, String), {(SimpleData, double) namedSubRecord})>>
  returnListOfNestedPositionalAndNamedRecord(
    Session session,
    List<((int, String), {(SimpleData, double) namedSubRecord})> recordList,
  ) async {
    return recordList;
  }

  Stream<List<((int, String), {(SimpleData, double) namedSubRecord})?>?>
  streamNullableListOfNullableNestedPositionalAndNamedRecord(
    Session session,
    List<((int, String), {(SimpleData, double) namedSubRecord})?>? initialValue,
    Stream<List<((int, String), {(SimpleData, double) namedSubRecord})?>?>
    values,
  ) async* {
    yield initialValue;

    await for (var value in values) {
      yield value;
    }
  }
  // #endregion

  // #region Records inside model class
  Future<TypesRecord> echoModelClassWithRecordField(
    Session session,
    TypesRecord value,
  ) async {
    return value;
  }

  Future<TypesRecord?> echoNullableModelClassWithRecordField(
    Session session,
    TypesRecord? value,
  ) async {
    return value;
  }

  Future<ModuleClass?> echoNullableModelClassWithRecordFieldFromExternalModule(
    Session session,
    ModuleClass? value,
  ) async {
    return value;
  }

  Stream<TypesRecord> streamOfModelClassWithRecordField(
    Session session,
    TypesRecord initialValue,
    Stream<TypesRecord> values,
  ) async* {
    yield initialValue;

    await for (var value in values) {
      yield value;
    }
  }

  Stream<TypesRecord?> streamOfNullableModelClassWithRecordField(
    Session session,
    TypesRecord? initialValue,
    Stream<TypesRecord?> values,
  ) async* {
    yield initialValue;

    await for (var value in values) {
      yield value;
    }
  }

  Stream<ModuleClass?>
  streamOfNullableModelClassWithRecordFieldFromExternalModule(
    Session session,
    ModuleClass? initialValue,
    Stream<ModuleClass?> values,
  ) async* {
    yield initialValue;

    await for (var value in values) {
      yield value;
    }
  }
  // #endregion

  // #region Record parameter with custom name
  Future<int> recordParametersWithCustomNames(
    Session session,
    (int,) positionalRecord, {
    required (int,) namedRecord,
  }) async {
    return positionalRecord.$1 + namedRecord.$1;
  }

  // #endregion
}
