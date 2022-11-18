/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data' as typed_data;
import 'package:serverpod_client/serverpod_client.dart';
import 'protocol.dart';

import 'package:serverpod_test_module_client/module.dart'
    as serverpod_test_module;
import 'package:serverpod_auth_client/module.dart' as serverpod_auth;

class _EndpointAsyncTasks extends EndpointRef {
  @override
  String get name => 'asyncTasks';

  _EndpointAsyncTasks(EndpointCaller caller) : super(caller);

  Future<void> insertRowToSimpleDataAfterDelay(
    int num,
    int seconds,
  ) async {
    return await caller.callServerEndpoint(
        'asyncTasks', 'insertRowToSimpleDataAfterDelay', 'void', {
      'num': num,
      'seconds': seconds,
    });
  }

  Future<void> throwExceptionAfterDelay(
    int seconds,
  ) async {
    return await caller
        .callServerEndpoint('asyncTasks', 'throwExceptionAfterDelay', 'void', {
      'seconds': seconds,
    });
  }
}

class _EndpointAuthentication extends EndpointRef {
  @override
  String get name => 'authentication';

  _EndpointAuthentication(EndpointCaller caller) : super(caller);

  Future<void> removeAllUsers() async {
    return await caller
        .callServerEndpoint('authentication', 'removeAllUsers', 'void', {});
  }

  Future<int> countUsers() async {
    return await caller
        .callServerEndpoint('authentication', 'countUsers', 'int', {});
  }

  Future<void> createUser(
    String email,
    String password,
  ) async {
    return await caller
        .callServerEndpoint('authentication', 'createUser', 'void', {
      'email': email,
      'password': password,
    });
  }

  Future<serverpod_auth.AuthenticationResponse> authenticate(
    String email,
    String password,
  ) async {
    return await caller.callServerEndpoint(
        'authentication', 'authenticate', 'AuthenticationResponse', {
      'email': email,
      'password': password,
    });
  }

  Future<void> signOut() async {
    return await caller
        .callServerEndpoint('authentication', 'signOut', 'void', {});
  }
}

class _EndpointBasicTypes extends EndpointRef {
  @override
  String get name => 'basicTypes';

  _EndpointBasicTypes(EndpointCaller caller) : super(caller);

  Future<int?> testInt(
    int? value,
  ) async {
    return await caller.callServerEndpoint('basicTypes', 'testInt', 'int', {
      'value': value,
    });
  }

  Future<double?> testDouble(
    double? value,
  ) async {
    return await caller
        .callServerEndpoint('basicTypes', 'testDouble', 'double', {
      'value': value,
    });
  }

  Future<bool?> testBool(
    bool? value,
  ) async {
    return await caller.callServerEndpoint('basicTypes', 'testBool', 'bool', {
      'value': value,
    });
  }

  Future<DateTime?> testDateTime(
    DateTime? dateTime,
  ) async {
    return await caller
        .callServerEndpoint('basicTypes', 'testDateTime', 'DateTime', {
      'dateTime': dateTime,
    });
  }

  Future<String?> testString(
    String? value,
  ) async {
    return await caller
        .callServerEndpoint('basicTypes', 'testString', 'String', {
      'value': value,
    });
  }

  Future<typed_data.ByteData?> testByteData(
    typed_data.ByteData? value,
  ) async {
    return await caller
        .callServerEndpoint('basicTypes', 'testByteData', 'ByteData', {
      'value': value,
    });
  }
}

class _EndpointCloudStorage extends EndpointRef {
  @override
  String get name => 'cloudStorage';

  _EndpointCloudStorage(EndpointCaller caller) : super(caller);

  Future<void> reset() async {
    return await caller.callServerEndpoint('cloudStorage', 'reset', 'void', {});
  }

  Future<void> storePublicFile(
    String path,
    typed_data.ByteData byteData,
  ) async {
    return await caller
        .callServerEndpoint('cloudStorage', 'storePublicFile', 'void', {
      'path': path,
      'byteData': byteData,
    });
  }

  Future<typed_data.ByteData?> retrievePublicFile(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('cloudStorage', 'retrievePublicFile', 'ByteData', {
      'path': path,
    });
  }

  Future<bool?> existsPublicFile(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('cloudStorage', 'existsPublicFile', 'bool', {
      'path': path,
    });
  }

