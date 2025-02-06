/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;
import 'dart:typed_data' as _i4;
import 'package:uuid/uuid_value.dart' as _i5;
import 'package:serverpod_test_shared/src/protocol_custom_classes.dart' as _i6;
import 'package:serverpod_test_shared/src/custom_classes.dart' as _i7;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i8;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i9;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i10;
import 'package:serverpod_test_client/src/protocol/simple_data_list.dart'
    as _i11;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i12;
import 'package:serverpod_test_client/src/protocol/object_with_enum.dart'
    as _i13;
import 'package:serverpod_test_client/src/protocol/object_with_object.dart'
    as _i14;
import 'package:serverpod_test_client/src/protocol/object_field_scopes.dart'
    as _i15;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i16;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i17;
import 'package:serverpod_test_client/src/protocol/module_datatype.dart'
    as _i18;
import 'package:serverpod_test_client/src/protocol/scopes/scope_server_only_field.dart'
    as _i19;
import 'package:serverpod_test_client/src/protocol/scopes/scope_server_only_field_child.dart'
    as _i20;
import 'package:serverpod_test_client/src/protocol/my_feature/models/my_feature_model.dart'
    as _i21;
import 'protocol.dart' as _i22;

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
    String password, [
    List<String>? scopes,
  ]) =>
      caller.callServerEndpoint<_i3.AuthenticationResponse>(
        'authentication',
        'authenticate',
        {
          'email': email,
          'password': password,
          'scopes': scopes,
        },
      );

  _i2.Future<void> signOut() => caller.callServerEndpoint<void>(
        'authentication',
        'signOut',
        {},
      );

  _i2.Future<void> updateScopes(
    int userId,
    List<String> scopes,
  ) =>
      caller.callServerEndpoint<void>(
        'authentication',
        'updateScopes',
        {
          'userId': userId,
          'scopes': scopes,
        },
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

  _i2.Future<Uri?> testUri(Uri? value) => caller.callServerEndpoint<Uri?>(
        'basicTypes',
        'testUri',
        {'value': value},
      );

  _i2.Future<BigInt?> testBigInt(BigInt? value) =>
      caller.callServerEndpoint<BigInt?>(
        'basicTypes',
        'testBigInt',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointBasicTypesStreaming extends _i1.EndpointRef {
  EndpointBasicTypesStreaming(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicTypesStreaming';

  _i2.Stream<int?> testInt(_i2.Stream<int?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int?>, int?>(
        'basicTypesStreaming',
        'testInt',
        {},
        {'value': value},
      );

  _i2.Stream<double?> testDouble(_i2.Stream<double?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<double?>, double?>(
        'basicTypesStreaming',
        'testDouble',
        {},
        {'value': value},
      );

  _i2.Stream<bool?> testBool(_i2.Stream<bool?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool?>, bool?>(
        'basicTypesStreaming',
        'testBool',
        {},
        {'value': value},
      );

  _i2.Stream<DateTime?> testDateTime(_i2.Stream<DateTime?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<DateTime?>, DateTime?>(
        'basicTypesStreaming',
        'testDateTime',
        {},
        {'value': value},
      );

  _i2.Stream<String?> testString(_i2.Stream<String?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<String?>, String?>(
        'basicTypesStreaming',
        'testString',
        {},
        {'value': value},
      );

  _i2.Stream<_i4.ByteData?> testByteData(_i2.Stream<_i4.ByteData?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i4.ByteData?>,
          _i4.ByteData?>(
        'basicTypesStreaming',
        'testByteData',
        {},
        {'value': value},
      );

  _i2.Stream<Duration?> testDuration(_i2.Stream<Duration?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<Duration?>, Duration?>(
        'basicTypesStreaming',
        'testDuration',
        {},
        {'value': value},
      );

  _i2.Stream<_i5.UuidValue?> testUuid(_i2.Stream<_i5.UuidValue?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i5.UuidValue?>,
          _i5.UuidValue?>(
        'basicTypesStreaming',
        'testUuid',
        {},
        {'value': value},
      );

  _i2.Stream<Uri?> testUri(_i2.Stream<Uri?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<Uri?>, Uri?>(
        'basicTypesStreaming',
        'testUri',
        {},
        {'value': value},
      );

  _i2.Stream<BigInt?> testBigInt(_i2.Stream<BigInt?> value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<BigInt?>, BigInt?>(
        'basicTypesStreaming',
        'testBigInt',
        {},
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
class EndpointCustomClassProtocol extends _i1.EndpointRef {
  EndpointCustomClassProtocol(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customClassProtocol';

  _i2.Future<_i6.ProtocolCustomClass> getProtocolField() =>
      caller.callServerEndpoint<_i6.ProtocolCustomClass>(
        'customClassProtocol',
        'getProtocolField',
        {},
      );
}

/// {@category Endpoint}
class EndpointCustomTypes extends _i1.EndpointRef {
  EndpointCustomTypes(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customTypes';

  _i2.Future<_i7.CustomClass> returnCustomClass(_i7.CustomClass data) =>
      caller.callServerEndpoint<_i7.CustomClass>(
        'customTypes',
        'returnCustomClass',
        {'data': data},
      );

  _i2.Future<_i7.CustomClass?> returnCustomClassNullable(
          _i7.CustomClass? data) =>
      caller.callServerEndpoint<_i7.CustomClass?>(
        'customTypes',
        'returnCustomClassNullable',
        {'data': data},
      );

  _i2.Future<_i7.CustomClass2> returnCustomClass2(_i7.CustomClass2 data) =>
      caller.callServerEndpoint<_i7.CustomClass2>(
        'customTypes',
        'returnCustomClass2',
        {'data': data},
      );

  _i2.Future<_i7.CustomClass2?> returnCustomClass2Nullable(
          _i7.CustomClass2? data) =>
      caller.callServerEndpoint<_i7.CustomClass2?>(
        'customTypes',
        'returnCustomClass2Nullable',
        {'data': data},
      );

  _i2.Future<_i8.ExternalCustomClass> returnExternalCustomClass(
          _i8.ExternalCustomClass data) =>
      caller.callServerEndpoint<_i8.ExternalCustomClass>(
        'customTypes',
        'returnExternalCustomClass',
        {'data': data},
      );

  _i2.Future<_i8.ExternalCustomClass?> returnExternalCustomClassNullable(
          _i8.ExternalCustomClass? data) =>
      caller.callServerEndpoint<_i8.ExternalCustomClass?>(
        'customTypes',
        'returnExternalCustomClassNullable',
        {'data': data},
      );

  _i2.Future<_i9.FreezedCustomClass> returnFreezedCustomClass(
          _i9.FreezedCustomClass data) =>
      caller.callServerEndpoint<_i9.FreezedCustomClass>(
        'customTypes',
        'returnFreezedCustomClass',
        {'data': data},
      );

  _i2.Future<_i9.FreezedCustomClass?> returnFreezedCustomClassNullable(
          _i9.FreezedCustomClass? data) =>
      caller.callServerEndpoint<_i9.FreezedCustomClass?>(
        'customTypes',
        'returnFreezedCustomClassNullable',
        {'data': data},
      );

  _i2.Future<_i7.CustomClassWithoutProtocolSerialization>
      returnCustomClassWithoutProtocolSerialization(
              _i7.CustomClassWithoutProtocolSerialization data) =>
          caller
              .callServerEndpoint<_i7.CustomClassWithoutProtocolSerialization>(
            'customTypes',
            'returnCustomClassWithoutProtocolSerialization',
            {'data': data},
          );

  _i2.Future<_i7.CustomClassWithProtocolSerialization>
      returnCustomClassWithProtocolSerialization(
              _i7.CustomClassWithProtocolSerialization data) =>
          caller.callServerEndpoint<_i7.CustomClassWithProtocolSerialization>(
            'customTypes',
            'returnCustomClassWithProtocolSerialization',
            {'data': data},
          );

  _i2.Future<_i7.CustomClassWithProtocolSerializationMethod>
      returnCustomClassWithProtocolSerializationMethod(
              _i7.CustomClassWithProtocolSerializationMethod data) =>
          caller.callServerEndpoint<
              _i7.CustomClassWithProtocolSerializationMethod>(
            'customTypes',
            'returnCustomClassWithProtocolSerializationMethod',
            {'data': data},
          );
}

/// {@category Endpoint}
class EndpointBasicDatabase extends _i1.EndpointRef {
  EndpointBasicDatabase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicDatabase';

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

  _i2.Future<void> findAndDeleteSimpleTestData(int num) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'findAndDeleteSimpleTestData',
        {'num': num},
      );

  _i2.Future<void> createSimpleTestData(int numRows) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'createSimpleTestData',
        {'numRows': numRows},
      );

  _i2.Future<List<_i10.SimpleData>> findSimpleData({
    required int limit,
    required int offset,
  }) =>
      caller.callServerEndpoint<List<_i10.SimpleData>>(
        'basicDatabase',
        'findSimpleData',
        {
          'limit': limit,
          'offset': offset,
        },
      );

  _i2.Future<_i10.SimpleData?> findFirstRowSimpleData(int num) =>
      caller.callServerEndpoint<_i10.SimpleData?>(
        'basicDatabase',
        'findFirstRowSimpleData',
        {'num': num},
      );

  _i2.Future<_i10.SimpleData?> findByIdSimpleData(int id) =>
      caller.callServerEndpoint<_i10.SimpleData?>(
        'basicDatabase',
        'findByIdSimpleData',
        {'id': id},
      );

  _i2.Future<_i11.SimpleDataList?> findSimpleDataRowsLessThan(
    int num,
    int offset,
    int limit,
    bool descending,
  ) =>
      caller.callServerEndpoint<_i11.SimpleDataList?>(
        'basicDatabase',
        'findSimpleDataRowsLessThan',
        {
          'num': num,
          'offset': offset,
          'limit': limit,
          'descending': descending,
        },
      );

  _i2.Future<_i10.SimpleData> insertRowSimpleData(_i10.SimpleData simpleData) =>
      caller.callServerEndpoint<_i10.SimpleData>(
        'basicDatabase',
        'insertRowSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<_i10.SimpleData> updateRowSimpleData(_i10.SimpleData simpleData) =>
      caller.callServerEndpoint<_i10.SimpleData>(
        'basicDatabase',
        'updateRowSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<int> deleteRowSimpleData(_i10.SimpleData simpleData) =>
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

  _i2.Future<_i12.Types> insertTypes(_i12.Types value) =>
      caller.callServerEndpoint<_i12.Types>(
        'basicDatabase',
        'insertTypes',
        {'value': value},
      );

  _i2.Future<_i12.Types> updateTypes(_i12.Types value) =>
      caller.callServerEndpoint<_i12.Types>(
        'basicDatabase',
        'updateTypes',
        {'value': value},
      );

  _i2.Future<int?> countTypesRows() => caller.callServerEndpoint<int?>(
        'basicDatabase',
        'countTypesRows',
        {},
      );

  _i2.Future<List<int>> deleteAllInTypes() =>
      caller.callServerEndpoint<List<int>>(
        'basicDatabase',
        'deleteAllInTypes',
        {},
      );

  _i2.Future<_i12.Types?> getTypes(int id) =>
      caller.callServerEndpoint<_i12.Types?>(
        'basicDatabase',
        'getTypes',
        {'id': id},
      );

  _i2.Future<int?> getTypesRawQuery(int id) => caller.callServerEndpoint<int?>(
        'basicDatabase',
        'getTypesRawQuery',
        {'id': id},
      );

  _i2.Future<_i13.ObjectWithEnum> storeObjectWithEnum(
          _i13.ObjectWithEnum object) =>
      caller.callServerEndpoint<_i13.ObjectWithEnum>(
        'basicDatabase',
        'storeObjectWithEnum',
        {'object': object},
      );

  _i2.Future<_i13.ObjectWithEnum?> getObjectWithEnum(int id) =>
      caller.callServerEndpoint<_i13.ObjectWithEnum?>(
        'basicDatabase',
        'getObjectWithEnum',
        {'id': id},
      );

  _i2.Future<_i14.ObjectWithObject> storeObjectWithObject(
          _i14.ObjectWithObject object) =>
      caller.callServerEndpoint<_i14.ObjectWithObject>(
        'basicDatabase',
        'storeObjectWithObject',
        {'object': object},
      );

  _i2.Future<_i14.ObjectWithObject?> getObjectWithObject(int id) =>
      caller.callServerEndpoint<_i14.ObjectWithObject?>(
        'basicDatabase',
        'getObjectWithObject',
        {'id': id},
      );

  _i2.Future<int> deleteAll() => caller.callServerEndpoint<int>(
        'basicDatabase',
        'deleteAll',
        {},
      );

  _i2.Future<bool> testByteDataStore() => caller.callServerEndpoint<bool>(
        'basicDatabase',
        'testByteDataStore',
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

/// A simple endpoint for testing deprecated endpoint methods.
/// {@category Endpoint}
class EndpointDeprecation extends _i1.EndpointRef {
  EndpointDeprecation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'deprecation';

  /// A method with a simple "@deprecated" annotation.
  @deprecated
  _i2.Future<void> setGlobalDouble(double? value) =>
      caller.callServerEndpoint<void>(
        'deprecation',
        'setGlobalDouble',
        {'value': value},
      );

  /// A method with a "@Deprecated(..)" annotation.
  @Deprecated('Marking endpoint method as deprecated')
  _i2.Future<double> getGlobalDouble() => caller.callServerEndpoint<double>(
        'deprecation',
        'getGlobalDouble',
        {},
      );
}

/// This class is meant for echoing / reflecting the received headers,
/// auth keys, parameters etc in endpoint invocations.
/// {@category Endpoint}
class EndpointEchoRequest extends _i1.EndpointRef {
  EndpointEchoRequest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'echoRequest';

  /// Echo the authentication key of the session.
  /// Returns null if the key is not set.
  _i2.Future<String?> echoAuthenticationKey() =>
      caller.callServerEndpoint<String?>(
        'echoRequest',
        'echoAuthenticationKey',
        {},
      );

  /// Echo a specified header of the HTTP request.
  /// Returns null of the header is not set.
  _i2.Future<List<String>?> echoHttpHeader(String headerName) =>
      caller.callServerEndpoint<List<String>?>(
        'echoRequest',
        'echoHttpHeader',
        {'headerName': headerName},
      );
}

/// {@category Endpoint}
class EndpointEmailAuthTestMethods extends _i1.EndpointRef {
  EndpointEmailAuthTestMethods(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailAuthTestMethods';

  _i2.Future<String?> findVerificationCode(
    String userName,
    String email,
  ) =>
      caller.callServerEndpoint<String?>(
        'emailAuthTestMethods',
        'findVerificationCode',
        {
          'userName': userName,
          'email': email,
        },
      );

  _i2.Future<String?> findResetCode(String email) =>
      caller.callServerEndpoint<String?>(
        'emailAuthTestMethods',
        'findResetCode',
        {'email': email},
      );

  _i2.Future<void> tearDown() => caller.callServerEndpoint<void>(
        'emailAuthTestMethods',
        'tearDown',
        {},
      );

  _i2.Future<bool> createUser(
    String userName,
    String email,
    String password,
  ) =>
      caller.callServerEndpoint<bool>(
        'emailAuthTestMethods',
        'createUser',
        {
          'userName': userName,
          'email': email,
          'password': password,
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

  _i2.Future<void> storeObject(_i15.ObjectFieldScopes object) =>
      caller.callServerEndpoint<void>(
        'fieldScopes',
        'storeObject',
        {'object': object},
      );

  _i2.Future<_i15.ObjectFieldScopes?> retrieveObject() =>
      caller.callServerEndpoint<_i15.ObjectFieldScopes?>(
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

  _i2.Future<void> makeFutureCall(_i10.SimpleData? data) =>
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

  _i2.Future<List<_i10.SimpleData>> returnSimpleDataList(
          List<_i10.SimpleData> list) =>
      caller.callServerEndpoint<List<_i10.SimpleData>>(
        'listParameters',
        'returnSimpleDataList',
        {'list': list},
      );

  _i2.Future<List<_i10.SimpleData?>> returnSimpleDataListNullableSimpleData(
          List<_i10.SimpleData?> list) =>
      caller.callServerEndpoint<List<_i10.SimpleData?>>(
        'listParameters',
        'returnSimpleDataListNullableSimpleData',
        {'list': list},
      );

  _i2.Future<List<_i10.SimpleData>?> returnSimpleDataListNullable(
          List<_i10.SimpleData>? list) =>
      caller.callServerEndpoint<List<_i10.SimpleData>?>(
        'listParameters',
        'returnSimpleDataListNullable',
        {'list': list},
      );

  _i2.Future<List<_i10.SimpleData?>?>
      returnNullableSimpleDataListNullableSimpleData(
              List<_i10.SimpleData?>? list) =>
          caller.callServerEndpoint<List<_i10.SimpleData?>?>(
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

  _i2.Future<void> slowQueryMethod(int seconds) =>
      caller.callServerEndpoint<void>(
        'logging',
        'slowQueryMethod',
        {'seconds': seconds},
      );

  _i2.Future<void> queryMethod(int queries) => caller.callServerEndpoint<void>(
        'logging',
        'queryMethod',
        {'queries': queries},
      );

  _i2.Future<void> failedQueryMethod() => caller.callServerEndpoint<void>(
        'logging',
        'failedQueryMethod',
        {},
      );

  _i2.Future<void> slowMethod(int delayMillis) =>
      caller.callServerEndpoint<void>(
        'logging',
        'slowMethod',
        {'delayMillis': delayMillis},
      );

  _i2.Future<void> failingMethod() => caller.callServerEndpoint<void>(
        'logging',
        'failingMethod',
        {},
      );

  _i2.Future<void> emptyMethod() => caller.callServerEndpoint<void>(
        'logging',
        'emptyMethod',
        {},
      );

  _i2.Future<void> log(
    String message,
    List<int> logLevels,
  ) =>
      caller.callServerEndpoint<void>(
        'logging',
        'log',
        {
          'message': message,
          'logLevels': logLevels,
        },
      );

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

  _i2.Stream<int> streamEmpty(_i2.Stream<int> input) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'logging',
        'streamEmpty',
        {},
        {'input': input},
      );

  _i2.Stream<int> streamLogging(_i2.Stream<int> input) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'logging',
        'streamLogging',
        {},
        {'input': input},
      );

  _i2.Stream<int> streamQueryLogging(_i2.Stream<int> input) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'logging',
        'streamQueryLogging',
        {},
        {'input': input},
      );

  _i2.Stream<int> streamException() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'logging',
        'streamException',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointStreamLogging extends _i1.EndpointRef {
  EndpointStreamLogging(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'streamLogging';
}

/// {@category Endpoint}
class EndpointStreamQueryLogging extends _i1.EndpointRef {
  EndpointStreamQueryLogging(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'streamQueryLogging';
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

  _i2.Future<Map<String, _i10.SimpleData>> returnSimpleDataMap(
          Map<String, _i10.SimpleData> map) =>
      caller.callServerEndpoint<Map<String, _i10.SimpleData>>(
        'mapParameters',
        'returnSimpleDataMap',
        {'map': map},
      );

  _i2.Future<Map<String, _i10.SimpleData?>>
      returnSimpleDataMapNullableSimpleData(
              Map<String, _i10.SimpleData?> map) =>
          caller.callServerEndpoint<Map<String, _i10.SimpleData?>>(
            'mapParameters',
            'returnSimpleDataMapNullableSimpleData',
            {'map': map},
          );

  _i2.Future<Map<String, _i10.SimpleData>?> returnSimpleDataMapNullable(
          Map<String, _i10.SimpleData>? map) =>
      caller.callServerEndpoint<Map<String, _i10.SimpleData>?>(
        'mapParameters',
        'returnSimpleDataMapNullable',
        {'map': map},
      );

  _i2.Future<Map<String, _i10.SimpleData?>?>
      returnNullableSimpleDataMapNullableSimpleData(
              Map<String, _i10.SimpleData?>? map) =>
          caller.callServerEndpoint<Map<String, _i10.SimpleData?>?>(
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
class EndpointMethodSignaturePermutations extends _i1.EndpointRef {
  EndpointMethodSignaturePermutations(_i1.EndpointCaller caller)
      : super(caller);

  @override
  String get name => 'methodSignaturePermutations';

  _i2.Future<String> echoPositionalArg(String string) =>
      caller.callServerEndpoint<String>(
        'methodSignaturePermutations',
        'echoPositionalArg',
        {'string': string},
      );

  _i2.Future<String> echoNamedArg({required String string}) =>
      caller.callServerEndpoint<String>(
        'methodSignaturePermutations',
        'echoNamedArg',
        {'string': string},
      );

  _i2.Future<String?> echoNullableNamedArg({String? string}) =>
      caller.callServerEndpoint<String?>(
        'methodSignaturePermutations',
        'echoNullableNamedArg',
        {'string': string},
      );

  _i2.Future<String?> echoOptionalArg([String? string]) =>
      caller.callServerEndpoint<String?>(
        'methodSignaturePermutations',
        'echoOptionalArg',
        {'string': string},
      );

  _i2.Future<List<String?>> echoPositionalAndNamedArgs(
    String string1, {
    required String string2,
  }) =>
      caller.callServerEndpoint<List<String?>>(
        'methodSignaturePermutations',
        'echoPositionalAndNamedArgs',
        {
          'string1': string1,
          'string2': string2,
        },
      );

  _i2.Future<List<String?>> echoPositionalAndNullableNamedArgs(
    String string1, {
    String? string2,
  }) =>
      caller.callServerEndpoint<List<String?>>(
        'methodSignaturePermutations',
        'echoPositionalAndNullableNamedArgs',
        {
          'string1': string1,
          'string2': string2,
        },
      );

  _i2.Future<List<String?>> echoPositionalAndOptionalArgs(
    String string1, [
    String? string2,
  ]) =>
      caller.callServerEndpoint<List<String?>>(
        'methodSignaturePermutations',
        'echoPositionalAndOptionalArgs',
        {
          'string1': string1,
          'string2': string2,
        },
      );

  _i2.Stream<String> echoNamedArgStream(
          {required _i2.Stream<String> strings}) =>
      caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
        'methodSignaturePermutations',
        'echoNamedArgStream',
        {},
        {'strings': strings},
      );

  _i2.Future<String> echoNamedArgStreamAsFuture(
          {required _i2.Stream<String> strings}) =>
      caller.callStreamingServerEndpoint<_i2.Future<String>, String>(
        'methodSignaturePermutations',
        'echoNamedArgStreamAsFuture',
        {},
        {'strings': strings},
      );

  _i2.Stream<String> echoPositionalArgStream(_i2.Stream<String> strings) =>
      caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
        'methodSignaturePermutations',
        'echoPositionalArgStream',
        {},
        {'strings': strings},
      );

  _i2.Future<String> echoPositionalArgStreamAsFuture(
          _i2.Stream<String> strings) =>
      caller.callStreamingServerEndpoint<_i2.Future<String>, String>(
        'methodSignaturePermutations',
        'echoPositionalArgStreamAsFuture',
        {},
        {'strings': strings},
      );
}

/// {@category Endpoint}
class EndpointMethodStreaming extends _i1.EndpointRef {
  EndpointMethodStreaming(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'methodStreaming';

  /// Returns a simple stream of integers from 0 to 9.
  _i2.Stream<int> simpleStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'simpleStream',
        {},
        {},
      );

  _i2.Stream<int> neverEndingStreamWithDelay(int millisecondsDelay) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'neverEndingStreamWithDelay',
        {'millisecondsDelay': millisecondsDelay},
        {},
      );

  _i2.Future<void> methodCallEndpoint() => caller.callServerEndpoint<void>(
        'methodStreaming',
        'methodCallEndpoint',
        {},
      );

  _i2.Future<int> intReturnFromStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<int>, int>(
        'methodStreaming',
        'intReturnFromStream',
        {},
        {'stream': stream},
      );

  _i2.Future<int?> nullableIntReturnFromStream(_i2.Stream<int?> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<int?>, int?>(
        'methodStreaming',
        'nullableIntReturnFromStream',
        {},
        {'stream': stream},
      );

  _i2.Stream<int?> getBroadcastStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int?>, int?>(
        'methodStreaming',
        'getBroadcastStream',
        {},
        {},
      );

  _i2.Future<bool> wasBroadcastStreamCanceled() =>
      caller.callServerEndpoint<bool>(
        'methodStreaming',
        'wasBroadcastStreamCanceled',
        {},
      );

  _i2.Future<bool> wasSessionWillCloseListenerCalled() =>
      caller.callServerEndpoint<bool>(
        'methodStreaming',
        'wasSessionWillCloseListenerCalled',
        {},
      );

  _i2.Stream<int> intStreamFromValue(int value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'intStreamFromValue',
        {'value': value},
        {},
      );

  _i2.Stream<int> intEchoStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'intEchoStream',
        {},
        {'stream': stream},
      );

  _i2.Stream<dynamic> dynamicEchoStream(_i2.Stream<dynamic> stream) =>
      caller.callStreamingServerEndpoint<_i2.Stream<dynamic>, dynamic>(
        'methodStreaming',
        'dynamicEchoStream',
        {},
        {'stream': stream},
      );

  _i2.Stream<int?> nullableIntEchoStream(_i2.Stream<int?> stream) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int?>, int?>(
        'methodStreaming',
        'nullableIntEchoStream',
        {},
        {'stream': stream},
      );

  _i2.Future<void> voidReturnAfterStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'voidReturnAfterStream',
        {},
        {'stream': stream},
      );

  _i2.Stream<int> multipleIntEchoStreams(
    _i2.Stream<int> stream1,
    _i2.Stream<int> stream2,
  ) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'multipleIntEchoStreams',
        {},
        {
          'stream1': stream1,
          'stream2': stream2,
        },
      );

  _i2.Future<void> directVoidReturnWithStreamInput(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'directVoidReturnWithStreamInput',
        {},
        {'stream': stream},
      );

  _i2.Future<int> directOneIntReturnWithStreamInput(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<int>, int>(
        'methodStreaming',
        'directOneIntReturnWithStreamInput',
        {},
        {'stream': stream},
      );

  _i2.Future<int> simpleInputReturnStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<int>, int>(
        'methodStreaming',
        'simpleInputReturnStream',
        {},
        {'stream': stream},
      );

  _i2.Stream<int> simpleStreamWithParameter(int value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'simpleStreamWithParameter',
        {'value': value},
        {},
      );

  _i2.Stream<_i10.SimpleData> simpleDataStream(int value) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i10.SimpleData>,
          _i10.SimpleData>(
        'methodStreaming',
        'simpleDataStream',
        {'value': value},
        {},
      );

  _i2.Stream<_i10.SimpleData> simpleInOutDataStream(
          _i2.Stream<_i10.SimpleData> simpleDataStream) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i10.SimpleData>,
          _i10.SimpleData>(
        'methodStreaming',
        'simpleInOutDataStream',
        {},
        {'simpleDataStream': simpleDataStream},
      );

  _i2.Future<void> simpleEndpoint() => caller.callServerEndpoint<void>(
        'methodStreaming',
        'simpleEndpoint',
        {},
      );

  _i2.Future<void> intParameter(int value) => caller.callServerEndpoint<void>(
        'methodStreaming',
        'intParameter',
        {'value': value},
      );

  _i2.Future<int> doubleInputValue(int value) => caller.callServerEndpoint<int>(
        'methodStreaming',
        'doubleInputValue',
        {'value': value},
      );

  /// Delays the response for [delay] seconds.
  ///
  /// Responses can be closed by calling [completeAllDelayedResponses].
  _i2.Future<void> delayedResponse(int delay) =>
      caller.callServerEndpoint<void>(
        'methodStreaming',
        'delayedResponse',
        {'delay': delay},
      );

  _i2.Stream<int> delayedStreamResponse(int delay) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'delayedStreamResponse',
        {'delay': delay},
        {},
      );

  _i2.Future<void> delayedNeverListenedInputStream(
    int delay,
    _i2.Stream<int> stream,
  ) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'delayedNeverListenedInputStream',
        {'delay': delay},
        {'stream': stream},
      );

  _i2.Future<void> delayedPausedInputStream(
    int delay,
    _i2.Stream<int> stream,
  ) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'delayedPausedInputStream',
        {'delay': delay},
        {'stream': stream},
      );

  /// Completes all delayed responses.
  /// This makes the delayedResponse return directly.
  _i2.Future<void> completeAllDelayedResponses() =>
      caller.callServerEndpoint<void>(
        'methodStreaming',
        'completeAllDelayedResponses',
        {},
      );

  _i2.Future<void> inStreamThrowsException(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'inStreamThrowsException',
        {},
        {'stream': stream},
      );

  _i2.Future<void> inStreamThrowsSerializableException(
          _i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'inStreamThrowsSerializableException',
        {},
        {'stream': stream},
      );

  _i2.Stream<int> outStreamThrowsException() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'outStreamThrowsException',
        {},
        {},
      );

  _i2.Stream<int> outStreamThrowsSerializableException() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'outStreamThrowsSerializableException',
        {},
        {},
      );

  _i2.Future<void> throwsExceptionVoid(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'throwsExceptionVoid',
        {},
        {'stream': stream},
      );

  _i2.Future<void> throwsSerializableExceptionVoid(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<void>, void>(
        'methodStreaming',
        'throwsSerializableExceptionVoid',
        {},
        {'stream': stream},
      );

  _i2.Future<int> throwsException(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<int>, int>(
        'methodStreaming',
        'throwsException',
        {},
        {'stream': stream},
      );

  _i2.Future<int> throwsSerializableException(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<int>, int>(
        'methodStreaming',
        'throwsSerializableException',
        {},
        {'stream': stream},
      );

  _i2.Stream<int> throwsExceptionStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'throwsExceptionStream',
        {},
        {},
      );

  _i2.Stream<int> exceptionThrownBeforeStreamReturn() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'exceptionThrownBeforeStreamReturn',
        {},
        {},
      );

  _i2.Stream<int> exceptionThrownInStreamReturn() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'exceptionThrownInStreamReturn',
        {},
        {},
      );

  _i2.Stream<int> throwsSerializableExceptionStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'methodStreaming',
        'throwsSerializableExceptionStream',
        {},
        {},
      );

  _i2.Future<bool> didInputStreamHaveError(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<bool>, bool>(
        'methodStreaming',
        'didInputStreamHaveError',
        {},
        {'stream': stream},
      );

  _i2.Future<bool> didInputStreamHaveSerializableExceptionError(
          _i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Future<bool>, bool>(
        'methodStreaming',
        'didInputStreamHaveSerializableExceptionError',
        {},
        {'stream': stream},
      );
}

/// {@category Endpoint}
class EndpointAuthenticatedMethodStreaming extends _i1.EndpointRef {
  EndpointAuthenticatedMethodStreaming(_i1.EndpointCaller caller)
      : super(caller);

  @override
  String get name => 'authenticatedMethodStreaming';

  _i2.Stream<int> simpleStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'authenticatedMethodStreaming',
        'simpleStream',
        {},
        {},
      );

  _i2.Stream<int> intEchoStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'authenticatedMethodStreaming',
        'intEchoStream',
        {},
        {'stream': stream},
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
    _i10.SimpleData data,
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
    _i10.SimpleData data,
  ) =>
      caller.callServerEndpoint<void>(
        'redis',
        'setSimpleDataWithLifetime',
        {
          'key': key,
          'data': data,
        },
      );

  _i2.Future<_i10.SimpleData?> getSimpleData(String key) =>
      caller.callServerEndpoint<_i10.SimpleData?>(
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

  _i2.Future<_i10.SimpleData?> listenToChannel(String channel) =>
      caller.callServerEndpoint<_i10.SimpleData?>(
        'redis',
        'listenToChannel',
        {'channel': channel},
      );

  _i2.Future<void> postToChannel(
    String channel,
    _i10.SimpleData data,
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
class EndpointServerOnlyScopedFieldModel extends _i1.EndpointRef {
  EndpointServerOnlyScopedFieldModel(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'serverOnlyScopedFieldModel';

  _i2.Future<_i19.ScopeServerOnlyField> getScopeServerOnlyField() =>
      caller.callServerEndpoint<_i19.ScopeServerOnlyField>(
        'serverOnlyScopedFieldModel',
        'getScopeServerOnlyField',
        {},
      );
}

/// {@category Endpoint}
class EndpointServerOnlyScopedFieldChildModel extends _i1.EndpointRef {
  EndpointServerOnlyScopedFieldChildModel(_i1.EndpointCaller caller)
      : super(caller);

  @override
  String get name => 'serverOnlyScopedFieldChildModel';

  _i2.Future<_i20.ScopeServerOnlyFieldChild> getProtocolField() =>
      caller.callServerEndpoint<_i20.ScopeServerOnlyFieldChild>(
        'serverOnlyScopedFieldChildModel',
        'getProtocolField',
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

/// {@category Endpoint}
class EndpointAdminScopeRequired extends _i1.EndpointRef {
  EndpointAdminScopeRequired(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminScopeRequired';

  _i2.Future<bool> testMethod() => caller.callServerEndpoint<bool>(
        'adminScopeRequired',
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

/// {@category Endpoint}
class EndpointTestTools extends _i1.EndpointRef {
  EndpointTestTools(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'testTools';

  _i2.Future<_i5.UuidValue> returnsSessionId() =>
      caller.callServerEndpoint<_i5.UuidValue>(
        'testTools',
        'returnsSessionId',
        {},
      );

  _i2.Future<List<String?>> returnsSessionEndpointAndMethod() =>
      caller.callServerEndpoint<List<String?>>(
        'testTools',
        'returnsSessionEndpointAndMethod',
        {},
      );

  _i2.Stream<_i5.UuidValue> returnsSessionIdFromStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i5.UuidValue>,
          _i5.UuidValue>(
        'testTools',
        'returnsSessionIdFromStream',
        {},
        {},
      );

  _i2.Stream<String?> returnsSessionEndpointAndMethodFromStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<String?>, String?>(
        'testTools',
        'returnsSessionEndpointAndMethodFromStream',
        {},
        {},
      );

  _i2.Future<String> returnsString(String string) =>
      caller.callServerEndpoint<String>(
        'testTools',
        'returnsString',
        {'string': string},
      );

  _i2.Stream<int> returnsStream(int n) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'testTools',
        'returnsStream',
        {'n': n},
        {},
      );

  _i2.Future<List<int>> returnsListFromInputStream(_i2.Stream<int> numbers) =>
      caller.callStreamingServerEndpoint<_i2.Future<List<int>>, List<int>>(
        'testTools',
        'returnsListFromInputStream',
        {},
        {'numbers': numbers},
      );

  _i2.Future<List<_i10.SimpleData>> returnsSimpleDataListFromInputStream(
          _i2.Stream<_i10.SimpleData> simpleDatas) =>
      caller.callStreamingServerEndpoint<_i2.Future<List<_i10.SimpleData>>,
          List<_i10.SimpleData>>(
        'testTools',
        'returnsSimpleDataListFromInputStream',
        {},
        {'simpleDatas': simpleDatas},
      );

  _i2.Stream<int> returnsStreamFromInputStream(_i2.Stream<int> numbers) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'testTools',
        'returnsStreamFromInputStream',
        {},
        {'numbers': numbers},
      );

  _i2.Stream<_i10.SimpleData> returnsSimpleDataStreamFromInputStream(
          _i2.Stream<_i10.SimpleData> simpleDatas) =>
      caller.callStreamingServerEndpoint<_i2.Stream<_i10.SimpleData>,
          _i10.SimpleData>(
        'testTools',
        'returnsSimpleDataStreamFromInputStream',
        {},
        {'simpleDatas': simpleDatas},
      );

  _i2.Future<void> postNumberToSharedStream(int number) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'postNumberToSharedStream',
        {'number': number},
      );

  _i2.Stream<int> postNumberToSharedStreamAndReturnStream(int number) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'testTools',
        'postNumberToSharedStreamAndReturnStream',
        {'number': number},
        {},
      );

  _i2.Stream<int> listenForNumbersOnSharedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'testTools',
        'listenForNumbersOnSharedStream',
        {},
        {},
      );

  _i2.Future<void> createSimpleData(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleData',
        {'data': data},
      );

  _i2.Future<List<_i10.SimpleData>> getAllSimpleData() =>
      caller.callServerEndpoint<List<_i10.SimpleData>>(
        'testTools',
        'getAllSimpleData',
        {},
      );

  _i2.Future<void> createSimpleDatasInsideTransactions(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInsideTransactions',
        {'data': data},
      );

  _i2.Future<void> createSimpleDataAndThrowInsideTransaction(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDataAndThrowInsideTransaction',
        {'data': data},
      );

  _i2.Future<void> createSimpleDatasInParallelTransactionCalls() =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInParallelTransactionCalls',
        {},
      );

  _i2.Future<_i10.SimpleData> echoSimpleData(_i10.SimpleData simpleData) =>
      caller.callServerEndpoint<_i10.SimpleData>(
        'testTools',
        'echoSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<List<_i10.SimpleData>> echoSimpleDatas(
          List<_i10.SimpleData> simpleDatas) =>
      caller.callServerEndpoint<List<_i10.SimpleData>>(
        'testTools',
        'echoSimpleDatas',
        {'simpleDatas': simpleDatas},
      );

  _i2.Future<void> logMessageWithSession() => caller.callServerEndpoint<void>(
        'testTools',
        'logMessageWithSession',
        {},
      );

  _i2.Future<void> addWillCloseListenerToSessionAndThrow() =>
      caller.callServerEndpoint<void>(
        'testTools',
        'addWillCloseListenerToSessionAndThrow',
        {},
      );

  _i2.Stream<int> addWillCloseListenerToSessionIntStreamMethodAndThrow() =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'testTools',
        'addWillCloseListenerToSessionIntStreamMethodAndThrow',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointAuthenticatedTestTools extends _i1.EndpointRef {
  EndpointAuthenticatedTestTools(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authenticatedTestTools';

  _i2.Future<String> returnsString(String string) =>
      caller.callServerEndpoint<String>(
        'authenticatedTestTools',
        'returnsString',
        {'string': string},
      );

  _i2.Stream<int> returnsStream(int n) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'authenticatedTestTools',
        'returnsStream',
        {'n': n},
        {},
      );

  _i2.Future<List<int>> returnsListFromInputStream(_i2.Stream<int> numbers) =>
      caller.callStreamingServerEndpoint<_i2.Future<List<int>>, List<int>>(
        'authenticatedTestTools',
        'returnsListFromInputStream',
        {},
        {'numbers': numbers},
      );

  _i2.Stream<int> intEchoStream(_i2.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_i2.Stream<int>, int>(
        'authenticatedTestTools',
        'intEchoStream',
        {},
        {'stream': stream},
      );
}

/// {@category Endpoint}
class EndpointMyFeature extends _i1.EndpointRef {
  EndpointMyFeature(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myFeature';

  _i2.Future<String> myFeatureMethod() => caller.callServerEndpoint<String>(
        'myFeature',
        'myFeatureMethod',
        {},
      );

  _i2.Future<_i21.MyFeatureModel> myFeatureModel() =>
      caller.callServerEndpoint<_i21.MyFeatureModel>(
        'myFeature',
        'myFeatureModel',
        {},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i3.Caller(client);
    module = _i17.Caller(client);
  }

  late final _i3.Caller auth;

  late final _i17.Caller module;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i22.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    asyncTasks = EndpointAsyncTasks(this);
    authentication = EndpointAuthentication(this);
    basicTypes = EndpointBasicTypes(this);
    basicTypesStreaming = EndpointBasicTypesStreaming(this);
    cloudStorage = EndpointCloudStorage(this);
    s3CloudStorage = EndpointS3CloudStorage(this);
    customClassProtocol = EndpointCustomClassProtocol(this);
    customTypes = EndpointCustomTypes(this);
    basicDatabase = EndpointBasicDatabase(this);
    transactionsDatabase = EndpointTransactionsDatabase(this);
    deprecation = EndpointDeprecation(this);
    echoRequest = EndpointEchoRequest(this);
    emailAuthTestMethods = EndpointEmailAuthTestMethods(this);
    exceptionTest = EndpointExceptionTest(this);
    failedCalls = EndpointFailedCalls(this);
    fieldScopes = EndpointFieldScopes(this);
    futureCalls = EndpointFutureCalls(this);
    listParameters = EndpointListParameters(this);
    logging = EndpointLogging(this);
    streamLogging = EndpointStreamLogging(this);
    streamQueryLogging = EndpointStreamQueryLogging(this);
    loggingDisabled = EndpointLoggingDisabled(this);
    mapParameters = EndpointMapParameters(this);
    methodSignaturePermutations = EndpointMethodSignaturePermutations(this);
    methodStreaming = EndpointMethodStreaming(this);
    authenticatedMethodStreaming = EndpointAuthenticatedMethodStreaming(this);
    moduleSerialization = EndpointModuleSerialization(this);
    namedParameters = EndpointNamedParameters(this);
    optionalParameters = EndpointOptionalParameters(this);
    redis = EndpointRedis(this);
    serverOnlyScopedFieldModel = EndpointServerOnlyScopedFieldModel(this);
    serverOnlyScopedFieldChildModel =
        EndpointServerOnlyScopedFieldChildModel(this);
    signInRequired = EndpointSignInRequired(this);
    adminScopeRequired = EndpointAdminScopeRequired(this);
    simple = EndpointSimple(this);
    streaming = EndpointStreaming(this);
    streamingLogging = EndpointStreamingLogging(this);
    subSubDirTest = EndpointSubSubDirTest(this);
    subDirTest = EndpointSubDirTest(this);
    testTools = EndpointTestTools(this);
    authenticatedTestTools = EndpointAuthenticatedTestTools(this);
    myFeature = EndpointMyFeature(this);
    modules = Modules(this);
  }

  late final EndpointAsyncTasks asyncTasks;

  late final EndpointAuthentication authentication;

  late final EndpointBasicTypes basicTypes;

  late final EndpointBasicTypesStreaming basicTypesStreaming;

  late final EndpointCloudStorage cloudStorage;

  late final EndpointS3CloudStorage s3CloudStorage;

  late final EndpointCustomClassProtocol customClassProtocol;

  late final EndpointCustomTypes customTypes;

  late final EndpointBasicDatabase basicDatabase;

  late final EndpointTransactionsDatabase transactionsDatabase;

  late final EndpointDeprecation deprecation;

  late final EndpointEchoRequest echoRequest;

  late final EndpointEmailAuthTestMethods emailAuthTestMethods;

  late final EndpointExceptionTest exceptionTest;

  late final EndpointFailedCalls failedCalls;

  late final EndpointFieldScopes fieldScopes;

  late final EndpointFutureCalls futureCalls;

  late final EndpointListParameters listParameters;

  late final EndpointLogging logging;

  late final EndpointStreamLogging streamLogging;

  late final EndpointStreamQueryLogging streamQueryLogging;

  late final EndpointLoggingDisabled loggingDisabled;

  late final EndpointMapParameters mapParameters;

  late final EndpointMethodSignaturePermutations methodSignaturePermutations;

  late final EndpointMethodStreaming methodStreaming;

  late final EndpointAuthenticatedMethodStreaming authenticatedMethodStreaming;

  late final EndpointModuleSerialization moduleSerialization;

  late final EndpointNamedParameters namedParameters;

  late final EndpointOptionalParameters optionalParameters;

  late final EndpointRedis redis;

  late final EndpointServerOnlyScopedFieldModel serverOnlyScopedFieldModel;

  late final EndpointServerOnlyScopedFieldChildModel
      serverOnlyScopedFieldChildModel;

  late final EndpointSignInRequired signInRequired;

  late final EndpointAdminScopeRequired adminScopeRequired;

  late final EndpointSimple simple;

  late final EndpointStreaming streaming;

  late final EndpointStreamingLogging streamingLogging;

  late final EndpointSubSubDirTest subSubDirTest;

  late final EndpointSubDirTest subDirTest;

  late final EndpointTestTools testTools;

  late final EndpointAuthenticatedTestTools authenticatedTestTools;

  late final EndpointMyFeature myFeature;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'asyncTasks': asyncTasks,
        'authentication': authentication,
        'basicTypes': basicTypes,
        'basicTypesStreaming': basicTypesStreaming,
        'cloudStorage': cloudStorage,
        's3CloudStorage': s3CloudStorage,
        'customClassProtocol': customClassProtocol,
        'customTypes': customTypes,
        'basicDatabase': basicDatabase,
        'transactionsDatabase': transactionsDatabase,
        'deprecation': deprecation,
        'echoRequest': echoRequest,
        'emailAuthTestMethods': emailAuthTestMethods,
        'exceptionTest': exceptionTest,
        'failedCalls': failedCalls,
        'fieldScopes': fieldScopes,
        'futureCalls': futureCalls,
        'listParameters': listParameters,
        'logging': logging,
        'streamLogging': streamLogging,
        'streamQueryLogging': streamQueryLogging,
        'loggingDisabled': loggingDisabled,
        'mapParameters': mapParameters,
        'methodSignaturePermutations': methodSignaturePermutations,
        'methodStreaming': methodStreaming,
        'authenticatedMethodStreaming': authenticatedMethodStreaming,
        'moduleSerialization': moduleSerialization,
        'namedParameters': namedParameters,
        'optionalParameters': optionalParameters,
        'redis': redis,
        'serverOnlyScopedFieldModel': serverOnlyScopedFieldModel,
        'serverOnlyScopedFieldChildModel': serverOnlyScopedFieldChildModel,
        'signInRequired': signInRequired,
        'adminScopeRequired': adminScopeRequired,
        'simple': simple,
        'streaming': streaming,
        'streamingLogging': streamingLogging,
        'subSubDirTest': subSubDirTest,
        'subDirTest': subDirTest,
        'testTools': testTools,
        'authenticatedTestTools': authenticatedTestTools,
        'myFeature': myFeature,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
        'auth': modules.auth,
        'module': modules.module,
      };
}
