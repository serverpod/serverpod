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
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i11;
import 'package:serverpod_test_client/src/protocol/object_with_enum.dart'
    as _i12;
import 'package:serverpod_test_client/src/protocol/simple_data_list.dart'
    as _i13;
import 'package:serverpod_test_client/src/protocol/object_with_object.dart'
    as _i14;
import 'package:serverpod_test_client/src/protocol/unique_data.dart' as _i15;
import 'package:serverpod_test_client/src/protocol/related_unique_data.dart'
    as _i16;
import 'package:serverpod_test_client/src/protocol/entities_with_list_relations/city.dart'
    as _i17;
import 'package:serverpod_test_client/src/protocol/entities_with_list_relations/organization.dart'
    as _i18;
import 'package:serverpod_test_client/src/protocol/entities_with_list_relations/person.dart'
    as _i19;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/customer.dart'
    as _i20;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/comment.dart'
    as _i21;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/order.dart'
    as _i22;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/citizen.dart'
    as _i23;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/address.dart'
    as _i24;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/self_relation/post.dart'
    as _i25;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/company.dart'
    as _i26;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/town.dart'
    as _i27;
import 'package:serverpod_test_client/src/protocol/object_field_scopes.dart'
    as _i28;
import 'package:serverpod_test_module_client/module.dart' as _i29;
import 'package:serverpod_test_client/src/protocol/module_datatype.dart'
    as _i30;