  Future<void> deletePublicFile(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('cloudStorage', 'deletePublicFile', 'void', {
      'path': path,
    });
  }

  Future<String?> getPublicUrlForFile(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('cloudStorage', 'getPublicUrlForFile', 'String', {
      'path': path,
    });
  }

  Future<String?> getDirectFilePostUrl(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('cloudStorage', 'getDirectFilePostUrl', 'String', {
      'path': path,
    });
  }

  Future<bool> verifyDirectFileUpload(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('cloudStorage', 'verifyDirectFileUpload', 'bool', {
      'path': path,
    });
  }
}

class _EndpointS3CloudStorage extends EndpointRef {
  @override
  String get name => 's3CloudStorage';

  _EndpointS3CloudStorage(EndpointCaller caller) : super(caller);

  Future<void> storePublicFile(
    String path,
    typed_data.ByteData byteData,
  ) async {
    return await caller
        .callServerEndpoint('s3CloudStorage', 'storePublicFile', 'void', {
      'path': path,
      'byteData': byteData,
    });
  }

  Future<typed_data.ByteData?> retrievePublicFile(
    String path,
  ) async {
    return await caller.callServerEndpoint(
        's3CloudStorage', 'retrievePublicFile', 'ByteData', {
      'path': path,
    });
  }

  Future<bool?> existsPublicFile(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('s3CloudStorage', 'existsPublicFile', 'bool', {
      'path': path,
    });
  }

  Future<void> deletePublicFile(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('s3CloudStorage', 'deletePublicFile', 'void', {
      'path': path,
    });
  }

  Future<String?> getPublicUrlForFile(
    String path,
  ) async {
    return await caller
        .callServerEndpoint('s3CloudStorage', 'getPublicUrlForFile', 'String', {
      'path': path,
    });
  }

  Future<String?> getDirectFilePostUrl(
    String path,
  ) async {
    return await caller.callServerEndpoint(
        's3CloudStorage', 'getDirectFilePostUrl', 'String', {
      'path': path,
    });
  }

  Future<bool> verifyDirectFileUpload(
    String path,
  ) async {
    return await caller.callServerEndpoint(
        's3CloudStorage', 'verifyDirectFileUpload', 'bool', {
      'path': path,
    });
  }
}

class _EndpointCustomTypes extends EndpointRef {
  @override
  String get name => 'customTypes';

  _EndpointCustomTypes(EndpointCaller caller) : super(caller);

  Future<CustomClass> returnCustomClass(
    CustomClass data,
  ) async {
    return await caller
        .callServerEndpoint('customTypes', 'returnCustomClass', 'CustomClass', {
      'data': data,
    });
  }

  Future<CustomClass?> returnCustomClassNullable(
    CustomClass? data,
  ) async {
    return await caller.callServerEndpoint(
        'customTypes', 'returnCustomClassNullable', 'CustomClass', {
      'data': data,
    });
  }

  Future<CustomClass2> returnCustomClass2(
    CustomClass2 data,
  ) async {
    return await caller.callServerEndpoint(
        'customTypes', 'returnCustomClass2', 'CustomClass2', {
      'data': data,
    });
  }

  Future<CustomClass2?> returnCustomClass2Nullable(
    CustomClass2? data,
  ) async {
    return await caller.callServerEndpoint(
        'customTypes', 'returnCustomClass2Nullable', 'CustomClass2', {
      'data': data,
    });
  }

  Future<serverpod_test_shared.ExternalCustomClass> returnExternalCustomClass(
    serverpod_test_shared.ExternalCustomClass data,
  ) async {
    return await caller.callServerEndpoint(
        'customTypes', 'returnExternalCustomClass', 'ExternalCustomClass', {
      'data': data,
    });
  }

  Future<serverpod_test_shared.ExternalCustomClass?>
      returnExternalCustomClassNullable(
    serverpod_test_shared.ExternalCustomClass? data,
  ) async {
    return await caller.callServerEndpoint('customTypes',
        'returnExternalCustomClassNullable', 'ExternalCustomClass', {
      'data': data,
    });
  }

  Future<serverpod_test_shared.FreezedCustomClass> returnFreezedCustomClass(
    serverpod_test_shared.FreezedCustomClass data,
  ) async {
    return await caller.callServerEndpoint(
        'customTypes', 'returnFreezedCustomClass', 'FreezedCustomClass', {
      'data': data,
    });
  }

