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
import 'package:serverpod_test_client/src/protocol/types.dart' as _i6;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i7;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i8;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i9;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i10;
import 'package:serverpod_test_client/src/protocol/object_with_enum.dart'
    as _i11;
import 'package:serverpod_test_client/src/protocol/simple_data_list.dart'
    as _i12;
import 'package:serverpod_test_client/src/protocol/object_with_object.dart'
    as _i13;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/citizen.dart'
    as _i14;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/address.dart'
    as _i15;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/post.dart'
    as _i16;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/company.dart'
    as _i17;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/town.dart'
    as _i18;
import 'package:serverpod_test_client/src/protocol/object_field_scopes.dart'
    as _i19;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i20;
import 'package:serverpod_test_module_client/module.dart' as _i21;
import 'package:serverpod_test_client/src/protocol/module_datatype.dart'
    as _i22;
import 'dart:io' as _i23;
import 'protocol.dart' as _i24;

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
class EndpointColumnBool extends _i1.EndpointRef {
  EndpointColumnBool(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnBool';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnBool',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnBool',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBool',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(bool? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBool',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(bool? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBool',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<bool> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBool',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<bool> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBool',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(bool value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBool',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(bool value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBool',
        'isNotDistinctFrom',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointColumnDateTime extends _i1.EndpointRef {
  EndpointColumnDateTime(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnDateTime';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnDateTime',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnDateTime',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(DateTime? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(DateTime? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<DateTime> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<DateTime> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    DateTime min,
    DateTime max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'between',
        {
          'min': min,
          'max': max,
        },
      );

  _i2.Future<List<_i6.Types>> notBetween(
    DateTime min,
    DateTime max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTime',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnDouble extends _i1.EndpointRef {
  EndpointColumnDouble(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnDouble';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnDouble',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnDouble',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(double? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(double? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<double> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<double> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    double min,
    double max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'between',
        {
          'min': min,
          'max': max,
        },
      );

  _i2.Future<List<_i6.Types>> notBetween(
    double min,
    double max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDouble',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnDuration extends _i1.EndpointRef {
  EndpointColumnDuration(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnDuration';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnDuration',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnDuration',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(Duration? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(Duration? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<Duration> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<Duration> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    Duration min,
    Duration max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'between',
        {
          'min': min,
          'max': max,
        },
      );

  _i2.Future<List<_i6.Types>> notBetween(
    Duration min,
    Duration max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDuration',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnEnum extends _i1.EndpointRef {
  EndpointColumnEnum(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnEnum';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnEnum',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnEnum',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnum',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(_i7.TestEnum? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnum',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(_i7.TestEnum? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnum',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<_i7.TestEnum> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnum',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<_i7.TestEnum> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnum',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(_i7.TestEnum value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnum',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(_i7.TestEnum value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnum',
        'isNotDistinctFrom',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointColumnInt extends _i1.EndpointRef {
  EndpointColumnInt(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnInt';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnInt',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnInt',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(int? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(int? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<int> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<int> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    int min,
    int max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'between',
        {
          'min': min,
          'max': max,
        },
      );

  _i2.Future<List<_i6.Types>> notBetween(
    int min,
    int max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnInt',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnString extends _i1.EndpointRef {
  EndpointColumnString(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnString';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnString',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnString',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(String? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(String? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<String> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<String> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> like(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'like',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> ilike(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnString',
        'ilike',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointColumnUuid extends _i1.EndpointRef {
  EndpointColumnUuid(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnUuid';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnUuid',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnUuid',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuid',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(_i5.UuidValue? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuid',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(_i5.UuidValue? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuid',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<_i5.UuidValue> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuid',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<_i5.UuidValue> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuid',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(_i5.UuidValue value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuid',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(_i5.UuidValue value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuid',
        'isNotDistinctFrom',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointCustomTypes extends _i1.EndpointRef {
  EndpointCustomTypes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customTypes';

  _i2.Future<_i8.CustomClass> returnCustomClass(_i8.CustomClass data) =>
      caller.callServerEndpoint<_i8.CustomClass>(
        'customTypes',
        'returnCustomClass',
        {'data': data},
      );

  _i2.Future<_i8.CustomClass?> returnCustomClassNullable(
          _i8.CustomClass? data) =>
      caller.callServerEndpoint<_i8.CustomClass?>(
        'customTypes',
        'returnCustomClassNullable',
        {'data': data},
      );

  _i2.Future<_i8.CustomClass2> returnCustomClass2(_i8.CustomClass2 data) =>
      caller.callServerEndpoint<_i8.CustomClass2>(
        'customTypes',
        'returnCustomClass2',
        {'data': data},
      );

  _i2.Future<_i8.CustomClass2?> returnCustomClass2Nullable(
          _i8.CustomClass2? data) =>
      caller.callServerEndpoint<_i8.CustomClass2?>(
        'customTypes',
        'returnCustomClass2Nullable',
        {'data': data},
      );

  _i2.Future<_i9.ExternalCustomClass> returnExternalCustomClass(
          _i9.ExternalCustomClass data) =>
      caller.callServerEndpoint<_i9.ExternalCustomClass>(
        'customTypes',
        'returnExternalCustomClass',
        {'data': data},
      );

  _i2.Future<_i9.ExternalCustomClass?> returnExternalCustomClassNullable(
          _i9.ExternalCustomClass? data) =>
      caller.callServerEndpoint<_i9.ExternalCustomClass?>(
        'customTypes',
        'returnExternalCustomClassNullable',
        {'data': data},
      );

  _i2.Future<_i10.FreezedCustomClass> returnFreezedCustomClass(
          _i10.FreezedCustomClass data) =>
      caller.callServerEndpoint<_i10.FreezedCustomClass>(
        'customTypes',
        'returnFreezedCustomClass',
        {'data': data},
      );

  _i2.Future<_i10.FreezedCustomClass?> returnFreezedCustomClassNullable(
          _i10.FreezedCustomClass? data) =>
      caller.callServerEndpoint<_i10.FreezedCustomClass?>(
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

  _i2.Future<int?> storeTypes(_i6.Types types) =>
      caller.callServerEndpoint<int?>(
        'basicDatabase',
        'storeTypes',
        {'types': types},
      );

  _i2.Future<_i6.Types?> getTypes(int id) =>
      caller.callServerEndpoint<_i6.Types?>(
        'basicDatabase',
        'getTypes',
        {'id': id},
      );

  _i2.Future<int?> storeObjectWithEnum(_i11.ObjectWithEnum object) =>
      caller.callServerEndpoint<int?>(
        'basicDatabase',
        'storeObjectWithEnum',
        {'object': object},
      );

  _i2.Future<_i11.ObjectWithEnum?> getObjectWithEnum(int id) =>
      caller.callServerEndpoint<_i11.ObjectWithEnum?>(
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
class EndpointRelation extends _i1.EndpointRef {
  EndpointRelation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'relation';

  _i2.Future<List<_i14.Citizen>> citizenFindWhereCompanyNameIs(
          {required String companyName}) =>
      caller.callServerEndpoint<List<_i14.Citizen>>(
        'relation',
        'citizenFindWhereCompanyNameIs',
        {'companyName': companyName},
      );

  _i2.Future<List<_i14.Citizen>> citizenFindWhereCompanyTownNameIs(
          {required String townName}) =>
      caller.callServerEndpoint<List<_i14.Citizen>>(
        'relation',
        'citizenFindWhereCompanyTownNameIs',
        {'townName': townName},
      );

  _i2.Future<List<_i14.Citizen>> citizenFindOrderedByCompanyName() =>
      caller.callServerEndpoint<List<_i14.Citizen>>(
        'relation',
        'citizenFindOrderedByCompanyName',
        {},
      );

  _i2.Future<List<_i14.Citizen>> citizenFindOrderedByCompanyTownName() =>
      caller.callServerEndpoint<List<_i14.Citizen>>(
        'relation',
        'citizenFindOrderedByCompanyTownName',
        {},
      );

  _i2.Future<int> citizenDeleteWhereCompanyNameIs(
          {required String companyName}) =>
      caller.callServerEndpoint<int>(
        'relation',
        'citizenDeleteWhereCompanyNameIs',
        {'companyName': companyName},
      );

  _i2.Future<int> citizenDeleteWhereCompanyTownNameIs(
          {required String townName}) =>
      caller.callServerEndpoint<int>(
        'relation',
        'citizenDeleteWhereCompanyTownNameIs',
        {'townName': townName},
      );

  _i2.Future<int> citizenCountWhereCompanyNameIs(
          {required String companyName}) =>
      caller.callServerEndpoint<int>(
        'relation',
        'citizenCountWhereCompanyNameIs',
        {'companyName': companyName},
      );

  _i2.Future<int> citizenCountWhereCompanyTownNameIs(
          {required String townName}) =>
      caller.callServerEndpoint<int>(
        'relation',
        'citizenCountWhereCompanyTownNameIs',
        {'townName': townName},
      );

  _i2.Future<List<_i14.Citizen>> citizenFindAll() =>
      caller.callServerEndpoint<List<_i14.Citizen>>(
        'relation',
        'citizenFindAll',
        {},
      );

  /// Includes company and oldCompany and their respective towns
  _i2.Future<List<_i14.Citizen>> citizenFindAllWithDeepIncludes() =>
      caller.callServerEndpoint<List<_i14.Citizen>>(
        'relation',
        'citizenFindAllWithDeepIncludes',
        {},
      );

  /// Includes the address
  _i2.Future<List<_i14.Citizen>>
      citizenFindAllWithNamedRelationNoneOriginSide() =>
          caller.callServerEndpoint<List<_i14.Citizen>>(
            'relation',
            'citizenFindAllWithNamedRelationNoneOriginSide',
            {},
          );

  /// Includes company and oldCompany
  _i2.Future<List<_i14.Citizen>> citizenFindAllWithShallowIncludes() =>
      caller.callServerEndpoint<List<_i14.Citizen>>(
        'relation',
        'citizenFindAllWithShallowIncludes',
        {},
      );

  _i2.Future<_i14.Citizen?> citizenFindByIdWithIncludes(int id) =>
      caller.callServerEndpoint<_i14.Citizen?>(
        'relation',
        'citizenFindByIdWithIncludes',
        {'id': id},
      );

  _i2.Future<List<_i15.Address>> addressFindAll() =>
      caller.callServerEndpoint<List<_i15.Address>>(
        'relation',
        'addressFindAll',
        {},
      );

  _i2.Future<_i15.Address?> addressFindById(int id) =>
      caller.callServerEndpoint<_i15.Address?>(
        'relation',
        'addressFindById',
        {'id': id},
      );

  _i2.Future<List<_i16.Post>> findAllPostsIncludingNextAndPrevious() =>
      caller.callServerEndpoint<List<_i16.Post>>(
        'relation',
        'findAllPostsIncludingNextAndPrevious',
        {},
      );

  _i2.Future<void> citizenAttachCompany(
    _i14.Citizen citizen,
    _i17.Company company,
  ) =>
      caller.callServerEndpoint<void>(
        'relation',
        'citizenAttachCompany',
        {
          'citizen': citizen,
          'company': company,
        },
      );

  _i2.Future<void> citizenAttachAddress(
    _i14.Citizen citizen,
    _i15.Address address,
  ) =>
      caller.callServerEndpoint<void>(
        'relation',
        'citizenAttachAddress',
        {
          'citizen': citizen,
          'address': address,
        },
      );

  _i2.Future<void> citizenDetachAddress(_i14.Citizen citizen) =>
      caller.callServerEndpoint<void>(
        'relation',
        'citizenDetachAddress',
        {'citizen': citizen},
      );

  _i2.Future<void> addressAttachCitizen(
    _i15.Address address,
    _i14.Citizen citizen,
  ) =>
      caller.callServerEndpoint<void>(
        'relation',
        'addressAttachCitizen',
        {
          'address': address,
          'citizen': citizen,
        },
      );

  _i2.Future<void> addressDetachCitizen(_i15.Address address) =>
      caller.callServerEndpoint<void>(
        'relation',
        'addressDetachCitizen',
        {'address': address},
      );

  _i2.Future<List<_i17.Company>> companyFindAll() =>
      caller.callServerEndpoint<List<_i17.Company>>(
        'relation',
        'companyFindAll',
        {},
      );

  _i2.Future<int?> citizenInsert(_i14.Citizen citizen) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'citizenInsert',
        {'citizen': citizen},
      );

  _i2.Future<int?> companyInsert(_i17.Company company) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'companyInsert',
        {'company': company},
      );

  _i2.Future<int?> townInsert(_i18.Town town) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'townInsert',
        {'town': town},
      );

  _i2.Future<int?> addressInsert(_i15.Address address) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'addressInsert',
        {'address': address},
      );

  _i2.Future<int?> postInsert(_i16.Post post) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'postInsert',
        {'post': post},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'relation',
        'deleteAll',
        {},
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

  _i2.Future<void> storeObject(_i19.ObjectFieldScopes object) =>
      caller.callServerEndpoint<void>(
        'fieldScopes',
        'storeObject',
        {'object': object},
      );

  _i2.Future<_i19.ObjectFieldScopes?> retrieveObject() =>
      caller.callServerEndpoint<_i19.ObjectFieldScopes?>(
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

  _i2.Future<void> makeFutureCall(_i20.SimpleData? data) =>
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

  _i2.Future<List<_i20.SimpleData>> returnSimpleDataList(
          List<_i20.SimpleData> list) =>
      caller.callServerEndpoint<List<_i20.SimpleData>>(
        'listParameters',
        'returnSimpleDataList',
        {'list': list},
      );

  _i2.Future<List<_i20.SimpleData?>> returnSimpleDataListNullableSimpleData(
          List<_i20.SimpleData?> list) =>
      caller.callServerEndpoint<List<_i20.SimpleData?>>(
        'listParameters',
        'returnSimpleDataListNullableSimpleData',
        {'list': list},
      );

  _i2.Future<List<_i20.SimpleData>?> returnSimpleDataListNullable(
          List<_i20.SimpleData>? list) =>
      caller.callServerEndpoint<List<_i20.SimpleData>?>(
        'listParameters',
        'returnSimpleDataListNullable',
        {'list': list},
      );

  _i2.Future<List<_i20.SimpleData?>?>
      returnNullableSimpleDataListNullableSimpleData(
              List<_i20.SimpleData?>? list) =>
          caller.callServerEndpoint<List<_i20.SimpleData?>?>(
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

  _i2.Future<Map<_i7.TestEnum, int>> returnEnumIntMap(
          Map<_i7.TestEnum, int> map) =>
      caller.callServerEndpoint<Map<_i7.TestEnum, int>>(
        'mapParameters',
        'returnEnumIntMap',
        {'map': map},
      );

  _i2.Future<Map<String, _i7.TestEnum>> returnEnumMap(
          Map<String, _i7.TestEnum> map) =>
      caller.callServerEndpoint<Map<String, _i7.TestEnum>>(
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

  _i2.Future<Map<String, _i20.SimpleData>> returnSimpleDataMap(
          Map<String, _i20.SimpleData> map) =>
      caller.callServerEndpoint<Map<String, _i20.SimpleData>>(
        'mapParameters',
        'returnSimpleDataMap',
        {'map': map},
      );

  _i2.Future<Map<String, _i20.SimpleData?>>
      returnSimpleDataMapNullableSimpleData(
              Map<String, _i20.SimpleData?> map) =>
          caller.callServerEndpoint<Map<String, _i20.SimpleData?>>(
            'mapParameters',
            'returnSimpleDataMapNullableSimpleData',
            {'map': map},
          );

  _i2.Future<Map<String, _i20.SimpleData>?> returnSimpleDataMapNullable(
          Map<String, _i20.SimpleData>? map) =>
      caller.callServerEndpoint<Map<String, _i20.SimpleData>?>(
        'mapParameters',
        'returnSimpleDataMapNullable',
        {'map': map},
      );

  _i2.Future<Map<String, _i20.SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
              Map<String, _i20.SimpleData?>? map) =>
          caller.callServerEndpoint<Map<String, _i20.SimpleData?>?>(
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

  _i2.Future<_i21.ModuleClass> modifyModuleObject(_i21.ModuleClass object) =>
      caller.callServerEndpoint<_i21.ModuleClass>(
        'moduleSerialization',
        'modifyModuleObject',
        {'object': object},
      );

  _i2.Future<_i22.ModuleDatatype> serializeNestedModuleObject() =>
      caller.callServerEndpoint<_i22.ModuleDatatype>(
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
    _i20.SimpleData data,
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
    _i20.SimpleData data,
  ) =>
      caller.callServerEndpoint<void>(
        'redis',
        'setSimpleDataWithLifetime',
        {
          'key': key,
          'data': data,
        },
      );

  _i2.Future<_i20.SimpleData?> getSimpleData(String key) =>
      caller.callServerEndpoint<_i20.SimpleData?>(
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

  _i2.Future<_i20.SimpleData?> listenToChannel(String channel) =>
      caller.callServerEndpoint<_i20.SimpleData?>(
        'redis',
        'listenToChannel',
        {'channel': channel},
      );

  _i2.Future<void> postToChannel(
    String channel,
    _i20.SimpleData data,
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

  _i2.Future<String> hello(String name) => caller.callServerEndpoint<String>(
        'simple',
        'hello',
        {'name': name},
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
    module = _i21.Caller(client);
    auth = _i3.Caller(client);
  }

  late final _i21.Caller module;

  late final _i3.Caller auth;
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i23.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
  }) : super(
          host,
          _i24.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
        ) {
    asyncTasks = EndpointAsyncTasks(this);
    authentication = EndpointAuthentication(this);
    basicTypes = EndpointBasicTypes(this);
    cloudStorage = EndpointCloudStorage(this);
    s3CloudStorage = EndpointS3CloudStorage(this);
    columnBool = EndpointColumnBool(this);
    columnDateTime = EndpointColumnDateTime(this);
    columnDouble = EndpointColumnDouble(this);
    columnDuration = EndpointColumnDuration(this);
    columnEnum = EndpointColumnEnum(this);
    columnInt = EndpointColumnInt(this);
    columnString = EndpointColumnString(this);
    columnUuid = EndpointColumnUuid(this);
    customTypes = EndpointCustomTypes(this);
    basicDatabase = EndpointBasicDatabase(this);
    transactionsDatabase = EndpointTransactionsDatabase(this);
    relation = EndpointRelation(this);
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

  late final EndpointColumnBool columnBool;

  late final EndpointColumnDateTime columnDateTime;

  late final EndpointColumnDouble columnDouble;

  late final EndpointColumnDuration columnDuration;

  late final EndpointColumnEnum columnEnum;

  late final EndpointColumnInt columnInt;

  late final EndpointColumnString columnString;

  late final EndpointColumnUuid columnUuid;

  late final EndpointCustomTypes customTypes;

  late final EndpointBasicDatabase basicDatabase;

  late final EndpointTransactionsDatabase transactionsDatabase;

  late final EndpointRelation relation;

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
        'columnBool': columnBool,
        'columnDateTime': columnDateTime,
        'columnDouble': columnDouble,
        'columnDuration': columnDuration,
        'columnEnum': columnEnum,
        'columnInt': columnInt,
        'columnString': columnString,
        'columnUuid': columnUuid,
        'customTypes': customTypes,
        'basicDatabase': basicDatabase,
        'transactionsDatabase': transactionsDatabase,
        'relation': relation,
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
