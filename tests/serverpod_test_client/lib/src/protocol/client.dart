/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i312scxx;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/container.dart'
    as _ij4seqzx;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/container_module.dart'
    as _ijjdovst;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/parent.dart'
    as _itefpq8v;
import 'package:serverpod_test_client/src/protocol/module_datatype.dart'
    as _igh53y2y;
import 'package:serverpod_test_client/src/protocol/my_feature/models/my_feature_model.dart'
    as _ismcc0ff;
import 'package:serverpod_test_client/src/protocol/object_field_scopes.dart'
    as _i1ck89ud;
import 'package:serverpod_test_client/src/protocol/object_with_dynamic.dart'
    as _ia1iglq9;
import 'package:serverpod_test_client/src/protocol/object_with_enum.dart'
    as _i3hki8pv;
import 'package:serverpod_test_client/src/protocol/object_with_enum_enhanced.dart'
    as _ix5jj06m;
import 'package:serverpod_test_client/src/protocol/object_with_object.dart'
    as _iz3ku4m0;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'package:serverpod_test_client/src/protocol/required/model_with_required_field.dart'
    as _i6e6wv43;
import 'package:serverpod_test_client/src/protocol/scopes/scope_server_only_field.dart'
    as _igbepoe4;
import 'package:serverpod_test_client/src/protocol/scopes/scope_server_only_field_child.dart'
    as _ie2anuek;
import 'package:serverpod_test_client/src/protocol/session_auth_info.dart'
    as _iqsl8fox;
import 'package:serverpod_test_client/src/protocol/simple_data.dart'
    as _i68e2f8e;
import 'package:serverpod_test_client/src/protocol/simple_data_list.dart'
    as _ijf5utg1;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _ih5exyov;
import 'package:serverpod_test_client/src/protocol/types.dart' as _izst1ldh;
import 'package:serverpod_test_client/src/protocol/types_record.dart'
    as _iiuaejha;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i89s5423;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
import 'package:serverpod_test_shared_module_client/serverpod_test_shared_module_client.dart'
    as _iyerxm0e;
import 'protocol.dart' as _il2as5qe;

/// {@category Endpoint}
class EndpointAsyncTasks extends _isc.EndpointRef {
  EndpointAsyncTasks(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'asyncTasks';

  _ida.Future<void> insertRowToSimpleDataAfterDelay(
    int num,
    int seconds,
  ) => caller.callServerEndpoint<void>(
    'asyncTasks',
    'insertRowToSimpleDataAfterDelay',
    {
      'num': num,
      'seconds': seconds,
    },
  );

  _ida.Future<void> throwExceptionAfterDelay(int seconds) =>
      caller.callServerEndpoint<void>(
        'asyncTasks',
        'throwExceptionAfterDelay',
        {'seconds': seconds},
      );
}

/// {@category Endpoint}
class EndpointAuthentication extends _isc.EndpointRef {
  EndpointAuthentication(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authentication';

  _ida.Future<void> removeAllUsers() => caller.callServerEndpoint<void>(
    'authentication',
    'removeAllUsers',
    {},
  );

  _ida.Future<int> countUsers() => caller.callServerEndpoint<int>(
    'authentication',
    'countUsers',
    {},
  );

  _ida.Future<void> createUser(
    String email,
    String password,
  ) => caller.callServerEndpoint<void>(
    'authentication',
    'createUser',
    {
      'email': email,
      'password': password,
    },
  );

  _ida.Future<_i312scxx.AuthenticationResponse> authenticate(
    String email,
    String password, [
    List<String>? scopes,
  ]) => caller.callServerEndpoint<_i312scxx.AuthenticationResponse>(
    'authentication',
    'authenticate',
    {
      'email': email,
      'password': password,
      'scopes': scopes,
    },
  );

  _ida.Future<void> signOut() => caller.callServerEndpoint<void>(
    'authentication',
    'signOut',
    {},
  );

  _ida.Future<void> updateScopes(
    int userId,
    List<String> scopes,
  ) => caller.callServerEndpoint<void>(
    'authentication',
    'updateScopes',
    {
      'userId': userId,
      'scopes': scopes,
    },
  );
}

/// {@category Endpoint}
class EndpointBasicTypes extends _isc.EndpointRef {
  EndpointBasicTypes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicTypes';

  _ida.Future<int?> testInt(int? value) => caller.callServerEndpoint<int?>(
    'basicTypes',
    'testInt',
    {'value': value},
  );

  _ida.Future<double?> testDouble(double? value) =>
      caller.callServerEndpoint<double?>(
        'basicTypes',
        'testDouble',
        {'value': value},
      );

  _ida.Future<bool?> testBool(bool? value) => caller.callServerEndpoint<bool?>(
    'basicTypes',
    'testBool',
    {'value': value},
  );

  _ida.Future<DateTime?> testDateTime(DateTime? dateTime) =>
      caller.callServerEndpoint<DateTime?>(
        'basicTypes',
        'testDateTime',
        {'dateTime': dateTime},
      );

  _ida.Future<String?> testString(String? value) =>
      caller.callServerEndpoint<String?>(
        'basicTypes',
        'testString',
        {'value': value},
      );

  _ida.Future<_idt.ByteData?> testByteData(_idt.ByteData? value) =>
      caller.callServerEndpoint<_idt.ByteData?>(
        'basicTypes',
        'testByteData',
        {'value': value},
      );

  _ida.Future<Duration?> testDuration(Duration? value) =>
      caller.callServerEndpoint<Duration?>(
        'basicTypes',
        'testDuration',
        {'value': value},
      );

  _ida.Future<_isc.UuidValue?> testUuid(_isc.UuidValue? value) =>
      caller.callServerEndpoint<_isc.UuidValue?>(
        'basicTypes',
        'testUuid',
        {'value': value},
      );

  _ida.Future<Uri?> testUri(Uri? value) => caller.callServerEndpoint<Uri?>(
    'basicTypes',
    'testUri',
    {'value': value},
  );