  Future<serverpod_test_shared.FreezedCustomClass?>
      returnFreezedCustomClassNullable(
    serverpod_test_shared.FreezedCustomClass? data,
  ) async {
    return await caller.callServerEndpoint('customTypes',
        'returnFreezedCustomClassNullable', 'FreezedCustomClass', {
      'data': data,
    });
  }
}

class _EndpointBasicDatabase extends EndpointRef {
  @override
  String get name => 'basicDatabase';

  _EndpointBasicDatabase(EndpointCaller caller) : super(caller);

  Future<int?> storeTypes(
    Types types,
  ) async {
    return await caller
        .callServerEndpoint('basicDatabase', 'storeTypes', 'int', {
      'types': types,
    });
  }

  Future<Types?> getTypes(
    int id,
  ) async {
    return await caller
        .callServerEndpoint('basicDatabase', 'getTypes', 'Types', {
      'id': id,
    });
  }

  Future<int?> storeObjectWithEnum(
    ObjectWithEnum object,
  ) async {
    return await caller
        .callServerEndpoint('basicDatabase', 'storeObjectWithEnum', 'int', {
      'object': object,
    });
  }

  Future<ObjectWithEnum?> getObjectWithEnum(
    int id,
  ) async {
    return await caller.callServerEndpoint(
        'basicDatabase', 'getObjectWithEnum', 'ObjectWithEnum', {
      'id': id,
    });
  }

  Future<int?> getTypesRawQuery(
    int id,
  ) async {
    return await caller
        .callServerEndpoint('basicDatabase', 'getTypesRawQuery', 'int', {
      'id': id,
    });
  }

  Future<int?> countTypesRows() async {
    return await caller
        .callServerEndpoint('basicDatabase', 'countTypesRows', 'int', {});
  }

  Future<int?> deleteAllInTypes() async {
    return await caller
        .callServerEndpoint('basicDatabase', 'deleteAllInTypes', 'int', {});
  }

  Future<void> createSimpleTestData(
    int numRows,
  ) async {
    return await caller
        .callServerEndpoint('basicDatabase', 'createSimpleTestData', 'void', {
      'numRows': numRows,
    });
  }

  Future<int?> countSimpleData() async {
    return await caller
        .callServerEndpoint('basicDatabase', 'countSimpleData', 'int', {});
  }

  Future<void> deleteAllSimpleTestData() async {
    return await caller.callServerEndpoint(
        'basicDatabase', 'deleteAllSimpleTestData', 'void', {});
  }

  Future<void> deleteSimpleTestDataLessThan(
    int num,
  ) async {
    return await caller.callServerEndpoint(
        'basicDatabase', 'deleteSimpleTestDataLessThan', 'void', {
      'num': num,
    });
  }

  Future<bool?> findAndDeleteSimpleTestData(
    int num,
  ) async {
    return await caller.callServerEndpoint(
        'basicDatabase', 'findAndDeleteSimpleTestData', 'bool', {
      'num': num,
    });
  }

  Future<SimpleDataList?> findSimpleDataRowsLessThan(
    int num,
    int offset,
    int limit,
    bool descending,
  ) async {
    return await caller.callServerEndpoint(
        'basicDatabase', 'findSimpleDataRowsLessThan', 'SimpleDataList', {
      'num': num,
      'offset': offset,
      'limit': limit,
      'descending': descending,
    });
  }

  Future<bool?> updateSimpleDataRow(
    int num,
    int newNum,
  ) async {
    return await caller
        .callServerEndpoint('basicDatabase', 'updateSimpleDataRow', 'bool', {
      'num': num,
      'newNum': newNum,
    });
  }

  Future<int?> storeObjectWithObject(
    ObjectWithObject object,
  ) async {
    return await caller
        .callServerEndpoint('basicDatabase', 'storeObjectWithObject', 'int', {
      'object': object,
    });
  }

  Future<ObjectWithObject?> getObjectWithObject(
    int id,
  ) async {
    return await caller.callServerEndpoint(
        'basicDatabase', 'getObjectWithObject', 'ObjectWithObject', {
      'id': id,
    });
  }
}

class _EndpointTransactionsDatabase extends EndpointRef {
  @override
  String get name => 'transactionsDatabase';

