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
    var retval = await caller.callServerEndpoint(
        'asyncTasks', 'insertRowToSimpleDataAfterDelay', 'void', {
      'num': num,
      'seconds': seconds,
    });
    return retval;
  }

  Future<void> throwExceptionAfterDelay(
    int seconds,
  ) async {
    var retval = await caller
        .callServerEndpoint('asyncTasks', 'throwExceptionAfterDelay', 'void', {
      'seconds': seconds,
    });
    return retval;
  }
}

class _EndpointAuthentication extends EndpointRef {
  @override
  String get name => 'authentication';

  _EndpointAuthentication(EndpointCaller caller) : super(caller);

  Future<void> removeAllUsers() async {
    var retval = await caller
        .callServerEndpoint('authentication', 'removeAllUsers', 'void', {});
    return retval;
  }

  Future<int> countUsers() async {
    var retval = await caller
        .callServerEndpoint('authentication', 'countUsers', 'int', {});
    return retval;
  }

  Future<void> createUser(
    String email,
    String password,
  ) async {
    var retval = await caller
        .callServerEndpoint('authentication', 'createUser', 'void', {
      'email': email,
      'password': password,
    });
    return retval;
  }

  Future<serverpod_auth.AuthenticationResponse> authenticate(
    String email,
    String password,
  ) async {
    var retval = await caller.callServerEndpoint(
        'authentication', 'authenticate', 'AuthenticationResponse', {
      'email': email,
      'password': password,
    });
    return retval;
  }
}

class _EndpointBasicTypes extends EndpointRef {
  @override
  String get name => 'basicTypes';

  _EndpointBasicTypes(EndpointCaller caller) : super(caller);

  Future<int?> testInt(
    int? value,
  ) async {
    var retval =
        await caller.callServerEndpoint('basicTypes', 'testInt', 'int', {
      'value': value,
    });
    return retval;
  }

  Future<double?> testDouble(
    double? value,
  ) async {
    var retval =
        await caller.callServerEndpoint('basicTypes', 'testDouble', 'double', {
      'value': value,
    });
    return retval;
  }

  Future<bool?> testBool(
    bool? value,
  ) async {
    var retval =
        await caller.callServerEndpoint('basicTypes', 'testBool', 'bool', {
      'value': value,
    });
    return retval;
  }

  Future<DateTime?> testDateTime(
    DateTime? dateTime,
  ) async {
    var retval = await caller
        .callServerEndpoint('basicTypes', 'testDateTime', 'DateTime', {
      'dateTime': dateTime,
    });
    return retval;
  }

  Future<String?> testString(
    String? value,
  ) async {
    var retval =
        await caller.callServerEndpoint('basicTypes', 'testString', 'String', {
      'value': value,
    });
    return retval;
  }

  Future<typed_data.ByteData?> testByteData(
    typed_data.ByteData? value,
  ) async {
    var retval = await caller
        .callServerEndpoint('basicTypes', 'testByteData', 'ByteData', {
      'value': value,
    });
    return retval;
  }
}

class _EndpointCloudStorage extends EndpointRef {
  @override
  String get name => 'cloudStorage';

  _EndpointCloudStorage(EndpointCaller caller) : super(caller);

  Future<void> reset() async {
    var retval =
        await caller.callServerEndpoint('cloudStorage', 'reset', 'void', {});
    return retval;
  }

  Future<void> storePublicFile(
    String path,
    typed_data.ByteData byteData,
  ) async {
    var retval = await caller
        .callServerEndpoint('cloudStorage', 'storePublicFile', 'void', {
      'path': path,
      'byteData': byteData,
    });
    return retval;
  }

  Future<typed_data.ByteData?> retrievePublicFile(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('cloudStorage', 'retrievePublicFile', 'ByteData', {
      'path': path,
    });
    return retval;
  }

  Future<bool?> existsPublicFile(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('cloudStorage', 'existsPublicFile', 'bool', {
      'path': path,
    });
    return retval;
  }

  Future<void> deletePublicFile(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('cloudStorage', 'deletePublicFile', 'void', {
      'path': path,
    });
    return retval;
  }

  Future<String?> getPublicUrlForFile(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('cloudStorage', 'getPublicUrlForFile', 'String', {
      'path': path,
    });
    return retval;
  }

  Future<String?> getDirectFilePostUrl(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('cloudStorage', 'getDirectFilePostUrl', 'String', {
      'path': path,
    });
    return retval;
  }

