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
  late final _EndpointFutureCalls futureCalls;
  late final _EndpointLogging logging;
  late final _EndpointLoggingDisabled loggingDisabled;
  late final _EndpointModuleSerialization moduleSerialization;
  late final _EndpointRedis redis;
  late final _EndpointSignInRequired signInRequired;
  late final _EndpointSimple simple;
  late final _EndpointStreaming streaming;
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
    futureCalls = _EndpointFutureCalls(this);
    logging = _EndpointLogging(this);
    loggingDisabled = _EndpointLoggingDisabled(this);
    moduleSerialization = _EndpointModuleSerialization(this);
    redis = _EndpointRedis(this);
    signInRequired = _EndpointSignInRequired(this);
    simple = _EndpointSimple(this);
    streaming = _EndpointStreaming(this);

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
        'futureCalls': futureCalls,
        'logging': logging,
        'loggingDisabled': loggingDisabled,
        'moduleSerialization': moduleSerialization,
        'redis': redis,
        'signInRequired': signInRequired,
        'simple': simple,
        'streaming': streaming,
      };

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {
        'module': modules.module,
        'auth': modules.auth,
      };
}