  _EndpointTransactionsDatabase(EndpointCaller caller) : super(caller);

  Future<void> removeRow(
    int num,
  ) async {
    return await caller
        .callServerEndpoint('transactionsDatabase', 'removeRow', 'void', {
      'num': num,
    });
  }

  Future<bool> updateInsertDelete(
    int numUpdate,
    int numInsert,
    int numDelete,
  ) async {
    return await caller.callServerEndpoint(
        'transactionsDatabase', 'updateInsertDelete', 'bool', {
      'numUpdate': numUpdate,
      'numInsert': numInsert,
      'numDelete': numDelete,
    });
  }
}

class _EndpointFailedCalls extends EndpointRef {
  @override
  String get name => 'failedCalls';

  _EndpointFailedCalls(EndpointCaller caller) : super(caller);

  Future<void> failedCall() async {
    return await caller
        .callServerEndpoint('failedCalls', 'failedCall', 'void', {});
  }

  Future<void> failedDatabaseQuery() async {
    return await caller
        .callServerEndpoint('failedCalls', 'failedDatabaseQuery', 'void', {});
  }

  Future<bool> failedDatabaseQueryCaughtException() async {
    return await caller.callServerEndpoint(
        'failedCalls', 'failedDatabaseQueryCaughtException', 'bool', {});
  }

  Future<void> slowCall() async {
    return await caller
        .callServerEndpoint('failedCalls', 'slowCall', 'void', {});
  }

  Future<void> caughtException() async {
    return await caller
        .callServerEndpoint('failedCalls', 'caughtException', 'void', {});
  }
}

class _EndpointFieldScopes extends EndpointRef {
  @override
  String get name => 'fieldScopes';

  _EndpointFieldScopes(EndpointCaller caller) : super(caller);

  Future<void> storeObject(
    ObjectFieldScopes object,
  ) async {
    return await caller
        .callServerEndpoint('fieldScopes', 'storeObject', 'void', {
      'object': object,
    });
  }

  Future<ObjectFieldScopes?> retrieveObject() async {
    return await caller.callServerEndpoint(
        'fieldScopes', 'retrieveObject', 'ObjectFieldScopes', {});
  }
}

class _EndpointFutureCalls extends EndpointRef {
  @override
  String get name => 'futureCalls';

  _EndpointFutureCalls(EndpointCaller caller) : super(caller);

  Future<void> makeFutureCall(
    SimpleData? data,
  ) async {
    return await caller
        .callServerEndpoint('futureCalls', 'makeFutureCall', 'void', {
      'data': data,
    });
  }
}

class _EndpointListParameters extends EndpointRef {
  @override
  String get name => 'listParameters';

  _EndpointListParameters(EndpointCaller caller) : super(caller);

  Future<List<int>> returnIntList(
    List<int> list,
  ) async {
    return await caller
        .callServerEndpoint('listParameters', 'returnIntList', 'List<int>', {
      'list': list,
    });
  }