  Future<bool> verifyDirectFileUpload(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('cloudStorage', 'verifyDirectFileUpload', 'bool', {
      'path': path,
    });
    return retval;
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
    var retval = await caller
        .callServerEndpoint('s3CloudStorage', 'storePublicFile', 'void', {
      'path': path,
      'byteData': byteData,
    });
    return retval;
  }

  Future<typed_data.ByteData?> retrievePublicFile(
    String path,
  ) async {
    var retval = await caller.callServerEndpoint(
        's3CloudStorage', 'retrievePublicFile', 'ByteData', {
      'path': path,
    });
    return retval;
  }

  Future<bool?> existsPublicFile(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('s3CloudStorage', 'existsPublicFile', 'bool', {
      'path': path,
    });
    return retval;
  }

  Future<void> deletePublicFile(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('s3CloudStorage', 'deletePublicFile', 'void', {
      'path': path,
    });
    return retval;
  }

  Future<String?> getPublicUrlForFile(
    String path,
  ) async {
    var retval = await caller
        .callServerEndpoint('s3CloudStorage', 'getPublicUrlForFile', 'String', {
      'path': path,
    });
    return retval;
  }

  Future<String?> getDirectFilePostUrl(
    String path,
  ) async {
    var retval = await caller.callServerEndpoint(
        's3CloudStorage', 'getDirectFilePostUrl', 'String', {
      'path': path,
    });
    return retval;
  }

  Future<bool> verifyDirectFileUpload(
    String path,
  ) async {
    var retval = await caller.callServerEndpoint(
        's3CloudStorage', 'verifyDirectFileUpload', 'bool', {
      'path': path,
    });
    return retval;
  }
}

class _EndpointBasicDatabase extends EndpointRef {
  @override
  String get name => 'basicDatabase';

  _EndpointBasicDatabase(EndpointCaller caller) : super(caller);

  Future<int?> storeTypes(
    Types types,
  ) async {
    var retval =
        await caller.callServerEndpoint('basicDatabase', 'storeTypes', 'int', {
      'types': types,
    });
    return retval;
  }

  Future<Types?> getTypes(
    int id,
  ) async {
    var retval =
        await caller.callServerEndpoint('basicDatabase', 'getTypes', 'Types', {
      'id': id,
    });
    return retval;
  }

  Future<int?> getTypesRawQuery(
    int id,
  ) async {
    var retval = await caller
        .callServerEndpoint('basicDatabase', 'getTypesRawQuery', 'int', {
      'id': id,
    });
    return retval;
  }

  Future<int?> countTypesRows() async {
    var retval = await caller
        .callServerEndpoint('basicDatabase', 'countTypesRows', 'int', {});
    return retval;
  }

  Future<int?> deleteAllInTypes() async {
    var retval = await caller
        .callServerEndpoint('basicDatabase', 'deleteAllInTypes', 'int', {});
    return retval;
  }

  Future<void> createSimpleTestData(
    int numRows,
  ) async {
    var retval = await caller
        .callServerEndpoint('basicDatabase', 'createSimpleTestData', 'void', {
      'numRows': numRows,
    });
    return retval;
  }

  Future<int?> countSimpleData() async {
    var retval = await caller
        .callServerEndpoint('basicDatabase', 'countSimpleData', 'int', {});
    return retval;
  }

  Future<void> deleteAllSimpleTestData() async {
    var retval = await caller.callServerEndpoint(
        'basicDatabase', 'deleteAllSimpleTestData', 'void', {});
    return retval;
  }

  Future<void> deleteSimpleTestDataLessThan(
    int num,
  ) async {
    var retval = await caller.callServerEndpoint(
        'basicDatabase', 'deleteSimpleTestDataLessThan', 'void', {
      'num': num,
    });
    return retval;
  }

  Future<bool?> findAndDeleteSimpleTestData(
    int num,
  ) async {
    var retval = await caller.callServerEndpoint(
        'basicDatabase', 'findAndDeleteSimpleTestData', 'bool', {
      'num': num,
    });
    return retval;
  }

  Future<SimpleDataList?> findSimpleDataRowsLessThan(
    int num,
    int offset,
    int limit,
    bool descending,
  ) async {
    var retval = await caller.callServerEndpoint(
        'basicDatabase', 'findSimpleDataRowsLessThan', 'SimpleDataList', {
      'num': num,
      'offset': offset,
      'limit': limit,
      'descending': descending,
    });
    return retval;
  }

