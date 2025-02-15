import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';

typedef _MixedRecordTypeDef = (int number, {SimpleData data});

class RecordParametersEndpoint extends Endpoint {
  Future<(int,)> returnIntRecord(Session session, (int,) record) async {
    return record;
  }

  Future<(String, String)?> returnNullableStringRecord(
    Session session,
    (String, String)? record,
  ) async {
    return record;
  }

  Stream<(int,)> streamIntRecordEcho(
    Session session,
    Stream<(int,)> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<(int,)?> returnNullableIntRecord(
    Session session,
    (int,)? record,
  ) async {
    return record;
  }

  Stream<(int,)?> streamNullableIntRecordEcho(
    Session session,
    Stream<(int,)?> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<(int, String)> returnIntStringRecord(
    Session session,
    (int, String) record,
  ) async {
    return record;
  }

  Stream<(int, String)> streamIntStringRecordEcho(
    Session session,
    Stream<(int, String)> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<(int, String)?> returnNullableIntStringRecord(
      Session session, (int, String)? record) async {
    return record;
  }

  Stream<(int, String)?> streamNullableIntStringRecordEcho(
    Session session,
    Stream<(int, String)?> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<(int, SimpleData)> returnIntSimpleDataRecord(
    Session session,
    (int, SimpleData) record,
  ) async {
    return record;
  }

  Stream<(int, SimpleData)> streamIntSimpleDataRecordEcho(
    Session session,
    Stream<(int, SimpleData)> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<(int, SimpleData)?> returnNullableIntSimpleDataRecord(
      Session session, (int, SimpleData)? record) async {
    return record;
  }

  Stream<(int, SimpleData)?> streamNullableIntSimpleDataRecordEcho(
    Session session,
    Stream<(int, SimpleData)?> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<({int number, String text})> returnNamedIntStringRecord(
    Session session,
    ({int number, String text}) record,
  ) async {
    return record;
  }

  Stream<({int number, String text})> streamNamedIntStringRecordEcho(
    Session session,
    Stream<({int number, String text})> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<({int number, String text})?> returnNamedNullableIntStringRecord(
    Session session,
    ({int number, String text})? record,
  ) async {
    return record;
  }

  Stream<(int, String)?> streamNamedNullableIntStringRecordEcho(
    Session session,
    Stream<(int, String)?> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<({int number, SimpleData data})> returnNamedIntSimpleDataRecord(
    Session session,
    ({int number, SimpleData data}) record,
  ) async {
    return record;
  }

  Stream<({int number, SimpleData data})> streamNamedIntSimpleDataRecordEcho(
    Session session,
    Stream<({int number, SimpleData data})> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<({int number, SimpleData data})?>
      returnNamedNullableIntSimpleDataRecord(
    Session session,
    ({int number, SimpleData data})? record,
  ) async {
    return record;
  }

  Stream<({int number, SimpleData data})?>
      streamNamedNullableIntSimpleDataRecordEcho(
    Session session,
    Stream<({int number, SimpleData data})?> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<_MixedRecordTypeDef> returnRecordTypedef(
    Session session,
    _MixedRecordTypeDef record,
  ) async {
    return record;
  }

  Stream<_MixedRecordTypeDef> streamRecordTypedef(
    Session session,
    Stream<_MixedRecordTypeDef> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<_MixedRecordTypeDef?> returnNullableRecordTypedef(
    Session session,
    _MixedRecordTypeDef? record,
  ) async {
    return record;
  }

  Stream<_MixedRecordTypeDef?> streamNullableRecordTypedef(
    Session session,
    Stream<_MixedRecordTypeDef?> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<List<(int, SimpleData)>> returnListOfIntSimpleDataRecord(
    Session session,
    List<(int, SimpleData)> recordList,
  ) async {
    return recordList;
  }

  Stream<List<(int, SimpleData)>> streamListOfIntSimpleDataRecordEchoStream(
    Session session,
    Stream<List<(int, SimpleData)>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<List<(int, SimpleData)?>> returnListOfNullableIntSimpleDataRecord(
    Session session,
    List<(int, SimpleData)?> record,
  ) async {
    return record;
  }

  Stream<List<(int, SimpleData)?>>
      streamListOfNullableIntSimpleDataRecordEchoStream(
    Session session,
    Stream<List<(int, SimpleData)?>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<Set<(int, SimpleData)>?> returnNullableSetOfIntSimpleDataRecord(
    Session session,
    Set<(int, SimpleData)>? recordSet,
  ) async {
    return recordSet;
  }

  Future<Set<(int, SimpleData)>> returnSetOfIntSimpleDataRecord(
    Session session,
    Set<(int, SimpleData)> recordSet,
  ) async {
    return recordSet;
  }

  Stream<Set<(int, SimpleData)>> streamSetOfIntSimpleDataRecordEchoStream(
    Session session,
    Stream<Set<(int, SimpleData)>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<Set<(int, SimpleData)?>> returnSetOfNullableIntSimpleDataRecord(
    Session session,
    Set<(int, SimpleData)?> set,
  ) async {
    return set;
  }

  Stream<Set<(int, SimpleData)?>>
      streamSetOfNullableIntSimpleDataRecordEchoStream(
    Session session,
    Stream<Set<(int, SimpleData)?>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<Map<String, (int, SimpleData)>> returnStringMapOfIntSimpleDataRecord(
    Session session,
    Map<String, (int, SimpleData)> map,
  ) async {
    return map;
  }

  Future<
      Map<
          String,
          List<
              (
                String,
                Set<(int, int, String, String)>,
                List<(int, int, int, String, String, String)>
              )>>> returnStringMapOfListOfRecord(
    Session session,
    List<(int, int, int, int, String, String, String, String)> list,
  ) async {
    return {};
  }

  Stream<Map<String, (int, SimpleData)>>
      streamStringMapOfIntSimpleDataRecordEchoStream(
    Session session,
    Stream<Map<String, (int, SimpleData)>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<Map<String, (int, SimpleData)?>>
      returnStringMapOfNullableIntSimpleDataRecord(
    Session session,
    Map<String, (int, SimpleData)?> map,
  ) async {
    return map;
  }

  Stream<Map<String, (int, SimpleData)?>>
      streamStringMapOfNullableIntSimpleDataRecordEchoStream(
    Session session,
    Stream<Map<String, (int, SimpleData)?>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<Map<(String, int), (int, SimpleData)>>
      returnRecordMapOfIntSimpleDataRecord(
    Session session,
    Map<(String, int), (int, SimpleData)> map,
  ) async {
    return map;
  }

  Stream<Map<(String, int), (int, SimpleData)>>
      streamRecordMapOfIntSimpleDataRecordEchoStream(
    Session session,
    Stream<Map<(String, int), (int, SimpleData)>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<Map<String, (int, SimpleData)?>>
      returnRecordMapOfNullableIntSimpleDataRecord(
    Session session,
    Map<String, (int, SimpleData)?> map,
  ) async {
    return map;
  }

  Stream<Map<(String, int), (int, SimpleData)?>>
      streamRecordMapOfNullableIntSimpleDataRecordEchoStream(
    Session session,
    Stream<Map<(String, int), (int, SimpleData)?>> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<((int, String), {(SimpleData, double) namedSubRecord})>
      returnNestedRecord(
    Session session,
    ((int, String), {(SimpleData, double) namedSubRecord}) record,
  ) async {
    return record;
  }

  Future<List<((int, String), {(SimpleData, double) namedSubRecord})>>
      returnListOfNestedRecord(
    Session session,
    List<((int, String), {(SimpleData, double) namedSubRecord})> recordList,
  ) async {
    return recordList;
  }

  Stream<((int, String), {(SimpleData, double) namedSubRecord})>
      streamNestedRecordEchoStream(
    Session session,
    Stream<((int, String), {(SimpleData, double) namedSubRecord})> value,
  ) async* {
    await for (var i in value) {
      yield i;
    }
  }

  Future<({(SimpleData, double)? namedSubRecord})>
      returnNamedNullableNestedRecord(
    Session session,
    ({(SimpleData, double)? namedSubRecord}) record,
  ) async {
    return record;
  }

  Future<(SimpleData? data, (int, SimpleData? data))>
      returnPositionedNullableNestedRecord(
    Session session,
    (SimpleData? data, (int, SimpleData? data)) record,
  ) async {
    return record;
  }
}