  Future<List<List<int>>> returnIntListList(
    List<List<int>> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnIntListList', 'List<List<int>>', {
      'list': list,
    });
  }

  Future<List<int>?> returnIntListNullable(
    List<int>? list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnIntListNullable', 'List<int>', {
      'list': list,
    });
  }

  Future<List<List<int>?>> returnIntListNullableList(
    List<List<int>?> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnIntListNullableList', 'List<List<int>>', {
      'list': list,
    });
  }

  Future<List<List<int>>?> returnIntListListNullable(
    List<List<int>>? list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnIntListListNullable', 'List<List<int>>', {
      'list': list,
    });
  }

  Future<List<int?>> returnIntListNullableInts(
    List<int?> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnIntListNullableInts', 'List<int>', {
      'list': list,
    });
  }

  Future<List<int?>?> returnNullableIntListNullableInts(
    List<int?>? list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnNullableIntListNullableInts', 'List<int>', {
      'list': list,
    });
  }

  Future<List<double>> returnDoubleList(
    List<double> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnDoubleList', 'List<double>', {
      'list': list,
    });
  }

  Future<List<double?>> returnDoubleListNullableDoubles(
    List<double?> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnDoubleListNullableDoubles', 'List<double>', {
      'list': list,
    });
  }

  Future<List<bool>> returnBoolList(
    List<bool> list,
  ) async {
    return await caller
        .callServerEndpoint('listParameters', 'returnBoolList', 'List<bool>', {
      'list': list,
    });
  }

  Future<List<bool?>> returnBoolListNullableBools(
    List<bool?> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnBoolListNullableBools', 'List<bool>', {
      'list': list,
    });
  }

  Future<List<String>> returnStringList(
    List<String> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnStringList', 'List<String>', {
      'list': list,
    });
  }

  Future<List<String?>> returnStringListNullableStrings(
    List<String?> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnStringListNullableStrings', 'List<String>', {
      'list': list,
    });
  }

  Future<List<DateTime>> returnDateTimeList(
    List<DateTime> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnDateTimeList', 'List<DateTime>', {
      'list': list,
    });
  }

  Future<List<DateTime?>> returnDateTimeListNullableDateTimes(
    List<DateTime?> list,
  ) async {
    return await caller.callServerEndpoint('listParameters',
        'returnDateTimeListNullableDateTimes', 'List<DateTime>', {
      'list': list,
    });
  }

  Future<List<ByteData>> returnByteDataList(
    List<ByteData> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnByteDataList', 'List<ByteData>', {
      'list': list,
    });
  }

  Future<List<ByteData?>> returnByteDataListNullableByteDatas(
    List<ByteData?> list,
  ) async {
    return await caller.callServerEndpoint('listParameters',
        'returnByteDataListNullableByteDatas', 'List<ByteData>', {
      'list': list,
    });
  }

  Future<List<SimpleData>> returnSimpleDataList(
    List<SimpleData> list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnSimpleDataList', 'List<SimpleData>', {
      'list': list,
    });
  }

  Future<List<SimpleData?>> returnSimpleDataListNullableSimpleData(
    List<SimpleData?> list,
  ) async {
    return await caller.callServerEndpoint('listParameters',
        'returnSimpleDataListNullableSimpleData', 'List<SimpleData>', {
      'list': list,
    });
  }

  Future<List<SimpleData>?> returnSimpleDataListNullable(
    List<SimpleData>? list,
  ) async {
    return await caller.callServerEndpoint(
        'listParameters', 'returnSimpleDataListNullable', 'List<SimpleData>', {
      'list': list,
    });
  }

  Future<List<SimpleData?>?> returnNullableSimpleDataListNullableSimpleData(
    List<SimpleData?>? list,
  ) async {
    return await caller.callServerEndpoint('listParameters',
        'returnNullableSimpleDataListNullableSimpleData', 'List<SimpleData>', {
      'list': list,
    });
  }
}

class _EndpointLogging extends EndpointRef {
  @override
  String get name => 'logging';

  _EndpointLogging(EndpointCaller caller) : super(caller);

  Future<void> logInfo(
    String message,
  ) async {
    return await caller.callServerEndpoint('logging', 'logInfo', 'void', {
      'message': message,
    });
  }

  Future<void> logDebugAndInfoAndError(
    String debug,
    String info,
    String error,
  ) async {
    return await caller
        .callServerEndpoint('logging', 'logDebugAndInfoAndError', 'void', {
      'debug': debug,
      'info': info,
      'error': error,
    });
  }

  Future<void> twoQueries() async {
    return await caller.callServerEndpoint('logging', 'twoQueries', 'void', {});
  }
}

class _EndpointLoggingDisabled extends EndpointRef {
  @override
  String get name => 'loggingDisabled';

  _EndpointLoggingDisabled(EndpointCaller caller) : super(caller);

  Future<void> logInfo(
    String message,
  ) async {
    return await caller
        .callServerEndpoint('loggingDisabled', 'logInfo', 'void', {
      'message': message,
    });
  }
}

class _EndpointMapParameters extends EndpointRef {
  @override
  String get name => 'mapParameters';

  _EndpointMapParameters(EndpointCaller caller) : super(caller);