  Future<bool?> updateSimpleDataRow(
    int num,
    int newNum,
  ) async {
    var retval = await caller
        .callServerEndpoint('basicDatabase', 'updateSimpleDataRow', 'bool', {
      'num': num,
      'newNum': newNum,
    });
    return retval;
  }

  Future<int?> storeObjectWithObject(
    ObjectWithObject object,
  ) async {
    var retval = await caller
        .callServerEndpoint('basicDatabase', 'storeObjectWithObject', 'int', {
      'object': object,
    });
    return retval;
  }

  Future<ObjectWithObject?> getObjectWithObject(
    int id,
  ) async {
    var retval = await caller.callServerEndpoint(
        'basicDatabase', 'getObjectWithObject', 'ObjectWithObject', {
      'id': id,
    });
    return retval;
  }
}

class _EndpointTransactionsDatabase extends EndpointRef {
  @override
  String get name => 'transactionsDatabase';

  _EndpointTransactionsDatabase(EndpointCaller caller) : super(caller);

  Future<void> removeRow(
    int num,
  ) async {
    var retval = await caller
        .callServerEndpoint('transactionsDatabase', 'removeRow', 'void', {
      'num': num,
    });
    return retval;
  }

  Future<bool> updateInsertDelete(
    int numUpdate,
    int numInsert,
    int numDelete,
  ) async {
    var retval = await caller.callServerEndpoint(
        'transactionsDatabase', 'updateInsertDelete', 'bool', {
      'numUpdate': numUpdate,
      'numInsert': numInsert,
      'numDelete': numDelete,
    });
    return retval;
  }
}

class _EndpointFailedCalls extends EndpointRef {
  @override
  String get name => 'failedCalls';

  _EndpointFailedCalls(EndpointCaller caller) : super(caller);

  Future<void> failedCall() async {
    var retval = await caller
        .callServerEndpoint('failedCalls', 'failedCall', 'void', {});
    return retval;
  }

  Future<void> failedDatabaseQuery() async {
    var retval = await caller
        .callServerEndpoint('failedCalls', 'failedDatabaseQuery', 'void', {});
    return retval;
  }

  Future<bool> failedDatabaseQueryCaughtException() async {
    var retval = await caller.callServerEndpoint(
        'failedCalls', 'failedDatabaseQueryCaughtException', 'bool', {});
    return retval;
  }

  Future<void> slowCall() async {
    var retval =
        await caller.callServerEndpoint('failedCalls', 'slowCall', 'void', {});
    return retval;
  }

  Future<void> caughtException() async {
    var retval = await caller
        .callServerEndpoint('failedCalls', 'caughtException', 'void', {});
    return retval;
  }
}

class _EndpointFieldScopes extends EndpointRef {
  @override
  String get name => 'fieldScopes';

  _EndpointFieldScopes(EndpointCaller caller) : super(caller);

  Future<void> storeObject(
    ObjectFieldScopes object,
  ) async {
    var retval =
        await caller.callServerEndpoint('fieldScopes', 'storeObject', 'void', {
      'object': object,
    });
    return retval;
  }

  Future<ObjectFieldScopes?> retrieveObject() async {
    var retval = await caller.callServerEndpoint(
        'fieldScopes', 'retrieveObject', 'ObjectFieldScopes', {});
    return retval;
  }
}

class _EndpointFutureCalls extends EndpointRef {
  @override
  String get name => 'futureCalls';

  _EndpointFutureCalls(EndpointCaller caller) : super(caller);

  Future<void> makeFutureCall(
    SimpleData? data,
  ) async {
    var retval = await caller
        .callServerEndpoint('futureCalls', 'makeFutureCall', 'void', {
      'data': data,
    });
    return retval;
  }
}

class _EndpointListParameters extends EndpointRef {
  @override
  String get name => 'listParameters';

  _EndpointListParameters(EndpointCaller caller) : super(caller);

