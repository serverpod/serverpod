/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_client/module.dart' as _i3;
import 'dart:typed_data' as _i4;
import 'package:uuid/uuid.dart' as _i5;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i6;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i7;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i8;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i9;
import 'package:serverpod_test_client/src/protocol/object_with_enum.dart'
    as _i10;
import 'package:serverpod_test_client/src/protocol/simple_datatime.dart'
    as _i11;
import 'package:serverpod_test_client/src/protocol/simple_data_list.dart'
    as _i12;
import 'package:serverpod_test_client/src/protocol/object_with_object.dart'
    as _i13;
import 'package:serverpod_test_client/src/protocol/object_field_scopes.dart'
    as _i14;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i15;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i16;
import 'package:serverpod_test_module_client/module.dart' as _i17;
import 'package:serverpod_test_client/src/protocol/module_datatype.dart'
    as _i18;
import 'dart:io' as _i19;
import 'protocol.dart' as _i20;

/// {@category Endpoint}
class EndpointAsyncTasks extends _i1.EndpointRef {
  EndpointAsyncTasks(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'asyncTasks';

  _i2.Future<void> insertRowToSimpleDataAfterDelay(
    int num,
    int seconds,
  ) =>
      caller.callServerEndpoint<void>(
        'asyncTasks',
        'insertRowToSimpleDataAfterDelay',
        {
          'num': num,
          'seconds': seconds,
        },
      );

  _i2.Future<void> throwExceptionAfterDelay(int seconds) =>
      caller.callServerEndpoint<void>(
        'asyncTasks',
        'throwExceptionAfterDelay',
        {'seconds': seconds},
      );
}

/// {@category Endpoint}
class EndpointAuthentication extends _i1.EndpointRef {
  EndpointAuthentication(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authentication';

  _i2.Future<void> removeAllUsers() => caller.callServerEndpoint<void>(
        'authentication',
        'removeAllUsers',
        {},
      );

  _i2.Future<int> countUsers() => caller.callServerEndpoint<int>(
        'authentication',
        'countUsers',
        {},
      );

  _i2.Future<void> createUser(
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<void>(
        'authentication',
        'createUser',
        {
          'email': email,
          'password': password,
        },
      );

  _i2.Future<_i3.AuthenticationResponse> authenticate(
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<_i3.AuthenticationResponse>(
        'authentication',
        'authenticate',
        {
          'email': email,
          'password': password,
        },
      );

  _i2.Future<void> signOut() => caller.callServerEndpoint<void>(
        'authentication',
        'signOut',
        {},
      );
}

/// {@category Endpoint}
class EndpointBasicTypes extends _i1.EndpointRef {
  EndpointBasicTypes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicTypes';

  _i2.Future<int?> testInt(int? value) => caller.callServerEndpoint<int?>(
        'basicTypes',
        'testInt',
        {'value': value},
      );

  _i2.Future<double?> testDouble(double? value) =>
      caller.callServerEndpoint<double?>(
        'basicTypes',
        'testDouble',
        {'value': value},
      );

  _i2.Future<bool?> testBool(bool? value) => caller.callServerEndpoint<bool?>(
        'basicTypes',
        'testBool',
        {'value': value},
      );

  _i2.Future<DateTime?> testDateTime(DateTime? dateTime) =>
      caller.callServerEndpoint<DateTime?>(
        'basicTypes',
        'testDateTime',
        {'dateTime': dateTime},
      );

  _i2.Future<String?> testString(String? value) =>
      caller.callServerEndpoint<String?>(
        'basicTypes',
        'testString',
        {'value': value},
      );

  _i2.Future<_i4.ByteData?> testByteData(_i4.ByteData? value) =>
      caller.callServerEndpoint<_i4.ByteData?>(
        'basicTypes',
        'testByteData',
        {'value': value},
      );

  _i2.Future<Duration?> testDuration(Duration? value) =>
      caller.callServerEndpoint<Duration?>(
        'basicTypes',
        'testDuration',
        {'value': value},
      );

  _i2.Future<_i5.UuidValue?> testUuid(_i5.UuidValue? value) =>
      caller.callServerEndpoint<_i5.UuidValue?>(
        'basicTypes',
        'testUuid',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointCloudStorage extends _i1.EndpointRef {
  EndpointCloudStorage(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cloudStorage';

  _i2.Future<void> reset() => caller.callServerEndpoint<void>(
        'cloudStorage',
        'reset',
        {},
      );

  _i2.Future<void> storePublicFile(
    String path,
    _i4.ByteData byteData,
  ) =>
      caller.callServerEndpoint<void>(
        'cloudStorage',
        'storePublicFile',
        {
          'path': path,
          'byteData': byteData,
        },
      );

  _i2.Future<_i4.ByteData?> retrievePublicFile(String path) =>
      caller.callServerEndpoint<_i4.ByteData?>(
        'cloudStorage',
        'retrievePublicFile',
        {'path': path},
      );

  _i2.Future<bool?> existsPublicFile(String path) =>
      caller.callServerEndpoint<bool?>(
        'cloudStorage',
        'existsPublicFile',
        {'path': path},
      );

  _i2.Future<void> deletePublicFile(String path) =>
      caller.callServerEndpoint<void>(
        'cloudStorage',
        'deletePublicFile',
        {'path': path},
      );

  _i2.Future<String?> getPublicUrlForFile(String path) =>
      caller.callServerEndpoint<String?>(
        'cloudStorage',
        'getPublicUrlForFile',
        {'path': path},
      );

  _i2.Future<String?> getDirectFilePostUrl(String path) =>
      caller.callServerEndpoint<String?>(
        'cloudStorage',
        'getDirectFilePostUrl',
        {'path': path},
      );

  _i2.Future<bool> verifyDirectFileUpload(String path) =>
      caller.callServerEndpoint<bool>(
        'cloudStorage',
        'verifyDirectFileUpload',
        {'path': path},
      );
}

/// {@category Endpoint}
class EndpointS3CloudStorage extends _i1.EndpointRef {
  EndpointS3CloudStorage(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 's3CloudStorage';

  _i2.Future<void> storePublicFile(
    String path,
    _i4.ByteData byteData,
  ) =>
      caller.callServerEndpoint<void>(
        's3CloudStorage',
        'storePublicFile',
        {
          'path': path,
          'byteData': byteData,
        },
      );

  _i2.Future<_i4.ByteData?> retrievePublicFile(String path) =>
      caller.callServerEndpoint<_i4.ByteData?>(
        's3CloudStorage',
        'retrievePublicFile',
        {'path': path},
      );

  _i2.Future<bool?> existsPublicFile(String path) =>
      caller.callServerEndpoint<bool?>(
        's3CloudStorage',
        'existsPublicFile',
        {'path': path},
      );

  _i2.Future<void> deletePublicFile(String path) =>
      caller.callServerEndpoint<void>(
        's3CloudStorage',
        'deletePublicFile',
        {'path': path},
      );

  _i2.Future<String?> getPublicUrlForFile(String path) =>
      caller.callServerEndpoint<String?>(
        's3CloudStorage',
        'getPublicUrlForFile',
        {'path': path},
      );

  _i2.Future<String?> getDirectFilePostUrl(String path) =>
      caller.callServerEndpoint<String?>(
        's3CloudStorage',
        'getDirectFilePostUrl',
        {'path': path},
      );

  _i2.Future<bool> verifyDirectFileUpload(String path) =>
      caller.callServerEndpoint<bool>(
        's3CloudStorage',
        'verifyDirectFileUpload',
        {'path': path},
      );
}

/// {@category Endpoint}
class EndpointCustomTypes extends _i1.EndpointRef {
  EndpointCustomTypes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customTypes';

  _i2.Future<_i6.CustomClass> returnCustomClass(_i6.CustomClass data) =>
      caller.callServerEndpoint<_i6.CustomClass>(
        'customTypes',
        'returnCustomClass',
        {'data': data},
      );

  _i2.Future<_i6.CustomClass?> returnCustomClassNullable(
          _i6.CustomClass? data) =>
      caller.callServerEndpoint<_i6.CustomClass?>(
        'customTypes',
        'returnCustomClassNullable',
        {'data': data},
      );

  _i2.Future<_i6.CustomClass2> returnCustomClass2(_i6.CustomClass2 data) =>
      caller.callServerEndpoint<_i6.CustomClass2>(
        'customTypes',
        'returnCustomClass2',
        {'data': data},
      );

  _i2.Future<_i6.CustomClass2?> returnCustomClass2Nullable(
          _i6.CustomClass2? data) =>
      caller.callServerEndpoint<_i6.CustomClass2?>(
        'customTypes',
        'returnCustomClass2Nullable',
        {'data': data},
      );

  _i2.Future<_i7.ExternalCustomClass> returnExternalCustomClass(
          _i7.ExternalCustomClass data) =>
      caller.callServerEndpoint<_i7.ExternalCustomClass>(
        'customTypes',
        'returnExternalCustomClass',
        {'data': data},
      );

  _i2.Future<_i7.ExternalCustomClass?> returnExternalCustomClassNullable(
          _i7.ExternalCustomClass? data) =>
      caller.callServerEndpoint<_i7.ExternalCustomClass?>(
        'customTypes',
        'returnExternalCustomClassNullable',
        {'data': data},
      );

  _i2.Future<_i8.FreezedCustomClass> returnFreezedCustomClass(
          _i8.FreezedCustomClass data) =>
      caller.callServerEndpoint<_i8.FreezedCustomClass>(
        'customTypes',
        'returnFreezedCustomClass',
        {'data': data},
      );

  _i2.Future<_i8.FreezedCustomClass?> returnFreezedCustomClassNullable(
          _i8.FreezedCustomClass? data) =>
      caller.callServerEndpoint<_i8.FreezedCustomClass?>(
        'customTypes',
        'returnFreezedCustomClassNullable',
        {'data': data},
      );
}

/// {@category Endpoint}
class EndpointBasicDatabase extends _i1.EndpointRef {
  EndpointBasicDatabase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicDatabase';

  _i2.Future<int?> storeTypes(_i9.Types types) =>
      caller.callServerEndpoint<int?>(
        'basicDatabase',
        'storeTypes',
        {'types': types},
      );

  _i2.Future<_i9.Types?> getTypes(int id) =>
      caller.callServerEndpoint<_i9.Types?>(
        'basicDatabase',
        'getTypes',
        {'id': id},
      );

  _i2.Future<int?> storeObjectWithEnum(_i10.ObjectWithEnum object) =>
      caller.callServerEndpoint<int?>(
        'basicDatabase',
        'storeObjectWithEnum',
        {'object': object},
      );

  _i2.Future<_i10.ObjectWithEnum?> getObjectWithEnum(int id) =>
      caller.callServerEndpoint<_i10.ObjectWithEnum?>(
        'basicDatabase',
        'getObjectWithEnum',
        {'id': id},
      );

  _i2.Future<int?> getTypesRawQuery(int id) => caller.callServerEndpoint<int?>(
        'basicDatabase',
        'getTypesRawQuery',
        {'id': id},
      );

  _i2.Future<int?> countTypesRows() => caller.callServerEndpoint<int?>(
        'basicDatabase',
        'countTypesRows',
        {},
      );

  _i2.Future<int?> deleteAllInTypes() => caller.callServerEndpoint<int?>(
        'basicDatabase',
        'deleteAllInTypes',
        {},
      );

  _i2.Future<void> createSimpleDateTimeTestData(
    int numRows,
    DateTime earliestDate,
    DateTime latestDate,
  ) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'createSimpleDateTimeTestData',
        {
          'numRows': numRows,
          'earliestDate': earliestDate,
          'latestDate': latestDate,
        },
      );

  _i2.Future<List<_i11.SimpleDateTime>> findSimpleDateTimeRowsBefore(
    DateTime dateTime,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<List<_i11.SimpleDateTime>>(
        'basicDatabase',
        'findSimpleDateTimeRowsBefore',
        {
          'dateTime': dateTime,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<List<_i11.SimpleDateTime>> findSimpleDateTimeRowsAfter(
    DateTime dateTime,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<List<_i11.SimpleDateTime>>(
        'basicDatabase',
        'findSimpleDateTimeRowsAfter',
        {
          'dateTime': dateTime,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<List<_i11.SimpleDateTime>> findSimpleDateTimeRowsEqualsOrBefore(
    DateTime dateTime,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<List<_i11.SimpleDateTime>>(
        'basicDatabase',
        'findSimpleDateTimeRowsEqualsOrBefore',
        {
          'dateTime': dateTime,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<List<_i11.SimpleDateTime>> findSimpleDateTimeRowsEqualsOrAfter(
    DateTime dateTime,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<List<_i11.SimpleDateTime>>(
        'basicDatabase',
        'findSimpleDateTimeRowsEqualsOrAfter',
        {
          'dateTime': dateTime,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<void> deleteAllSimpleDateTimeTestData() =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'deleteAllSimpleDateTimeTestData',
        {},
      );

  _i2.Future<void> createSimpleTestData(int numRows) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'createSimpleTestData',
        {'numRows': numRows},
      );

  _i2.Future<int?> countSimpleData() => caller.callServerEndpoint<int?>(
        'basicDatabase',
        'countSimpleData',
        {},
      );

  _i2.Future<void> deleteAllSimpleTestData() => caller.callServerEndpoint<void>(
        'basicDatabase',
        'deleteAllSimpleTestData',
        {},
      );

  _i2.Future<void> deleteSimpleTestDataLessThan(int num) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'deleteSimpleTestDataLessThan',
        {'num': num},
      );

  _i2.Future<bool?> findAndDeleteSimpleTestData(int num) =>
      caller.callServerEndpoint<bool?>(
        'basicDatabase',
        'findAndDeleteSimpleTestData',
        {'num': num},
      );

  _i2.Future<_i12.SimpleDataList?> findSimpleDataRowsLessThan(
    int num,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<_i12.SimpleDataList?>(
        'basicDatabase',
        'findSimpleDataRowsLessThan',
        {
          'num': num,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<_i12.SimpleDataList?> findSimpleDataRowsInSet(
    Set<int> set,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<_i12.SimpleDataList?>(
        'basicDatabase',
        'findSimpleDataRowsInSet',
        {
          'set': set,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<_i12.SimpleDataList?> findSimpleDataRowsNotInSet(
    Set<int> set,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<_i12.SimpleDataList?>(
        'basicDatabase',
        'findSimpleDataRowsNotInSet',
        {
          'set': set,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<_i12.SimpleDataList?> findSimpleDataRowsBetween(
    int min,
    int max,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<_i12.SimpleDataList?>(
        'basicDatabase',
        'findSimpleDataRowsBetween',
        {
          'min': min,
          'max': max,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<_i12.SimpleDataList?> findSimpleDataRowsNotBetween(
    int min,
    int max,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<_i12.SimpleDataList?>(
        'basicDatabase',
        'findSimpleDataRowsNotBetween',
        {
          'min': min,
          'max': max,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<bool?> updateSimpleDataRow(
    int num,
    int newNum,
  ) =>
      caller.callServerEndpoint<bool?>(
        'basicDatabase',
        'updateSimpleDataRow',
        {
          'num': num,
          'newNum': newNum,
        },
      );

  _i2.Future<int?> storeObjectWithObject(_i13.ObjectWithObject object) =>
      caller.callServerEndpoint<int?>(
        'basicDatabase',
        'storeObjectWithObject',
        {'object': object},
      );

  _i2.Future<_i13.ObjectWithObject?> getObjectWithObject(int id) =>
      caller.callServerEndpoint<_i13.ObjectWithObject?>(
        'basicDatabase',
        'getObjectWithObject',
        {'id': id},
      );

  _i2.Future<bool> testByteDataStore() => caller.callServerEndpoint<bool>(
        'basicDatabase',
        'testByteDataStore',
        {},
      );

  _i2.Future<bool> testDurationStore() => caller.callServerEndpoint<bool>(
        'basicDatabase',
        'testDurationStore',
        {},
      );
}

/// {@category Endpoint}
class EndpointTransactionsDatabase extends _i1.EndpointRef {
  EndpointTransactionsDatabase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transactionsDatabase';

  _i2.Future<void> removeRow(int num) => caller.callServerEndpoint<void>(
        'transactionsDatabase',
        'removeRow',
        {'num': num},
      );

  _i2.Future<bool> updateInsertDelete(
    int numUpdate,
    int numInsert,
    int numDelete,
  ) =>
      caller.callServerEndpoint<bool>(
        'transactionsDatabase',
        'updateInsertDelete',
        {
          'numUpdate': numUpdate,
          'numInsert': numInsert,
          'numDelete': numDelete,
        },
      );
}

/// {@category Endpoint}
class EndpointExceptionTest extends _i1.EndpointRef {
  EndpointExceptionTest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'exceptionTest';

  _i2.Future<String> throwNormalException() =>
      caller.callServerEndpoint<String>(
        'exceptionTest',
        'throwNormalException',
        {},
      );

  _i2.Future<String> throwExceptionWithData() =>
      caller.callServerEndpoint<String>(
        'exceptionTest',
        'throwExceptionWithData',
        {},
      );

  _i2.Future<String> workingWithoutException() =>
      caller.callServerEndpoint<String>(
        'exceptionTest',
        'workingWithoutException',
        {},
      );
}

/// {@category Endpoint}
class EndpointFailedCalls extends _i1.EndpointRef {
  EndpointFailedCalls(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'failedCalls';

  _i2.Future<void> failedCall() => caller.callServerEndpoint<void>(
        'failedCalls',
        'failedCall',
        {},
      );

  _i2.Future<void> failedDatabaseQuery() => caller.callServerEndpoint<void>(
        'failedCalls',
        'failedDatabaseQuery',
        {},
      );

  _i2.Future<bool> failedDatabaseQueryCaughtException() =>
      caller.callServerEndpoint<bool>(
        'failedCalls',
        'failedDatabaseQueryCaughtException',
        {},
      );

  _i2.Future<void> slowCall() => caller.callServerEndpoint<void>(
        'failedCalls',
        'slowCall',
        {},
      );

  _i2.Future<void> caughtException() => caller.callServerEndpoint<void>(
        'failedCalls',
        'caughtException',
        {},
      );
}

/// {@category Endpoint}
class EndpointFieldScopes extends _i1.EndpointRef {
  EndpointFieldScopes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'fieldScopes';

  _i2.Future<void> storeObject(_i14.ObjectFieldScopes object) =>
      caller.callServerEndpoint<void>(
        'fieldScopes',
        'storeObject',
        {'object': object},
      );

  _i2.Future<_i14.ObjectFieldScopes?> retrieveObject() =>
      caller.callServerEndpoint<_i14.ObjectFieldScopes?>(
        'fieldScopes',
        'retrieveObject',
        {},
      );
}

/// {@category Endpoint}
class EndpointFutureCalls extends _i1.EndpointRef {
  EndpointFutureCalls(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'futureCalls';

  _i2.Future<void> makeFutureCall(_i15.SimpleData? data) =>
      caller.callServerEndpoint<void>(
        'futureCalls',
        'makeFutureCall',
        {'data': data},
      );
}

/// {@category Endpoint}
class EndpointListParameters extends _i1.EndpointRef {
  EndpointListParameters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'listParameters';

  _i2.Future<List<int>> returnIntList(List<int> list) =>
      caller.callServerEndpoint<List<int>>(
        'listParameters',
        'returnIntList',
        {'list': list},
      );

  _i2.Future<List<List<int>>> returnIntListList(List<List<int>> list) =>
      caller.callServerEndpoint<List<List<int>>>(
        'listParameters',
        'returnIntListList',
        {'list': list},
      );

  _i2.Future<List<int>?> returnIntListNullable(List<int>? list) =>
      caller.callServerEndpoint<List<int>?>(
        'listParameters',
        'returnIntListNullable',
        {'list': list},
      );

  _i2.Future<List<List<int>?>> returnIntListNullableList(
          List<List<int>?> list) =>
      caller.callServerEndpoint<List<List<int>?>>(
        'listParameters',
        'returnIntListNullableList',
        {'list': list},
      );

  _i2.Future<List<List<int>>?> returnIntListListNullable(
          List<List<int>>? list) =>
      caller.callServerEndpoint<List<List<int>>?>(
        'listParameters',
        'returnIntListListNullable',
        {'list': list},
      );

  _i2.Future<List<int?>> returnIntListNullableInts(List<int?> list) =>
      caller.callServerEndpoint<List<int?>>(
        'listParameters',
        'returnIntListNullableInts',
        {'list': list},
      );

  _i2.Future<List<int?>?> returnNullableIntListNullableInts(List<int?>? list) =>
      caller.callServerEndpoint<List<int?>?>(
        'listParameters',
        'returnNullableIntListNullableInts',
        {'list': list},
      );

  _i2.Future<List<double>> returnDoubleList(List<double> list) =>
      caller.callServerEndpoint<List<double>>(
        'listParameters',
        'returnDoubleList',
        {'list': list},
      );

  _i2.Future<List<double?>> returnDoubleListNullableDoubles(
          List<double?> list) =>
      caller.callServerEndpoint<List<double?>>(
        'listParameters',
        'returnDoubleListNullableDoubles',
        {'list': list},
      );

  _i2.Future<List<bool>> returnBoolList(List<bool> list) =>
      caller.callServerEndpoint<List<bool>>(
        'listParameters',
        'returnBoolList',
        {'list': list},
      );

  _i2.Future<List<bool?>> returnBoolListNullableBools(List<bool?> list) =>
      caller.callServerEndpoint<List<bool?>>(
        'listParameters',
        'returnBoolListNullableBools',
        {'list': list},
      );

  _i2.Future<List<String>> returnStringList(List<String> list) =>
      caller.callServerEndpoint<List<String>>(
        'listParameters',
        'returnStringList',
        {'list': list},
      );

  _i2.Future<List<String?>> returnStringListNullableStrings(
          List<String?> list) =>
      caller.callServerEndpoint<List<String?>>(
        'listParameters',
        'returnStringListNullableStrings',
        {'list': list},
      );

  _i2.Future<List<DateTime>> returnDateTimeList(List<DateTime> list) =>
      caller.callServerEndpoint<List<DateTime>>(
        'listParameters',
        'returnDateTimeList',
        {'list': list},
      );

  _i2.Future<List<DateTime?>> returnDateTimeListNullableDateTimes(
          List<DateTime?> list) =>
      caller.callServerEndpoint<List<DateTime?>>(
        'listParameters',
        'returnDateTimeListNullableDateTimes',
        {'list': list},
      );

  _i2.Future<List<_i4.ByteData>> returnByteDataList(List<_i4.ByteData> list) =>
      caller.callServerEndpoint<List<_i4.ByteData>>(
        'listParameters',
        'returnByteDataList',
        {'list': list},
      );

  _i2.Future<List<_i4.ByteData?>> returnByteDataListNullableByteDatas(
          List<_i4.ByteData?> list) =>
      caller.callServerEndpoint<List<_i4.ByteData?>>(
        'listParameters',
        'returnByteDataListNullableByteDatas',
        {'list': list},
      );

  _i2.Future<List<_i15.SimpleData>> returnSimpleDataList(
          List<_i15.SimpleData> list) =>
      caller.callServerEndpoint<List<_i15.SimpleData>>(
        'listParameters',
        'returnSimpleDataList',
        {'list': list},
      );

  _i2.Future<List<_i15.SimpleData?>> returnSimpleDataListNullableSimpleData(
          List<_i15.SimpleData?> list) =>
      caller.callServerEndpoint<List<_i15.SimpleData?>>(
        'listParameters',
        'returnSimpleDataListNullableSimpleData',
        {'list': list},
      );

  _i2.Future<List<_i15.SimpleData>?> returnSimpleDataListNullable(
          List<_i15.SimpleData>? list) =>
      caller.callServerEndpoint<List<_i15.SimpleData>?>(
        'listParameters',
        'returnSimpleDataListNullable',
        {'list': list},
      );

  _i2.Future<List<_i15.SimpleData?>?>
      returnNullableSimpleDataListNullableSimpleData(
              List<_i15.SimpleData?>? list) =>
          caller.callServerEndpoint<List<_i15.SimpleData?>?>(
            'listParameters',
            'returnNullableSimpleDataListNullableSimpleData',
            {'list': list},
          );

  _i2.Future<List<Duration>> returnDurationList(List<Duration> list) =>
      caller.callServerEndpoint<List<Duration>>(
        'listParameters',
        'returnDurationList',
        {'list': list},
      );

  _i2.Future<List<Duration?>> returnDurationListNullableDurations(
          List<Duration?> list) =>
      caller.callServerEndpoint<List<Duration?>>(
        'listParameters',
        'returnDurationListNullableDurations',
        {'list': list},
      );
}

/// {@category Endpoint}
class EndpointLogging extends _i1.EndpointRef {
  EndpointLogging(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'logging';

  _i2.Future<void> logInfo(String message) => caller.callServerEndpoint<void>(
        'logging',
        'logInfo',
        {'message': message},
      );

  _i2.Future<void> logDebugAndInfoAndError(
    String debug,
    String info,
    String error,
  ) =>
      caller.callServerEndpoint<void>(
        'logging',
        'logDebugAndInfoAndError',
        {
          'debug': debug,
          'info': info,
          'error': error,
        },
      );

  _i2.Future<void> twoQueries() => caller.callServerEndpoint<void>(
        'logging',
        'twoQueries',
        {},
      );
}

/// {@category Endpoint}
class EndpointLoggingDisabled extends _i1.EndpointRef {
  EndpointLoggingDisabled(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'loggingDisabled';

  _i2.Future<void> logInfo(String message) => caller.callServerEndpoint<void>(
        'loggingDisabled',
        'logInfo',
        {'message': message},
      );
}

/// {@category Endpoint}
class EndpointMapParameters extends _i1.EndpointRef {
  EndpointMapParameters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mapParameters';

  _i2.Future<Map<String, int>> returnIntMap(Map<String, int> map) =>
      caller.callServerEndpoint<Map<String, int>>(
        'mapParameters',
        'returnIntMap',
        {'map': map},
      );

  _i2.Future<Map<String, int>?> returnIntMapNullable(Map<String, int>? map) =>
      caller.callServerEndpoint<Map<String, int>?>(
        'mapParameters',
        'returnIntMapNullable',
        {'map': map},
      );

  _i2.Future<Map<String, Map<String, int>>> returnNestedIntMap(
          Map<String, Map<String, int>> map) =>
      caller.callServerEndpoint<Map<String, Map<String, int>>>(
        'mapParameters',
        'returnNestedIntMap',
        {'map': map},
      );

  _i2.Future<Map<String, int?>> returnIntMapNullableInts(
          Map<String, int?> map) =>
      caller.callServerEndpoint<Map<String, int?>>(
        'mapParameters',
        'returnIntMapNullableInts',
        {'map': map},
      );

  _i2.Future<Map<String, int?>?> returnNullableIntMapNullableInts(
          Map<String, int?>? map) =>
      caller.callServerEndpoint<Map<String, int?>?>(
        'mapParameters',
        'returnNullableIntMapNullableInts',
        {'map': map},
      );

  _i2.Future<Map<int, int>> returnIntIntMap(Map<int, int> map) =>
      caller.callServerEndpoint<Map<int, int>>(
        'mapParameters',
        'returnIntIntMap',
        {'map': map},
      );

  _i2.Future<Map<_i16.TestEnum, int>> returnEnumIntMap(
          Map<_i16.TestEnum, int> map) =>
      caller.callServerEndpoint<Map<_i16.TestEnum, int>>(
        'mapParameters',
        'returnEnumIntMap',
        {'map': map},
      );

  _i2.Future<Map<String, _i16.TestEnum>> returnEnumMap(
          Map<String, _i16.TestEnum> map) =>
      caller.callServerEndpoint<Map<String, _i16.TestEnum>>(
        'mapParameters',
        'returnEnumMap',
        {'map': map},
      );

  _i2.Future<Map<String, double>> returnDoubleMap(Map<String, double> map) =>
      caller.callServerEndpoint<Map<String, double>>(
        'mapParameters',
        'returnDoubleMap',
        {'map': map},
      );

  _i2.Future<Map<String, double?>> returnDoubleMapNullableDoubles(
          Map<String, double?> map) =>
      caller.callServerEndpoint<Map<String, double?>>(
        'mapParameters',
        'returnDoubleMapNullableDoubles',
        {'map': map},
      );

  _i2.Future<Map<String, bool>> returnBoolMap(Map<String, bool> map) =>
      caller.callServerEndpoint<Map<String, bool>>(
        'mapParameters',
        'returnBoolMap',
        {'map': map},
      );

  _i2.Future<Map<String, bool?>> returnBoolMapNullableBools(
          Map<String, bool?> map) =>
      caller.callServerEndpoint<Map<String, bool?>>(
        'mapParameters',
        'returnBoolMapNullableBools',
        {'map': map},
      );

  _i2.Future<Map<String, String>> returnStringMap(Map<String, String> map) =>
      caller.callServerEndpoint<Map<String, String>>(
        'mapParameters',
        'returnStringMap',
        {'map': map},
      );

  _i2.Future<Map<String, String?>> returnStringMapNullableStrings(
          Map<String, String?> map) =>
      caller.callServerEndpoint<Map<String, String?>>(
        'mapParameters',
        'returnStringMapNullableStrings',
        {'map': map},
      );

  _i2.Future<Map<String, DateTime>> returnDateTimeMap(
          Map<String, DateTime> map) =>
      caller.callServerEndpoint<Map<String, DateTime>>(
        'mapParameters',
        'returnDateTimeMap',
        {'map': map},
      );

  _i2.Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
          Map<String, DateTime?> map) =>
      caller.callServerEndpoint<Map<String, DateTime?>>(
        'mapParameters',
        'returnDateTimeMapNullableDateTimes',
        {'map': map},
      );

  _i2.Future<Map<String, _i4.ByteData>> returnByteDataMap(
          Map<String, _i4.ByteData> map) =>
      caller.callServerEndpoint<Map<String, _i4.ByteData>>(
        'mapParameters',
        'returnByteDataMap',
        {'map': map},
      );

  _i2.Future<Map<String, _i4.ByteData?>> returnByteDataMapNullableByteDatas(
          Map<String, _i4.ByteData?> map) =>
      caller.callServerEndpoint<Map<String, _i4.ByteData?>>(
        'mapParameters',
        'returnByteDataMapNullableByteDatas',
        {'map': map},
      );

  _i2.Future<Map<String, _i15.SimpleData>> returnSimpleDataMap(
          Map<String, _i15.SimpleData> map) =>
      caller.callServerEndpoint<Map<String, _i15.SimpleData>>(
        'mapParameters',
        'returnSimpleDataMap',
        {'map': map},
      );

  _i2.Future<Map<String, _i15.SimpleData?>>
      returnSimpleDataMapNullableSimpleData(
              Map<String, _i15.SimpleData?> map) =>
          caller.callServerEndpoint<Map<String, _i15.SimpleData?>>(
            'mapParameters',
            'returnSimpleDataMapNullableSimpleData',
            {'map': map},
          );

  _i2.Future<Map<String, _i15.SimpleData>?> returnSimpleDataMapNullable(
          Map<String, _i15.SimpleData>? map) =>
      caller.callServerEndpoint<Map<String, _i15.SimpleData>?>(
        'mapParameters',
        'returnSimpleDataMapNullable',
        {'map': map},
      );

  _i2.Future<Map<String, _i15.SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
              Map<String, _i15.SimpleData?>? map) =>
          caller.callServerEndpoint<Map<String, _i15.SimpleData?>?>(
            'mapParameters',
            'returnNullableSimpleDataMapNullableSimpleData',
            {'map': map},
          );

  _i2.Future<Map<String, Duration>> returnDurationMap(
          Map<String, Duration> map) =>
      caller.callServerEndpoint<Map<String, Duration>>(
        'mapParameters',
        'returnDurationMap',
        {'map': map},
      );

  _i2.Future<Map<String, Duration?>> returnDurationMapNullableDurations(
          Map<String, Duration?> map) =>
      caller.callServerEndpoint<Map<String, Duration?>>(
        'mapParameters',
        'returnDurationMapNullableDurations',
        {'map': map},
      );
}

/// {@category Endpoint}
class EndpointModuleSerialization extends _i1.EndpointRef {
  EndpointModuleSerialization(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleSerialization';

  _i2.Future<bool> serializeModuleObject() => caller.callServerEndpoint<bool>(
        'moduleSerialization',
        'serializeModuleObject',
        {},
      );

  _i2.Future<_i17.ModuleClass> modifyModuleObject(_i17.ModuleClass object) =>
      caller.callServerEndpoint<_i17.ModuleClass>(
        'moduleSerialization',
        'modifyModuleObject',
        {'object': object},
      );

  _i2.Future<_i18.ModuleDatatype> serializeNestedModuleObject() =>
      caller.callServerEndpoint<_i18.ModuleDatatype>(
        'moduleSerialization',
        'serializeNestedModuleObject',
        {},
      );
}

/// {@category Endpoint}
class EndpointNamedParameters extends _i1.EndpointRef {
  EndpointNamedParameters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'namedParameters';

  _i2.Future<bool> namedParametersMethod({
    required int namedInt,
    required int intWithDefaultValue,
    int? nullableInt,
    int? nullableIntWithDefaultValue,
  }) =>
      caller.callServerEndpoint<bool>(
        'namedParameters',
        'namedParametersMethod',
        {
          'namedInt': namedInt,
          'intWithDefaultValue': intWithDefaultValue,
          'nullableInt': nullableInt,
          'nullableIntWithDefaultValue': nullableIntWithDefaultValue,
        },
      );

  _i2.Future<bool> namedParametersMethodEqualInts({
    required int namedInt,
    int? nullableInt,
  }) =>
      caller.callServerEndpoint<bool>(
        'namedParameters',
        'namedParametersMethodEqualInts',
        {
          'namedInt': namedInt,
          'nullableInt': nullableInt,
        },
      );
}

/// {@category Endpoint}
class EndpointOptionalParameters extends _i1.EndpointRef {
  EndpointOptionalParameters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'optionalParameters';

  _i2.Future<int?> returnOptionalInt([int? optionalInt]) =>
      caller.callServerEndpoint<int?>(
        'optionalParameters',
        'returnOptionalInt',
        {'optionalInt': optionalInt},
      );
}

/// {@category Endpoint}
class EndpointRedis extends _i1.EndpointRef {
  EndpointRedis(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'redis';

  _i2.Future<void> setSimpleData(
    String key,
    _i15.SimpleData data,
  ) =>
      caller.callServerEndpoint<void>(
        'redis',
        'setSimpleData',
        {
          'key': key,
          'data': data,
        },
      );

  _i2.Future<void> setSimpleDataWithLifetime(
    String key,
    _i15.SimpleData data,
  ) =>
      caller.callServerEndpoint<void>(
        'redis',
        'setSimpleDataWithLifetime',
        {
          'key': key,
          'data': data,
        },
      );

  _i2.Future<_i15.SimpleData?> getSimpleData(String key) =>
      caller.callServerEndpoint<_i15.SimpleData?>(
        'redis',
        'getSimpleData',
        {'key': key},
      );

  _i2.Future<void> deleteSimpleData(String key) =>
      caller.callServerEndpoint<void>(
        'redis',
        'deleteSimpleData',
        {'key': key},
      );

  _i2.Future<void> resetMessageCentralTest() => caller.callServerEndpoint<void>(
        'redis',
        'resetMessageCentralTest',
        {},
      );

  _i2.Future<_i15.SimpleData?> listenToChannel(String channel) =>
      caller.callServerEndpoint<_i15.SimpleData?>(
        'redis',
        'listenToChannel',
        {'channel': channel},
      );

  _i2.Future<void> postToChannel(
    String channel,
    _i15.SimpleData data,
  ) =>
      caller.callServerEndpoint<void>(
        'redis',
        'postToChannel',
        {
          'channel': channel,
          'data': data,
        },
      );

  _i2.Future<int> countSubscribedChannels() => caller.callServerEndpoint<int>(
        'redis',
        'countSubscribedChannels',
        {},
      );
}

/// {@category Endpoint}
class EndpointSignInRequired extends _i1.EndpointRef {
  EndpointSignInRequired(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'signInRequired';

  _i2.Future<bool> testMethod() => caller.callServerEndpoint<bool>(
        'signInRequired',
        'testMethod',
        {},
      );
}

/// A simple endpoint that modifies a global integer. This class is meant for
/// testing and the documentation has multiple lines.
/// {@category Endpoint}
class EndpointSimple extends _i1.EndpointRef {
  EndpointSimple(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'simple';

  /// Sets a global integer.
  _i2.Future<void> setGlobalInt(
    int? value, [
    int? secondValue,
  ]) =>
      caller.callServerEndpoint<void>(
        'simple',
        'setGlobalInt',
        {
          'value': value,
          'secondValue': secondValue,
        },
      );

  /// Adds 1 to the global integer.
  _i2.Future<void> addToGlobalInt() => caller.callServerEndpoint<void>(
        'simple',
        'addToGlobalInt',
        {},
      );

  /// Retrieves a global integer.
  _i2.Future<int> getGlobalInt() => caller.callServerEndpoint<int>(
        'simple',
        'getGlobalInt',
        {},
      );
}

/// {@category Endpoint}
class EndpointStreaming extends _i1.EndpointRef {
  EndpointStreaming(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'streaming';
}

/// {@category Endpoint}
class EndpointStreamingLogging extends _i1.EndpointRef {
  EndpointStreamingLogging(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'streamingLogging';
}

/// {@category Endpoint}
class EndpointSubSubDirTest extends _i1.EndpointRef {
  EndpointSubSubDirTest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subSubDirTest';

  _i2.Future<String> testMethod() => caller.callServerEndpoint<String>(
        'subSubDirTest',
        'testMethod',
        {},
      );
}

/// {@category Endpoint}
class EndpointSubDirTest extends _i1.EndpointRef {
  EndpointSubDirTest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subDirTest';

  _i2.Future<String> testMethod() => caller.callServerEndpoint<String>(
        'subDirTest',
        'testMethod',
        {},
      );
}

class _Modules {
  _Modules(Client client) {
    module = _i17.Caller(client);
    auth = _i3.Caller(client);
  }

  late final _i17.Caller module;

  late final _i3.Caller auth;
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i19.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i20.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {
    asyncTasks = EndpointAsyncTasks(this);
    authentication = EndpointAuthentication(this);
    basicTypes = EndpointBasicTypes(this);
    cloudStorage = EndpointCloudStorage(this);
    s3CloudStorage = EndpointS3CloudStorage(this);
    customTypes = EndpointCustomTypes(this);
    basicDatabase = EndpointBasicDatabase(this);
    transactionsDatabase = EndpointTransactionsDatabase(this);
    exceptionTest = EndpointExceptionTest(this);
    failedCalls = EndpointFailedCalls(this);
    fieldScopes = EndpointFieldScopes(this);
    futureCalls = EndpointFutureCalls(this);
    listParameters = EndpointListParameters(this);
    logging = EndpointLogging(this);
    loggingDisabled = EndpointLoggingDisabled(this);
    mapParameters = EndpointMapParameters(this);
    moduleSerialization = EndpointModuleSerialization(this);
    namedParameters = EndpointNamedParameters(this);
    optionalParameters = EndpointOptionalParameters(this);
    redis = EndpointRedis(this);
    signInRequired = EndpointSignInRequired(this);
    simple = EndpointSimple(this);
    streaming = EndpointStreaming(this);
    streamingLogging = EndpointStreamingLogging(this);
    subSubDirTest = EndpointSubSubDirTest(this);
    subDirTest = EndpointSubDirTest(this);
    modules = _Modules(this);
  }

  late final EndpointAsyncTasks asyncTasks;

  late final EndpointAuthentication authentication;

  late final EndpointBasicTypes basicTypes;

  late final EndpointCloudStorage cloudStorage;

  late final EndpointS3CloudStorage s3CloudStorage;

  late final EndpointCustomTypes customTypes;

  late final EndpointBasicDatabase basicDatabase;

  late final EndpointTransactionsDatabase transactionsDatabase;

  late final EndpointExceptionTest exceptionTest;

  late final EndpointFailedCalls failedCalls;

  late final EndpointFieldScopes fieldScopes;

  late final EndpointFutureCalls futureCalls;

  late final EndpointListParameters listParameters;

  late final EndpointLogging logging;

  late final EndpointLoggingDisabled loggingDisabled;

  late final EndpointMapParameters mapParameters;

  late final EndpointModuleSerialization moduleSerialization;

  late final EndpointNamedParameters namedParameters;

  late final EndpointOptionalParameters optionalParameters;

  late final EndpointRedis redis;

  late final EndpointSignInRequired signInRequired;

  late final EndpointSimple simple;

  late final EndpointStreaming streaming;

  late final EndpointStreamingLogging streamingLogging;

  late final EndpointSubSubDirTest subSubDirTest;

  late final EndpointSubDirTest subDirTest;

  late final _Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'asyncTasks': asyncTasks,
        'authentication': authentication,
        'basicTypes': basicTypes,
        'cloudStorage': cloudStorage,
        's3CloudStorage': s3CloudStorage,
        'customTypes': customTypes,
        'basicDatabase': basicDatabase,
        'transactionsDatabase': transactionsDatabase,
        'exceptionTest': exceptionTest,
        'failedCalls': failedCalls,
        'fieldScopes': fieldScopes,
        'futureCalls': futureCalls,
        'listParameters': listParameters,
        'logging': logging,
        'loggingDisabled': loggingDisabled,
        'mapParameters': mapParameters,
        'moduleSerialization': moduleSerialization,
        'namedParameters': namedParameters,
        'optionalParameters': optionalParameters,
        'redis': redis,
        'signInRequired': signInRequired,
        'simple': simple,
        'streaming': streaming,
        'streamingLogging': streamingLogging,
        'subSubDirTest': subSubDirTest,
        'subDirTest': subDirTest,
      };
  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
        'module': modules.module,
        'auth': modules.auth,
      };
}