  Future<Map<String, int>> returnIntMap(
    Map<String, int> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnIntMap', 'Map<String,int>', {
      'map': map,
    });
  }

  Future<Map<String, int>?> returnIntMapNullable(
    Map<String, int>? map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnIntMapNullable', 'Map<String,int>', {
      'map': map,
    });
  }

  Future<Map<String, Map<String, int>>> returnNestedIntMap(
    Map<String, Map<String, int>> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnNestedIntMap', 'Map<String,Map<String,int>>', {
      'map': map,
    });
  }

  Future<Map<String, int?>> returnIntMapNullableInts(
    Map<String, int?> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnIntMapNullableInts', 'Map<String,int?>', {
      'map': map,
    });
  }

  Future<Map<String, int?>?> returnNullableIntMapNullableInts(
    Map<String, int?>? map,
  ) async {
    return await caller.callServerEndpoint('mapParameters',
        'returnNullableIntMapNullableInts', 'Map<String,int?>', {
      'map': map,
    });
  }

  Future<Map<int, int>> returnIntIntMap(
    Map<int, int> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnIntIntMap', 'Map<int,int>', {
      'map': map,
    });
  }

  Future<Map<TestEnum, int>> returnEnumIntMap(
    Map<TestEnum, int> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnEnumIntMap', 'Map<TestEnum,int>', {
      'map': map,
    });
  }

  Future<Map<String, TestEnum>> returnEnumMap(
    Map<String, TestEnum> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnEnumMap', 'Map<String,TestEnum>', {
      'map': map,
    });
  }

  Future<Map<String, double>> returnDoubleMap(
    Map<String, double> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnDoubleMap', 'Map<String,double>', {
      'map': map,
    });
  }

  Future<Map<String, double?>> returnDoubleMapNullableDoubles(
    Map<String, double?> map,
  ) async {
    return await caller.callServerEndpoint('mapParameters',
        'returnDoubleMapNullableDoubles', 'Map<String,double?>', {
      'map': map,
    });
  }

  Future<Map<String, bool>> returnBoolMap(
    Map<String, bool> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnBoolMap', 'Map<String,bool>', {
      'map': map,
    });
  }

  Future<Map<String, bool?>> returnBoolMapNullableBools(
    Map<String, bool?> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnBoolMapNullableBools', 'Map<String,bool?>', {
      'map': map,
    });
  }

  Future<Map<String, String>> returnStringMap(
    Map<String, String> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnStringMap', 'Map<String,String>', {
      'map': map,
    });
  }

  Future<Map<String, String?>> returnStringMapNullableStrings(
    Map<String, String?> map,
  ) async {
    return await caller.callServerEndpoint('mapParameters',
        'returnStringMapNullableStrings', 'Map<String,String?>', {
      'map': map,
    });
  }

  Future<Map<String, DateTime>> returnDateTimeMap(
    Map<String, DateTime> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnDateTimeMap', 'Map<String,DateTime>', {
      'map': map,
    });
  }

  Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
    Map<String, DateTime?> map,
  ) async {
    return await caller.callServerEndpoint('mapParameters',
        'returnDateTimeMapNullableDateTimes', 'Map<String,DateTime?>', {
      'map': map,
    });
  }

  Future<Map<String, ByteData>> returnByteDataMap(
    Map<String, ByteData> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnByteDataMap', 'Map<String,ByteData>', {
      'map': map,
    });
  }

  Future<Map<String, ByteData?>> returnByteDataMapNullableByteDatas(
    Map<String, ByteData?> map,
  ) async {
    return await caller.callServerEndpoint('mapParameters',
        'returnByteDataMapNullableByteDatas', 'Map<String,ByteData?>', {
      'map': map,
    });
  }

  Future<Map<String, SimpleData>> returnSimpleDataMap(
    Map<String, SimpleData> map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters', 'returnSimpleDataMap', 'Map<String,SimpleData>', {
      'map': map,
    });
  }

  Future<Map<String, SimpleData?>> returnSimpleDataMapNullableSimpleData(
    Map<String, SimpleData?> map,
  ) async {
    return await caller.callServerEndpoint('mapParameters',
        'returnSimpleDataMapNullableSimpleData', 'Map<String,SimpleData?>', {
      'map': map,
    });
  }

  Future<Map<String, SimpleData>?> returnSimpleDataMapNullable(
    Map<String, SimpleData>? map,
  ) async {
    return await caller.callServerEndpoint('mapParameters',
        'returnSimpleDataMapNullable', 'Map<String,SimpleData>', {
      'map': map,
    });
  }

  Future<Map<String, SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
    Map<String, SimpleData?>? map,
  ) async {
    return await caller.callServerEndpoint(
        'mapParameters',
        'returnNullableSimpleDataMapNullableSimpleData',
        'Map<String,SimpleData?>', {
      'map': map,
    });
  }
}