import 'dart:io' as _i31;
import 'protocol.dart' as _i32;

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
class EndpointColumnBoolLegacy extends _i1.EndpointRef {
  EndpointColumnBoolLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnBoolLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnBoolLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnBoolLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBoolLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(bool? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBoolLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(bool? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBoolLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<bool> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBoolLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<bool> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBoolLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(bool value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBoolLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(bool value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnBoolLegacy',
        'isNotDistinctFrom',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointColumnDateTimeLegacy extends _i1.EndpointRef {
  EndpointColumnDateTimeLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnDateTimeLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnDateTimeLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnDateTimeLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(DateTime? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(DateTime? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<DateTime> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<DateTime> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(DateTime value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    DateTime min,
    DateTime max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDateTimeLegacy',
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
        'columnDateTimeLegacy',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnDoubleLegacy extends _i1.EndpointRef {
  EndpointColumnDoubleLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnDoubleLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnDoubleLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnDoubleLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(double? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(double? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<double> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<double> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(double value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    double min,
    double max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDoubleLegacy',
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
        'columnDoubleLegacy',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnDurationLegacy extends _i1.EndpointRef {
  EndpointColumnDurationLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnDurationLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnDurationLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnDurationLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(Duration? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(Duration? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<Duration> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<Duration> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(Duration value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    Duration min,
    Duration max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnDurationLegacy',
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
        'columnDurationLegacy',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnEnumLegacy extends _i1.EndpointRef {
  EndpointColumnEnumLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnEnumLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnEnumLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnEnumLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnumLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(_i7.TestEnum? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnumLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(_i7.TestEnum? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnumLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<_i7.TestEnum> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnumLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<_i7.TestEnum> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnumLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(_i7.TestEnum value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnumLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(_i7.TestEnum value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnEnumLegacy',
        'isNotDistinctFrom',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointColumnIntLegacy extends _i1.EndpointRef {
  EndpointColumnIntLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnIntLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnIntLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnIntLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(int? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(int? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<int> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<int> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'greaterThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> greaterOrEqualThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'greaterOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'lessThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> lessOrEqualThan(int value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
        'lessOrEqualThan',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> between(
    int min,
    int max,
  ) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnIntLegacy',
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
        'columnIntLegacy',
        'notBetween',
        {
          'min': min,
          'max': max,
        },
      );
}

/// {@category Endpoint}
class EndpointColumnStringLegacy extends _i1.EndpointRef {
  EndpointColumnStringLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnStringLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnStringLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnStringLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(String? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(String? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<String> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<String> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'isNotDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> like(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'like',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> ilike(String value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnStringLegacy',
        'ilike',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointColumnUuidLegacy extends _i1.EndpointRef {
  EndpointColumnUuidLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'columnUuidLegacy';

  _i2.Future<void> insert(List<_i6.Types> types) =>
      caller.callServerEndpoint<void>(
        'columnUuidLegacy',
        'insert',
        {'types': types},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'columnUuidLegacy',
        'deleteAll',
        {},
      );

  _i2.Future<List<_i6.Types>> findAll() =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuidLegacy',
        'findAll',
        {},
      );

  _i2.Future<List<_i6.Types>> equals(_i5.UuidValue? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuidLegacy',
        'equals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notEquals(_i5.UuidValue? value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuidLegacy',
        'notEquals',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> inSet(List<_i5.UuidValue> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuidLegacy',
        'inSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> notInSet(List<_i5.UuidValue> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuidLegacy',
        'notInSet',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isDistinctFrom(_i5.UuidValue value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuidLegacy',
        'isDistinctFrom',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> isNotDistinctFrom(_i5.UuidValue value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'columnUuidLegacy',
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

  _i2.Future<List<_i11.SimpleData>> findSimpleData({
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_i11.SimpleData>>(
        'basicDatabase',
        'findSimpleData',
        {
          'limit': limit,
          'offset': offset,
        },
      );

  _i2.Future<_i11.SimpleData?> findRowSimpleData(int num) =>
      caller.callServerEndpoint<_i11.SimpleData?>(
        'basicDatabase',
        'findRowSimpleData',
        {'num': num},
      );

  _i2.Future<_i11.SimpleData?> findByIdSimpleData(int id) =>
      caller.callServerEndpoint<_i11.SimpleData?>(
        'basicDatabase',
        'findByIdSimpleData',
        {'id': id},
      );

  _i2.Future<_i11.SimpleData> insertRowSimpleData(_i11.SimpleData simpleData) =>
      caller.callServerEndpoint<_i11.SimpleData>(
        'basicDatabase',
        'insertRowSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<_i11.SimpleData> updateRowSimpleData(_i11.SimpleData simpleData) =>
      caller.callServerEndpoint<_i11.SimpleData>(
        'basicDatabase',
        'updateRowSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<int> deleteRowSimpleData(_i11.SimpleData simpleData) =>
      caller.callServerEndpoint<int>(
        'basicDatabase',
        'deleteRowSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<List<int>> deleteWhereSimpleData() =>
      caller.callServerEndpoint<List<int>>(
        'basicDatabase',
        'deleteWhereSimpleData',
        {},
      );

  _i2.Future<int> countSimpleData() => caller.callServerEndpoint<int>(
        'basicDatabase',
        'countSimpleData',
        {},
      );

  _i2.Future<_i6.Types> insertTypes(_i6.Types value) =>
      caller.callServerEndpoint<_i6.Types>(
        'basicDatabase',
        'insertTypes',
        {'value': value},
      );

  _i2.Future<_i6.Types> updateTypes(_i6.Types value) =>
      caller.callServerEndpoint<_i6.Types>(
        'basicDatabase',
        'updateTypes',
        {'value': value},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'basicDatabase',
        'deleteAll',
        {},
      );
}

/// {@category Endpoint}
class EndpointBasicDatabaseLegacy extends _i1.EndpointRef {
  EndpointBasicDatabaseLegacy(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicDatabaseLegacy';

  _i2.Future<int?> storeTypes(_i6.Types types) =>
      caller.callServerEndpoint<int?>(
        'basicDatabaseLegacy',
        'storeTypes',
        {'types': types},
      );

  _i2.Future<_i6.Types?> getTypes(int id) =>
      caller.callServerEndpoint<_i6.Types?>(
        'basicDatabaseLegacy',
        'getTypes',
        {'id': id},
      );

  _i2.Future<int?> storeObjectWithEnum(_i12.ObjectWithEnum object) =>
      caller.callServerEndpoint<int?>(
        'basicDatabaseLegacy',
        'storeObjectWithEnum',
        {'object': object},
      );

  _i2.Future<_i12.ObjectWithEnum?> getObjectWithEnum(int id) =>
      caller.callServerEndpoint<_i12.ObjectWithEnum?>(
        'basicDatabaseLegacy',
        'getObjectWithEnum',
        {'id': id},
      );

  _i2.Future<int?> getTypesRawQuery(int id) => caller.callServerEndpoint<int?>(
        'basicDatabaseLegacy',
        'getTypesRawQuery',
        {'id': id},
      );

  _i2.Future<int?> countTypesRows() => caller.callServerEndpoint<int?>(
        'basicDatabaseLegacy',
        'countTypesRows',
        {},
      );

  _i2.Future<int?> deleteAllInTypes() => caller.callServerEndpoint<int?>(
        'basicDatabaseLegacy',
        'deleteAllInTypes',
        {},
      );

  _i2.Future<void> createSimpleTestData(int numRows) =>
      caller.callServerEndpoint<void>(
        'basicDatabaseLegacy',
        'createSimpleTestData',
        {'numRows': numRows},
      );

  _i2.Future<int?> countSimpleData() => caller.callServerEndpoint<int?>(
        'basicDatabaseLegacy',
        'countSimpleData',
        {},
      );

  _i2.Future<void> deleteAllSimpleTestData() => caller.callServerEndpoint<void>(
        'basicDatabaseLegacy',
        'deleteAllSimpleTestData',
        {},
      );

  _i2.Future<void> deleteSimpleTestDataLessThan(int num) =>
      caller.callServerEndpoint<void>(
        'basicDatabaseLegacy',
        'deleteSimpleTestDataLessThan',
        {'num': num},
      );

  _i2.Future<bool?> findAndDeleteSimpleTestData(int num) =>
      caller.callServerEndpoint<bool?>(
        'basicDatabaseLegacy',
        'findAndDeleteSimpleTestData',
        {'num': num},
      );

  _i2.Future<_i13.SimpleDataList?> findSimpleDataRowsLessThan(
    int num,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<_i13.SimpleDataList?>(
        'basicDatabaseLegacy',
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
        'basicDatabaseLegacy',
        'updateSimpleDataRow',
        {
          'num': num,
          'newNum': newNum,
        },
      );

  _i2.Future<int?> storeObjectWithObject(_i14.ObjectWithObject object) =>
      caller.callServerEndpoint<int?>(
        'basicDatabaseLegacy',
        'storeObjectWithObject',
        {'object': object},
      );

  _i2.Future<_i14.ObjectWithObject?> getObjectWithObject(int id) =>
      caller.callServerEndpoint<_i14.ObjectWithObject?>(
        'basicDatabaseLegacy',
        'getObjectWithObject',
        {'id': id},
      );

  _i2.Future<bool> testByteDataStore() => caller.callServerEndpoint<bool>(
        'basicDatabaseLegacy',
        'testByteDataStore',
        {},
      );

  _i2.Future<bool> testDurationStore() => caller.callServerEndpoint<bool>(
        'basicDatabaseLegacy',
        'testDurationStore',
        {},
      );
}

/// {@category Endpoint}
class EndpointDatabaseBatch extends _i1.EndpointRef {
  EndpointDatabaseBatch(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'databaseBatch';

  _i2.Future<List<_i15.UniqueData>> batchInsert(List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatch',
        'batchInsert',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> batchInsertTypes(List<_i6.Types> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'databaseBatch',
        'batchInsertTypes',
        {'value': value},
      );

  _i2.Future<List<_i15.UniqueData>> batchUpdate(List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatch',
        'batchUpdate',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> batchUpdateTypes(List<_i6.Types> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'databaseBatch',
        'batchUpdateTypes',
        {'value': value},
      );

  _i2.Future<List<_i15.UniqueData>> batchUpdateWithInvalidColumn(
          List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatch',
        'batchUpdateWithInvalidColumn',
        {'value': value},
      );

  _i2.Future<List<_i15.UniqueData>> batchUpdateNumberOnly(
          List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatch',
        'batchUpdateNumberOnly',
        {'value': value},
      );

  _i2.Future<List<int>> batchDelete(List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<int>>(
        'databaseBatch',
        'batchDelete',
        {'value': value},
      );

  _i2.Future<_i16.RelatedUniqueData> insertRelatedUniqueData(
          _i16.RelatedUniqueData value) =>
      caller.callServerEndpoint<_i16.RelatedUniqueData>(
        'databaseBatch',
        'insertRelatedUniqueData',
        {'value': value},
      );

  _i2.Future<_i15.UniqueData?> findByEmail(String email) =>
      caller.callServerEndpoint<_i15.UniqueData?>(
        'databaseBatch',
        'findByEmail',
        {'email': email},
      );

  _i2.Future<_i15.UniqueData?> findById(int id) =>
      caller.callServerEndpoint<_i15.UniqueData?>(
        'databaseBatch',
        'findById',
        {'id': id},
      );

  _i2.Future<List<_i15.UniqueData>> findAll() =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatch',
        'findAll',
        {},
      );

  _i2.Future<void> deleteAll() => caller.callServerEndpoint<void>(
        'databaseBatch',
        'deleteAll',
        {},
      );
}

/// {@category Endpoint}
class EndpointDatabaseBatchGenerated extends _i1.EndpointRef {
  EndpointDatabaseBatchGenerated(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'databaseBatchGenerated';

  _i2.Future<List<_i15.UniqueData>> batchInsert(List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatchGenerated',
        'batchInsert',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> batchInsertTypes(List<_i6.Types> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'databaseBatchGenerated',
        'batchInsertTypes',
        {'value': value},
      );

  _i2.Future<List<_i15.UniqueData>> batchUpdate(List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatchGenerated',
        'batchUpdate',
        {'value': value},
      );

  _i2.Future<List<_i6.Types>> batchUpdateTypes(List<_i6.Types> value) =>
      caller.callServerEndpoint<List<_i6.Types>>(
        'databaseBatchGenerated',
        'batchUpdateTypes',
        {'value': value},
      );

  _i2.Future<List<int>> batchDelete(List<_i15.UniqueData> value) =>
      caller.callServerEndpoint<List<int>>(
        'databaseBatchGenerated',
        'batchDelete',
        {'value': value},
      );

  _i2.Future<_i16.RelatedUniqueData> insertRelatedUniqueData(
          _i16.RelatedUniqueData value) =>
      caller.callServerEndpoint<_i16.RelatedUniqueData>(
        'databaseBatchGenerated',
        'insertRelatedUniqueData',
        {'value': value},
      );

  _i2.Future<_i15.UniqueData?> findByEmail(String email) =>
      caller.callServerEndpoint<_i15.UniqueData?>(
        'databaseBatchGenerated',
        'findByEmail',
        {'email': email},
      );

  _i2.Future<_i15.UniqueData?> findById(int id) =>
      caller.callServerEndpoint<_i15.UniqueData?>(
        'databaseBatchGenerated',
        'findById',
        {'id': id},
      );

  _i2.Future<List<_i15.UniqueData>> findAll() =>
      caller.callServerEndpoint<List<_i15.UniqueData>>(
        'databaseBatchGenerated',
        'findAll',
        {},
      );

  _i2.Future<void> deleteAll() => caller.callServerEndpoint<void>(
        'databaseBatchGenerated',
        'deleteAll',
        {},
      );
}

/// {@category Endpoint}
class EndpointDatabaseListRelationMethods extends _i1.EndpointRef {
  EndpointDatabaseListRelationMethods(_i1.EndpointCaller caller)
      : super(caller);

  @override
  String get name => 'databaseListRelationMethods';

  _i2.Future<_i17.City> insertCity(_i17.City city) =>
      caller.callServerEndpoint<_i17.City>(
        'databaseListRelationMethods',
        'insertCity',
        {'city': city},
      );

  _i2.Future<_i18.Organization> insertOrganization(
          _i18.Organization organization) =>
      caller.callServerEndpoint<_i18.Organization>(
        'databaseListRelationMethods',
        'insertOrganization',
        {'organization': organization},
      );

  _i2.Future<_i19.Person> insertPerson(_i19.Person person) =>
      caller.callServerEndpoint<_i19.Person>(
        'databaseListRelationMethods',
        'insertPerson',
        {'person': person},
      );

  _i2.Future<void> implicitAttachRowCitizen(
    _i17.City city,
    _i19.Person citizen,
  ) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'implicitAttachRowCitizen',
        {
          'city': city,
          'citizen': citizen,
        },
      );

  _i2.Future<void> implicitAttachCitizens(
    _i17.City city,
    List<_i19.Person> citizens,
  ) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'implicitAttachCitizens',
        {
          'city': city,
          'citizens': citizens,
        },
      );

  _i2.Future<void> implicitDetachRowCitizens(_i19.Person citizen) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'implicitDetachRowCitizens',
        {'citizen': citizen},
      );

  _i2.Future<void> implicitDetachCitizens(List<_i19.Person> citizens) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'implicitDetachCitizens',
        {'citizens': citizens},
      );

  _i2.Future<_i17.City?> cityFindById(int id) =>
      caller.callServerEndpoint<_i17.City?>(
        'databaseListRelationMethods',
        'cityFindById',
        {'id': id},
      );

  _i2.Future<void> explicitAttachRowPeople(
    _i18.Organization org,
    _i19.Person person,
  ) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'explicitAttachRowPeople',
        {
          'org': org,
          'person': person,
        },
      );

  _i2.Future<void> explicitAttachPeople(
    _i18.Organization org,
    List<_i19.Person> persons,
  ) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'explicitAttachPeople',
        {
          'org': org,
          'persons': persons,
        },
      );

  _i2.Future<void> explicitDetachRowPeople(_i19.Person person) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'explicitDetachRowPeople',
        {'person': person},
      );

  _i2.Future<void> explicitDetachPeople(List<_i19.Person> persons) =>
      caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'explicitDetachPeople',
        {'persons': persons},
      );

  _i2.Future<_i18.Organization?> organizationFindById(int id) =>
      caller.callServerEndpoint<_i18.Organization?>(
        'databaseListRelationMethods',
        'organizationFindById',
        {'id': id},
      );

  _i2.Future<void> deleteAll() => caller.callServerEndpoint<void>(
        'databaseListRelationMethods',
        'deleteAll',
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
class EndpointOneToMany extends _i1.EndpointRef {
  EndpointOneToMany(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'oneToMany';

  _i2.Future<List<_i20.Customer>> customerOrderByOrderCountAscending() =>
      caller.callServerEndpoint<List<_i20.Customer>>(
        'oneToMany',
        'customerOrderByOrderCountAscending',
        {},
      );

  _i2.Future<List<_i20.Customer>>
      customerOrderByOrderCountAscendingWhereDescriptionIs(
              String description) =>
          caller.callServerEndpoint<List<_i20.Customer>>(
            'oneToMany',
            'customerOrderByOrderCountAscendingWhereDescriptionIs',
            {'description': description},
          );

  _i2.Future<List<_i21.Comment>> commentInsert(List<_i21.Comment> comments) =>
      caller.callServerEndpoint<List<_i21.Comment>>(
        'oneToMany',
        'commentInsert',
        {'comments': comments},
      );

  _i2.Future<List<_i22.Order>> orderInsert(List<_i22.Order> orders) =>
      caller.callServerEndpoint<List<_i22.Order>>(
        'oneToMany',
        'orderInsert',
        {'orders': orders},
      );

  _i2.Future<List<_i20.Customer>> customerInsert(
          List<_i20.Customer> customers) =>
      caller.callServerEndpoint<List<_i20.Customer>>(
        'oneToMany',
        'customerInsert',
        {'customers': customers},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'oneToMany',
        'deleteAll',
        {},
      );
}

/// {@category Endpoint}
class EndpointRelation extends _i1.EndpointRef {
  EndpointRelation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'relation';

  _i2.Future<List<_i23.Citizen>> citizenFindWhereCompanyNameIs(
          {required String companyName}) =>
      caller.callServerEndpoint<List<_i23.Citizen>>(
        'relation',
        'citizenFindWhereCompanyNameIs',
        {'companyName': companyName},
      );

  _i2.Future<List<_i23.Citizen>> citizenFindWhereCompanyTownNameIs(
          {required String townName}) =>
      caller.callServerEndpoint<List<_i23.Citizen>>(
        'relation',
        'citizenFindWhereCompanyTownNameIs',
        {'townName': townName},
      );

  _i2.Future<List<_i23.Citizen>> citizenFindOrderedByCompanyName() =>
      caller.callServerEndpoint<List<_i23.Citizen>>(
        'relation',
        'citizenFindOrderedByCompanyName',
        {},
      );

  _i2.Future<List<_i23.Citizen>> citizenFindOrderedByCompanyTownName() =>
      caller.callServerEndpoint<List<_i23.Citizen>>(
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

  _i2.Future<List<_i23.Citizen>> citizenFindAll() =>
      caller.callServerEndpoint<List<_i23.Citizen>>(
        'relation',
        'citizenFindAll',
        {},
      );

  /// Includes company and oldCompany and their respective towns
  _i2.Future<List<_i23.Citizen>> citizenFindAllWithDeepIncludes() =>
      caller.callServerEndpoint<List<_i23.Citizen>>(
        'relation',
        'citizenFindAllWithDeepIncludes',
        {},
      );

  /// Includes the address
  _i2.Future<List<_i23.Citizen>>
      citizenFindAllWithNamedRelationNoneOriginSide() =>
          caller.callServerEndpoint<List<_i23.Citizen>>(
            'relation',
            'citizenFindAllWithNamedRelationNoneOriginSide',
            {},
          );

  /// Includes company and oldCompany
  _i2.Future<List<_i23.Citizen>> citizenFindAllWithShallowIncludes() =>
      caller.callServerEndpoint<List<_i23.Citizen>>(
        'relation',
        'citizenFindAllWithShallowIncludes',
        {},
      );

  _i2.Future<_i23.Citizen?> citizenFindByIdWithIncludes(int id) =>
      caller.callServerEndpoint<_i23.Citizen?>(
        'relation',
        'citizenFindByIdWithIncludes',
        {'id': id},
      );

  _i2.Future<List<_i24.Address>> addressFindAll() =>
      caller.callServerEndpoint<List<_i24.Address>>(
        'relation',
        'addressFindAll',
        {},
      );

  _i2.Future<_i24.Address?> addressFindById(int id) =>
      caller.callServerEndpoint<_i24.Address?>(
        'relation',
        'addressFindById',
        {'id': id},
      );

  _i2.Future<List<_i25.Post>> findAllPostsIncludingNextAndPrevious() =>
      caller.callServerEndpoint<List<_i25.Post>>(
        'relation',
        'findAllPostsIncludingNextAndPrevious',
        {},
      );

  _i2.Future<void> citizenAttachCompany(
    _i23.Citizen citizen,
    _i26.Company company,
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
    _i23.Citizen citizen,
    _i24.Address address,
  ) =>
      caller.callServerEndpoint<void>(
        'relation',
        'citizenAttachAddress',
        {
          'citizen': citizen,
          'address': address,
        },
      );

  _i2.Future<void> citizenDetachAddress(_i23.Citizen citizen) =>
      caller.callServerEndpoint<void>(
        'relation',
        'citizenDetachAddress',
        {'citizen': citizen},
      );

  _i2.Future<void> addressAttachCitizen(
    _i24.Address address,
    _i23.Citizen citizen,
  ) =>
      caller.callServerEndpoint<void>(
        'relation',
        'addressAttachCitizen',
        {
          'address': address,
          'citizen': citizen,
        },
      );

  _i2.Future<void> addressDetachCitizen(_i24.Address address) =>
      caller.callServerEndpoint<void>(
        'relation',
        'addressDetachCitizen',
        {'address': address},
      );

  _i2.Future<List<_i26.Company>> companyFindAll() =>
      caller.callServerEndpoint<List<_i26.Company>>(
        'relation',
        'companyFindAll',
        {},
      );

  _i2.Future<int?> citizenInsert(_i23.Citizen citizen) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'citizenInsert',
        {'citizen': citizen},
      );

  _i2.Future<int?> companyInsert(_i26.Company company) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'companyInsert',
        {'company': company},
      );

  _i2.Future<int?> townInsert(_i27.Town town) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'townInsert',
        {'town': town},
      );

  _i2.Future<int?> addressInsert(_i24.Address address) =>
      caller.callServerEndpoint<int?>(
        'relation',
        'addressInsert',
        {'address': address},
      );

  _i2.Future<int?> postInsert(_i25.Post post) =>
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

  _i2.Future<void> storeObject(_i28.ObjectFieldScopes object) =>
      caller.callServerEndpoint<void>(
        'fieldScopes',
        'storeObject',
        {'object': object},
      );

  _i2.Future<_i28.ObjectFieldScopes?> retrieveObject() =>
      caller.callServerEndpoint<_i28.ObjectFieldScopes?>(
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

  _i2.Future<void> makeFutureCall(_i11.SimpleData? data) =>
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

  _i2.Future<List<_i11.SimpleData>> returnSimpleDataList(
          List<_i11.SimpleData> list) =>
      caller.callServerEndpoint<List<_i11.SimpleData>>(
        'listParameters',
        'returnSimpleDataList',
        {'list': list},
      );

  _i2.Future<List<_i11.SimpleData?>> returnSimpleDataListNullableSimpleData(
          List<_i11.SimpleData?> list) =>
      caller.callServerEndpoint<List<_i11.SimpleData?>>(
        'listParameters',
        'returnSimpleDataListNullableSimpleData',
        {'list': list},
      );

  _i2.Future<List<_i11.SimpleData>?> returnSimpleDataListNullable(
          List<_i11.SimpleData>? list) =>
      caller.callServerEndpoint<List<_i11.SimpleData>?>(
        'listParameters',
        'returnSimpleDataListNullable',
        {'list': list},
      );

  _i2.Future<List<_i11.SimpleData?>?>
      returnNullableSimpleDataListNullableSimpleData(
              List<_i11.SimpleData?>? list) =>
          caller.callServerEndpoint<List<_i11.SimpleData?>?>(
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

  _i2.Future<Map<String, _i11.SimpleData>> returnSimpleDataMap(
          Map<String, _i11.SimpleData> map) =>
      caller.callServerEndpoint<Map<String, _i11.SimpleData>>(
        'mapParameters',
        'returnSimpleDataMap',
        {'map': map},
      );

  _i2.Future<Map<String, _i11.SimpleData?>>
      returnSimpleDataMapNullableSimpleData(
              Map<String, _i11.SimpleData?> map) =>
          caller.callServerEndpoint<Map<String, _i11.SimpleData?>>(
            'mapParameters',
            'returnSimpleDataMapNullableSimpleData',
            {'map': map},
          );

  _i2.Future<Map<String, _i11.SimpleData>?> returnSimpleDataMapNullable(
          Map<String, _i11.SimpleData>? map) =>
      caller.callServerEndpoint<Map<String, _i11.SimpleData>?>(
        'mapParameters',
        'returnSimpleDataMapNullable',
        {'map': map},
      );

  _i2.Future<Map<String, _i11.SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
              Map<String, _i11.SimpleData?>? map) =>
          caller.callServerEndpoint<Map<String, _i11.SimpleData?>?>(
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

  _i2.Future<_i29.ModuleClass> modifyModuleObject(_i29.ModuleClass object) =>
      caller.callServerEndpoint<_i29.ModuleClass>(
        'moduleSerialization',
        'modifyModuleObject',
        {'object': object},
      );

  _i2.Future<_i30.ModuleDatatype> serializeNestedModuleObject() =>
      caller.callServerEndpoint<_i30.ModuleDatatype>(
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
    _i11.SimpleData data,
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
    _i11.SimpleData data,
  ) =>
      caller.callServerEndpoint<void>(
        'redis',
        'setSimpleDataWithLifetime',
        {
          'key': key,
          'data': data,
        },
      );

  _i2.Future<_i11.SimpleData?> getSimpleData(String key) =>
      caller.callServerEndpoint<_i11.SimpleData?>(
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

  _i2.Future<_i11.SimpleData?> listenToChannel(String channel) =>
      caller.callServerEndpoint<_i11.SimpleData?>(
        'redis',
        'listenToChannel',
        {'channel': channel},
      );

  _i2.Future<void> postToChannel(
    String channel,
    _i11.SimpleData data,
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
    module = _i29.Caller(client);
    auth = _i3.Caller(client);
  }

  late final _i29.Caller module;

  late final _i3.Caller auth;
}

class Client extends _i1.ServerpodClient {
  Client(
    String host, {
    _i31.SecurityContext? context,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    _i1.HeaderManager? headerManager,
  }) : super(
          host,
          _i32.Protocol(),
          context: context,
          authenticationKeyManager: authenticationKeyManager,
          headerManager: headerManager,
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
    columnBoolLegacy = EndpointColumnBoolLegacy(this);
    columnDateTimeLegacy = EndpointColumnDateTimeLegacy(this);
    columnDoubleLegacy = EndpointColumnDoubleLegacy(this);
    columnDurationLegacy = EndpointColumnDurationLegacy(this);
    columnEnumLegacy = EndpointColumnEnumLegacy(this);
    columnIntLegacy = EndpointColumnIntLegacy(this);
    columnStringLegacy = EndpointColumnStringLegacy(this);
    columnUuidLegacy = EndpointColumnUuidLegacy(this);
    customTypes = EndpointCustomTypes(this);
    basicDatabase = EndpointBasicDatabase(this);
    basicDatabaseLegacy = EndpointBasicDatabaseLegacy(this);
    databaseBatch = EndpointDatabaseBatch(this);
    databaseBatchGenerated = EndpointDatabaseBatchGenerated(this);
    databaseListRelationMethods = EndpointDatabaseListRelationMethods(this);
    transactionsDatabase = EndpointTransactionsDatabase(this);
    oneToMany = EndpointOneToMany(this);
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

  late final EndpointColumnBoolLegacy columnBoolLegacy;

  late final EndpointColumnDateTimeLegacy columnDateTimeLegacy;

  late final EndpointColumnDoubleLegacy columnDoubleLegacy;

  late final EndpointColumnDurationLegacy columnDurationLegacy;

  late final EndpointColumnEnumLegacy columnEnumLegacy;

  late final EndpointColumnIntLegacy columnIntLegacy;

  late final EndpointColumnStringLegacy columnStringLegacy;

  late final EndpointColumnUuidLegacy columnUuidLegacy;

  late final EndpointCustomTypes customTypes;

  late final EndpointBasicDatabase basicDatabase;

  late final EndpointBasicDatabaseLegacy basicDatabaseLegacy;

  late final EndpointDatabaseBatch databaseBatch;

  late final EndpointDatabaseBatchGenerated databaseBatchGenerated;

  late final EndpointDatabaseListRelationMethods databaseListRelationMethods;

  late final EndpointTransactionsDatabase transactionsDatabase;

  late final EndpointOneToMany oneToMany;

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
        'columnBoolLegacy': columnBoolLegacy,
        'columnDateTimeLegacy': columnDateTimeLegacy,
        'columnDoubleLegacy': columnDoubleLegacy,
        'columnDurationLegacy': columnDurationLegacy,
        'columnEnumLegacy': columnEnumLegacy,
        'columnIntLegacy': columnIntLegacy,
        'columnStringLegacy': columnStringLegacy,
        'columnUuidLegacy': columnUuidLegacy,
        'customTypes': customTypes,
        'basicDatabase': basicDatabase,
        'basicDatabaseLegacy': basicDatabaseLegacy,
        'databaseBatch': databaseBatch,
        'databaseBatchGenerated': databaseBatchGenerated,
        'databaseListRelationMethods': databaseListRelationMethods,
        'transactionsDatabase': transactionsDatabase,
        'oneToMany': oneToMany,
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