  Future<List<int>> returnIntList(
    List<int> list,
  ) async {
    var retval = await caller
        .callServerEndpoint('listParameters', 'returnIntList', 'List<int>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<int>?> returnIntListNullable(
    List<int>? list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnIntListNullable', 'List<int>', {
      'list': list,
    });
    return (retval as List?)?.cast();
  }

  Future<List<int?>> returnIntListNullableInts(
    List<int?> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnIntListNullableInts', 'List<int?>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<int?>?> returnNullableIntListNullableInts(
    List<int?>? list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnNullableIntListNullableInts', 'List<int?>', {
      'list': list,
    });
    return (retval as List?)?.cast();
  }

  Future<List<double>> returnDoubleList(
    List<double> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnDoubleList', 'List<double>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<double?>> returnDoubleListNullableDoubles(
    List<double?> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnDoubleListNullableDoubles', 'List<double?>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<bool>> returnBoolList(
    List<bool> list,
  ) async {
    var retval = await caller
        .callServerEndpoint('listParameters', 'returnBoolList', 'List<bool>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<bool?>> returnBoolListNullableBools(
    List<bool?> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnBoolListNullableBools', 'List<bool?>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<String>> returnStringList(
    List<String> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnStringList', 'List<String>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<String?>> returnStringListNullableStrings(
    List<String?> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnStringListNullableStrings', 'List<String?>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<DateTime>> returnDateTimeList(
    List<DateTime> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnDateTimeList', 'List<DateTime>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<DateTime?>> returnDateTimeListNullableDateTimes(
    List<DateTime?> list,
  ) async {
    var retval = await caller.callServerEndpoint('listParameters',
        'returnDateTimeListNullableDateTimes', 'List<DateTime?>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<typed_data.ByteData>> returnByteDataList(
    List<typed_data.ByteData> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnByteDataList', 'List<ByteData>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<typed_data.ByteData?>> returnByteDataListNullableByteDatas(
    List<typed_data.ByteData?> list,
  ) async {
    var retval = await caller.callServerEndpoint('listParameters',
        'returnByteDataListNullableByteDatas', 'List<ByteData?>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<SimpleData>> returnSimpleDataList(
    List<SimpleData> list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnSimpleDataList', 'List<SimpleData>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<SimpleData?>> returnSimpleDataListNullableSimpleData(
    List<SimpleData?> list,
  ) async {
    var retval = await caller.callServerEndpoint('listParameters',
        'returnSimpleDataListNullableSimpleData', 'List<SimpleData?>', {
      'list': list,
    });
    return (retval as List).cast();
  }

  Future<List<SimpleData>?> returnSimpleDataListNullable(
    List<SimpleData>? list,
  ) async {
    var retval = await caller.callServerEndpoint(
        'listParameters', 'returnSimpleDataListNullable', 'List<SimpleData>', {
      'list': list,
    });
    return (retval as List?)?.cast();
  }

  Future<List<SimpleData?>?> returnNullableSimpleDataListNullableSimpleData(
    List<SimpleData?>? list,
  ) async {
    var retval = await caller.callServerEndpoint('listParameters',
        'returnNullableSimpleDataListNullableSimpleData', 'List<SimpleData?>', {
      'list': list,
    });
    return (retval as List?)?.cast();
  }
}

class _EndpointLogging extends EndpointRef {
  @override
  String get name => 'logging';

  _EndpointLogging(EndpointCaller caller) : super(caller);

  Future<void> logInfo(
    String message,
  ) async {
    var retval = await caller.callServerEndpoint('logging', 'logInfo', 'void', {
      'message': message,
    });
    return retval;
  }

  Future<void> logDebugAndInfoAndError(
    String debug,
    String info,
    String error,
  ) async {
    var retval = await caller
        .callServerEndpoint('logging', 'logDebugAndInfoAndError', 'void', {
      'debug': debug,
      'info': info,
      'error': error,
    });
    return retval;
  }

  Future<void> twoQueries() async {
    var retval =
        await caller.callServerEndpoint('logging', 'twoQueries', 'void', {});
    return retval;
  }
}

class _EndpointLoggingDisabled extends EndpointRef {
  @override
  String get name => 'loggingDisabled';

  _EndpointLoggingDisabled(EndpointCaller caller) : super(caller);

  Future<void> logInfo(
    String message,
  ) async {
    var retval =
        await caller.callServerEndpoint('loggingDisabled', 'logInfo', 'void', {
      'message': message,
    });
    return retval;
  }
}

class _EndpointMapParameters extends EndpointRef {
  @override
  String get name => 'mapParameters';

  _EndpointMapParameters(EndpointCaller caller) : super(caller);

  Future<Map<String, int>> returnIntMap(
    Map<String, int> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnIntMap', 'Map<String,int>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, int>?> returnIntMapNullable(
    Map<String, int>? map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnIntMapNullable', 'Map<String,int>', {
      'map': map,
    });
    return (retval as Map?)?.cast();
  }

  Future<Map<String, int?>> returnIntMapNullableInts(
    Map<String, int?> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnIntMapNullableInts', 'Map<String,int?>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, int?>?> returnNullableIntMapNullableInts(
    Map<String, int?>? map,
  ) async {
    var retval = await caller.callServerEndpoint('mapParameters',
        'returnNullableIntMapNullableInts', 'Map<String,int?>', {
      'map': map,
    });
    return (retval as Map?)?.cast();
  }

  Future<Map<String, double>> returnDoubleMap(
    Map<String, double> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnDoubleMap', 'Map<String,double>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, double?>> returnDoubleMapNullableDoubles(
    Map<String, double?> map,
  ) async {
    var retval = await caller.callServerEndpoint('mapParameters',
        'returnDoubleMapNullableDoubles', 'Map<String,double?>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, bool>> returnBoolMap(
    Map<String, bool> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnBoolMap', 'Map<String,bool>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, bool?>> returnBoolMapNullableBools(
    Map<String, bool?> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnBoolMapNullableBools', 'Map<String,bool?>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, String>> returnStringMap(
    Map<String, String> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnStringMap', 'Map<String,String>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, String?>> returnStringMapNullableStrings(
    Map<String, String?> map,
  ) async {
    var retval = await caller.callServerEndpoint('mapParameters',
        'returnStringMapNullableStrings', 'Map<String,String?>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, DateTime>> returnDateTimeMap(
    Map<String, DateTime> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnDateTimeMap', 'Map<String,DateTime>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
    Map<String, DateTime?> map,
  ) async {
    var retval = await caller.callServerEndpoint('mapParameters',
        'returnDateTimeMapNullableDateTimes', 'Map<String,DateTime?>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, typed_data.ByteData>> returnByteDataMap(
    Map<String, typed_data.ByteData> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnByteDataMap', 'Map<String,ByteData>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, typed_data.ByteData?>> returnByteDataMapNullableByteDatas(
    Map<String, typed_data.ByteData?> map,
  ) async {
    var retval = await caller.callServerEndpoint('mapParameters',
        'returnByteDataMapNullableByteDatas', 'Map<String,ByteData?>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, SimpleData>> returnSimpleDataMap(
    Map<String, SimpleData> map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters', 'returnSimpleDataMap', 'Map<String,SimpleData>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, SimpleData?>> returnSimpleDataMapNullableSimpleData(
    Map<String, SimpleData?> map,
  ) async {
    var retval = await caller.callServerEndpoint('mapParameters',
        'returnSimpleDataMapNullableSimpleData', 'Map<String,SimpleData?>', {
      'map': map,
    });
    return (retval as Map).cast();
  }

  Future<Map<String, SimpleData>?> returnSimpleDataMapNullable(
    Map<String, SimpleData>? map,
  ) async {
    var retval = await caller.callServerEndpoint('mapParameters',
        'returnSimpleDataMapNullable', 'Map<String,SimpleData>', {
      'map': map,
    });
    return (retval as Map?)?.cast();
  }

  Future<Map<String, SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
    Map<String, SimpleData?>? map,
  ) async {
    var retval = await caller.callServerEndpoint(
        'mapParameters',
        'returnNullableSimpleDataMapNullableSimpleData',
        'Map<String,SimpleData?>', {
      'map': map,
    });
    return (retval as Map?)?.cast();
  }
}

class _EndpointModuleSerialization extends EndpointRef {
  @override
  String get name => 'moduleSerialization';

  _EndpointModuleSerialization(EndpointCaller caller) : super(caller);

  Future<bool> serializeModuleObject() async {
    var retval = await caller.callServerEndpoint(
        'moduleSerialization', 'serializeModuleObject', 'bool', {});
    return retval;
  }

  Future<serverpod_test_module.ModuleClass> modifyModuleObject(
    serverpod_test_module.ModuleClass object,
  ) async {
    var retval = await caller.callServerEndpoint(
        'moduleSerialization', 'modifyModuleObject', 'ModuleClass', {
      'object': object,
    });
    return retval;
  }
}

class _EndpointNamedParameters extends EndpointRef {
  @override
  String get name => 'namedParameters';

  _EndpointNamedParameters(EndpointCaller caller) : super(caller);

  Future<bool> namedParametersMethod({
    required int namedInt,
    required int intWithDefaultValue,
    int? nullableInt,
    int? nullableIntWithDefaultValue,
  }) async {
    var retval = await caller.callServerEndpoint(
        'namedParameters', 'namedParametersMethod', 'bool', {
      'namedInt': namedInt,
      'intWithDefaultValue': intWithDefaultValue,
      'nullableInt': nullableInt,
      'nullableIntWithDefaultValue': nullableIntWithDefaultValue,
    });
    return retval;
  }

  Future<bool> namedParametersMethodEqualInts({
    required int namedInt,
    int? nullableInt,
  }) async {
    var retval = await caller.callServerEndpoint(
        'namedParameters', 'namedParametersMethodEqualInts', 'bool', {
      'namedInt': namedInt,
      'nullableInt': nullableInt,
    });
    return retval;
  }
}

class _EndpointOptionalParameters extends EndpointRef {
  @override
  String get name => 'optionalParameters';

  _EndpointOptionalParameters(EndpointCaller caller) : super(caller);

  Future<int?> returnOptionalInt([
    int? optionalInt,
  ]) async {
    var retval = await caller
        .callServerEndpoint('optionalParameters', 'returnOptionalInt', 'int', {
      'optionalInt': optionalInt,
    });
    return retval;
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
    var retval =
        await caller.callServerEndpoint('redis', 'setSimpleData', 'void', {
      'key': key,
      'data': data,
    });
    return retval;
  }

  Future<void> setSimpleDataWithLifetime(
    String key,
    SimpleData data,
  ) async {
    var retval = await caller
        .callServerEndpoint('redis', 'setSimpleDataWithLifetime', 'void', {
      'key': key,
      'data': data,
    });
    return retval;
  }

  Future<SimpleData?> getSimpleData(
    String key,
  ) async {
    var retval = await caller
        .callServerEndpoint('redis', 'getSimpleData', 'SimpleData', {
      'key': key,
    });
    return retval;
  }

  Future<void> deleteSimpleData(
    String key,
  ) async {
    var retval =
        await caller.callServerEndpoint('redis', 'deleteSimpleData', 'void', {
      'key': key,
    });
    return retval;
  }

  Future<void> resetMessageCentralTest() async {
    var retval = await caller
        .callServerEndpoint('redis', 'resetMessageCentralTest', 'void', {});
    return retval;
  }

  Future<SimpleData?> listenToChannel(
    String channel,
  ) async {
    var retval = await caller
        .callServerEndpoint('redis', 'listenToChannel', 'SimpleData', {
      'channel': channel,
    });
    return retval;
  }

  Future<void> postToChannel(
    String channel,
    SimpleData data,
  ) async {
    var retval =
        await caller.callServerEndpoint('redis', 'postToChannel', 'void', {
      'channel': channel,
      'data': data,
    });
    return retval;
  }

  Future<int> countSubscribedChannels() async {
    var retval = await caller
        .callServerEndpoint('redis', 'countSubscribedChannels', 'int', {});
    return retval;
  }
}

class _EndpointSignInRequired extends EndpointRef {
  @override
  String get name => 'signInRequired';

  _EndpointSignInRequired(EndpointCaller caller) : super(caller);

  Future<bool> testMethod() async {
    var retval = await caller
        .callServerEndpoint('signInRequired', 'testMethod', 'bool', {});
    return retval;
  }
}

/// A simple endpoint that modifies a global integer. This class is meant for
/// testing and the documentation has multiple lines.
class _EndpointSimple extends EndpointRef {
  @override
  String get name => 'simple';

  _EndpointSimple(EndpointCaller caller) : super(caller);

  /// Sets a global integer.
  Future<void> setGlobalInt(
    int? value, [
    int? secondValue,
  ]) async {
    var retval =
        await caller.callServerEndpoint('simple', 'setGlobalInt', 'void', {
      'value': value,
      'secondValue': secondValue,
    });
    return retval;
  }

  /// Adds 1 to the global integer.
  Future<void> addToGlobalInt() async {
    var retval =
        await caller.callServerEndpoint('simple', 'addToGlobalInt', 'void', {});
    return retval;
  }

  /// Retrieves a global integer.
  Future<int> getGlobalInt() async {
    var retval =
        await caller.callServerEndpoint('simple', 'getGlobalInt', 'int', {});
    return retval;
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