class _EndpointModuleSerialization extends EndpointRef {
  @override
  String get name => 'moduleSerialization';

  _EndpointModuleSerialization(EndpointCaller caller) : super(caller);

  Future<bool> serializeModuleObject() async {
    return await caller.callServerEndpoint(
        'moduleSerialization', 'serializeModuleObject', 'bool', {});
  }

  Future<serverpod_test_module.ModuleClass> modifyModuleObject(
    serverpod_test_module.ModuleClass object,
  ) async {
    return await caller.callServerEndpoint(
        'moduleSerialization', 'modifyModuleObject', 'ModuleClass', {
      'object': object,
    });
  }
}

class _EndpointNamedParameters extends EndpointRef {
  @override
  String get name => 'namedParameters';

  _EndpointNamedParameters(EndpointCaller caller) : super(caller);

  Future<bool> namedParametersMethod() async {
    return await caller.callServerEndpoint(
        'namedParameters', 'namedParametersMethod', 'bool', {});
  }

  Future<bool> namedParametersMethodEqualInts() async {
    return await caller.callServerEndpoint(
        'namedParameters', 'namedParametersMethodEqualInts', 'bool', {});
  }
}

class _EndpointOptionalParameters extends EndpointRef {
  @override
  String get name => 'optionalParameters';

  _EndpointOptionalParameters(EndpointCaller caller) : super(caller);

  Future<int?> returnOptionalInt([
    int? optionalInt,
  ]) async {
    return await caller
        .callServerEndpoint('optionalParameters', 'returnOptionalInt', 'int', {
      'optionalInt': optionalInt,
    });
  }
}

class _EndpointRedis extends EndpointRef {
  @override
  String get name => 'redis';

  _EndpointRedis(EndpointCaller caller) : super(caller);

  Future<void> setSimpleData(
    String key,
    SimpleData data,
  ) async {
    return await caller.callServerEndpoint('redis', 'setSimpleData', 'void', {
      'key': key,
      'data': data,
    });
  }

  Future<void> setSimpleDataWithLifetime(
    String key,
    SimpleData data,
  ) async {
    return await caller
        .callServerEndpoint('redis', 'setSimpleDataWithLifetime', 'void', {
      'key': key,
      'data': data,
    });
  }

  Future<SimpleData?> getSimpleData(
    String key,
  ) async {
    return await caller
        .callServerEndpoint('redis', 'getSimpleData', 'SimpleData', {
      'key': key,
    });
  }

  Future<void> deleteSimpleData(
    String key,
  ) async {
    return await caller
        .callServerEndpoint('redis', 'deleteSimpleData', 'void', {
      'key': key,
    });
  }

  Future<void> resetMessageCentralTest() async {
    return await caller
        .callServerEndpoint('redis', 'resetMessageCentralTest', 'void', {});
  }

  Future<SimpleData?> listenToChannel(
    String channel,
  ) async {
    return await caller
        .callServerEndpoint('redis', 'listenToChannel', 'SimpleData', {
      'channel': channel,
    });
  }

  Future<void> postToChannel(
    String channel,
    SimpleData data,
  ) async {
    return await caller.callServerEndpoint('redis', 'postToChannel', 'void', {
      'channel': channel,
      'data': data,
    });
  }

  Future<int> countSubscribedChannels() async {
    return await caller
        .callServerEndpoint('redis', 'countSubscribedChannels', 'int', {});
  }
}

class _EndpointSignInRequired extends EndpointRef {
  @override
  String get name => 'signInRequired';

  _EndpointSignInRequired(EndpointCaller caller) : super(caller);

  Future<bool> testMethod() async {
    return await caller
        .callServerEndpoint('signInRequired', 'testMethod', 'bool', {});
  }
}

class _EndpointSimple extends EndpointRef {
  @override
  String get name => 'simple';

  _EndpointSimple(EndpointCaller caller) : super(caller);

  Future<void> setGlobalInt(
    int? value, [
    int? secondValue,
  ]) async {
    return await caller.callServerEndpoint('simple', 'setGlobalInt', 'void', {
      'value': value,
      'secondValue': secondValue,
    });
  }