  _ida.Future<BigInt?> testBigInt(BigInt? value) =>
      caller.callServerEndpoint<BigInt?>(
        'basicTypes',
        'testBigInt',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointBasicTypesStreaming extends _isc.EndpointRef {
  EndpointBasicTypesStreaming(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicTypesStreaming';

  _ida.Stream<int?> testInt(_ida.Stream<int?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int?>, int?>(
        'basicTypesStreaming',
        'testInt',
        {},
        {'value': value},
      );

  _ida.Stream<double?> testDouble(_ida.Stream<double?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<double?>, double?>(
        'basicTypesStreaming',
        'testDouble',
        {},
        {'value': value},
      );

  _ida.Stream<bool?> testBool(_ida.Stream<bool?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool?>, bool?>(
        'basicTypesStreaming',
        'testBool',
        {},
        {'value': value},
      );

  _ida.Stream<DateTime?> testDateTime(_ida.Stream<DateTime?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<DateTime?>, DateTime?>(
        'basicTypesStreaming',
        'testDateTime',
        {},
        {'value': value},
      );

  _ida.Stream<String?> testString(_ida.Stream<String?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<String?>, String?>(
        'basicTypesStreaming',
        'testString',
        {},
        {'value': value},
      );

  _ida.Stream<_idt.ByteData?> testByteData(
    _ida.Stream<_idt.ByteData?> value,
  ) => caller
      .callStreamingServerEndpoint<_ida.Stream<_idt.ByteData?>, _idt.ByteData?>(
        'basicTypesStreaming',
        'testByteData',
        {},
        {'value': value},
      );

  _ida.Stream<Duration?> testDuration(_ida.Stream<Duration?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<Duration?>, Duration?>(
        'basicTypesStreaming',
        'testDuration',
        {},
        {'value': value},
      );

  _ida.Stream<_isc.UuidValue?> testUuid(_ida.Stream<_isc.UuidValue?> value) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_isc.UuidValue?>,
        _isc.UuidValue?
      >(
        'basicTypesStreaming',
        'testUuid',
        {},
        {'value': value},
      );

  _ida.Stream<Uri?> testUri(_ida.Stream<Uri?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<Uri?>, Uri?>(
        'basicTypesStreaming',
        'testUri',
        {},
        {'value': value},
      );

  _ida.Stream<BigInt?> testBigInt(_ida.Stream<BigInt?> value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<BigInt?>, BigInt?>(
        'basicTypesStreaming',
        'testBigInt',
        {},
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointCloudStorage extends _isc.EndpointRef {
  EndpointCloudStorage(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cloudStorage';

  _ida.Future<void> reset() => caller.callServerEndpoint<void>(
    'cloudStorage',
    'reset',
    {},
  );

  _ida.Future<void> storePublicFile(
    String path,
    _idt.ByteData byteData,
  ) => caller.callServerEndpoint<void>(
    'cloudStorage',
    'storePublicFile',
    {
      'path': path,
      'byteData': byteData,
    },
  );

  _ida.Future<_idt.ByteData> retrievePublicFile(String path) =>
      caller.callServerEndpoint<_idt.ByteData>(
        'cloudStorage',
        'retrievePublicFile',
        {'path': path},
      );

  _ida.Future<bool> existsPublicFile(String path) =>
      caller.callServerEndpoint<bool>(
        'cloudStorage',
        'existsPublicFile',
        {'path': path},
      );

  _ida.Future<void> deletePublicFile(String path) =>
      caller.callServerEndpoint<void>(
        'cloudStorage',
        'deletePublicFile',
        {'path': path},
      );

  _ida.Future<String> publicDownloadUrlForFile(String path) =>
      caller.callServerEndpoint<String>(
        'cloudStorage',
        'publicDownloadUrlForFile',
        {'path': path},
      );

  _ida.Future<String> temporaryDownloadUrlForFile(String path) =>
      caller.callServerEndpoint<String>(
        'cloudStorage',
        'temporaryDownloadUrlForFile',
        {'path': path},
      );

  _ida.Future<String> createUploadDescriptionForFile(String path) =>
      caller.callServerEndpoint<String>(
        'cloudStorage',
        'createUploadDescriptionForFile',
        {'path': path},
      );

  _ida.Future<bool> verifyUpload(String path) =>
      caller.callServerEndpoint<bool>(
        'cloudStorage',
        'verifyUpload',
        {'path': path},
      );
}

/// {@category Endpoint}
class EndpointS3CloudStorage extends _isc.EndpointRef {
  EndpointS3CloudStorage(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 's3CloudStorage';

  _ida.Future<void> storePublicFile(
    String path,
    _idt.ByteData byteData,
  ) => caller.callServerEndpoint<void>(
    's3CloudStorage',
    'storePublicFile',
    {
      'path': path,
      'byteData': byteData,
    },
  );

  _ida.Future<_idt.ByteData> retrievePublicFile(String path) =>
      caller.callServerEndpoint<_idt.ByteData>(
        's3CloudStorage',
        'retrievePublicFile',
        {'path': path},
      );

  _ida.Future<bool> existsPublicFile(String path) =>
      caller.callServerEndpoint<bool>(
        's3CloudStorage',
        'existsPublicFile',
        {'path': path},
      );

  _ida.Future<void> deletePublicFile(String path) =>
      caller.callServerEndpoint<void>(
        's3CloudStorage',
        'deletePublicFile',
        {'path': path},
      );

  _ida.Future<String> publicDownloadUrlForFile(String path) =>
      caller.callServerEndpoint<String>(
        's3CloudStorage',
        'publicDownloadUrlForFile',
        {'path': path},
      );

  _ida.Future<String> createUploadDescriptionForFile(String path) =>
      caller.callServerEndpoint<String>(
        's3CloudStorage',
        'createUploadDescriptionForFile',
        {'path': path},
      );

  _ida.Future<bool> verifyUpload(String path) =>
      caller.callServerEndpoint<bool>(
        's3CloudStorage',
        'verifyUpload',
        {'path': path},
      );
}

/// {@category Endpoint}
class EndpointCustomClassProtocol extends _isc.EndpointRef {
  EndpointCustomClassProtocol(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customClassProtocol';

  _ida.Future<_ilwf0zl1.ProtocolCustomClass> getProtocolField() =>
      caller.callServerEndpoint<_ilwf0zl1.ProtocolCustomClass>(
        'customClassProtocol',
        'getProtocolField',
        {},
      );
}

/// {@category Endpoint}
class EndpointCustomTypes extends _isc.EndpointRef {
  EndpointCustomTypes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customTypes';

  _ida.Future<_ilwf0zl1.CustomClass> returnCustomClass(
    _ilwf0zl1.CustomClass data,
  ) => caller.callServerEndpoint<_ilwf0zl1.CustomClass>(
    'customTypes',
    'returnCustomClass',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.CustomClass?> returnCustomClassNullable(
    _ilwf0zl1.CustomClass? data,
  ) => caller.callServerEndpoint<_ilwf0zl1.CustomClass?>(
    'customTypes',
    'returnCustomClassNullable',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.CustomClass2> returnCustomClass2(
    _ilwf0zl1.CustomClass2 data,
  ) => caller.callServerEndpoint<_ilwf0zl1.CustomClass2>(
    'customTypes',
    'returnCustomClass2',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.CustomClass2?> returnCustomClass2Nullable(
    _ilwf0zl1.CustomClass2? data,
  ) => caller.callServerEndpoint<_ilwf0zl1.CustomClass2?>(
    'customTypes',
    'returnCustomClass2Nullable',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.ExternalCustomClass> returnExternalCustomClass(
    _ilwf0zl1.ExternalCustomClass data,
  ) => caller.callServerEndpoint<_ilwf0zl1.ExternalCustomClass>(
    'customTypes',
    'returnExternalCustomClass',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.ExternalCustomClass?> returnExternalCustomClassNullable(
    _ilwf0zl1.ExternalCustomClass? data,
  ) => caller.callServerEndpoint<_ilwf0zl1.ExternalCustomClass?>(
    'customTypes',
    'returnExternalCustomClassNullable',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.FreezedCustomClass> returnFreezedCustomClass(
    _ilwf0zl1.FreezedCustomClass data,
  ) => caller.callServerEndpoint<_ilwf0zl1.FreezedCustomClass>(
    'customTypes',
    'returnFreezedCustomClass',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.FreezedCustomClass?> returnFreezedCustomClassNullable(
    _ilwf0zl1.FreezedCustomClass? data,
  ) => caller.callServerEndpoint<_ilwf0zl1.FreezedCustomClass?>(
    'customTypes',
    'returnFreezedCustomClassNullable',
    {'data': data},
  );

  _ida.Future<_ilwf0zl1.CustomClassWithoutProtocolSerialization>
  returnCustomClassWithoutProtocolSerialization(
    _ilwf0zl1.CustomClassWithoutProtocolSerialization data,
  ) => caller
      .callServerEndpoint<_ilwf0zl1.CustomClassWithoutProtocolSerialization>(
        'customTypes',
        'returnCustomClassWithoutProtocolSerialization',
        {'data': data},
      );

  _ida.Future<_ilwf0zl1.CustomClassWithProtocolSerialization>
  returnCustomClassWithProtocolSerialization(
    _ilwf0zl1.CustomClassWithProtocolSerialization data,
  ) =>
      caller.callServerEndpoint<_ilwf0zl1.CustomClassWithProtocolSerialization>(
        'customTypes',
        'returnCustomClassWithProtocolSerialization',
        {'data': data},
      );

  _ida.Future<_ilwf0zl1.CustomClassWithProtocolSerializationMethod>
  returnCustomClassWithProtocolSerializationMethod(
    _ilwf0zl1.CustomClassWithProtocolSerializationMethod data,
  ) => caller
      .callServerEndpoint<_ilwf0zl1.CustomClassWithProtocolSerializationMethod>(
        'customTypes',
        'returnCustomClassWithProtocolSerializationMethod',
        {'data': data},
      );
}

/// {@category Endpoint}
class EndpointBasicDatabase extends _isc.EndpointRef {
  EndpointBasicDatabase(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'basicDatabase';

  _ida.Future<void> deleteAllSimpleTestData() =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'deleteAllSimpleTestData',
        {},
      );

  _ida.Future<void> deleteSimpleTestDataLessThan(int num) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'deleteSimpleTestDataLessThan',
        {'num': num},
      );

  _ida.Future<void> findAndDeleteSimpleTestData(int num) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'findAndDeleteSimpleTestData',
        {'num': num},
      );

  _ida.Future<void> createSimpleTestData(int numRows) =>
      caller.callServerEndpoint<void>(
        'basicDatabase',
        'createSimpleTestData',
        {'numRows': numRows},
      );

  _ida.Future<List<_i68e2f8e.SimpleData>> findSimpleData({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i68e2f8e.SimpleData>>(
    'basicDatabase',
    'findSimpleData',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  _ida.Future<_i68e2f8e.SimpleData?> findFirstRowSimpleData(int num) =>
      caller.callServerEndpoint<_i68e2f8e.SimpleData?>(
        'basicDatabase',
        'findFirstRowSimpleData',
        {'num': num},
      );

  _ida.Future<_i68e2f8e.SimpleData?> findByIdSimpleData(int id) =>
      caller.callServerEndpoint<_i68e2f8e.SimpleData?>(
        'basicDatabase',
        'findByIdSimpleData',
        {'id': id},
      );

  _ida.Future<_ijf5utg1.SimpleDataList?> findSimpleDataRowsLessThan(
    int num,
    int offset,
    int limit,
    bool descending,
  ) => caller.callServerEndpoint<_ijf5utg1.SimpleDataList?>(
    'basicDatabase',
    'findSimpleDataRowsLessThan',
    {
      'num': num,
      'offset': offset,
      'limit': limit,
      'descending': descending,
    },
  );

  _ida.Future<_i68e2f8e.SimpleData> insertRowSimpleData(
    _i68e2f8e.SimpleData simpleData,
  ) => caller.callServerEndpoint<_i68e2f8e.SimpleData>(
    'basicDatabase',
    'insertRowSimpleData',
    {'simpleData': simpleData},
  );

  _ida.Future<_i68e2f8e.SimpleData> updateRowSimpleData(
    _i68e2f8e.SimpleData simpleData,
  ) => caller.callServerEndpoint<_i68e2f8e.SimpleData>(
    'basicDatabase',
    'updateRowSimpleData',
    {'simpleData': simpleData},
  );

  _ida.Future<int> deleteRowSimpleData(_i68e2f8e.SimpleData simpleData) =>
      caller.callServerEndpoint<int>(
        'basicDatabase',
        'deleteRowSimpleData',
        {'simpleData': simpleData},
      );

  _ida.Future<List<int>> deleteWhereSimpleData() =>
      caller.callServerEndpoint<List<int>>(
        'basicDatabase',
        'deleteWhereSimpleData',
        {},
      );

  _ida.Future<int> countSimpleData() => caller.callServerEndpoint<int>(
    'basicDatabase',
    'countSimpleData',
    {},
  );

  _ida.Future<_izst1ldh.Types> insertTypes(_izst1ldh.Types value) =>
      caller.callServerEndpoint<_izst1ldh.Types>(
        'basicDatabase',
        'insertTypes',
        {'value': value},
      );

  _ida.Future<_izst1ldh.Types> updateTypes(_izst1ldh.Types value) =>
      caller.callServerEndpoint<_izst1ldh.Types>(
        'basicDatabase',
        'updateTypes',
        {'value': value},
      );

  _ida.Future<int?> countTypesRows() => caller.callServerEndpoint<int?>(
    'basicDatabase',
    'countTypesRows',
    {},
  );

  _ida.Future<List<int>> deleteAllInTypes() =>
      caller.callServerEndpoint<List<int>>(
        'basicDatabase',
        'deleteAllInTypes',
        {},
      );

  _ida.Future<_izst1ldh.Types?> getTypes(int id) =>
      caller.callServerEndpoint<_izst1ldh.Types?>(
        'basicDatabase',
        'getTypes',
        {'id': id},
      );

  _ida.Future<int?> getTypesRawQuery(int id) => caller.callServerEndpoint<int?>(
    'basicDatabase',
    'getTypesRawQuery',
    {'id': id},
  );

  _ida.Future<_i3hki8pv.ObjectWithEnum> storeObjectWithEnum(
    _i3hki8pv.ObjectWithEnum object,
  ) => caller.callServerEndpoint<_i3hki8pv.ObjectWithEnum>(
    'basicDatabase',
    'storeObjectWithEnum',
    {'object': object},
  );

  _ida.Future<_i3hki8pv.ObjectWithEnum?> getObjectWithEnum(int id) =>
      caller.callServerEndpoint<_i3hki8pv.ObjectWithEnum?>(
        'basicDatabase',
        'getObjectWithEnum',
        {'id': id},
      );

  _ida.Future<_ix5jj06m.ObjectWithEnumEnhanced> storeObjectWithEnumEnhanced(
    _ix5jj06m.ObjectWithEnumEnhanced object,
  ) => caller.callServerEndpoint<_ix5jj06m.ObjectWithEnumEnhanced>(
    'basicDatabase',
    'storeObjectWithEnumEnhanced',
    {'object': object},
  );

  _ida.Future<_ix5jj06m.ObjectWithEnumEnhanced?> getObjectWithEnumEnhanced(
    int id,
  ) => caller.callServerEndpoint<_ix5jj06m.ObjectWithEnumEnhanced?>(
    'basicDatabase',
    'getObjectWithEnumEnhanced',
    {'id': id},
  );

  _ida.Future<_iz3ku4m0.ObjectWithObject> storeObjectWithObject(
    _iz3ku4m0.ObjectWithObject object,
  ) => caller.callServerEndpoint<_iz3ku4m0.ObjectWithObject>(
    'basicDatabase',
    'storeObjectWithObject',
    {'object': object},
  );

  _ida.Future<_iz3ku4m0.ObjectWithObject?> getObjectWithObject(int id) =>
      caller.callServerEndpoint<_iz3ku4m0.ObjectWithObject?>(
        'basicDatabase',
        'getObjectWithObject',
        {'id': id},
      );

  _ida.Future<int> deleteAll() => caller.callServerEndpoint<int>(
    'basicDatabase',
    'deleteAll',
    {},
  );

  _ida.Future<bool> testByteDataStore() => caller.callServerEndpoint<bool>(
    'basicDatabase',
    'testByteDataStore',
    {},
  );
}

/// {@category Endpoint}
class EndpointTransactionsDatabase extends _isc.EndpointRef {
  EndpointTransactionsDatabase(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'transactionsDatabase';

  _ida.Future<void> removeRow(int num) => caller.callServerEndpoint<void>(
    'transactionsDatabase',
    'removeRow',
    {'num': num},
  );

  _ida.Future<bool> updateInsertDelete(
    int numUpdate,
    int numInsert,
    int numDelete,
  ) => caller.callServerEndpoint<bool>(
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
class EndpointDeprecation extends _isc.EndpointRef {
  EndpointDeprecation(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'deprecation';

  /// A method with a simple "@deprecated" annotation.
  @deprecated
  _ida.Future<void> setGlobalDouble(double? value) =>
      caller.callServerEndpoint<void>(
        'deprecation',
        'setGlobalDouble',
        {'value': value},
      );

  /// A method with a "@Deprecated(..)" annotation.
  @Deprecated('Marking endpoint method as deprecated')
  _ida.Future<double> getGlobalDouble() => caller.callServerEndpoint<double>(
    'deprecation',
    'getGlobalDouble',
    {},
  );

  /// A method with a deprecated parameter using "@deprecated" annotation.
  _ida.Future<String> methodWithDeprecatedParam(
    @deprecated String deprecatedParam,
  ) => caller.callServerEndpoint<String>(
    'deprecation',
    'methodWithDeprecatedParam',
    {'deprecatedParam': deprecatedParam},
  );

  /// A method with a deprecated parameter using "@Deprecated(..)" annotation.
  _ida.Future<String> methodWithDeprecatedParamMessage(
    @Deprecated('This parameter is deprecated') String deprecatedParam,
  ) => caller.callServerEndpoint<String>(
    'deprecation',
    'methodWithDeprecatedParamMessage',
    {'deprecatedParam': deprecatedParam},
  );

  /// A method with both deprecated and non-deprecated parameters.
  _ida.Future<String> methodWithMixedParams(
    String normalParam,
    @deprecated String deprecatedParam,
  ) => caller.callServerEndpoint<String>(
    'deprecation',
    'methodWithMixedParams',
    {
      'normalParam': normalParam,
      'deprecatedParam': deprecatedParam,
    },
  );

  /// A method with deprecated optional positional parameter.
  _ida.Future<String> methodWithOptionalDeprecatedParam([
    @deprecated String? deprecatedParam,
  ]) => caller.callServerEndpoint<String>(
    'deprecation',
    'methodWithOptionalDeprecatedParam',
    {'deprecatedParam': deprecatedParam},
  );

  /// A method with deprecated named parameter.
  _ida.Future<String> methodWithNamedDeprecatedParam({
    required String normalParam,
    @deprecated String? deprecatedParam,
  }) => caller.callServerEndpoint<String>(
    'deprecation',
    'methodWithNamedDeprecatedParam',
    {
      'normalParam': normalParam,
      'deprecatedParam': deprecatedParam,
    },
  );
}

/// {@category Endpoint}
class EndpointDiagnosticEventTest extends _isc.EndpointRef {
  EndpointDiagnosticEventTest(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'diagnosticEventTest';

  _ida.Future<String> submitExceptionEvent() =>
      caller.callServerEndpoint<String>(
        'diagnosticEventTest',
        'submitExceptionEvent',
        {},
      );
}

/// This class is meant for echoing / reflecting the received headers,
/// auth keys, parameters etc in endpoint invocations.
/// {@category Endpoint}
class EndpointEchoRequest extends _isc.EndpointRef {
  EndpointEchoRequest(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'echoRequest';

  /// Echo the authentication key of the session.
  /// Returns null if the key is not set.
  _ida.Future<String?> echoAuthenticationKey() =>
      caller.callServerEndpoint<String?>(
        'echoRequest',
        'echoAuthenticationKey',
        {},
      );

  /// Echo a specified header of the HTTP request.
  /// Returns null of the header is not set.
  _ida.Future<List<String>?> echoHttpHeader(String headerName) =>
      caller.callServerEndpoint<List<String>?>(
        'echoRequest',
        'echoHttpHeader',
        {'headerName': headerName},
      );
}

/// {@category Endpoint}
class EndpointEchoRequiredField extends _isc.EndpointRef {
  EndpointEchoRequiredField(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'echoRequiredField';

  _ida.Future<_i6e6wv43.ModelWithRequiredField> echoModel(
    _i6e6wv43.ModelWithRequiredField model,
  ) => caller.callServerEndpoint<_i6e6wv43.ModelWithRequiredField>(
    'echoRequiredField',
    'echoModel',
    {'model': model},
  );

  _ida.Future<void> throwException() => caller.callServerEndpoint<void>(
    'echoRequiredField',
    'throwException',
    {},
  );
}

/// {@category Endpoint}
class EndpointEmailAuthTestMethods extends _isc.EndpointRef {
  EndpointEmailAuthTestMethods(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailAuthTestMethods';

  _ida.Future<String?> findVerificationCode(
    String userName,
    String email,
  ) => caller.callServerEndpoint<String?>(
    'emailAuthTestMethods',
    'findVerificationCode',
    {
      'userName': userName,
      'email': email,
    },
  );

  _ida.Future<String?> findResetCode(String email) =>
      caller.callServerEndpoint<String?>(
        'emailAuthTestMethods',
        'findResetCode',
        {'email': email},
      );

  _ida.Future<void> tearDown() => caller.callServerEndpoint<void>(
    'emailAuthTestMethods',
    'tearDown',
    {},
  );

  _ida.Future<bool> createUser(
    String userName,
    String email,
    String password,
  ) => caller.callServerEndpoint<bool>(
    'emailAuthTestMethods',
    'createUser',
    {
      'userName': userName,
      'email': email,
      'password': password,
    },
  );
}

/// An abstract endpoint with a virtual method.
/// {@category Endpoint}
abstract class EndpointAbstractBase extends _isc.EndpointRef {
  EndpointAbstractBase(_isc.EndpointCaller caller) : super(caller);

  /// This is a virtual method that must be overriden.
  _ida.Future<String> virtualMethod();

  /// This body should not be present in the generated abstract class.
  _ida.Future<String> abstractBaseMethod();

  /// This body should not be present in the generated abstract class.
  _ida.Stream<String> abstractBaseStreamMethod();
}

/// A concrete endpoint that extends the abstract endpoint.
/// {@category Endpoint}
class EndpointConcreteBase extends EndpointAbstractBase {
  EndpointConcreteBase(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'concreteBase';

  @override
  _ida.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteBase',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  _ida.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'concreteBase',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteBase',
    'abstractBaseMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Stream<String> abstractBaseStreamMethod() =>
      caller.callStreamingServerEndpoint<_ida.Stream<String>, String>(
        'concreteBase',
        'abstractBaseStreamMethod',
        {},
        {},
      );
}

/// An abstract endpoint that extends a concrete endpoint. Should override all
/// methods, since abstract generated class have all methods as abstract.
/// {@category Endpoint}
abstract class EndpointAbstractSubClass extends EndpointConcreteBase {
  EndpointAbstractSubClass(_isc.EndpointCaller caller) : super(caller);

  _ida.Future<String> subClassVirtualMethod();

  @override
  _ida.Future<String> virtualMethod();

  /// A concrete method that should be present in the generated class.
  @override
  _ida.Future<String> concreteMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Stream<String> abstractBaseStreamMethod();
}

/// A concrete endpoint that extends an abstract endpoint with concrete parent.
/// {@category Endpoint}
class EndpointConcreteSubClass extends EndpointAbstractSubClass {
  EndpointConcreteSubClass(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'concreteSubClass';

  @override
  _ida.Future<String> subClassVirtualMethod() =>
      caller.callServerEndpoint<String>(
        'concreteSubClass',
        'subClassVirtualMethod',
        {},
      );

  @override
  _ida.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteSubClass',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  @override
  _ida.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'concreteSubClass',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteSubClass',
    'abstractBaseMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Stream<String> abstractBaseStreamMethod() =>
      caller.callStreamingServerEndpoint<_ida.Stream<String>, String>(
        'concreteSubClass',
        'abstractBaseStreamMethod',
        {},
        {},
      );
}

/// A class that carries all methods from the inheritance chain, but do not
/// extend any of the classes. Should inherit [Endpoint] directly.
/// {@category Endpoint}
class EndpointIndependent extends _isc.EndpointRef {
  EndpointIndependent(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'independent';

  _ida.Future<String> subClassVirtualMethod() =>
      caller.callServerEndpoint<String>(
        'independent',
        'subClassVirtualMethod',
        {},
      );

  _ida.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'independent',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  _ida.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'independent',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  _ida.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'independent',
    'abstractBaseMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  _ida.Stream<String> abstractBaseStreamMethod() =>
      caller.callStreamingServerEndpoint<_ida.Stream<String>, String>(
        'independent',
        'abstractBaseStreamMethod',
        {},
        {},
      );
}

/// An abstract endpoint that extends an abstract endpoint from another module.
/// {@category Endpoint}
abstract class EndpointAbstractModuleBase
    extends _i89s5423.EndpointAbstractBase {
  EndpointAbstractModuleBase(_isc.EndpointCaller caller) : super(caller);

  /// This is a virtual method that must be overriden.
  @override
  _ida.Future<String> virtualMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod();
}

/// A concrete endpoint that extends an abstract endpoint from another module.
/// {@category Endpoint}
class EndpointConcreteFromModuleAbstractBase
    extends _i89s5423.EndpointAbstractBase {
  EndpointConcreteFromModuleAbstractBase(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'concreteFromModuleAbstractBase';

  @override
  _ida.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteFromModuleAbstractBase',
    'virtualMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteFromModuleAbstractBase',
    'abstractBaseMethod',
    {},
  );
}

/// A concrete endpoint that extends a concrete endpoint from another module.
/// {@category Endpoint}
class EndpointConcreteModuleBase extends _i89s5423.EndpointConcreteBase {
  EndpointConcreteModuleBase(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'concreteModuleBase';

  @override
  _ida.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteModuleBase',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  @override
  _ida.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'concreteModuleBase',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteModuleBase',
    'abstractBaseMethod',
    {},
  );
}

/// An abstract endpoint that extends a concrete endpoint from another module.
/// {@category Endpoint}
abstract class EndpointAbstractModuleSubClass
    extends _i89s5423.EndpointConcreteBase {
  EndpointAbstractModuleSubClass(_isc.EndpointCaller caller) : super(caller);

  @override
  _ida.Future<String> virtualMethod();

  /// A concrete method that should be present in the generated class.
  @override
  _ida.Future<String> concreteMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _ida.Future<String> abstractBaseMethod();
}

/// {@category Endpoint}
class EndpointLoggedIn extends _isc.EndpointRef {
  EndpointLoggedIn(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'loggedIn';
}

/// {@category Endpoint}
class EndpointMyLoggedIn extends EndpointLoggedIn {
  EndpointMyLoggedIn(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myLoggedIn';

  _ida.Future<String> echo(String value) => caller.callServerEndpoint<String>(
    'myLoggedIn',
    'echo',
    {'value': value},
  );
}

/// {@category Endpoint}
class EndpointAdmin extends EndpointLoggedIn {
  EndpointAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';
}

/// {@category Endpoint}
class EndpointMyAdmin extends EndpointAdmin {
  EndpointMyAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myAdmin';

  _ida.Future<String> echo(String value) => caller.callServerEndpoint<String>(
    'myAdmin',
    'echo',
    {'value': value},
  );
}

/// {@category Endpoint}
abstract class EndpointAbstractLoggedIn extends _isc.EndpointRef {
  EndpointAbstractLoggedIn(_isc.EndpointCaller caller) : super(caller);
}

/// {@category Endpoint}
abstract class EndpointAbstractAdmin extends EndpointAbstractLoggedIn {
  EndpointAbstractAdmin(_isc.EndpointCaller caller) : super(caller);
}

/// {@category Endpoint}
class EndpointMyConcreteAdmin extends EndpointAbstractAdmin {
  EndpointMyConcreteAdmin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myConcreteAdmin';

  _ida.Future<String> echo(String value) => caller.callServerEndpoint<String>(
    'myConcreteAdmin',
    'echo',
    {'value': value},
  );
}

/// {@category Endpoint}
class EndpointExceptionTest extends _isc.EndpointRef {
  EndpointExceptionTest(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'exceptionTest';

  _ida.Future<String> throwNormalException() =>
      caller.callServerEndpoint<String>(
        'exceptionTest',
        'throwNormalException',
        {},
      );

  _ida.Future<String> throwExceptionWithData() =>
      caller.callServerEndpoint<String>(
        'exceptionTest',
        'throwExceptionWithData',
        {},
      );

  _ida.Future<String> workingWithoutException() =>
      caller.callServerEndpoint<String>(
        'exceptionTest',
        'workingWithoutException',
        {},
      );
}

/// {@category Endpoint}
class EndpointFailedCalls extends _isc.EndpointRef {
  EndpointFailedCalls(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'failedCalls';

  _ida.Future<void> failedCall() => caller.callServerEndpoint<void>(
    'failedCalls',
    'failedCall',
    {},
  );

  _ida.Future<void> failedDatabaseQuery() => caller.callServerEndpoint<void>(
    'failedCalls',
    'failedDatabaseQuery',
    {},
  );

  _ida.Future<bool> failedDatabaseQueryCaughtException() =>
      caller.callServerEndpoint<bool>(
        'failedCalls',
        'failedDatabaseQueryCaughtException',
        {},
      );

  _ida.Future<void> slowCall() => caller.callServerEndpoint<void>(
    'failedCalls',
    'slowCall',
    {},
  );

  _ida.Future<void> caughtException() => caller.callServerEndpoint<void>(
    'failedCalls',
    'caughtException',
    {},
  );
}

/// {@category Endpoint}
class EndpointFieldScopes extends _isc.EndpointRef {
  EndpointFieldScopes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'fieldScopes';

  _ida.Future<void> storeObject(_i1ck89ud.ObjectFieldScopes object) =>
      caller.callServerEndpoint<void>(
        'fieldScopes',
        'storeObject',
        {'object': object},
      );

  _ida.Future<_i1ck89ud.ObjectFieldScopes?> retrieveObject() =>
      caller.callServerEndpoint<_i1ck89ud.ObjectFieldScopes?>(
        'fieldScopes',
        'retrieveObject',
        {},
      );
}

/// {@category Endpoint}
class EndpointTestFutureCalls extends _isc.EndpointRef {
  EndpointTestFutureCalls(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'testFutureCalls';

  _ida.Future<void> makeFutureCall(_i68e2f8e.SimpleData? data) =>
      caller.callServerEndpoint<void>(
        'testFutureCalls',
        'makeFutureCall',
        {'data': data},
      );

  _ida.Future<void> makeFutureCallThatThrows(_i68e2f8e.SimpleData? data) =>
      caller.callServerEndpoint<void>(
        'testFutureCalls',
        'makeFutureCallThatThrows',
        {'data': data},
      );
}

/// {@category Endpoint}
class EndpointListParameters extends _isc.EndpointRef {
  EndpointListParameters(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'listParameters';

  _ida.Future<List<int>> returnIntList(List<int> list) =>
      caller.callServerEndpoint<List<int>>(
        'listParameters',
        'returnIntList',
        {'list': list},
      );

  _ida.Future<List<List<int>>> returnIntListList(List<List<int>> list) =>
      caller.callServerEndpoint<List<List<int>>>(
        'listParameters',
        'returnIntListList',
        {'list': list},
      );

  _ida.Future<List<int>?> returnIntListNullable(List<int>? list) =>
      caller.callServerEndpoint<List<int>?>(
        'listParameters',
        'returnIntListNullable',
        {'list': list},
      );

  _ida.Future<List<List<int>?>> returnIntListNullableList(
    List<List<int>?> list,
  ) => caller.callServerEndpoint<List<List<int>?>>(
    'listParameters',
    'returnIntListNullableList',
    {'list': list},
  );

  _ida.Future<List<List<int>>?> returnIntListListNullable(
    List<List<int>>? list,
  ) => caller.callServerEndpoint<List<List<int>>?>(
    'listParameters',
    'returnIntListListNullable',
    {'list': list},
  );

  _ida.Future<List<int?>> returnIntListNullableInts(List<int?> list) =>
      caller.callServerEndpoint<List<int?>>(
        'listParameters',
        'returnIntListNullableInts',
        {'list': list},
      );

  _ida.Future<List<int?>?> returnNullableIntListNullableInts(
    List<int?>? list,
  ) => caller.callServerEndpoint<List<int?>?>(
    'listParameters',
    'returnNullableIntListNullableInts',
    {'list': list},
  );

  _ida.Future<List<double>> returnDoubleList(List<double> list) =>
      caller.callServerEndpoint<List<double>>(
        'listParameters',
        'returnDoubleList',
        {'list': list},
      );

  _ida.Future<List<double?>> returnDoubleListNullableDoubles(
    List<double?> list,
  ) => caller.callServerEndpoint<List<double?>>(
    'listParameters',
    'returnDoubleListNullableDoubles',
    {'list': list},
  );

  _ida.Future<List<bool>> returnBoolList(List<bool> list) =>
      caller.callServerEndpoint<List<bool>>(
        'listParameters',
        'returnBoolList',
        {'list': list},
      );

  _ida.Future<List<bool?>> returnBoolListNullableBools(List<bool?> list) =>
      caller.callServerEndpoint<List<bool?>>(
        'listParameters',
        'returnBoolListNullableBools',
        {'list': list},
      );

  _ida.Future<List<String>> returnStringList(List<String> list) =>
      caller.callServerEndpoint<List<String>>(
        'listParameters',
        'returnStringList',
        {'list': list},
      );

  _ida.Future<List<String?>> returnStringListNullableStrings(
    List<String?> list,
  ) => caller.callServerEndpoint<List<String?>>(
    'listParameters',
    'returnStringListNullableStrings',
    {'list': list},
  );

  _ida.Future<List<DateTime>> returnDateTimeList(List<DateTime> list) =>
      caller.callServerEndpoint<List<DateTime>>(
        'listParameters',
        'returnDateTimeList',
        {'list': list},
      );

  _ida.Future<List<DateTime?>> returnDateTimeListNullableDateTimes(
    List<DateTime?> list,
  ) => caller.callServerEndpoint<List<DateTime?>>(
    'listParameters',
    'returnDateTimeListNullableDateTimes',
    {'list': list},
  );

  _ida.Future<List<_idt.ByteData>> returnByteDataList(
    List<_idt.ByteData> list,
  ) => caller.callServerEndpoint<List<_idt.ByteData>>(
    'listParameters',
    'returnByteDataList',
    {'list': list},
  );

  _ida.Future<List<_idt.ByteData?>> returnByteDataListNullableByteDatas(
    List<_idt.ByteData?> list,
  ) => caller.callServerEndpoint<List<_idt.ByteData?>>(
    'listParameters',
    'returnByteDataListNullableByteDatas',
    {'list': list},
  );

  _ida.Future<List<_i68e2f8e.SimpleData>> returnSimpleDataList(
    List<_i68e2f8e.SimpleData> list,
  ) => caller.callServerEndpoint<List<_i68e2f8e.SimpleData>>(
    'listParameters',
    'returnSimpleDataList',
    {'list': list},
  );

  _ida.Future<List<_i68e2f8e.SimpleData?>>
  returnSimpleDataListNullableSimpleData(List<_i68e2f8e.SimpleData?> list) =>
      caller.callServerEndpoint<List<_i68e2f8e.SimpleData?>>(
        'listParameters',
        'returnSimpleDataListNullableSimpleData',
        {'list': list},
      );

  _ida.Future<List<_i68e2f8e.SimpleData>?> returnSimpleDataListNullable(
    List<_i68e2f8e.SimpleData>? list,
  ) => caller.callServerEndpoint<List<_i68e2f8e.SimpleData>?>(
    'listParameters',
    'returnSimpleDataListNullable',
    {'list': list},
  );

  _ida.Future<List<_i68e2f8e.SimpleData?>?>
  returnNullableSimpleDataListNullableSimpleData(
    List<_i68e2f8e.SimpleData?>? list,
  ) => caller.callServerEndpoint<List<_i68e2f8e.SimpleData?>?>(
    'listParameters',
    'returnNullableSimpleDataListNullableSimpleData',
    {'list': list},
  );

  _ida.Future<List<Duration>> returnDurationList(List<Duration> list) =>
      caller.callServerEndpoint<List<Duration>>(
        'listParameters',
        'returnDurationList',
        {'list': list},
      );

  _ida.Future<List<Duration?>> returnDurationListNullableDurations(
    List<Duration?> list,
  ) => caller.callServerEndpoint<List<Duration?>>(
    'listParameters',
    'returnDurationListNullableDurations',
    {'list': list},
  );
}

/// {@category Endpoint}
class EndpointLogging extends _isc.EndpointRef {
  EndpointLogging(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'logging';

  _ida.Future<void> slowQueryMethod(int seconds) =>
      caller.callServerEndpoint<void>(
        'logging',
        'slowQueryMethod',
        {'seconds': seconds},
      );

  _ida.Future<void> queryMethod(int queries) => caller.callServerEndpoint<void>(
    'logging',
    'queryMethod',
    {'queries': queries},
  );

  _ida.Future<void> failedQueryMethod() => caller.callServerEndpoint<void>(
    'logging',
    'failedQueryMethod',
    {},
  );

  _ida.Future<void> slowMethod(int delayMillis) =>
      caller.callServerEndpoint<void>(
        'logging',
        'slowMethod',
        {'delayMillis': delayMillis},
      );

  _ida.Future<void> failingMethod() => caller.callServerEndpoint<void>(
    'logging',
    'failingMethod',
    {},
  );

  _ida.Future<void> emptyMethod() => caller.callServerEndpoint<void>(
    'logging',
    'emptyMethod',
    {},
  );

  _ida.Future<void> log(
    String message,
    List<int> logLevels,
  ) => caller.callServerEndpoint<void>(
    'logging',
    'log',
    {
      'message': message,
      'logLevels': logLevels,
    },
  );

  _ida.Future<void> logInfo(String message) => caller.callServerEndpoint<void>(
    'logging',
    'logInfo',
    {'message': message},
  );

  _ida.Future<void> logDebugAndInfoAndError(
    String debug,
    String info,
    String error,
  ) => caller.callServerEndpoint<void>(
    'logging',
    'logDebugAndInfoAndError',
    {
      'debug': debug,
      'info': info,
      'error': error,
    },
  );

  _ida.Future<void> twoQueries() => caller.callServerEndpoint<void>(
    'logging',
    'twoQueries',
    {},
  );

  _ida.Stream<int> streamEmpty(_ida.Stream<int> input) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'logging',
        'streamEmpty',
        {},
        {'input': input},
      );

  _ida.Stream<int> streamLogging(_ida.Stream<int> input) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'logging',
        'streamLogging',
        {},
        {'input': input},
      );

  _ida.Stream<int> streamQueryLogging(_ida.Stream<int> input) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'logging',
        'streamQueryLogging',
        {},
        {'input': input},
      );

  _ida.Stream<int> streamException() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'logging',
        'streamException',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointLoggingDisabled extends _isc.EndpointRef {
  EndpointLoggingDisabled(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'loggingDisabled';

  _ida.Future<void> logInfo(String message) => caller.callServerEndpoint<void>(
    'loggingDisabled',
    'logInfo',
    {'message': message},
  );
}

/// {@category Endpoint}
class EndpointMapParameters extends _isc.EndpointRef {
  EndpointMapParameters(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mapParameters';

  _ida.Future<Map<String, int>> returnIntMap(Map<String, int> map) =>
      caller.callServerEndpoint<Map<String, int>>(
        'mapParameters',
        'returnIntMap',
        {'map': map},
      );

  _ida.Future<Map<String, int>?> returnIntMapNullable(Map<String, int>? map) =>
      caller.callServerEndpoint<Map<String, int>?>(
        'mapParameters',
        'returnIntMapNullable',
        {'map': map},
      );

  _ida.Future<Map<String, Map<String, int>>> returnNestedIntMap(
    Map<String, Map<String, int>> map,
  ) => caller.callServerEndpoint<Map<String, Map<String, int>>>(
    'mapParameters',
    'returnNestedIntMap',
    {'map': map},
  );

  _ida.Future<Map<String, int?>> returnIntMapNullableInts(
    Map<String, int?> map,
  ) => caller.callServerEndpoint<Map<String, int?>>(
    'mapParameters',
    'returnIntMapNullableInts',
    {'map': map},
  );

  _ida.Future<Map<String, int?>?> returnNullableIntMapNullableInts(
    Map<String, int?>? map,
  ) => caller.callServerEndpoint<Map<String, int?>?>(
    'mapParameters',
    'returnNullableIntMapNullableInts',
    {'map': map},
  );

  _ida.Future<Map<int, int>> returnIntIntMap(Map<int, int> map) =>
      caller.callServerEndpoint<Map<int, int>>(
        'mapParameters',
        'returnIntIntMap',
        {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
      );

  _ida.Future<Map<String, Map<int, int>>> returnNestedIntIntMap(
    Map<String, Map<int, int>> map,
  ) => caller.callServerEndpoint<Map<String, Map<int, int>>>(
    'mapParameters',
    'returnNestedIntIntMap',
    {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<_ih5exyov.TestEnum, int>> returnEnumIntMap(
    Map<_ih5exyov.TestEnum, int> map,
  ) => caller.callServerEndpoint<Map<_ih5exyov.TestEnum, int>>(
    'mapParameters',
    'returnEnumIntMap',
    {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<String, _ih5exyov.TestEnum>> returnEnumMap(
    Map<String, _ih5exyov.TestEnum> map,
  ) => caller.callServerEndpoint<Map<String, _ih5exyov.TestEnum>>(
    'mapParameters',
    'returnEnumMap',
    {'map': map},
  );

  _ida.Future<Map<String, double>> returnDoubleMap(Map<String, double> map) =>
      caller.callServerEndpoint<Map<String, double>>(
        'mapParameters',
        'returnDoubleMap',
        {'map': map},
      );

  _ida.Future<Map<String, double?>> returnDoubleMapNullableDoubles(
    Map<String, double?> map,
  ) => caller.callServerEndpoint<Map<String, double?>>(
    'mapParameters',
    'returnDoubleMapNullableDoubles',
    {'map': map},
  );

  _ida.Future<Map<String, bool>> returnBoolMap(Map<String, bool> map) =>
      caller.callServerEndpoint<Map<String, bool>>(
        'mapParameters',
        'returnBoolMap',
        {'map': map},
      );

  _ida.Future<Map<String, bool?>> returnBoolMapNullableBools(
    Map<String, bool?> map,
  ) => caller.callServerEndpoint<Map<String, bool?>>(
    'mapParameters',
    'returnBoolMapNullableBools',
    {'map': map},
  );

  _ida.Future<Map<String, String>> returnStringMap(Map<String, String> map) =>
      caller.callServerEndpoint<Map<String, String>>(
        'mapParameters',
        'returnStringMap',
        {'map': map},
      );

  _ida.Future<Map<String, String?>> returnStringMapNullableStrings(
    Map<String, String?> map,
  ) => caller.callServerEndpoint<Map<String, String?>>(
    'mapParameters',
    'returnStringMapNullableStrings',
    {'map': map},
  );

  _ida.Future<Map<String, DateTime>> returnDateTimeMap(
    Map<String, DateTime> map,
  ) => caller.callServerEndpoint<Map<String, DateTime>>(
    'mapParameters',
    'returnDateTimeMap',
    {'map': map},
  );

  _ida.Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
    Map<String, DateTime?> map,
  ) => caller.callServerEndpoint<Map<String, DateTime?>>(
    'mapParameters',
    'returnDateTimeMapNullableDateTimes',
    {'map': map},
  );

  _ida.Future<Map<String, _idt.ByteData>> returnByteDataMap(
    Map<String, _idt.ByteData> map,
  ) => caller.callServerEndpoint<Map<String, _idt.ByteData>>(
    'mapParameters',
    'returnByteDataMap',
    {'map': map},
  );

  _ida.Future<Map<String, _idt.ByteData?>> returnByteDataMapNullableByteDatas(
    Map<String, _idt.ByteData?> map,
  ) => caller.callServerEndpoint<Map<String, _idt.ByteData?>>(
    'mapParameters',
    'returnByteDataMapNullableByteDatas',
    {'map': map},
  );

  _ida.Future<Map<String, _i68e2f8e.SimpleData>> returnSimpleDataMap(
    Map<String, _i68e2f8e.SimpleData> map,
  ) => caller.callServerEndpoint<Map<String, _i68e2f8e.SimpleData>>(
    'mapParameters',
    'returnSimpleDataMap',
    {'map': map},
  );

  _ida.Future<Map<String, _i68e2f8e.SimpleData?>>
  returnSimpleDataMapNullableSimpleData(
    Map<String, _i68e2f8e.SimpleData?> map,
  ) => caller.callServerEndpoint<Map<String, _i68e2f8e.SimpleData?>>(
    'mapParameters',
    'returnSimpleDataMapNullableSimpleData',
    {'map': map},
  );

  _ida.Future<Map<String, _i68e2f8e.SimpleData>?> returnSimpleDataMapNullable(
    Map<String, _i68e2f8e.SimpleData>? map,
  ) => caller.callServerEndpoint<Map<String, _i68e2f8e.SimpleData>?>(
    'mapParameters',
    'returnSimpleDataMapNullable',
    {'map': map},
  );

  _ida.Future<Map<String, _i68e2f8e.SimpleData?>?>
  returnNullableSimpleDataMapNullableSimpleData(
    Map<String, _i68e2f8e.SimpleData?>? map,
  ) => caller.callServerEndpoint<Map<String, _i68e2f8e.SimpleData?>?>(
    'mapParameters',
    'returnNullableSimpleDataMapNullableSimpleData',
    {'map': map},
  );

  _ida.Future<Map<String, Duration>> returnDurationMap(
    Map<String, Duration> map,
  ) => caller.callServerEndpoint<Map<String, Duration>>(
    'mapParameters',
    'returnDurationMap',
    {'map': map},
  );

  _ida.Future<Map<String, Duration?>> returnDurationMapNullableDurations(
    Map<String, Duration?> map,
  ) => caller.callServerEndpoint<Map<String, Duration?>>(
    'mapParameters',
    'returnDurationMapNullableDurations',
    {'map': map},
  );

  _ida.Future<Map<(Map<int, String>, String), String>>
  returnNestedNonStringKeyedMapInsideRecordInsideMap(
    Map<(Map<int, String>, String), String> map,
  ) => caller.callServerEndpoint<Map<(Map<int, String>, String), String>>(
    'mapParameters',
    'returnNestedNonStringKeyedMapInsideRecordInsideMap',
    {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<String, (Map<int, int>,)>>
  returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap(
    Map<String, (Map<int, int>,)> map,
  ) => caller.callServerEndpoint<Map<String, (Map<int, int>,)>>(
    'mapParameters',
    'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap',
    {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<DateTime, bool>> returnDateTimeBoolMap(
    Map<DateTime, bool> map,
  ) => caller.callServerEndpoint<Map<DateTime, bool>>(
    'mapParameters',
    'returnDateTimeBoolMap',
    {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<DateTime, bool>?> returnDateTimeBoolMapNullable(
    Map<DateTime, bool>? map,
  ) => caller.callServerEndpoint<Map<DateTime, bool>?>(
    'mapParameters',
    'returnDateTimeBoolMapNullable',
    {'map': map == null ? null : _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<int, String>> returnIntStringMap(Map<int, String> map) =>
      caller.callServerEndpoint<Map<int, String>>(
        'mapParameters',
        'returnIntStringMap',
        {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
      );

  _ida.Future<Map<int, String>?> returnIntStringMapNullable(
    Map<int, String>? map,
  ) => caller.callServerEndpoint<Map<int, String>?>(
    'mapParameters',
    'returnIntStringMapNullable',
    {'map': map == null ? null : _iza9lbb5.Protocol().mapContainerToJson(map)},
  );
}

/// {@category Endpoint}
class EndpointMethodSignaturePermutations extends _isc.EndpointRef {
  EndpointMethodSignaturePermutations(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'methodSignaturePermutations';

  _ida.Future<String> echoPositionalArg(String string) =>
      caller.callServerEndpoint<String>(
        'methodSignaturePermutations',
        'echoPositionalArg',
        {'string': string},
      );

  _ida.Future<String> echoNamedArg({required String string}) =>
      caller.callServerEndpoint<String>(
        'methodSignaturePermutations',
        'echoNamedArg',
        {'string': string},
      );

  _ida.Future<String?> echoNullableNamedArg({String? string}) =>
      caller.callServerEndpoint<String?>(
        'methodSignaturePermutations',
        'echoNullableNamedArg',
        {'string': string},
      );

  _ida.Future<String?> echoOptionalArg([String? string]) =>
      caller.callServerEndpoint<String?>(
        'methodSignaturePermutations',
        'echoOptionalArg',
        {'string': string},
      );

  _ida.Future<List<String?>> echoPositionalAndNamedArgs(
    String string1, {
    required String string2,
  }) => caller.callServerEndpoint<List<String?>>(
    'methodSignaturePermutations',
    'echoPositionalAndNamedArgs',
    {
      'string1': string1,
      'string2': string2,
    },
  );

  _ida.Future<List<String?>> echoPositionalAndNullableNamedArgs(
    String string1, {
    String? string2,
  }) => caller.callServerEndpoint<List<String?>>(
    'methodSignaturePermutations',
    'echoPositionalAndNullableNamedArgs',
    {
      'string1': string1,
      'string2': string2,
    },
  );

  _ida.Future<List<String?>> echoPositionalAndOptionalArgs(
    String string1, [
    String? string2,
  ]) => caller.callServerEndpoint<List<String?>>(
    'methodSignaturePermutations',
    'echoPositionalAndOptionalArgs',
    {
      'string1': string1,
      'string2': string2,
    },
  );

  _ida.Stream<String> echoNamedArgStream({
    required _ida.Stream<String> strings,
  }) => caller.callStreamingServerEndpoint<_ida.Stream<String>, String>(
    'methodSignaturePermutations',
    'echoNamedArgStream',
    {},
    {'strings': strings},
  );

  _ida.Future<String> echoNamedArgStreamAsFuture({
    required _ida.Stream<String> strings,
  }) => caller.callStreamingServerEndpoint<_ida.Future<String>, String>(
    'methodSignaturePermutations',
    'echoNamedArgStreamAsFuture',
    {},
    {'strings': strings},
  );

  _ida.Stream<String> echoPositionalArgStream(_ida.Stream<String> strings) =>
      caller.callStreamingServerEndpoint<_ida.Stream<String>, String>(
        'methodSignaturePermutations',
        'echoPositionalArgStream',
        {},
        {'strings': strings},
      );

  _ida.Future<String> echoPositionalArgStreamAsFuture(
    _ida.Stream<String> strings,
  ) => caller.callStreamingServerEndpoint<_ida.Future<String>, String>(
    'methodSignaturePermutations',
    'echoPositionalArgStreamAsFuture',
    {},
    {'strings': strings},
  );
}

/// {@category Endpoint}
class EndpointMethodStreaming extends _isc.EndpointRef {
  EndpointMethodStreaming(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'methodStreaming';

  /// Returns a simple stream of integers from 0 to 9.
  _ida.Stream<int> simpleStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'simpleStream',
        {},
        {},
      );

  _ida.Stream<int> neverEndingStreamWithDelay(int millisecondsDelay) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'neverEndingStreamWithDelay',
        {'millisecondsDelay': millisecondsDelay},
        {},
      );

  _ida.Future<void> methodCallEndpoint() => caller.callServerEndpoint<void>(
    'methodStreaming',
    'methodCallEndpoint',
    {},
  );

  _ida.Future<int> intReturnFromStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<int>, int>(
        'methodStreaming',
        'intReturnFromStream',
        {},
        {'stream': stream},
      );

  _ida.Future<int?> nullableIntReturnFromStream(_ida.Stream<int?> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<int?>, int?>(
        'methodStreaming',
        'nullableIntReturnFromStream',
        {},
        {'stream': stream},
      );

  _ida.Stream<int?> getBroadcastStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int?>, int?>(
        'methodStreaming',
        'getBroadcastStream',
        {},
        {},
      );

  _ida.Future<bool> wasBroadcastStreamCanceled() =>
      caller.callServerEndpoint<bool>(
        'methodStreaming',
        'wasBroadcastStreamCanceled',
        {},
      );

  _ida.Future<bool> wasSessionWillCloseListenerCalled() =>
      caller.callServerEndpoint<bool>(
        'methodStreaming',
        'wasSessionWillCloseListenerCalled',
        {},
      );

  _ida.Stream<int> intStreamFromValue(int value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'intStreamFromValue',
        {'value': value},
        {},
      );

  _ida.Stream<int> intEchoStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'intEchoStream',
        {},
        {'stream': stream},
      );

  _ida.Stream<dynamic> dynamicEchoStream(_ida.Stream<dynamic> stream) =>
      caller.callStreamingServerEndpoint<_ida.Stream<dynamic>, dynamic>(
        'methodStreaming',
        'dynamicEchoStream',
        {},
        {'stream': stream},
      );

  _ida.Stream<int?> nullableIntEchoStream(_ida.Stream<int?> stream) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int?>, int?>(
        'methodStreaming',
        'nullableIntEchoStream',
        {},
        {'stream': stream},
      );

  _ida.Future<void> voidReturnAfterStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
        'methodStreaming',
        'voidReturnAfterStream',
        {},
        {'stream': stream},
      );

  _ida.Stream<int> multipleIntEchoStreams(
    _ida.Stream<int> stream1,
    _ida.Stream<int> stream2,
  ) => caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
    'methodStreaming',
    'multipleIntEchoStreams',
    {},
    {
      'stream1': stream1,
      'stream2': stream2,
    },
  );

  _ida.Future<void> directVoidReturnWithStreamInput(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
        'methodStreaming',
        'directVoidReturnWithStreamInput',
        {},
        {'stream': stream},
      );

  _ida.Future<int> directOneIntReturnWithStreamInput(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<int>, int>(
        'methodStreaming',
        'directOneIntReturnWithStreamInput',
        {},
        {'stream': stream},
      );

  _ida.Future<int> simpleInputReturnStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<int>, int>(
        'methodStreaming',
        'simpleInputReturnStream',
        {},
        {'stream': stream},
      );

  _ida.Stream<int> simpleStreamWithParameter(int value) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'simpleStreamWithParameter',
        {'value': value},
        {},
      );

  _ida.Stream<_i68e2f8e.SimpleData> simpleDataStream(int value) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i68e2f8e.SimpleData>,
        _i68e2f8e.SimpleData
      >(
        'methodStreaming',
        'simpleDataStream',
        {'value': value},
        {},
      );

  _ida.Stream<_i68e2f8e.SimpleData> simpleInOutDataStream(
    _ida.Stream<_i68e2f8e.SimpleData> simpleDataStream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i68e2f8e.SimpleData>,
        _i68e2f8e.SimpleData
      >(
        'methodStreaming',
        'simpleInOutDataStream',
        {},
        {'simpleDataStream': simpleDataStream},
      );

  _ida.Stream<List<int>> simpleListInOutIntStream(
    _ida.Stream<List<int>> simpleDataListStream,
  ) => caller.callStreamingServerEndpoint<_ida.Stream<List<int>>, List<int>>(
    'methodStreaming',
    'simpleListInOutIntStream',
    {},
    {'simpleDataListStream': simpleDataListStream},
  );

  _ida.Stream<List<_i68e2f8e.SimpleData>> simpleListInOutDataStream(
    _ida.Stream<List<_i68e2f8e.SimpleData>> simpleDataListStream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<List<_i68e2f8e.SimpleData>>,
        List<_i68e2f8e.SimpleData>
      >(
        'methodStreaming',
        'simpleListInOutDataStream',
        {},
        {'simpleDataListStream': simpleDataListStream},
      );

  _ida.Stream<List<_i312scxx.UserInfo>> simpleListInOutOtherModuleTypeStream(
    _ida.Stream<List<_i312scxx.UserInfo>> userInfoListStream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<List<_i312scxx.UserInfo>>,
        List<_i312scxx.UserInfo>
      >(
        'methodStreaming',
        'simpleListInOutOtherModuleTypeStream',
        {},
        {'userInfoListStream': userInfoListStream},
      );

  _ida.Stream<List<_i68e2f8e.SimpleData>?>
  simpleNullableListInOutNullableDataStream(
    _ida.Stream<List<_i68e2f8e.SimpleData>?> simpleDataListStream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<List<_i68e2f8e.SimpleData>?>,
        List<_i68e2f8e.SimpleData>?
      >(
        'methodStreaming',
        'simpleNullableListInOutNullableDataStream',
        {},
        {'simpleDataListStream': simpleDataListStream},
      );

  _ida.Stream<List<_i68e2f8e.SimpleData?>> simpleListInOutNullableDataStream(
    _ida.Stream<List<_i68e2f8e.SimpleData?>> simpleDataListStream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<List<_i68e2f8e.SimpleData?>>,
        List<_i68e2f8e.SimpleData?>
      >(
        'methodStreaming',
        'simpleListInOutNullableDataStream',
        {},
        {'simpleDataListStream': simpleDataListStream},
      );

  _ida.Stream<Set<int>> simpleSetInOutIntStream(
    _ida.Stream<Set<int>> simpleDataSetStream,
  ) => caller.callStreamingServerEndpoint<_ida.Stream<Set<int>>, Set<int>>(
    'methodStreaming',
    'simpleSetInOutIntStream',
    {},
    {'simpleDataSetStream': simpleDataSetStream},
  );

  _ida.Stream<Set<_i68e2f8e.SimpleData>> simpleSetInOutDataStream(
    _ida.Stream<Set<_i68e2f8e.SimpleData>> simpleDataSetStream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<Set<_i68e2f8e.SimpleData>>,
        Set<_i68e2f8e.SimpleData>
      >(
        'methodStreaming',
        'simpleSetInOutDataStream',
        {},
        {'simpleDataSetStream': simpleDataSetStream},
      );

  _ida.Stream<Set<_i68e2f8e.SimpleData>> nestedSetInListInOutDataStream(
    _ida.Stream<List<Set<_i68e2f8e.SimpleData>>> simpleDataSetStream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<Set<_i68e2f8e.SimpleData>>,
        Set<_i68e2f8e.SimpleData>
      >(
        'methodStreaming',
        'nestedSetInListInOutDataStream',
        {},
        {'simpleDataSetStream': simpleDataSetStream},
      );

  _ida.Future<void> simpleEndpoint() => caller.callServerEndpoint<void>(
    'methodStreaming',
    'simpleEndpoint',
    {},
  );

  _ida.Future<void> intParameter(int value) => caller.callServerEndpoint<void>(
    'methodStreaming',
    'intParameter',
    {'value': value},
  );

  _ida.Future<int> doubleInputValue(int value) =>
      caller.callServerEndpoint<int>(
        'methodStreaming',
        'doubleInputValue',
        {'value': value},
      );

  /// Delays the response for [delay] seconds.
  ///
  /// Responses can be closed by calling [completeAllDelayedResponses].
  _ida.Future<void> delayedResponse(int delay) =>
      caller.callServerEndpoint<void>(
        'methodStreaming',
        'delayedResponse',
        {'delay': delay},
      );

  _ida.Stream<int> delayedStreamResponse(int delay) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'delayedStreamResponse',
        {'delay': delay},
        {},
      );

  _ida.Future<void> delayedNeverListenedInputStream(
    int delay,
    _ida.Stream<int> stream,
  ) => caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
    'methodStreaming',
    'delayedNeverListenedInputStream',
    {'delay': delay},
    {'stream': stream},
  );

  _ida.Future<void> delayedPausedInputStream(
    int delay,
    _ida.Stream<int> stream,
  ) => caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
    'methodStreaming',
    'delayedPausedInputStream',
    {'delay': delay},
    {'stream': stream},
  );

  /// Completes all delayed responses.
  /// This makes the delayedResponse return directly.
  _ida.Future<void> completeAllDelayedResponses() =>
      caller.callServerEndpoint<void>(
        'methodStreaming',
        'completeAllDelayedResponses',
        {},
      );

  _ida.Future<void> inStreamThrowsException(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
        'methodStreaming',
        'inStreamThrowsException',
        {},
        {'stream': stream},
      );

  _ida.Future<void> inStreamThrowsSerializableException(
    _ida.Stream<int> stream,
  ) => caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
    'methodStreaming',
    'inStreamThrowsSerializableException',
    {},
    {'stream': stream},
  );

  _ida.Stream<int> outStreamThrowsException() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'outStreamThrowsException',
        {},
        {},
      );

  _ida.Stream<int> outStreamThrowsSerializableException() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'outStreamThrowsSerializableException',
        {},
        {},
      );

  _ida.Future<void> throwsExceptionVoid(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
        'methodStreaming',
        'throwsExceptionVoid',
        {},
        {'stream': stream},
      );

  _ida.Future<void> throwsSerializableExceptionVoid(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<void>, void>(
        'methodStreaming',
        'throwsSerializableExceptionVoid',
        {},
        {'stream': stream},
      );

  _ida.Future<int> throwsException(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<int>, int>(
        'methodStreaming',
        'throwsException',
        {},
        {'stream': stream},
      );

  _ida.Future<int> throwsSerializableException(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<int>, int>(
        'methodStreaming',
        'throwsSerializableException',
        {},
        {'stream': stream},
      );

  _ida.Stream<int> throwsExceptionStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'throwsExceptionStream',
        {},
        {},
      );

  _ida.Stream<int> exceptionThrownBeforeStreamReturn() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'exceptionThrownBeforeStreamReturn',
        {},
        {},
      );

  _ida.Stream<int> exceptionThrownInStreamReturn() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'exceptionThrownInStreamReturn',
        {},
        {},
      );

  _ida.Stream<int> throwsSerializableExceptionStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'methodStreaming',
        'throwsSerializableExceptionStream',
        {},
        {},
      );

  _ida.Future<bool> didInputStreamHaveError(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Future<bool>, bool>(
        'methodStreaming',
        'didInputStreamHaveError',
        {},
        {'stream': stream},
      );

  _ida.Future<bool> didInputStreamHaveSerializableExceptionError(
    _ida.Stream<int> stream,
  ) => caller.callStreamingServerEndpoint<_ida.Future<bool>, bool>(
    'methodStreaming',
    'didInputStreamHaveSerializableExceptionError',
    {},
    {'stream': stream},
  );
}

/// {@category Endpoint}
class EndpointAuthenticatedMethodStreaming extends _isc.EndpointRef {
  EndpointAuthenticatedMethodStreaming(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'authenticatedMethodStreaming';

  _ida.Stream<int> simpleStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'authenticatedMethodStreaming',
        'simpleStream',
        {},
        {},
      );

  _ida.Stream<int> intEchoStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'authenticatedMethodStreaming',
        'intEchoStream',
        {},
        {'stream': stream},
      );
}

/// Plain extension of the existing endpoint
/// {@category Endpoint}
class EndpointModuleEndpointSubclass extends _isc.EndpointRef {
  EndpointModuleEndpointSubclass(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointSubclass';

  _ida.Future<String> echoString(String value) =>
      caller.callServerEndpoint<String>(
        'moduleEndpointSubclass',
        'echoString',
        {'value': value},
      );

  _ida.Future<(int, BigInt)> echoRecord((int, BigInt) value) =>
      caller.callServerEndpoint<(int, BigInt)>(
        'moduleEndpointSubclass',
        'echoRecord',
        {'value': _iza9lbb5.Protocol().mapRecordToJson(value)},
      );

  _ida.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointSubclass',
        'echoContainer',
        {'value': value},
      );

  _ida.Future<_i89s5423.ModuleClass> echoModel(_i89s5423.ModuleClass value) =>
      caller.callServerEndpoint<_i89s5423.ModuleClass>(
        'moduleEndpointSubclass',
        'echoModel',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointModuleEndpointAdaptation extends _isc.EndpointRef {
  EndpointModuleEndpointAdaptation(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointAdaptation';

  _ida.Future<String> echoString(String value) =>
      caller.callServerEndpoint<String>(
        'moduleEndpointAdaptation',
        'echoString',
        {'value': value},
      );

  /// Extended `echoRecord` which takes an optional argument for a multiplier
  ///
  /// This shows a backwards-compatible extension of the method, which is enforced by the Dart type system.
  _ida.Future<(int, BigInt)> echoRecord(
    (int, BigInt) value, [
    int? multiplier,
  ]) => caller.callServerEndpoint<(int, BigInt)>(
    'moduleEndpointAdaptation',
    'echoRecord',
    {
      'value': _iza9lbb5.Protocol().mapRecordToJson(value),
      'multiplier': multiplier,
    },
  );

  _ida.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointAdaptation',
        'echoContainer',
        {'value': value},
      );

  _ida.Future<_i89s5423.ModuleClass> echoModel(_i89s5423.ModuleClass value) =>
      caller.callServerEndpoint<_i89s5423.ModuleClass>(
        'moduleEndpointAdaptation',
        'echoModel',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointModuleEndpointReduction extends _isc.EndpointRef {
  EndpointModuleEndpointReduction(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointReduction';

  _ida.Future<(int, BigInt)> echoRecord((int, BigInt) value) =>
      caller.callServerEndpoint<(int, BigInt)>(
        'moduleEndpointReduction',
        'echoRecord',
        {'value': _iza9lbb5.Protocol().mapRecordToJson(value)},
      );

  _ida.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointReduction',
        'echoContainer',
        {'value': value},
      );

  _ida.Future<_i89s5423.ModuleClass> echoModel(_i89s5423.ModuleClass value) =>
      caller.callServerEndpoint<_i89s5423.ModuleClass>(
        'moduleEndpointReduction',
        'echoModel',
        {'value': value},
      );
}

/// Subclass inheriting all base class methods and adding a furhter method itself
/// {@category Endpoint}
class EndpointModuleEndpointExtension extends _isc.EndpointRef {
  EndpointModuleEndpointExtension(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointExtension';

  _ida.Future<String> greet(String name) => caller.callServerEndpoint<String>(
    'moduleEndpointExtension',
    'greet',
    {'name': name},
  );

  _ida.Future<void> ignoredMethod() => caller.callServerEndpoint<void>(
    'moduleEndpointExtension',
    'ignoredMethod',
    {},
  );

  _ida.Future<String> echoString(String value) =>
      caller.callServerEndpoint<String>(
        'moduleEndpointExtension',
        'echoString',
        {'value': value},
      );

  _ida.Future<(int, BigInt)> echoRecord((int, BigInt) value) =>
      caller.callServerEndpoint<(int, BigInt)>(
        'moduleEndpointExtension',
        'echoRecord',
        {'value': _iza9lbb5.Protocol().mapRecordToJson(value)},
      );

  _ida.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointExtension',
        'echoContainer',
        {'value': value},
      );

  _ida.Future<_i89s5423.ModuleClass> echoModel(_i89s5423.ModuleClass value) =>
      caller.callServerEndpoint<_i89s5423.ModuleClass>(
        'moduleEndpointExtension',
        'echoModel',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointModuleSerialization extends _isc.EndpointRef {
  EndpointModuleSerialization(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleSerialization';

  _ida.Future<bool> serializeModuleObject() => caller.callServerEndpoint<bool>(
    'moduleSerialization',
    'serializeModuleObject',
    {},
  );

  _ida.Future<_i89s5423.ModuleClass> modifyModuleObject(
    _i89s5423.ModuleClass object,
  ) => caller.callServerEndpoint<_i89s5423.ModuleClass>(
    'moduleSerialization',
    'modifyModuleObject',
    {'object': object},
  );

  _ida.Future<_iyerxm0e.SharedModuleTable> modifySharedModuleTable(
    _iyerxm0e.SharedModuleTable object,
  ) => caller.callServerEndpoint<_iyerxm0e.SharedModuleTable>(
    'moduleSerialization',
    'modifySharedModuleTable',
    {'object': object},
  );

  _ida.Future<_igh53y2y.ModuleDatatype> serializeNestedModuleObject() =>
      caller.callServerEndpoint<_igh53y2y.ModuleDatatype>(
        'moduleSerialization',
        'serializeNestedModuleObject',
        {},
      );
}

/// {@category Endpoint}
class EndpointNamedParameters extends _isc.EndpointRef {
  EndpointNamedParameters(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'namedParameters';

  _ida.Future<bool> namedParametersMethod({
    required int namedInt,
    required int intWithDefaultValue,
    int? nullableInt,
    int? nullableIntWithDefaultValue,
  }) => caller.callServerEndpoint<bool>(
    'namedParameters',
    'namedParametersMethod',
    {
      'namedInt': namedInt,
      'intWithDefaultValue': intWithDefaultValue,
      'nullableInt': nullableInt,
      'nullableIntWithDefaultValue': nullableIntWithDefaultValue,
    },
  );

  _ida.Future<bool> namedParametersMethodEqualInts({
    required int namedInt,
    int? nullableInt,
  }) => caller.callServerEndpoint<bool>(
    'namedParameters',
    'namedParametersMethodEqualInts',
    {
      'namedInt': namedInt,
      'nullableInt': nullableInt,
    },
  );
}

/// {@category Endpoint}
class EndpointOptionalParameters extends _isc.EndpointRef {
  EndpointOptionalParameters(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'optionalParameters';

  _ida.Future<int?> returnOptionalInt([int? optionalInt]) =>
      caller.callServerEndpoint<int?>(
        'optionalParameters',
        'returnOptionalInt',
        {'optionalInt': optionalInt},
      );
}

/// Endpoint for testing polymorphism functionality.
/// {@category Endpoint}
class EndpointInheritancePolymorphismTest extends _isc.EndpointRef {
  EndpointInheritancePolymorphismTest(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'inheritancePolymorphismTest';

  /// Receives a PolymorphicParent object for testing serialization.
  ///
  /// Returns the runtime type and the object itself. The object must retain
  /// its class when received by the client.
  _ida.Future<(String, _itefpq8v.PolymorphicParent)> polymorphicRoundtrip(
    _itefpq8v.PolymorphicParent parent,
  ) => caller.callServerEndpoint<(String, _itefpq8v.PolymorphicParent)>(
    'inheritancePolymorphismTest',
    'polymorphicRoundtrip',
    {'parent': parent},
  );

  /// Receives a PolymorphicParent object through streaming for testing.
  ///
  /// Yields the runtime type and the object itself. The object must retain its
  /// class when received by the client.
  _ida.Stream<(String, _itefpq8v.PolymorphicParent)>
  polymorphicStreamingRoundtrip(
    _ida.Stream<_itefpq8v.PolymorphicParent> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<(String, _itefpq8v.PolymorphicParent)>,
        (String, _itefpq8v.PolymorphicParent)
      >(
        'inheritancePolymorphismTest',
        'polymorphicStreamingRoundtrip',
        {},
        {'stream': stream},
      );

  /// Receives a PolymorphicChildContainer object for testing serialization.
  ///
  /// Returns the container object itself. All nested polymorphic objects must
  /// retain their runtime types when received by the client.
  _ida.Future<_ij4seqzx.PolymorphicChildContainer>
  polymorphicContainerRoundtrip(
    _ij4seqzx.PolymorphicChildContainer container,
  ) => caller.callServerEndpoint<_ij4seqzx.PolymorphicChildContainer>(
    'inheritancePolymorphismTest',
    'polymorphicContainerRoundtrip',
    {'container': container},
  );

  /// Receives a ModulePolymorphicChildContainer object for testing serialization.
  ///
  /// Returns the container object itself. All nested polymorphic objects must
  /// retain their runtime types when received by the client.
  _ida.Future<_ijjdovst.ModulePolymorphicChildContainer>
  polymorphicModuleContainerRoundtrip(
    _ijjdovst.ModulePolymorphicChildContainer container,
  ) => caller.callServerEndpoint<_ijjdovst.ModulePolymorphicChildContainer>(
    'inheritancePolymorphismTest',
    'polymorphicModuleContainerRoundtrip',
    {'container': container},
  );
}

/// {@category Endpoint}
class EndpointRecordParameters extends _isc.EndpointRef {
  EndpointRecordParameters(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recordParameters';

  _ida.Future<(int,)> returnRecordOfInt((int,) record) =>
      caller.callServerEndpoint<(int,)>(
        'recordParameters',
        'returnRecordOfInt',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<(int,)?> returnNullableRecordOfInt((int,)? record) =>
      caller.callServerEndpoint<(int,)?>(
        'recordParameters',
        'returnNullableRecordOfInt',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<(int?,)> returnRecordOfNullableInt((int?,) record) =>
      caller.callServerEndpoint<(int?,)>(
        'recordParameters',
        'returnRecordOfNullableInt',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<(int?,)?> returnNullableRecordOfNullableInt((int?,)? record) =>
      caller.callServerEndpoint<(int?,)?>(
        'recordParameters',
        'returnNullableRecordOfNullableInt',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Stream<(int?,)?> streamNullableRecordOfNullableInt(
    _ida.Stream<(int?,)?> values,
  ) => caller.callStreamingServerEndpoint<_ida.Stream<(int?,)?>, (int?,)?>(
    'recordParameters',
    'streamNullableRecordOfNullableInt',
    {},
    {'values': values},
  );

  _ida.Future<(int, String)> returnIntStringRecord((int, String) record) =>
      caller.callServerEndpoint<(int, String)>(
        'recordParameters',
        'returnIntStringRecord',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<(int, String)?> returnNullableIntStringRecord(
    (int, String)? record,
  ) => caller.callServerEndpoint<(int, String)?>(
    'recordParameters',
    'returnNullableIntStringRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<(int, _i68e2f8e.SimpleData)> returnIntSimpleDataRecord(
    (int, _i68e2f8e.SimpleData) record,
  ) => caller.callServerEndpoint<(int, _i68e2f8e.SimpleData)>(
    'recordParameters',
    'returnIntSimpleDataRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<(int, _i68e2f8e.SimpleData)?> returnNullableIntSimpleDataRecord(
    (int, _i68e2f8e.SimpleData)? record,
  ) => caller.callServerEndpoint<(int, _i68e2f8e.SimpleData)?>(
    'recordParameters',
    'returnNullableIntSimpleDataRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<(Map<String, int>,)> returnStringKeyedMapRecord(
    (Map<String, int>,) record,
  ) => caller.callServerEndpoint<(Map<String, int>,)>(
    'recordParameters',
    'returnStringKeyedMapRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<(Map<int, int>,)> returnNonStringKeyedMapRecord(
    (Map<int, int>,) record,
  ) => caller.callServerEndpoint<(Map<int, int>,)>(
    'recordParameters',
    'returnNonStringKeyedMapRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<(Set<(int,)>,)> returnSetWithNestedRecordRecord(
    (Set<(int,)>,) record,
  ) => caller.callServerEndpoint<(Set<(int,)>,)>(
    'recordParameters',
    'returnSetWithNestedRecordRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<({int number, String text})> returnNamedIntStringRecord(
    ({int number, String text}) record,
  ) => caller.callServerEndpoint<({int number, String text})>(
    'recordParameters',
    'returnNamedIntStringRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<({int number, String text})?> returnNamedNullableIntStringRecord(
    ({int number, String text})? record,
  ) => caller.callServerEndpoint<({int number, String text})?>(
    'recordParameters',
    'returnNamedNullableIntStringRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<({_i68e2f8e.SimpleData data, int number})>
  returnRecordOfNamedIntAndObject(
    ({_i68e2f8e.SimpleData data, int number}) record,
  ) => caller.callServerEndpoint<({_i68e2f8e.SimpleData data, int number})>(
    'recordParameters',
    'returnRecordOfNamedIntAndObject',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<({_i68e2f8e.SimpleData data, int number})?>
  returnNullableRecordOfNamedIntAndObject(
    ({_i68e2f8e.SimpleData data, int number})? record,
  ) => caller.callServerEndpoint<({_i68e2f8e.SimpleData data, int number})?>(
    'recordParameters',
    'returnNullableRecordOfNamedIntAndObject',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<({_i68e2f8e.SimpleData? data, int? number})>
  returnRecordOfNamedNullableIntAndNullableObject(
    ({_i68e2f8e.SimpleData? data, int? number}) record,
  ) => caller.callServerEndpoint<({_i68e2f8e.SimpleData? data, int? number})>(
    'recordParameters',
    'returnRecordOfNamedNullableIntAndNullableObject',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<({Map<int, int> intIntMap})> returnNamedNonStringKeyedMapRecord(
    ({Map<int, int> intIntMap}) record,
  ) => caller.callServerEndpoint<({Map<int, int> intIntMap})>(
    'recordParameters',
    'returnNamedNonStringKeyedMapRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<({Set<(bool,)> boolSet})> returnNamedSetWithNestedRecordRecord(
    ({Set<(bool,)> boolSet}) record,
  ) => caller.callServerEndpoint<({Set<(bool,)> boolSet})>(
    'recordParameters',
    'returnNamedSetWithNestedRecordRecord',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<(Map<(Map<int, String>, String), String>,)>
  returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord(
    (Map<(Map<int, String>, String), String>,) map,
  ) => caller.callServerEndpoint<(Map<(Map<int, String>, String), String>,)>(
    'recordParameters',
    'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord',
    {'map': _iza9lbb5.Protocol().mapRecordToJson(map)},
  );

  _ida.Future<(int, {_i68e2f8e.SimpleData data})> returnRecordTypedef(
    (int, {_i68e2f8e.SimpleData data}) record,
  ) => caller.callServerEndpoint<(int, {_i68e2f8e.SimpleData data})>(
    'recordParameters',
    'returnRecordTypedef',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<(int, {_i68e2f8e.SimpleData data})?> returnNullableRecordTypedef(
    (int, {_i68e2f8e.SimpleData data})? record,
  ) => caller.callServerEndpoint<(int, {_i68e2f8e.SimpleData data})?>(
    'recordParameters',
    'returnNullableRecordTypedef',
    {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
  );

  _ida.Future<List<(int, _i68e2f8e.SimpleData)>>
  returnListOfIntSimpleDataRecord(
    List<(int, _i68e2f8e.SimpleData)> recordList,
  ) => caller.callServerEndpoint<List<(int, _i68e2f8e.SimpleData)>>(
    'recordParameters',
    'returnListOfIntSimpleDataRecord',
    {'recordList': _iza9lbb5.Protocol().mapContainerToJson(recordList)},
  );

  _ida.Future<List<(int, _i68e2f8e.SimpleData)?>>
  returnListOfNullableIntSimpleDataRecord(
    List<(int, _i68e2f8e.SimpleData)?> record,
  ) => caller.callServerEndpoint<List<(int, _i68e2f8e.SimpleData)?>>(
    'recordParameters',
    'returnListOfNullableIntSimpleDataRecord',
    {'record': _iza9lbb5.Protocol().mapContainerToJson(record)},
  );

  _ida.Future<Set<(int, _i68e2f8e.SimpleData)>> returnSetOfIntSimpleDataRecord(
    Set<(int, _i68e2f8e.SimpleData)> recordSet,
  ) => caller.callServerEndpoint<Set<(int, _i68e2f8e.SimpleData)>>(
    'recordParameters',
    'returnSetOfIntSimpleDataRecord',
    {'recordSet': _iza9lbb5.Protocol().mapContainerToJson(recordSet)},
  );

  _ida.Future<Set<(int, _i68e2f8e.SimpleData)?>>
  returnSetOfNullableIntSimpleDataRecord(
    Set<(int, _i68e2f8e.SimpleData)?> set,
  ) => caller.callServerEndpoint<Set<(int, _i68e2f8e.SimpleData)?>>(
    'recordParameters',
    'returnSetOfNullableIntSimpleDataRecord',
    {'set': _iza9lbb5.Protocol().mapContainerToJson(set)},
  );

  _ida.Future<Set<(int, _i68e2f8e.SimpleData)>?>
  returnNullableSetOfIntSimpleDataRecord(
    Set<(int, _i68e2f8e.SimpleData)>? recordSet,
  ) => caller.callServerEndpoint<Set<(int, _i68e2f8e.SimpleData)>?>(
    'recordParameters',
    'returnNullableSetOfIntSimpleDataRecord',
    {
      'recordSet': recordSet == null
          ? null
          : _iza9lbb5.Protocol().mapContainerToJson(recordSet),
    },
  );

  _ida.Future<Map<String, (int, _i68e2f8e.SimpleData)>>
  returnStringMapOfIntSimpleDataRecord(
    Map<String, (int, _i68e2f8e.SimpleData)> map,
  ) => caller.callServerEndpoint<Map<String, (int, _i68e2f8e.SimpleData)>>(
    'recordParameters',
    'returnStringMapOfIntSimpleDataRecord',
    {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<String, (int, _i68e2f8e.SimpleData)?>>
  returnStringMapOfNullableIntSimpleDataRecord(
    Map<String, (int, _i68e2f8e.SimpleData)?> map,
  ) => caller.callServerEndpoint<Map<String, (int, _i68e2f8e.SimpleData)?>>(
    'recordParameters',
    'returnStringMapOfNullableIntSimpleDataRecord',
    {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
  );

  _ida.Future<Map<(String, int), (int, _i68e2f8e.SimpleData)>>
  returnRecordMapOfIntSimpleDataRecord(
    Map<(String, int), (int, _i68e2f8e.SimpleData)> map,
  ) => caller
      .callServerEndpoint<Map<(String, int), (int, _i68e2f8e.SimpleData)>>(
        'recordParameters',
        'returnRecordMapOfIntSimpleDataRecord',
        {'map': _iza9lbb5.Protocol().mapContainerToJson(map)},
      );

  /// Returns the first and only input value mapped into the return structure (basically reversed)
  _ida.Future<Map<String, List<Set<(int,)>>>> returnStringMapOfListOfRecord(
    Set<List<Map<String, (int,)>>> input,
  ) => caller.callServerEndpoint<Map<String, List<Set<(int,)>>>>(
    'recordParameters',
    'returnStringMapOfListOfRecord',
    {'input': _iza9lbb5.Protocol().mapContainerToJson(input)},
  );

  _ida.Future<({(_i68e2f8e.SimpleData, double) namedSubRecord})>
  returnNestedNamedRecord(
    ({(_i68e2f8e.SimpleData, double) namedSubRecord}) record,
  ) => caller
      .callServerEndpoint<({(_i68e2f8e.SimpleData, double) namedSubRecord})>(
        'recordParameters',
        'returnNestedNamedRecord',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<({(_i68e2f8e.SimpleData, double)? namedSubRecord})>
  returnNestedNullableNamedRecord(
    ({(_i68e2f8e.SimpleData, double)? namedSubRecord}) record,
  ) => caller
      .callServerEndpoint<({(_i68e2f8e.SimpleData, double)? namedSubRecord})>(
        'recordParameters',
        'returnNestedNullableNamedRecord',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})>
  returnNestedPositionalAndNamedRecord(
    ((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord}) record,
  ) =>
      caller.callServerEndpoint<
        ((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})
      >(
        'recordParameters',
        'returnNestedPositionalAndNamedRecord',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<
    List<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})>
  >
  returnListOfNestedPositionalAndNamedRecord(
    List<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})>
    recordList,
  ) =>
      caller.callServerEndpoint<
        List<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})>
      >(
        'recordParameters',
        'returnListOfNestedPositionalAndNamedRecord',
        {'recordList': _iza9lbb5.Protocol().mapContainerToJson(recordList)},
      );

  _ida.Stream<
    List<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})?>?
  >
  streamNullableListOfNullableNestedPositionalAndNamedRecord(
    List<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})?>?
    initialValue,
    _ida.Stream<
      List<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})?>?
    >
    values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<
          List<
            ((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})?
          >?
        >,
        List<((int, String), {(_i68e2f8e.SimpleData, double) namedSubRecord})?>?
      >(
        'recordParameters',
        'streamNullableListOfNullableNestedPositionalAndNamedRecord',
        {'initialValue': initialValue},
        {'values': values},
      );

  _ida.Future<_iiuaejha.TypesRecord> echoModelClassWithRecordField(
    _iiuaejha.TypesRecord value,
  ) => caller.callServerEndpoint<_iiuaejha.TypesRecord>(
    'recordParameters',
    'echoModelClassWithRecordField',
    {'value': value},
  );

  _ida.Future<_iiuaejha.TypesRecord?> echoNullableModelClassWithRecordField(
    _iiuaejha.TypesRecord? value,
  ) => caller.callServerEndpoint<_iiuaejha.TypesRecord?>(
    'recordParameters',
    'echoNullableModelClassWithRecordField',
    {'value': value},
  );

  _ida.Future<_i89s5423.ModuleClass?>
  echoNullableModelClassWithRecordFieldFromExternalModule(
    _i89s5423.ModuleClass? value,
  ) => caller.callServerEndpoint<_i89s5423.ModuleClass?>(
    'recordParameters',
    'echoNullableModelClassWithRecordFieldFromExternalModule',
    {'value': value},
  );

  _ida.Stream<_iiuaejha.TypesRecord> streamOfModelClassWithRecordField(
    _iiuaejha.TypesRecord initialValue,
    _ida.Stream<_iiuaejha.TypesRecord> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iiuaejha.TypesRecord>,
        _iiuaejha.TypesRecord
      >(
        'recordParameters',
        'streamOfModelClassWithRecordField',
        {'initialValue': initialValue},
        {'values': values},
      );

  _ida.Stream<_iiuaejha.TypesRecord?> streamOfNullableModelClassWithRecordField(
    _iiuaejha.TypesRecord? initialValue,
    _ida.Stream<_iiuaejha.TypesRecord?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iiuaejha.TypesRecord?>,
        _iiuaejha.TypesRecord?
      >(
        'recordParameters',
        'streamOfNullableModelClassWithRecordField',
        {'initialValue': initialValue},
        {'values': values},
      );

  _ida.Stream<_i89s5423.ModuleClass?>
  streamOfNullableModelClassWithRecordFieldFromExternalModule(
    _i89s5423.ModuleClass? initialValue,
    _ida.Stream<_i89s5423.ModuleClass?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i89s5423.ModuleClass?>,
        _i89s5423.ModuleClass?
      >(
        'recordParameters',
        'streamOfNullableModelClassWithRecordFieldFromExternalModule',
        {'initialValue': initialValue},
        {'values': values},
      );

  _ida.Stream<(int?, _i89s5423.ProjectStreamingClass?)>
  streamOfNullableIntAndModuleClass(
    _ida.Stream<(int?, _i89s5423.ProjectStreamingClass?)> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<(int?, _i89s5423.ProjectStreamingClass?)>,
        (int?, _i89s5423.ProjectStreamingClass?)
      >(
        'recordParameters',
        'streamOfNullableIntAndModuleClass',
        {},
        {'values': values},
      );

  _ida.Future<int> recordParametersWithCustomNames(
    (int,) positionalRecord, {
    required (int,) namedRecord,
  }) => caller.callServerEndpoint<int>(
    'recordParameters',
    'recordParametersWithCustomNames',
    {
      'positionalRecord': _iza9lbb5.Protocol().mapRecordToJson(
        positionalRecord,
      ),
      'namedRecord': _iza9lbb5.Protocol().mapRecordToJson(namedRecord),
    },
  );
}

/// {@category Endpoint}
class EndpointRedis extends _isc.EndpointRef {
  EndpointRedis(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'redis';

  _ida.Future<void> setSimpleData(
    String key,
    _i68e2f8e.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'redis',
    'setSimpleData',
    {
      'key': key,
      'data': data,
    },
  );

  _ida.Future<void> setSimpleDataWithLifetime(
    String key,
    _i68e2f8e.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'redis',
    'setSimpleDataWithLifetime',
    {
      'key': key,
      'data': data,
    },
  );

  _ida.Future<_i68e2f8e.SimpleData?> getSimpleData(String key) =>
      caller.callServerEndpoint<_i68e2f8e.SimpleData?>(
        'redis',
        'getSimpleData',
        {'key': key},
      );

  _ida.Future<void> deleteSimpleData(String key) =>
      caller.callServerEndpoint<void>(
        'redis',
        'deleteSimpleData',
        {'key': key},
      );

  _ida.Future<void> resetMessageCentralTest() =>
      caller.callServerEndpoint<void>(
        'redis',
        'resetMessageCentralTest',
        {},
      );

  _ida.Future<_i68e2f8e.SimpleData?> listenToChannel(String channel) =>
      caller.callServerEndpoint<_i68e2f8e.SimpleData?>(
        'redis',
        'listenToChannel',
        {'channel': channel},
      );

  _ida.Future<void> postToChannel(
    String channel,
    _i68e2f8e.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'redis',
    'postToChannel',
    {
      'channel': channel,
      'data': data,
    },
  );

  _ida.Future<int> countSubscribedChannels() => caller.callServerEndpoint<int>(
    'redis',
    'countSubscribedChannels',
    {},
  );
}

/// {@category Endpoint}
class EndpointServerOnlyScopedFieldModel extends _isc.EndpointRef {
  EndpointServerOnlyScopedFieldModel(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'serverOnlyScopedFieldModel';

  _ida.Future<_igbepoe4.ScopeServerOnlyField> getScopeServerOnlyField() =>
      caller.callServerEndpoint<_igbepoe4.ScopeServerOnlyField>(
        'serverOnlyScopedFieldModel',
        'getScopeServerOnlyField',
        {},
      );
}

/// {@category Endpoint}
class EndpointServerOnlyScopedFieldChildModel extends _isc.EndpointRef {
  EndpointServerOnlyScopedFieldChildModel(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'serverOnlyScopedFieldChildModel';

  _ida.Future<_ie2anuek.ScopeServerOnlyFieldChild> getProtocolField() =>
      caller.callServerEndpoint<_ie2anuek.ScopeServerOnlyFieldChild>(
        'serverOnlyScopedFieldChildModel',
        'getProtocolField',
        {},
      );
}

/// {@category Endpoint}
class EndpointSessionAuthentication extends _isc.EndpointRef {
  EndpointSessionAuthentication(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sessionAuthentication';

  /// Returns authenticated user identifier or null
  _ida.Future<String?> getAuthenticatedUserId() =>
      caller.callServerEndpoint<String?>(
        'sessionAuthentication',
        'getAuthenticatedUserId',
        {},
      );

  /// Returns all scope names
  _ida.Future<List<String>> getAuthenticatedScopes() =>
      caller.callServerEndpoint<List<String>>(
        'sessionAuthentication',
        'getAuthenticatedScopes',
        {},
      );

  /// Returns authenticated auth ID or null
  _ida.Future<String?> getAuthenticatedAuthId() =>
      caller.callServerEndpoint<String?>(
        'sessionAuthentication',
        'getAuthenticatedAuthId',
        {},
      );

  /// Returns full authentication info
  _ida.Future<_iqsl8fox.SessionAuthInfo> getAuthenticationInfo() =>
      caller.callServerEndpoint<_iqsl8fox.SessionAuthInfo>(
        'sessionAuthentication',
        'getAuthenticationInfo',
        {},
      );

  /// Returns authentication status as boolean
  _ida.Future<bool> isAuthenticated() => caller.callServerEndpoint<bool>(
    'sessionAuthentication',
    'isAuthenticated',
    {},
  );

  /// Stream that yields authenticated user ID
  _ida.Stream<String?> streamAuthenticatedUserId() =>
      caller.callStreamingServerEndpoint<_ida.Stream<String?>, String?>(
        'sessionAuthentication',
        'streamAuthenticatedUserId',
        {},
        {},
      );

  /// Stream that yields authentication status
  _ida.Stream<bool> streamIsAuthenticated() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'sessionAuthentication',
        'streamIsAuthenticated',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointSetParameters extends _isc.EndpointRef {
  EndpointSetParameters(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'setParameters';

  _ida.Future<Set<int>> returnIntSet(Set<int> set) =>
      caller.callServerEndpoint<Set<int>>(
        'setParameters',
        'returnIntSet',
        {'set': set},
      );

  _ida.Future<Set<Set<int>>> returnIntSetSet(Set<Set<int>> set) =>
      caller.callServerEndpoint<Set<Set<int>>>(
        'setParameters',
        'returnIntSetSet',
        {'set': set},
      );

  _ida.Future<Set<List<int>>> returnIntListSet(Set<List<int>> set) =>
      caller.callServerEndpoint<Set<List<int>>>(
        'setParameters',
        'returnIntListSet',
        {'set': set},
      );

  _ida.Future<Set<int>?> returnIntSetNullable(Set<int>? set) =>
      caller.callServerEndpoint<Set<int>?>(
        'setParameters',
        'returnIntSetNullable',
        {'set': set},
      );

  _ida.Future<Set<Set<int>?>> returnIntSetNullableSet(Set<Set<int>?> set) =>
      caller.callServerEndpoint<Set<Set<int>?>>(
        'setParameters',
        'returnIntSetNullableSet',
        {'set': set},
      );

  _ida.Future<Set<Set<int>>?> returnIntSetSetNullable(Set<Set<int>>? set) =>
      caller.callServerEndpoint<Set<Set<int>>?>(
        'setParameters',
        'returnIntSetSetNullable',
        {'set': set},
      );

  _ida.Future<Set<int?>> returnIntSetNullableInts(Set<int?> set) =>
      caller.callServerEndpoint<Set<int?>>(
        'setParameters',
        'returnIntSetNullableInts',
        {'set': set},
      );

  _ida.Future<Set<int?>?> returnNullableIntSetNullableInts(Set<int?>? set) =>
      caller.callServerEndpoint<Set<int?>?>(
        'setParameters',
        'returnNullableIntSetNullableInts',
        {'set': set},
      );

  _ida.Future<Set<double>> returnDoubleSet(Set<double> set) =>
      caller.callServerEndpoint<Set<double>>(
        'setParameters',
        'returnDoubleSet',
        {'set': set},
      );

  _ida.Future<Set<double?>> returnDoubleSetNullableDoubles(Set<double?> set) =>
      caller.callServerEndpoint<Set<double?>>(
        'setParameters',
        'returnDoubleSetNullableDoubles',
        {'set': set},
      );

  _ida.Future<Set<bool>> returnBoolSet(Set<bool> set) =>
      caller.callServerEndpoint<Set<bool>>(
        'setParameters',
        'returnBoolSet',
        {'set': set},
      );

  _ida.Future<Set<bool?>> returnBoolSetNullableBools(Set<bool?> set) =>
      caller.callServerEndpoint<Set<bool?>>(
        'setParameters',
        'returnBoolSetNullableBools',
        {'set': set},
      );

  _ida.Future<Set<String>> returnStringSet(Set<String> set) =>
      caller.callServerEndpoint<Set<String>>(
        'setParameters',
        'returnStringSet',
        {'set': set},
      );

  _ida.Future<Set<String?>> returnStringSetNullableStrings(Set<String?> set) =>
      caller.callServerEndpoint<Set<String?>>(
        'setParameters',
        'returnStringSetNullableStrings',
        {'set': set},
      );

  _ida.Future<Set<DateTime>> returnDateTimeSet(Set<DateTime> set) =>
      caller.callServerEndpoint<Set<DateTime>>(
        'setParameters',
        'returnDateTimeSet',
        {'set': set},
      );

  _ida.Future<Set<DateTime?>> returnDateTimeSetNullableDateTimes(
    Set<DateTime?> set,
  ) => caller.callServerEndpoint<Set<DateTime?>>(
    'setParameters',
    'returnDateTimeSetNullableDateTimes',
    {'set': set},
  );

  _ida.Future<Set<_idt.ByteData>> returnByteDataSet(Set<_idt.ByteData> set) =>
      caller.callServerEndpoint<Set<_idt.ByteData>>(
        'setParameters',
        'returnByteDataSet',
        {'set': set},
      );

  _ida.Future<Set<_idt.ByteData?>> returnByteDataSetNullableByteDatas(
    Set<_idt.ByteData?> set,
  ) => caller.callServerEndpoint<Set<_idt.ByteData?>>(
    'setParameters',
    'returnByteDataSetNullableByteDatas',
    {'set': set},
  );

  _ida.Future<Set<_i68e2f8e.SimpleData>> returnSimpleDataSet(
    Set<_i68e2f8e.SimpleData> set,
  ) => caller.callServerEndpoint<Set<_i68e2f8e.SimpleData>>(
    'setParameters',
    'returnSimpleDataSet',
    {'set': set},
  );

  _ida.Future<Set<_i68e2f8e.SimpleData?>> returnSimpleDataSetNullableSimpleData(
    Set<_i68e2f8e.SimpleData?> set,
  ) => caller.callServerEndpoint<Set<_i68e2f8e.SimpleData?>>(
    'setParameters',
    'returnSimpleDataSetNullableSimpleData',
    {'set': set},
  );

  _ida.Future<Set<Duration>> returnDurationSet(Set<Duration> set) =>
      caller.callServerEndpoint<Set<Duration>>(
        'setParameters',
        'returnDurationSet',
        {'set': set},
      );

  _ida.Future<Set<Duration?>> returnDurationSetNullableDurations(
    Set<Duration?> set,
  ) => caller.callServerEndpoint<Set<Duration?>>(
    'setParameters',
    'returnDurationSetNullableDurations',
    {'set': set},
  );
}

/// {@category Endpoint}
class EndpointSignInRequired extends _isc.EndpointRef {
  EndpointSignInRequired(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'signInRequired';

  _ida.Future<bool> testMethod() => caller.callServerEndpoint<bool>(
    'signInRequired',
    'testMethod',
    {},
  );
}

/// {@category Endpoint}
class EndpointAdminScopeRequired extends _isc.EndpointRef {
  EndpointAdminScopeRequired(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'adminScopeRequired';

  _ida.Future<bool> testMethod() => caller.callServerEndpoint<bool>(
    'adminScopeRequired',
    'testMethod',
    {},
  );
}

/// A simple endpoint that modifies a global integer. This class is meant for
/// testing and the documentation has multiple lines.
/// {@category Endpoint}
class EndpointSimple extends _isc.EndpointRef {
  EndpointSimple(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'simple';

  /// Sets a global integer.
  _ida.Future<void> setGlobalInt(
    int? value, [
    int? secondValue,
  ]) => caller.callServerEndpoint<void>(
    'simple',
    'setGlobalInt',
    {
      'value': value,
      'secondValue': secondValue,
    },
  );

  /// Adds 1 to the global integer.
  _ida.Future<void> addToGlobalInt() => caller.callServerEndpoint<void>(
    'simple',
    'addToGlobalInt',
    {},
  );

  /// Retrieves a global integer.
  _ida.Future<int> getGlobalInt() => caller.callServerEndpoint<int>(
    'simple',
    'getGlobalInt',
    {},
  );

  _ida.Future<String> hello(String name) => caller.callServerEndpoint<String>(
    'simple',
    'hello',
    {'name': name},
  );
}

/// {@category Endpoint}
class EndpointSubSubDirTest extends _isc.EndpointRef {
  EndpointSubSubDirTest(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subSubDirTest';

  _ida.Future<String> testMethod() => caller.callServerEndpoint<String>(
    'subSubDirTest',
    'testMethod',
    {},
  );
}

/// {@category Endpoint}
class EndpointSubDirTest extends _isc.EndpointRef {
  EndpointSubDirTest(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'subDirTest';

  _ida.Future<String> testMethod() => caller.callServerEndpoint<String>(
    'subDirTest',
    'testMethod',
    {},
  );
}

/// {@category Endpoint}
class EndpointTestTools extends _isc.EndpointRef {
  EndpointTestTools(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'testTools';

  _ida.Future<_isc.UuidValue> returnsSessionId() =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'testTools',
        'returnsSessionId',
        {},
      );

  _ida.Future<List<String?>> returnsSessionEndpointAndMethod() =>
      caller.callServerEndpoint<List<String?>>(
        'testTools',
        'returnsSessionEndpointAndMethod',
        {},
      );

  _ida.Stream<_isc.UuidValue> returnsSessionIdFromStream() => caller
      .callStreamingServerEndpoint<_ida.Stream<_isc.UuidValue>, _isc.UuidValue>(
        'testTools',
        'returnsSessionIdFromStream',
        {},
        {},
      );

  _ida.Stream<String?> returnsSessionEndpointAndMethodFromStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<String?>, String?>(
        'testTools',
        'returnsSessionEndpointAndMethodFromStream',
        {},
        {},
      );

  _ida.Future<String> returnsString(String string) =>
      caller.callServerEndpoint<String>(
        'testTools',
        'returnsString',
        {'string': string},
      );

  _ida.Stream<int> returnsStream(int n) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'testTools',
        'returnsStream',
        {'n': n},
        {},
      );

  _ida.Future<List<int>> returnsListFromInputStream(_ida.Stream<int> numbers) =>
      caller.callStreamingServerEndpoint<_ida.Future<List<int>>, List<int>>(
        'testTools',
        'returnsListFromInputStream',
        {},
        {'numbers': numbers},
      );

  _ida.Future<List<_i68e2f8e.SimpleData>> returnsSimpleDataListFromInputStream(
    _ida.Stream<_i68e2f8e.SimpleData> simpleDatas,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Future<List<_i68e2f8e.SimpleData>>,
        List<_i68e2f8e.SimpleData>
      >(
        'testTools',
        'returnsSimpleDataListFromInputStream',
        {},
        {'simpleDatas': simpleDatas},
      );

  _ida.Stream<int> returnsStreamFromInputStream(_ida.Stream<int> numbers) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'testTools',
        'returnsStreamFromInputStream',
        {},
        {'numbers': numbers},
      );

  _ida.Stream<_i68e2f8e.SimpleData> returnsSimpleDataStreamFromInputStream(
    _ida.Stream<_i68e2f8e.SimpleData> simpleDatas,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i68e2f8e.SimpleData>,
        _i68e2f8e.SimpleData
      >(
        'testTools',
        'returnsSimpleDataStreamFromInputStream',
        {},
        {'simpleDatas': simpleDatas},
      );

  _ida.Future<void> postNumberToSharedStream(int number) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'postNumberToSharedStream',
        {'number': number},
      );

  _ida.Stream<int> postNumberToSharedStreamAndReturnStream(int number) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'testTools',
        'postNumberToSharedStreamAndReturnStream',
        {'number': number},
        {},
      );

  _ida.Stream<int> listenForNumbersOnSharedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'testTools',
        'listenForNumbersOnSharedStream',
        {},
        {},
      );

  _ida.Future<void> createSimpleData(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleData',
        {'data': data},
      );

  _ida.Future<List<_i68e2f8e.SimpleData>> getAllSimpleData() =>
      caller.callServerEndpoint<List<_i68e2f8e.SimpleData>>(
        'testTools',
        'getAllSimpleData',
        {},
      );

  _ida.Future<void> createSimpleDatasInsideTransactions(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInsideTransactions',
        {'data': data},
      );

  _ida.Future<void> createSimpleDataAndThrowInsideTransaction(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDataAndThrowInsideTransaction',
        {'data': data},
      );

  _ida.Future<void> createSimpleDatasInParallelTransactionCalls() =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInParallelTransactionCalls',
        {},
      );

  _ida.Future<dynamic> echoDynamic(dynamic anything) =>
      caller.callServerEndpoint<dynamic>(
        'testTools',
        'echoDynamic',
        {'anything': anything},
      );

  _ida.Future<_i68e2f8e.SimpleData> echoSimpleData(
    _i68e2f8e.SimpleData simpleData,
  ) => caller.callServerEndpoint<_i68e2f8e.SimpleData>(
    'testTools',
    'echoSimpleData',
    {'simpleData': simpleData},
  );

  _ida.Future<List<_i68e2f8e.SimpleData>> echoSimpleDatas(
    List<_i68e2f8e.SimpleData> simpleDatas,
  ) => caller.callServerEndpoint<List<_i68e2f8e.SimpleData>>(
    'testTools',
    'echoSimpleDatas',
    {'simpleDatas': simpleDatas},
  );

  _ida.Future<_ia1iglq9.ObjectWithDynamic> echoObjectWithDynamic(
    _ia1iglq9.ObjectWithDynamic objectWithDynamic,
  ) => caller.callServerEndpoint<_ia1iglq9.ObjectWithDynamic>(
    'testTools',
    'echoObjectWithDynamic',
    {'objectWithDynamic': objectWithDynamic},
  );

  _ida.Future<_izst1ldh.Types> echoTypes(_izst1ldh.Types typesModel) =>
      caller.callServerEndpoint<_izst1ldh.Types>(
        'testTools',
        'echoTypes',
        {'typesModel': typesModel},
      );

  _ida.Future<List<_izst1ldh.Types>> echoTypesList(
    List<_izst1ldh.Types> typesList,
  ) => caller.callServerEndpoint<List<_izst1ldh.Types>>(
    'testTools',
    'echoTypesList',
    {'typesList': typesList},
  );

  /// Returns a model class which fields reference `ModuleClass` defined in another module
  _ida.Future<_igh53y2y.ModuleDatatype> echoModuleDatatype(
    _igh53y2y.ModuleDatatype moduleDatatype,
  ) => caller.callServerEndpoint<_igh53y2y.ModuleDatatype>(
    'testTools',
    'echoModuleDatatype',
    {'moduleDatatype': moduleDatatype},
  );

  _ida.Stream<_igh53y2y.ModuleDatatype?> streamModuleDatatype(
    _igh53y2y.ModuleDatatype? initialValue,
    _ida.Stream<_igh53y2y.ModuleDatatype?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_igh53y2y.ModuleDatatype?>,
        _igh53y2y.ModuleDatatype?
      >(
        'testTools',
        'streamModuleDatatype',
        {'initialValue': initialValue},
        {'values': values},
      );

  /// Returns the given `ModuleClass` instance
  ///
  /// `ModuleClass` is defined in another module
  _ida.Future<_i89s5423.ModuleClass> echoModuleClass(
    _i89s5423.ModuleClass moduleClass,
  ) => caller.callServerEndpoint<_i89s5423.ModuleClass>(
    'testTools',
    'echoModuleClass',
    {'moduleClass': moduleClass},
  );

  _ida.Stream<_i89s5423.ModuleClass?> streamModuleClass(
    _i89s5423.ModuleClass? initialValue,
    _ida.Stream<_i89s5423.ModuleClass?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_i89s5423.ModuleClass?>,
        _i89s5423.ModuleClass?
      >(
        'testTools',
        'streamModuleClass',
        {'initialValue': initialValue},
        {'values': values},
      );

  _ida.Future<(String, (int, bool))> echoRecord((String, (int, bool)) record) =>
      caller.callServerEndpoint<(String, (int, bool))>(
        'testTools',
        'echoRecord',
        {'record': _iza9lbb5.Protocol().mapRecordToJson(record)},
      );

  _ida.Future<List<(String, (int, bool))>> echoRecords(
    List<(String, (int, bool))> records,
  ) => caller.callServerEndpoint<List<(String, (int, bool))>>(
    'testTools',
    'echoRecords',
    {'records': _iza9lbb5.Protocol().mapContainerToJson(records)},
  );

  _ida.Future<(int, _i68e2f8e.SimpleData)> returnRecordWithSerializableObject(
    int number,
    _i68e2f8e.SimpleData data,
  ) => caller.callServerEndpoint<(int, _i68e2f8e.SimpleData)>(
    'testTools',
    'returnRecordWithSerializableObject',
    {
      'number': number,
      'data': data,
    },
  );

  _ida.Stream<
    (String, (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}))
  >
  recordEchoStream(
    (String, (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}))
    initialValue,
    _ida.Stream<
      (String, (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}))
    >
    stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<
          (
            String,
            (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}),
          )
        >,
        (
          String,
          (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}),
        )
      >(
        'testTools',
        'recordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _ida.Stream<List<(String, int)>> listOfRecordEchoStream(
    List<(String, int)> initialValue,
    _ida.Stream<List<(String, int)>> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<List<(String, int)>>,
        List<(String, int)>
      >(
        'testTools',
        'listOfRecordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _ida.Stream<
    (String, (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}))?
  >
  nullableRecordEchoStream(
    (String, (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}))?
    initialValue,
    _ida.Stream<
      (
        String,
        (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}),
      )?
    >
    stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<
          (
            String,
            (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}),
          )?
        >,
        (
          String,
          (Map<String, int>, {bool flag, _i68e2f8e.SimpleData simpleData}),
        )?
      >(
        'testTools',
        'nullableRecordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _ida.Stream<List<(String, int)>?> nullableListOfRecordEchoStream(
    List<(String, int)>? initialValue,
    _ida.Stream<List<(String, int)>?> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<List<(String, int)>?>,
        List<(String, int)>?
      >(
        'testTools',
        'nullableListOfRecordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _ida.Stream<_iiuaejha.TypesRecord?> modelWithRecordsEchoStream(
    _iiuaejha.TypesRecord? initialValue,
    _ida.Stream<_iiuaejha.TypesRecord?> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iiuaejha.TypesRecord?>,
        _iiuaejha.TypesRecord?
      >(
        'testTools',
        'modelWithRecordsEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _ida.Future<void> logMessageWithSession() => caller.callServerEndpoint<void>(
    'testTools',
    'logMessageWithSession',
    {},
  );

  _ida.Future<void> addWillCloseListenerToSessionAndThrow() =>
      caller.callServerEndpoint<void>(
        'testTools',
        'addWillCloseListenerToSessionAndThrow',
        {},
      );

  _ida.Stream<int> addWillCloseListenerToSessionIntStreamMethodAndThrow() =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'testTools',
        'addWillCloseListenerToSessionIntStreamMethodAndThrow',
        {},
        {},
      );

  _ida.Future<void> putInLocalCache(
    String key,
    _i68e2f8e.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'testTools',
    'putInLocalCache',
    {
      'key': key,
      'data': data,
    },
  );

  _ida.Future<_i68e2f8e.SimpleData?> getFromLocalCache(String key) =>
      caller.callServerEndpoint<_i68e2f8e.SimpleData?>(
        'testTools',
        'getFromLocalCache',
        {'key': key},
      );

  _ida.Future<void> putInLocalPrioCache(
    String key,
    _i68e2f8e.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'testTools',
    'putInLocalPrioCache',
    {
      'key': key,
      'data': data,
    },
  );

  _ida.Future<_i68e2f8e.SimpleData?> getFromLocalPrioCache(String key) =>
      caller.callServerEndpoint<_i68e2f8e.SimpleData?>(
        'testTools',
        'getFromLocalPrioCache',
        {'key': key},
      );

  _ida.Future<void> putInQueryCache(
    String key,
    _i68e2f8e.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'testTools',
    'putInQueryCache',
    {
      'key': key,
      'data': data,
    },
  );

  _ida.Future<_i68e2f8e.SimpleData?> getFromQueryCache(String key) =>
      caller.callServerEndpoint<_i68e2f8e.SimpleData?>(
        'testTools',
        'getFromQueryCache',
        {'key': key},
      );

  _ida.Future<void> putInLocalCacheWithGroup(
    String key,
    _i68e2f8e.SimpleData data,
    String group,
  ) => caller.callServerEndpoint<void>(
    'testTools',
    'putInLocalCacheWithGroup',
    {
      'key': key,
      'data': data,
      'group': group,
    },
  );
}

/// {@category Endpoint}
class EndpointAuthenticatedTestTools extends _isc.EndpointRef {
  EndpointAuthenticatedTestTools(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'authenticatedTestTools';

  _ida.Future<String> returnsString(String string) =>
      caller.callServerEndpoint<String>(
        'authenticatedTestTools',
        'returnsString',
        {'string': string},
      );

  _ida.Stream<int> returnsStream(int n) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'authenticatedTestTools',
        'returnsStream',
        {'n': n},
        {},
      );

  _ida.Future<List<int>> returnsListFromInputStream(_ida.Stream<int> numbers) =>
      caller.callStreamingServerEndpoint<_ida.Future<List<int>>, List<int>>(
        'authenticatedTestTools',
        'returnsListFromInputStream',
        {},
        {'numbers': numbers},
      );

  _ida.Stream<int> intEchoStream(_ida.Stream<int> stream) =>
      caller.callStreamingServerEndpoint<_ida.Stream<int>, int>(
        'authenticatedTestTools',
        'intEchoStream',
        {},
        {'stream': stream},
      );
}

/// {@category Endpoint}
class EndpointUnauthenticated extends _i89s5423.EndpointUnauthenticated {
  EndpointUnauthenticated(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'unauthenticated';

  @override
  _ida.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'unauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  @override
  _ida.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'unauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointPartiallyUnauthenticated
    extends _i89s5423.EndpointPartiallyUnauthenticated {
  EndpointPartiallyUnauthenticated(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'partiallyUnauthenticated';

  @override
  _ida.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'partiallyUnauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  @override
  _ida.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'partiallyUnauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );

  @override
  _ida.Future<bool> authenticatedMethod() => caller.callServerEndpoint<bool>(
    'partiallyUnauthenticated',
    'authenticatedMethod',
    {},
  );

  @override
  _ida.Stream<bool> authenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'partiallyUnauthenticated',
        'authenticatedStream',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointUnauthenticatedRequireLogin
    extends _i89s5423.EndpointUnauthenticated {
  EndpointUnauthenticatedRequireLogin(_isc.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'unauthenticatedRequireLogin';

  @override
  _ida.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'unauthenticatedRequireLogin',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  @override
  _ida.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'unauthenticatedRequireLogin',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointRequireLogin extends _isc.EndpointRef {
  EndpointRequireLogin(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'requireLogin';

  _ida.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'requireLogin',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  _ida.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_ida.Stream<bool>, bool>(
        'requireLogin',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointUpload extends _isc.EndpointRef {
  EndpointUpload(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'upload';

  _ida.Future<bool> uploadByteData(
    String path,
    _idt.ByteData data,
  ) => caller.callServerEndpoint<bool>(
    'upload',
    'uploadByteData',
    {
      'path': path,
      'data': data,
    },
  );
}

/// {@category Endpoint}
class EndpointMyFeature extends _isc.EndpointRef {
  EndpointMyFeature(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myFeature';

  _ida.Future<String> myFeatureMethod() => caller.callServerEndpoint<String>(
    'myFeature',
    'myFeatureMethod',
    {},
  );

  _ida.Future<_ismcc0ff.MyFeatureModel> myFeatureModel() =>
      caller.callServerEndpoint<_ismcc0ff.MyFeatureModel>(
        'myFeature',
        'myFeatureModel',
        {},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i312scxx.Caller(client);
    module = _i89s5423.Caller(client);
    shared_module = _iyerxm0e.Caller(client);
  }

  late final _i312scxx.Caller auth;

  late final _i89s5423.Caller module;

  late final _iyerxm0e.Caller shared_module;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
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
    diagnosticEventTest = EndpointDiagnosticEventTest(this);
    echoRequest = EndpointEchoRequest(this);
    echoRequiredField = EndpointEchoRequiredField(this);
    emailAuthTestMethods = EndpointEmailAuthTestMethods(this);
    concreteBase = EndpointConcreteBase(this);
    concreteSubClass = EndpointConcreteSubClass(this);
    independent = EndpointIndependent(this);
    concreteFromModuleAbstractBase = EndpointConcreteFromModuleAbstractBase(
      this,
    );
    concreteModuleBase = EndpointConcreteModuleBase(this);
    loggedIn = EndpointLoggedIn(this);
    myLoggedIn = EndpointMyLoggedIn(this);
    admin = EndpointAdmin(this);
    myAdmin = EndpointMyAdmin(this);
    myConcreteAdmin = EndpointMyConcreteAdmin(this);
    exceptionTest = EndpointExceptionTest(this);
    failedCalls = EndpointFailedCalls(this);
    fieldScopes = EndpointFieldScopes(this);
    testFutureCalls = EndpointTestFutureCalls(this);
    listParameters = EndpointListParameters(this);
    logging = EndpointLogging(this);
    loggingDisabled = EndpointLoggingDisabled(this);
    mapParameters = EndpointMapParameters(this);
    methodSignaturePermutations = EndpointMethodSignaturePermutations(this);
    methodStreaming = EndpointMethodStreaming(this);
    authenticatedMethodStreaming = EndpointAuthenticatedMethodStreaming(this);
    moduleEndpointSubclass = EndpointModuleEndpointSubclass(this);
    moduleEndpointAdaptation = EndpointModuleEndpointAdaptation(this);
    moduleEndpointReduction = EndpointModuleEndpointReduction(this);
    moduleEndpointExtension = EndpointModuleEndpointExtension(this);
    moduleSerialization = EndpointModuleSerialization(this);
    namedParameters = EndpointNamedParameters(this);
    optionalParameters = EndpointOptionalParameters(this);
    inheritancePolymorphismTest = EndpointInheritancePolymorphismTest(this);
    recordParameters = EndpointRecordParameters(this);
    redis = EndpointRedis(this);
    serverOnlyScopedFieldModel = EndpointServerOnlyScopedFieldModel(this);
    serverOnlyScopedFieldChildModel = EndpointServerOnlyScopedFieldChildModel(
      this,
    );
    sessionAuthentication = EndpointSessionAuthentication(this);
    setParameters = EndpointSetParameters(this);
    signInRequired = EndpointSignInRequired(this);
    adminScopeRequired = EndpointAdminScopeRequired(this);
    simple = EndpointSimple(this);
    subSubDirTest = EndpointSubSubDirTest(this);
    subDirTest = EndpointSubDirTest(this);
    testTools = EndpointTestTools(this);
    authenticatedTestTools = EndpointAuthenticatedTestTools(this);
    unauthenticated = EndpointUnauthenticated(this);
    partiallyUnauthenticated = EndpointPartiallyUnauthenticated(this);
    unauthenticatedRequireLogin = EndpointUnauthenticatedRequireLogin(this);
    requireLogin = EndpointRequireLogin(this);
    upload = EndpointUpload(this);
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

  late final EndpointDiagnosticEventTest diagnosticEventTest;

  late final EndpointEchoRequest echoRequest;

  late final EndpointEchoRequiredField echoRequiredField;

  late final EndpointEmailAuthTestMethods emailAuthTestMethods;

  late final EndpointConcreteBase concreteBase;

  late final EndpointConcreteSubClass concreteSubClass;

  late final EndpointIndependent independent;

  late final EndpointConcreteFromModuleAbstractBase
  concreteFromModuleAbstractBase;

  late final EndpointConcreteModuleBase concreteModuleBase;

  late final EndpointLoggedIn loggedIn;

  late final EndpointMyLoggedIn myLoggedIn;

  late final EndpointAdmin admin;

  late final EndpointMyAdmin myAdmin;

  late final EndpointMyConcreteAdmin myConcreteAdmin;

  late final EndpointExceptionTest exceptionTest;

  late final EndpointFailedCalls failedCalls;

  late final EndpointFieldScopes fieldScopes;

  late final EndpointTestFutureCalls testFutureCalls;

  late final EndpointListParameters listParameters;

  late final EndpointLogging logging;

  late final EndpointLoggingDisabled loggingDisabled;

  late final EndpointMapParameters mapParameters;

  late final EndpointMethodSignaturePermutations methodSignaturePermutations;

  late final EndpointMethodStreaming methodStreaming;

  late final EndpointAuthenticatedMethodStreaming authenticatedMethodStreaming;

  late final EndpointModuleEndpointSubclass moduleEndpointSubclass;

  late final EndpointModuleEndpointAdaptation moduleEndpointAdaptation;

  late final EndpointModuleEndpointReduction moduleEndpointReduction;

  late final EndpointModuleEndpointExtension moduleEndpointExtension;

  late final EndpointModuleSerialization moduleSerialization;

  late final EndpointNamedParameters namedParameters;

  late final EndpointOptionalParameters optionalParameters;

  late final EndpointInheritancePolymorphismTest inheritancePolymorphismTest;

  late final EndpointRecordParameters recordParameters;

  late final EndpointRedis redis;

  late final EndpointServerOnlyScopedFieldModel serverOnlyScopedFieldModel;

  late final EndpointServerOnlyScopedFieldChildModel
  serverOnlyScopedFieldChildModel;

  late final EndpointSessionAuthentication sessionAuthentication;

  late final EndpointSetParameters setParameters;

  late final EndpointSignInRequired signInRequired;

  late final EndpointAdminScopeRequired adminScopeRequired;

  late final EndpointSimple simple;

  late final EndpointSubSubDirTest subSubDirTest;

  late final EndpointSubDirTest subDirTest;

  late final EndpointTestTools testTools;

  late final EndpointAuthenticatedTestTools authenticatedTestTools;

  late final EndpointUnauthenticated unauthenticated;

  late final EndpointPartiallyUnauthenticated partiallyUnauthenticated;

  late final EndpointUnauthenticatedRequireLogin unauthenticatedRequireLogin;

  late final EndpointRequireLogin requireLogin;

  late final EndpointUpload upload;

  late final EndpointMyFeature myFeature;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
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
    'diagnosticEventTest': diagnosticEventTest,
    'echoRequest': echoRequest,
    'echoRequiredField': echoRequiredField,
    'emailAuthTestMethods': emailAuthTestMethods,
    'concreteBase': concreteBase,
    'concreteSubClass': concreteSubClass,
    'independent': independent,
    'concreteFromModuleAbstractBase': concreteFromModuleAbstractBase,
    'concreteModuleBase': concreteModuleBase,
    'loggedIn': loggedIn,
    'myLoggedIn': myLoggedIn,
    'admin': admin,
    'myAdmin': myAdmin,
    'myConcreteAdmin': myConcreteAdmin,
    'exceptionTest': exceptionTest,
    'failedCalls': failedCalls,
    'fieldScopes': fieldScopes,
    'testFutureCalls': testFutureCalls,
    'listParameters': listParameters,
    'logging': logging,
    'loggingDisabled': loggingDisabled,
    'mapParameters': mapParameters,
    'methodSignaturePermutations': methodSignaturePermutations,
    'methodStreaming': methodStreaming,
    'authenticatedMethodStreaming': authenticatedMethodStreaming,
    'moduleEndpointSubclass': moduleEndpointSubclass,
    'moduleEndpointAdaptation': moduleEndpointAdaptation,
    'moduleEndpointReduction': moduleEndpointReduction,
    'moduleEndpointExtension': moduleEndpointExtension,
    'moduleSerialization': moduleSerialization,
    'namedParameters': namedParameters,
    'optionalParameters': optionalParameters,
    'inheritancePolymorphismTest': inheritancePolymorphismTest,
    'recordParameters': recordParameters,
    'redis': redis,
    'serverOnlyScopedFieldModel': serverOnlyScopedFieldModel,
    'serverOnlyScopedFieldChildModel': serverOnlyScopedFieldChildModel,
    'sessionAuthentication': sessionAuthentication,
    'setParameters': setParameters,
    'signInRequired': signInRequired,
    'adminScopeRequired': adminScopeRequired,
    'simple': simple,
    'subSubDirTest': subSubDirTest,
    'subDirTest': subDirTest,
    'testTools': testTools,
    'authenticatedTestTools': authenticatedTestTools,
    'unauthenticated': unauthenticated,
    'partiallyUnauthenticated': partiallyUnauthenticated,
    'unauthenticatedRequireLogin': unauthenticatedRequireLogin,
    'requireLogin': requireLogin,
    'upload': upload,
    'myFeature': myFeature,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'module': modules.module,
    'shared_module': modules.shared_module,
  };
}