  Future<void> addToGlobalInt() async {
    return await caller
        .callServerEndpoint('simple', 'addToGlobalInt', 'void', {});
  }

  Future<int> getGlobalInt() async {
    return await caller.callServerEndpoint('simple', 'getGlobalInt', 'int', {});
  }
}

class _EndpointStreaming extends EndpointRef {
  @override
  String get name => 'streaming';

  _EndpointStreaming(EndpointCaller caller) : super(caller);
}

class _EndpointStreamingLogging extends EndpointRef {
  @override
  String get name => 'streamingLogging';

  _EndpointStreamingLogging(EndpointCaller caller) : super(caller);
}

class _Modules {
  late final serverpod_test_module.Caller module;
  late final serverpod_auth.Caller auth;

  _Modules(Client client) {
    module = serverpod_test_module.Caller(client);
    auth = serverpod_auth.Caller(client);
  }
}

class Client extends ServerpodClient {
  late final _EndpointAsyncTasks asyncTasks;
  late final _EndpointAuthentication authentication;
  late final _EndpointBasicTypes basicTypes;
  late final _EndpointCloudStorage cloudStorage;
  late final _EndpointS3CloudStorage s3CloudStorage;
  late final _EndpointCustomTypes customTypes;
  late final _EndpointBasicDatabase basicDatabase;
  late final _EndpointTransactionsDatabase transactionsDatabase;
  late final _EndpointFailedCalls failedCalls;
  late final _EndpointFieldScopes fieldScopes;
  late final _EndpointFutureCalls futureCalls;
  late final _EndpointListParameters listParameters;
  late final _EndpointLogging logging;
  late final _EndpointLoggingDisabled loggingDisabled;
  late final _EndpointMapParameters mapParameters;
  late final _EndpointModuleSerialization moduleSerialization;
  late final _EndpointNamedParameters namedParameters;
  late final _EndpointOptionalParameters optionalParameters;
  late final _EndpointRedis redis;
  late final _EndpointSignInRequired signInRequired;
  late final _EndpointSimple simple;
  late final _EndpointStreaming streaming;
  late final _EndpointStreamingLogging streamingLogging;
  late final _Modules modules;

  Client(String host,
      {SecurityContext? context,
      ServerpodClientErrorCallback? errorHandler,
      AuthenticationKeyManager? authenticationKeyManager})
      : super(host, Protocol.instance,
            context: context,
            errorHandler: errorHandler,
            authenticationKeyManager: authenticationKeyManager) {
    asyncTasks = _EndpointAsyncTasks(this);
    authentication = _EndpointAuthentication(this);
    basicTypes = _EndpointBasicTypes(this);
    cloudStorage = _EndpointCloudStorage(this);
    s3CloudStorage = _EndpointS3CloudStorage(this);
    customTypes = _EndpointCustomTypes(this);
    basicDatabase = _EndpointBasicDatabase(this);
    transactionsDatabase = _EndpointTransactionsDatabase(this);
    failedCalls = _EndpointFailedCalls(this);
    fieldScopes = _EndpointFieldScopes(this);
    futureCalls = _EndpointFutureCalls(this);
    listParameters = _EndpointListParameters(this);
    logging = _EndpointLogging(this);
    loggingDisabled = _EndpointLoggingDisabled(this);
    mapParameters = _EndpointMapParameters(this);
    moduleSerialization = _EndpointModuleSerialization(this);
    namedParameters = _EndpointNamedParameters(this);
    optionalParameters = _EndpointOptionalParameters(this);
    redis = _EndpointRedis(this);
    signInRequired = _EndpointSignInRequired(this);
    simple = _EndpointSimple(this);
    streaming = _EndpointStreaming(this);
    streamingLogging = _EndpointStreamingLogging(this);

    modules = _Modules(this);
    registerModuleProtocol(serverpod_test_module.Protocol());
    registerModuleProtocol(serverpod_auth.Protocol());
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
        'asyncTasks': asyncTasks,
        'authentication': authentication,
        'basicTypes': basicTypes,
        'cloudStorage': cloudStorage,
        's3CloudStorage': s3CloudStorage,
        'customTypes': customTypes,
        'basicDatabase': basicDatabase,
        'transactionsDatabase': transactionsDatabase,
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
      };

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {
        'module': modules.module,
        'auth': modules.auth,
      };
}
