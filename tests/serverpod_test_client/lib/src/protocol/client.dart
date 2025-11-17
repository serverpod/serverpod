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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'dart:typed_data' as _i3;
import 'package:serverpod_test_shared/src/protocol_custom_classes.dart' as _i4;
import 'package:serverpod_test_shared/src/custom_classes.dart' as _i5;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i6;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i7;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i8;
import 'package:serverpod_test_client/src/protocol/simple_data_list.dart'
    as _i9;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i10;
import 'package:serverpod_test_client/src/protocol/object_with_enum.dart'
    as _i11;
import 'package:serverpod_test_client/src/protocol/object_with_object.dart'
    as _i12;
import 'package:serverpod_test_client/src/protocol/required/model_with_required_field.dart'
    as _i13;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i14;
import 'package:serverpod_test_client/src/protocol/object_field_scopes.dart'
    as _i15;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i16;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i17;
import 'package:serverpod_test_client/src/protocol/module_datatype.dart'
    as _i18;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/parent.dart'
    as _i19;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/container.dart'
    as _i20;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/container_module.dart'
    as _i21;
import 'package:serverpod_test_client/src/protocol/types_record.dart' as _i22;
import 'package:serverpod_test_client/src/protocol/scopes/scope_server_only_field.dart'
    as _i23;
import 'package:serverpod_test_client/src/protocol/scopes/scope_server_only_field_child.dart'
    as _i24;
import 'package:serverpod_test_client/src/protocol/session_auth_info.dart'
    as _i25;
import 'package:serverpod_test_client/src/protocol/my_feature/models/my_feature_model.dart'
    as _i26;
import 'protocol.dart' as _i27;

/// {@category Endpoint}
class EndpointAsyncTasks extends _i1.EndpointRef {
  EndpointAsyncTasks(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'asyncTasks';

  _i2.Future<void> insertRowToSimpleDataAfterDelay(
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

  _i2.Future<void> throwExceptionAfterDelay(int seconds) =>
      caller.callServerEndpoint<void>(
        'asyncTasks',
        'throwExceptionAfterDelay',
        {'seconds': seconds},
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

  _i2.Future<_i3.ByteData?> testByteData(_i3.ByteData? value) =>
      caller.callServerEndpoint<_i3.ByteData?>(
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

  _i2.Future<_i1.UuidValue?> testUuid(_i1.UuidValue? value) =>
      caller.callServerEndpoint<_i1.UuidValue?>(
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

  _i2.Stream<_i3.ByteData?> testByteData(
    _i2.Stream<_i3.ByteData?> value,
  ) => caller
      .callStreamingServerEndpoint<_i2.Stream<_i3.ByteData?>, _i3.ByteData?>(
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

  _i2.Stream<_i1.UuidValue?> testUuid(
    _i2.Stream<_i1.UuidValue?> value,
  ) => caller
      .callStreamingServerEndpoint<_i2.Stream<_i1.UuidValue?>, _i1.UuidValue?>(
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
    _i3.ByteData byteData,
  ) => caller.callServerEndpoint<void>(
    'cloudStorage',
    'storePublicFile',
    {
      'path': path,
      'byteData': byteData,
    },
  );

  _i2.Future<_i3.ByteData?> retrievePublicFile(String path) =>
      caller.callServerEndpoint<_i3.ByteData?>(
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
    _i3.ByteData byteData,
  ) => caller.callServerEndpoint<void>(
    's3CloudStorage',
    'storePublicFile',
    {
      'path': path,
      'byteData': byteData,
    },
  );

  _i2.Future<_i3.ByteData?> retrievePublicFile(String path) =>
      caller.callServerEndpoint<_i3.ByteData?>(
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

  _i2.Future<_i4.ProtocolCustomClass> getProtocolField() =>
      caller.callServerEndpoint<_i4.ProtocolCustomClass>(
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

  _i2.Future<_i5.CustomClass> returnCustomClass(_i5.CustomClass data) =>
      caller.callServerEndpoint<_i5.CustomClass>(
        'customTypes',
        'returnCustomClass',
        {'data': data},
      );

  _i2.Future<_i5.CustomClass?> returnCustomClassNullable(
    _i5.CustomClass? data,
  ) => caller.callServerEndpoint<_i5.CustomClass?>(
    'customTypes',
    'returnCustomClassNullable',
    {'data': data},
  );

  _i2.Future<_i5.CustomClass2> returnCustomClass2(_i5.CustomClass2 data) =>
      caller.callServerEndpoint<_i5.CustomClass2>(
        'customTypes',
        'returnCustomClass2',
        {'data': data},
      );

  _i2.Future<_i5.CustomClass2?> returnCustomClass2Nullable(
    _i5.CustomClass2? data,
  ) => caller.callServerEndpoint<_i5.CustomClass2?>(
    'customTypes',
    'returnCustomClass2Nullable',
    {'data': data},
  );

  _i2.Future<_i6.ExternalCustomClass> returnExternalCustomClass(
    _i6.ExternalCustomClass data,
  ) => caller.callServerEndpoint<_i6.ExternalCustomClass>(
    'customTypes',
    'returnExternalCustomClass',
    {'data': data},
  );

  _i2.Future<_i6.ExternalCustomClass?> returnExternalCustomClassNullable(
    _i6.ExternalCustomClass? data,
  ) => caller.callServerEndpoint<_i6.ExternalCustomClass?>(
    'customTypes',
    'returnExternalCustomClassNullable',
    {'data': data},
  );

  _i2.Future<_i7.FreezedCustomClass> returnFreezedCustomClass(
    _i7.FreezedCustomClass data,
  ) => caller.callServerEndpoint<_i7.FreezedCustomClass>(
    'customTypes',
    'returnFreezedCustomClass',
    {'data': data},
  );

  _i2.Future<_i7.FreezedCustomClass?> returnFreezedCustomClassNullable(
    _i7.FreezedCustomClass? data,
  ) => caller.callServerEndpoint<_i7.FreezedCustomClass?>(
    'customTypes',
    'returnFreezedCustomClassNullable',
    {'data': data},
  );

  _i2.Future<_i5.CustomClassWithoutProtocolSerialization>
  returnCustomClassWithoutProtocolSerialization(
    _i5.CustomClassWithoutProtocolSerialization data,
  ) => caller.callServerEndpoint<_i5.CustomClassWithoutProtocolSerialization>(
    'customTypes',
    'returnCustomClassWithoutProtocolSerialization',
    {'data': data},
  );

  _i2.Future<_i5.CustomClassWithProtocolSerialization>
  returnCustomClassWithProtocolSerialization(
    _i5.CustomClassWithProtocolSerialization data,
  ) => caller.callServerEndpoint<_i5.CustomClassWithProtocolSerialization>(
    'customTypes',
    'returnCustomClassWithProtocolSerialization',
    {'data': data},
  );

  _i2.Future<_i5.CustomClassWithProtocolSerializationMethod>
  returnCustomClassWithProtocolSerializationMethod(
    _i5.CustomClassWithProtocolSerializationMethod data,
  ) =>
      caller.callServerEndpoint<_i5.CustomClassWithProtocolSerializationMethod>(
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

  _i2.Future<List<_i8.SimpleData>> findSimpleData({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i8.SimpleData>>(
    'basicDatabase',
    'findSimpleData',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  _i2.Future<_i8.SimpleData?> findFirstRowSimpleData(int num) =>
      caller.callServerEndpoint<_i8.SimpleData?>(
        'basicDatabase',
        'findFirstRowSimpleData',
        {'num': num},
      );

  _i2.Future<_i8.SimpleData?> findByIdSimpleData(int id) =>
      caller.callServerEndpoint<_i8.SimpleData?>(
        'basicDatabase',
        'findByIdSimpleData',
        {'id': id},
      );

  _i2.Future<_i9.SimpleDataList?> findSimpleDataRowsLessThan(
    int num,
    int offset,
    int limit,
    bool descending,
  ) => caller.callServerEndpoint<_i9.SimpleDataList?>(
    'basicDatabase',
    'findSimpleDataRowsLessThan',
    {
      'num': num,
      'offset': offset,
      'limit': limit,
      'descending': descending,
    },
  );

  _i2.Future<_i8.SimpleData> insertRowSimpleData(_i8.SimpleData simpleData) =>
      caller.callServerEndpoint<_i8.SimpleData>(
        'basicDatabase',
        'insertRowSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<_i8.SimpleData> updateRowSimpleData(_i8.SimpleData simpleData) =>
      caller.callServerEndpoint<_i8.SimpleData>(
        'basicDatabase',
        'updateRowSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<int> deleteRowSimpleData(_i8.SimpleData simpleData) =>
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

  _i2.Future<_i10.Types> insertTypes(_i10.Types value) =>
      caller.callServerEndpoint<_i10.Types>(
        'basicDatabase',
        'insertTypes',
        {'value': value},
      );

  _i2.Future<_i10.Types> updateTypes(_i10.Types value) =>
      caller.callServerEndpoint<_i10.Types>(
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

  _i2.Future<_i10.Types?> getTypes(int id) =>
      caller.callServerEndpoint<_i10.Types?>(
        'basicDatabase',
        'getTypes',
        {'id': id},
      );

  _i2.Future<int?> getTypesRawQuery(int id) => caller.callServerEndpoint<int?>(
    'basicDatabase',
    'getTypesRawQuery',
    {'id': id},
  );

  _i2.Future<_i11.ObjectWithEnum> storeObjectWithEnum(
    _i11.ObjectWithEnum object,
  ) => caller.callServerEndpoint<_i11.ObjectWithEnum>(
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

  _i2.Future<_i12.ObjectWithObject> storeObjectWithObject(
    _i12.ObjectWithObject object,
  ) => caller.callServerEndpoint<_i12.ObjectWithObject>(
    'basicDatabase',
    'storeObjectWithObject',
    {'object': object},
  );

  _i2.Future<_i12.ObjectWithObject?> getObjectWithObject(int id) =>
      caller.callServerEndpoint<_i12.ObjectWithObject?>(
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

/// {@category Endpoint}
class EndpointDiagnosticEventTest extends _i1.EndpointRef {
  EndpointDiagnosticEventTest(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'diagnosticEventTest';

  _i2.Future<String> submitExceptionEvent() =>
      caller.callServerEndpoint<String>(
        'diagnosticEventTest',
        'submitExceptionEvent',
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
class EndpointEchoRequiredField extends _i1.EndpointRef {
  EndpointEchoRequiredField(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'echoRequiredField';

  _i2.Future<_i13.ModelWithRequiredField> echoModel(
    _i13.ModelWithRequiredField model,
  ) => caller.callServerEndpoint<_i13.ModelWithRequiredField>(
    'echoRequiredField',
    'echoModel',
    {'model': model},
  );

  _i2.Future<void> throwException() => caller.callServerEndpoint<void>(
    'echoRequiredField',
    'throwException',
    {},
  );
}

/// An abstract endpoint with a virtual method.
/// {@category Endpoint}
abstract class EndpointAbstractBase extends _i1.EndpointRef {
  EndpointAbstractBase(_i1.EndpointCaller caller) : super(caller);

  /// This is a virtual method that must be overriden.
  _i2.Future<String> virtualMethod();

  /// This body should not be present in the generated abstract class.
  _i2.Future<String> abstractBaseMethod();

  /// This body should not be present in the generated abstract class.
  _i2.Stream<String> abstractBaseStreamMethod();
}

/// A concrete endpoint that extends the abstract endpoint.
/// {@category Endpoint}
class EndpointConcreteBase extends EndpointAbstractBase {
  EndpointConcreteBase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'concreteBase';

  @override
  _i2.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteBase',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  _i2.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'concreteBase',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteBase',
    'abstractBaseMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Stream<String> abstractBaseStreamMethod() =>
      caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
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
  EndpointAbstractSubClass(_i1.EndpointCaller caller) : super(caller);

  _i2.Future<String> subClassVirtualMethod();

  @override
  _i2.Future<String> virtualMethod();

  /// A concrete method that should be present in the generated class.
  @override
  _i2.Future<String> concreteMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Stream<String> abstractBaseStreamMethod();
}

/// A concrete endpoint that extends an abstract endpoint with concrete parent.
/// {@category Endpoint}
class EndpointConcreteSubClass extends EndpointAbstractSubClass {
  EndpointConcreteSubClass(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'concreteSubClass';

  @override
  _i2.Future<String> subClassVirtualMethod() =>
      caller.callServerEndpoint<String>(
        'concreteSubClass',
        'subClassVirtualMethod',
        {},
      );

  @override
  _i2.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteSubClass',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  @override
  _i2.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'concreteSubClass',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteSubClass',
    'abstractBaseMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Stream<String> abstractBaseStreamMethod() =>
      caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
        'concreteSubClass',
        'abstractBaseStreamMethod',
        {},
        {},
      );
}

/// A class that carries all methods from the inheritance chain, but do not
/// extend any of the classes. Should inherit [Endpoint] directly.
/// {@category Endpoint}
class EndpointIndependent extends _i1.EndpointRef {
  EndpointIndependent(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'independent';

  _i2.Future<String> subClassVirtualMethod() =>
      caller.callServerEndpoint<String>(
        'independent',
        'subClassVirtualMethod',
        {},
      );

  _i2.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'independent',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  _i2.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'independent',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  _i2.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'independent',
    'abstractBaseMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  _i2.Stream<String> abstractBaseStreamMethod() =>
      caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
        'independent',
        'abstractBaseStreamMethod',
        {},
        {},
      );
}

/// An abstract endpoint that extends an abstract endpoint from another module.
/// {@category Endpoint}
abstract class EndpointAbstractModuleBase extends _i14.EndpointAbstractBase {
  EndpointAbstractModuleBase(_i1.EndpointCaller caller) : super(caller);

  /// This is a virtual method that must be overriden.
  @override
  _i2.Future<String> virtualMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod();
}

/// A concrete endpoint that extends an abstract endpoint from another module.
/// {@category Endpoint}
class EndpointConcreteFromModuleAbstractBase extends _i14.EndpointAbstractBase {
  EndpointConcreteFromModuleAbstractBase(_i1.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'concreteFromModuleAbstractBase';

  @override
  _i2.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteFromModuleAbstractBase',
    'virtualMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteFromModuleAbstractBase',
    'abstractBaseMethod',
    {},
  );
}

/// A concrete endpoint that extends a concrete endpoint from another module.
/// {@category Endpoint}
class EndpointConcreteModuleBase extends _i14.EndpointConcreteBase {
  EndpointConcreteModuleBase(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'concreteModuleBase';

  @override
  _i2.Future<String> virtualMethod() => caller.callServerEndpoint<String>(
    'concreteModuleBase',
    'virtualMethod',
    {},
  );

  /// A concrete method that should be present in the generated class.
  @override
  _i2.Future<String> concreteMethod() => caller.callServerEndpoint<String>(
    'concreteModuleBase',
    'concreteMethod',
    {},
  );

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod() => caller.callServerEndpoint<String>(
    'concreteModuleBase',
    'abstractBaseMethod',
    {},
  );
}

/// An abstract endpoint that extends a concrete endpoint from another module.
/// {@category Endpoint}
abstract class EndpointAbstractModuleSubClass
    extends _i14.EndpointConcreteBase {
  EndpointAbstractModuleSubClass(_i1.EndpointCaller caller) : super(caller);

  @override
  _i2.Future<String> virtualMethod();

  /// A concrete method that should be present in the generated class.
  @override
  _i2.Future<String> concreteMethod();

  /// This body should not be present in the generated abstract class.
  @override
  _i2.Future<String> abstractBaseMethod();
}

/// {@category Endpoint}
class EndpointLoggedIn extends _i1.EndpointRef {
  EndpointLoggedIn(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'loggedIn';
}

/// {@category Endpoint}
class EndpointMyLoggedIn extends EndpointLoggedIn {
  EndpointMyLoggedIn(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myLoggedIn';

  _i2.Future<String> echo(String value) => caller.callServerEndpoint<String>(
    'myLoggedIn',
    'echo',
    {'value': value},
  );
}

/// {@category Endpoint}
class EndpointAdmin extends EndpointLoggedIn {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';
}

/// {@category Endpoint}
class EndpointMyAdmin extends EndpointAdmin {
  EndpointMyAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myAdmin';

  _i2.Future<String> echo(String value) => caller.callServerEndpoint<String>(
    'myAdmin',
    'echo',
    {'value': value},
  );
}

/// {@category Endpoint}
abstract class EndpointAbstractLoggedIn extends _i1.EndpointRef {
  EndpointAbstractLoggedIn(_i1.EndpointCaller caller) : super(caller);
}

/// {@category Endpoint}
abstract class EndpointAbstractAdmin extends EndpointAbstractLoggedIn {
  EndpointAbstractAdmin(_i1.EndpointCaller caller) : super(caller);
}

/// {@category Endpoint}
class EndpointMyConcreteAdmin extends EndpointAbstractAdmin {
  EndpointMyConcreteAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myConcreteAdmin';

  _i2.Future<String> echo(String value) => caller.callServerEndpoint<String>(
    'myConcreteAdmin',
    'echo',
    {'value': value},
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

  _i2.Future<void> makeFutureCall(_i8.SimpleData? data) =>
      caller.callServerEndpoint<void>(
        'futureCalls',
        'makeFutureCall',
        {'data': data},
      );

  _i2.Future<void> makeFutureCallThatThrows(_i8.SimpleData? data) =>
      caller.callServerEndpoint<void>(
        'futureCalls',
        'makeFutureCallThatThrows',
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
    List<List<int>?> list,
  ) => caller.callServerEndpoint<List<List<int>?>>(
    'listParameters',
    'returnIntListNullableList',
    {'list': list},
  );

  _i2.Future<List<List<int>>?> returnIntListListNullable(
    List<List<int>>? list,
  ) => caller.callServerEndpoint<List<List<int>>?>(
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
    List<double?> list,
  ) => caller.callServerEndpoint<List<double?>>(
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
    List<String?> list,
  ) => caller.callServerEndpoint<List<String?>>(
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
    List<DateTime?> list,
  ) => caller.callServerEndpoint<List<DateTime?>>(
    'listParameters',
    'returnDateTimeListNullableDateTimes',
    {'list': list},
  );

  _i2.Future<List<_i3.ByteData>> returnByteDataList(List<_i3.ByteData> list) =>
      caller.callServerEndpoint<List<_i3.ByteData>>(
        'listParameters',
        'returnByteDataList',
        {'list': list},
      );

  _i2.Future<List<_i3.ByteData?>> returnByteDataListNullableByteDatas(
    List<_i3.ByteData?> list,
  ) => caller.callServerEndpoint<List<_i3.ByteData?>>(
    'listParameters',
    'returnByteDataListNullableByteDatas',
    {'list': list},
  );

  _i2.Future<List<_i8.SimpleData>> returnSimpleDataList(
    List<_i8.SimpleData> list,
  ) => caller.callServerEndpoint<List<_i8.SimpleData>>(
    'listParameters',
    'returnSimpleDataList',
    {'list': list},
  );

  _i2.Future<List<_i8.SimpleData?>> returnSimpleDataListNullableSimpleData(
    List<_i8.SimpleData?> list,
  ) => caller.callServerEndpoint<List<_i8.SimpleData?>>(
    'listParameters',
    'returnSimpleDataListNullableSimpleData',
    {'list': list},
  );

  _i2.Future<List<_i8.SimpleData>?> returnSimpleDataListNullable(
    List<_i8.SimpleData>? list,
  ) => caller.callServerEndpoint<List<_i8.SimpleData>?>(
    'listParameters',
    'returnSimpleDataListNullable',
    {'list': list},
  );

  _i2.Future<List<_i8.SimpleData?>?>
  returnNullableSimpleDataListNullableSimpleData(List<_i8.SimpleData?>? list) =>
      caller.callServerEndpoint<List<_i8.SimpleData?>?>(
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
    List<Duration?> list,
  ) => caller.callServerEndpoint<List<Duration?>>(
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
  ) => caller.callServerEndpoint<void>(
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
  ) => caller.callServerEndpoint<void>(
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
    Map<String, Map<String, int>> map,
  ) => caller.callServerEndpoint<Map<String, Map<String, int>>>(
    'mapParameters',
    'returnNestedIntMap',
    {'map': map},
  );

  _i2.Future<Map<String, int?>> returnIntMapNullableInts(
    Map<String, int?> map,
  ) => caller.callServerEndpoint<Map<String, int?>>(
    'mapParameters',
    'returnIntMapNullableInts',
    {'map': map},
  );

  _i2.Future<Map<String, int?>?> returnNullableIntMapNullableInts(
    Map<String, int?>? map,
  ) => caller.callServerEndpoint<Map<String, int?>?>(
    'mapParameters',
    'returnNullableIntMapNullableInts',
    {'map': map},
  );

  _i2.Future<Map<int, int>> returnIntIntMap(Map<int, int> map) =>
      caller.callServerEndpoint<Map<int, int>>(
        'mapParameters',
        'returnIntIntMap',
        {'map': _i16.mapContainerToJson(map)},
      );

  _i2.Future<Map<String, Map<int, int>>> returnNestedIntIntMap(
    Map<String, Map<int, int>> map,
  ) => caller.callServerEndpoint<Map<String, Map<int, int>>>(
    'mapParameters',
    'returnNestedIntIntMap',
    {'map': _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<_i17.TestEnum, int>> returnEnumIntMap(
    Map<_i17.TestEnum, int> map,
  ) => caller.callServerEndpoint<Map<_i17.TestEnum, int>>(
    'mapParameters',
    'returnEnumIntMap',
    {'map': _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<String, _i17.TestEnum>> returnEnumMap(
    Map<String, _i17.TestEnum> map,
  ) => caller.callServerEndpoint<Map<String, _i17.TestEnum>>(
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
    Map<String, double?> map,
  ) => caller.callServerEndpoint<Map<String, double?>>(
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
    Map<String, bool?> map,
  ) => caller.callServerEndpoint<Map<String, bool?>>(
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
    Map<String, String?> map,
  ) => caller.callServerEndpoint<Map<String, String?>>(
    'mapParameters',
    'returnStringMapNullableStrings',
    {'map': map},
  );

  _i2.Future<Map<String, DateTime>> returnDateTimeMap(
    Map<String, DateTime> map,
  ) => caller.callServerEndpoint<Map<String, DateTime>>(
    'mapParameters',
    'returnDateTimeMap',
    {'map': map},
  );

  _i2.Future<Map<String, DateTime?>> returnDateTimeMapNullableDateTimes(
    Map<String, DateTime?> map,
  ) => caller.callServerEndpoint<Map<String, DateTime?>>(
    'mapParameters',
    'returnDateTimeMapNullableDateTimes',
    {'map': map},
  );

  _i2.Future<Map<String, _i3.ByteData>> returnByteDataMap(
    Map<String, _i3.ByteData> map,
  ) => caller.callServerEndpoint<Map<String, _i3.ByteData>>(
    'mapParameters',
    'returnByteDataMap',
    {'map': map},
  );

  _i2.Future<Map<String, _i3.ByteData?>> returnByteDataMapNullableByteDatas(
    Map<String, _i3.ByteData?> map,
  ) => caller.callServerEndpoint<Map<String, _i3.ByteData?>>(
    'mapParameters',
    'returnByteDataMapNullableByteDatas',
    {'map': map},
  );

  _i2.Future<Map<String, _i8.SimpleData>> returnSimpleDataMap(
    Map<String, _i8.SimpleData> map,
  ) => caller.callServerEndpoint<Map<String, _i8.SimpleData>>(
    'mapParameters',
    'returnSimpleDataMap',
    {'map': map},
  );

  _i2.Future<Map<String, _i8.SimpleData?>>
  returnSimpleDataMapNullableSimpleData(Map<String, _i8.SimpleData?> map) =>
      caller.callServerEndpoint<Map<String, _i8.SimpleData?>>(
        'mapParameters',
        'returnSimpleDataMapNullableSimpleData',
        {'map': map},
      );

  _i2.Future<Map<String, _i8.SimpleData>?> returnSimpleDataMapNullable(
    Map<String, _i8.SimpleData>? map,
  ) => caller.callServerEndpoint<Map<String, _i8.SimpleData>?>(
    'mapParameters',
    'returnSimpleDataMapNullable',
    {'map': map},
  );

  _i2.Future<Map<String, _i8.SimpleData?>?>
  returnNullableSimpleDataMapNullableSimpleData(
    Map<String, _i8.SimpleData?>? map,
  ) => caller.callServerEndpoint<Map<String, _i8.SimpleData?>?>(
    'mapParameters',
    'returnNullableSimpleDataMapNullableSimpleData',
    {'map': map},
  );

  _i2.Future<Map<String, Duration>> returnDurationMap(
    Map<String, Duration> map,
  ) => caller.callServerEndpoint<Map<String, Duration>>(
    'mapParameters',
    'returnDurationMap',
    {'map': map},
  );

  _i2.Future<Map<String, Duration?>> returnDurationMapNullableDurations(
    Map<String, Duration?> map,
  ) => caller.callServerEndpoint<Map<String, Duration?>>(
    'mapParameters',
    'returnDurationMapNullableDurations',
    {'map': map},
  );

  _i2.Future<Map<(Map<int, String>, String), String>>
  returnNestedNonStringKeyedMapInsideRecordInsideMap(
    Map<(Map<int, String>, String), String> map,
  ) => caller.callServerEndpoint<Map<(Map<int, String>, String), String>>(
    'mapParameters',
    'returnNestedNonStringKeyedMapInsideRecordInsideMap',
    {'map': _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<String, (Map<int, int>,)>>
  returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap(
    Map<String, (Map<int, int>,)> map,
  ) => caller.callServerEndpoint<Map<String, (Map<int, int>,)>>(
    'mapParameters',
    'returnDeeplyNestedNonStringKeyedMapInsideRecordInsideMap',
    {'map': _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<DateTime, bool>> returnDateTimeBoolMap(
    Map<DateTime, bool> map,
  ) => caller.callServerEndpoint<Map<DateTime, bool>>(
    'mapParameters',
    'returnDateTimeBoolMap',
    {'map': _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<DateTime, bool>?> returnDateTimeBoolMapNullable(
    Map<DateTime, bool>? map,
  ) => caller.callServerEndpoint<Map<DateTime, bool>?>(
    'mapParameters',
    'returnDateTimeBoolMapNullable',
    {'map': map == null ? null : _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<int, String>> returnIntStringMap(Map<int, String> map) =>
      caller.callServerEndpoint<Map<int, String>>(
        'mapParameters',
        'returnIntStringMap',
        {'map': _i16.mapContainerToJson(map)},
      );

  _i2.Future<Map<int, String>?> returnIntStringMapNullable(
    Map<int, String>? map,
  ) => caller.callServerEndpoint<Map<int, String>?>(
    'mapParameters',
    'returnIntStringMapNullable',
    {'map': map == null ? null : _i16.mapContainerToJson(map)},
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
  }) => caller.callServerEndpoint<List<String?>>(
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
  }) => caller.callServerEndpoint<List<String?>>(
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
  ]) => caller.callServerEndpoint<List<String?>>(
    'methodSignaturePermutations',
    'echoPositionalAndOptionalArgs',
    {
      'string1': string1,
      'string2': string2,
    },
  );

  _i2.Stream<String> echoNamedArgStream({
    required _i2.Stream<String> strings,
  }) => caller.callStreamingServerEndpoint<_i2.Stream<String>, String>(
    'methodSignaturePermutations',
    'echoNamedArgStream',
    {},
    {'strings': strings},
  );

  _i2.Future<String> echoNamedArgStreamAsFuture({
    required _i2.Stream<String> strings,
  }) => caller.callStreamingServerEndpoint<_i2.Future<String>, String>(
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
    _i2.Stream<String> strings,
  ) => caller.callStreamingServerEndpoint<_i2.Future<String>, String>(
    'methodSignaturePermutations',
    'echoPositionalArgStreamAsFuture',
    {},
    {'strings': strings},
  );
}

/// Plain extension of the existing endpoint
/// {@category Endpoint}
class EndpointModuleEndpointSubclass extends _i1.EndpointRef {
  EndpointModuleEndpointSubclass(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointSubclass';

  _i2.Future<String> echoString(String value) =>
      caller.callServerEndpoint<String>(
        'moduleEndpointSubclass',
        'echoString',
        {'value': value},
      );

  _i2.Future<(int, BigInt)> echoRecord((int, BigInt) value) =>
      caller.callServerEndpoint<(int, BigInt)>(
        'moduleEndpointSubclass',
        'echoRecord',
        {'value': _i16.mapRecordToJson(value)},
      );

  _i2.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointSubclass',
        'echoContainer',
        {'value': value},
      );

  _i2.Future<_i14.ModuleClass> echoModel(_i14.ModuleClass value) =>
      caller.callServerEndpoint<_i14.ModuleClass>(
        'moduleEndpointSubclass',
        'echoModel',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointModuleEndpointAdaptation extends _i1.EndpointRef {
  EndpointModuleEndpointAdaptation(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointAdaptation';

  _i2.Future<String> echoString(String value) =>
      caller.callServerEndpoint<String>(
        'moduleEndpointAdaptation',
        'echoString',
        {'value': value},
      );

  /// Extended `echoRecord` which takes an optional argument for a multiplier
  ///
  /// This shows a backwards-compatible extension of the method, which is enforced by the Dart type system.
  _i2.Future<(int, BigInt)> echoRecord(
    (int, BigInt) value, [
    int? multiplier,
  ]) => caller.callServerEndpoint<(int, BigInt)>(
    'moduleEndpointAdaptation',
    'echoRecord',
    {
      'value': _i16.mapRecordToJson(value),
      'multiplier': multiplier,
    },
  );

  _i2.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointAdaptation',
        'echoContainer',
        {'value': value},
      );

  _i2.Future<_i14.ModuleClass> echoModel(_i14.ModuleClass value) =>
      caller.callServerEndpoint<_i14.ModuleClass>(
        'moduleEndpointAdaptation',
        'echoModel',
        {'value': value},
      );
}

/// {@category Endpoint}
class EndpointModuleEndpointReduction extends _i1.EndpointRef {
  EndpointModuleEndpointReduction(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointReduction';

  _i2.Future<(int, BigInt)> echoRecord((int, BigInt) value) =>
      caller.callServerEndpoint<(int, BigInt)>(
        'moduleEndpointReduction',
        'echoRecord',
        {'value': _i16.mapRecordToJson(value)},
      );

  _i2.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointReduction',
        'echoContainer',
        {'value': value},
      );

  _i2.Future<_i14.ModuleClass> echoModel(_i14.ModuleClass value) =>
      caller.callServerEndpoint<_i14.ModuleClass>(
        'moduleEndpointReduction',
        'echoModel',
        {'value': value},
      );
}

/// Subclass inheriting all base class methods and adding a furhter method itself
/// {@category Endpoint}
class EndpointModuleEndpointExtension extends _i1.EndpointRef {
  EndpointModuleEndpointExtension(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'moduleEndpointExtension';

  _i2.Future<String> greet(String name) => caller.callServerEndpoint<String>(
    'moduleEndpointExtension',
    'greet',
    {'name': name},
  );

  _i2.Future<void> ignoredMethod() => caller.callServerEndpoint<void>(
    'moduleEndpointExtension',
    'ignoredMethod',
    {},
  );

  _i2.Future<String> echoString(String value) =>
      caller.callServerEndpoint<String>(
        'moduleEndpointExtension',
        'echoString',
        {'value': value},
      );

  _i2.Future<(int, BigInt)> echoRecord((int, BigInt) value) =>
      caller.callServerEndpoint<(int, BigInt)>(
        'moduleEndpointExtension',
        'echoRecord',
        {'value': _i16.mapRecordToJson(value)},
      );

  _i2.Future<Set<int>> echoContainer(Set<int> value) =>
      caller.callServerEndpoint<Set<int>>(
        'moduleEndpointExtension',
        'echoContainer',
        {'value': value},
      );

  _i2.Future<_i14.ModuleClass> echoModel(_i14.ModuleClass value) =>
      caller.callServerEndpoint<_i14.ModuleClass>(
        'moduleEndpointExtension',
        'echoModel',
        {'value': value},
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

  _i2.Future<_i14.ModuleClass> modifyModuleObject(_i14.ModuleClass object) =>
      caller.callServerEndpoint<_i14.ModuleClass>(
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

  _i2.Future<bool> namedParametersMethodEqualInts({
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

/// Endpoint for testing polymorphism functionality.
/// {@category Endpoint}
class EndpointInheritancePolymorphismTest extends _i1.EndpointRef {
  EndpointInheritancePolymorphismTest(_i1.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'inheritancePolymorphismTest';

  /// Receives a PolymorphicParent object for testing serialization.
  ///
  /// Returns the runtime type and the object itself. The object must retain
  /// its class when received by the client.
  _i2.Future<(String, _i19.PolymorphicParent)> polymorphicRoundtrip(
    _i19.PolymorphicParent parent,
  ) => caller.callServerEndpoint<(String, _i19.PolymorphicParent)>(
    'inheritancePolymorphismTest',
    'polymorphicRoundtrip',
    {'parent': parent},
  );

  /// Receives a PolymorphicParent object through streaming for testing.
  ///
  /// Yields the runtime type and the object itself. The object must retain its
  /// class when received by the client.
  _i2.Stream<(String, _i19.PolymorphicParent)> polymorphicStreamingRoundtrip(
    _i2.Stream<_i19.PolymorphicParent> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<(String, _i19.PolymorphicParent)>,
        (String, _i19.PolymorphicParent)
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
  _i2.Future<_i20.PolymorphicChildContainer> polymorphicContainerRoundtrip(
    _i20.PolymorphicChildContainer container,
  ) => caller.callServerEndpoint<_i20.PolymorphicChildContainer>(
    'inheritancePolymorphismTest',
    'polymorphicContainerRoundtrip',
    {'container': container},
  );

  /// Receives a ModulePolymorphicChildContainer object for testing serialization.
  ///
  /// Returns the container object itself. All nested polymorphic objects must
  /// retain their runtime types when received by the client.
  _i2.Future<_i21.ModulePolymorphicChildContainer>
  polymorphicModuleContainerRoundtrip(
    _i21.ModulePolymorphicChildContainer container,
  ) => caller.callServerEndpoint<_i21.ModulePolymorphicChildContainer>(
    'inheritancePolymorphismTest',
    'polymorphicModuleContainerRoundtrip',
    {'container': container},
  );
}

/// {@category Endpoint}
class EndpointRecordParameters extends _i1.EndpointRef {
  EndpointRecordParameters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'recordParameters';

  _i2.Future<(int,)> returnRecordOfInt((int,) record) =>
      caller.callServerEndpoint<(int,)>(
        'recordParameters',
        'returnRecordOfInt',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<(int,)?> returnNullableRecordOfInt((int,)? record) =>
      caller.callServerEndpoint<(int,)?>(
        'recordParameters',
        'returnNullableRecordOfInt',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<(int?,)> returnRecordOfNullableInt((int?,) record) =>
      caller.callServerEndpoint<(int?,)>(
        'recordParameters',
        'returnRecordOfNullableInt',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<(int?,)?> returnNullableRecordOfNullableInt((int?,)? record) =>
      caller.callServerEndpoint<(int?,)?>(
        'recordParameters',
        'returnNullableRecordOfNullableInt',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Stream<(int?,)?> streamNullableRecordOfNullableInt(
    _i2.Stream<(int?,)?> values,
  ) => caller.callStreamingServerEndpoint<_i2.Stream<(int?,)?>, (int?,)?>(
    'recordParameters',
    'streamNullableRecordOfNullableInt',
    {},
    {'values': values},
  );

  _i2.Future<(int, String)> returnIntStringRecord((int, String) record) =>
      caller.callServerEndpoint<(int, String)>(
        'recordParameters',
        'returnIntStringRecord',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<(int, String)?> returnNullableIntStringRecord(
    (int, String)? record,
  ) => caller.callServerEndpoint<(int, String)?>(
    'recordParameters',
    'returnNullableIntStringRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<(int, _i8.SimpleData)> returnIntSimpleDataRecord(
    (int, _i8.SimpleData) record,
  ) => caller.callServerEndpoint<(int, _i8.SimpleData)>(
    'recordParameters',
    'returnIntSimpleDataRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<(int, _i8.SimpleData)?> returnNullableIntSimpleDataRecord(
    (int, _i8.SimpleData)? record,
  ) => caller.callServerEndpoint<(int, _i8.SimpleData)?>(
    'recordParameters',
    'returnNullableIntSimpleDataRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<(Map<String, int>,)> returnStringKeyedMapRecord(
    (Map<String, int>,) record,
  ) => caller.callServerEndpoint<(Map<String, int>,)>(
    'recordParameters',
    'returnStringKeyedMapRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<(Map<int, int>,)> returnNonStringKeyedMapRecord(
    (Map<int, int>,) record,
  ) => caller.callServerEndpoint<(Map<int, int>,)>(
    'recordParameters',
    'returnNonStringKeyedMapRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<(Set<(int,)>,)> returnSetWithNestedRecordRecord(
    (Set<(int,)>,) record,
  ) => caller.callServerEndpoint<(Set<(int,)>,)>(
    'recordParameters',
    'returnSetWithNestedRecordRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<({int number, String text})> returnNamedIntStringRecord(
    ({int number, String text}) record,
  ) => caller.callServerEndpoint<({int number, String text})>(
    'recordParameters',
    'returnNamedIntStringRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<({int number, String text})?> returnNamedNullableIntStringRecord(
    ({int number, String text})? record,
  ) => caller.callServerEndpoint<({int number, String text})?>(
    'recordParameters',
    'returnNamedNullableIntStringRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<({_i8.SimpleData data, int number})>
  returnRecordOfNamedIntAndObject(({_i8.SimpleData data, int number}) record) =>
      caller.callServerEndpoint<({_i8.SimpleData data, int number})>(
        'recordParameters',
        'returnRecordOfNamedIntAndObject',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<({_i8.SimpleData data, int number})?>
  returnNullableRecordOfNamedIntAndObject(
    ({_i8.SimpleData data, int number})? record,
  ) => caller.callServerEndpoint<({_i8.SimpleData data, int number})?>(
    'recordParameters',
    'returnNullableRecordOfNamedIntAndObject',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<({_i8.SimpleData? data, int? number})>
  returnRecordOfNamedNullableIntAndNullableObject(
    ({_i8.SimpleData? data, int? number}) record,
  ) => caller.callServerEndpoint<({_i8.SimpleData? data, int? number})>(
    'recordParameters',
    'returnRecordOfNamedNullableIntAndNullableObject',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<({Map<int, int> intIntMap})> returnNamedNonStringKeyedMapRecord(
    ({Map<int, int> intIntMap}) record,
  ) => caller.callServerEndpoint<({Map<int, int> intIntMap})>(
    'recordParameters',
    'returnNamedNonStringKeyedMapRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<({Set<(bool,)> boolSet})> returnNamedSetWithNestedRecordRecord(
    ({Set<(bool,)> boolSet}) record,
  ) => caller.callServerEndpoint<({Set<(bool,)> boolSet})>(
    'recordParameters',
    'returnNamedSetWithNestedRecordRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<(Map<(Map<int, String>, String), String>,)>
  returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord(
    (Map<(Map<int, String>, String), String>,) map,
  ) => caller.callServerEndpoint<(Map<(Map<int, String>, String), String>,)>(
    'recordParameters',
    'returnNestedNonStringKeyedMapInsideRecordInsideMapInsideRecord',
    {'map': _i16.mapRecordToJson(map)},
  );

  _i2.Future<(int, {_i8.SimpleData data})> returnRecordTypedef(
    (int, {_i8.SimpleData data}) record,
  ) => caller.callServerEndpoint<(int, {_i8.SimpleData data})>(
    'recordParameters',
    'returnRecordTypedef',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<(int, {_i8.SimpleData data})?> returnNullableRecordTypedef(
    (int, {_i8.SimpleData data})? record,
  ) => caller.callServerEndpoint<(int, {_i8.SimpleData data})?>(
    'recordParameters',
    'returnNullableRecordTypedef',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<List<(int, _i8.SimpleData)>> returnListOfIntSimpleDataRecord(
    List<(int, _i8.SimpleData)> recordList,
  ) => caller.callServerEndpoint<List<(int, _i8.SimpleData)>>(
    'recordParameters',
    'returnListOfIntSimpleDataRecord',
    {'recordList': _i16.mapContainerToJson(recordList)},
  );

  _i2.Future<List<(int, _i8.SimpleData)?>>
  returnListOfNullableIntSimpleDataRecord(
    List<(int, _i8.SimpleData)?> record,
  ) => caller.callServerEndpoint<List<(int, _i8.SimpleData)?>>(
    'recordParameters',
    'returnListOfNullableIntSimpleDataRecord',
    {'record': _i16.mapContainerToJson(record)},
  );

  _i2.Future<Set<(int, _i8.SimpleData)>> returnSetOfIntSimpleDataRecord(
    Set<(int, _i8.SimpleData)> recordSet,
  ) => caller.callServerEndpoint<Set<(int, _i8.SimpleData)>>(
    'recordParameters',
    'returnSetOfIntSimpleDataRecord',
    {'recordSet': _i16.mapContainerToJson(recordSet)},
  );

  _i2.Future<Set<(int, _i8.SimpleData)?>>
  returnSetOfNullableIntSimpleDataRecord(Set<(int, _i8.SimpleData)?> set) =>
      caller.callServerEndpoint<Set<(int, _i8.SimpleData)?>>(
        'recordParameters',
        'returnSetOfNullableIntSimpleDataRecord',
        {'set': _i16.mapContainerToJson(set)},
      );

  _i2.Future<Set<(int, _i8.SimpleData)>?>
  returnNullableSetOfIntSimpleDataRecord(
    Set<(int, _i8.SimpleData)>? recordSet,
  ) => caller.callServerEndpoint<Set<(int, _i8.SimpleData)>?>(
    'recordParameters',
    'returnNullableSetOfIntSimpleDataRecord',
    {
      'recordSet': recordSet == null
          ? null
          : _i16.mapContainerToJson(recordSet),
    },
  );

  _i2.Future<Map<String, (int, _i8.SimpleData)>>
  returnStringMapOfIntSimpleDataRecord(
    Map<String, (int, _i8.SimpleData)> map,
  ) => caller.callServerEndpoint<Map<String, (int, _i8.SimpleData)>>(
    'recordParameters',
    'returnStringMapOfIntSimpleDataRecord',
    {'map': _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<String, (int, _i8.SimpleData)?>>
  returnStringMapOfNullableIntSimpleDataRecord(
    Map<String, (int, _i8.SimpleData)?> map,
  ) => caller.callServerEndpoint<Map<String, (int, _i8.SimpleData)?>>(
    'recordParameters',
    'returnStringMapOfNullableIntSimpleDataRecord',
    {'map': _i16.mapContainerToJson(map)},
  );

  _i2.Future<Map<(String, int), (int, _i8.SimpleData)>>
  returnRecordMapOfIntSimpleDataRecord(
    Map<(String, int), (int, _i8.SimpleData)> map,
  ) => caller.callServerEndpoint<Map<(String, int), (int, _i8.SimpleData)>>(
    'recordParameters',
    'returnRecordMapOfIntSimpleDataRecord',
    {'map': _i16.mapContainerToJson(map)},
  );

  /// Returns the first and only input value mapped into the return structure (basically reversed)
  _i2.Future<Map<String, List<Set<(int,)>>>> returnStringMapOfListOfRecord(
    Set<List<Map<String, (int,)>>> input,
  ) => caller.callServerEndpoint<Map<String, List<Set<(int,)>>>>(
    'recordParameters',
    'returnStringMapOfListOfRecord',
    {'input': _i16.mapContainerToJson(input)},
  );

  _i2.Future<({(_i8.SimpleData, double) namedSubRecord})>
  returnNestedNamedRecord(({(_i8.SimpleData, double) namedSubRecord}) record) =>
      caller.callServerEndpoint<({(_i8.SimpleData, double) namedSubRecord})>(
        'recordParameters',
        'returnNestedNamedRecord',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<({(_i8.SimpleData, double)? namedSubRecord})>
  returnNestedNullableNamedRecord(
    ({(_i8.SimpleData, double)? namedSubRecord}) record,
  ) => caller.callServerEndpoint<({(_i8.SimpleData, double)? namedSubRecord})>(
    'recordParameters',
    'returnNestedNullableNamedRecord',
    {'record': _i16.mapRecordToJson(record)},
  );

  _i2.Future<((int, String), {(_i8.SimpleData, double) namedSubRecord})>
  returnNestedPositionalAndNamedRecord(
    ((int, String), {(_i8.SimpleData, double) namedSubRecord}) record,
  ) =>
      caller.callServerEndpoint<
        ((int, String), {(_i8.SimpleData, double) namedSubRecord})
      >(
        'recordParameters',
        'returnNestedPositionalAndNamedRecord',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<List<((int, String), {(_i8.SimpleData, double) namedSubRecord})>>
  returnListOfNestedPositionalAndNamedRecord(
    List<((int, String), {(_i8.SimpleData, double) namedSubRecord})> recordList,
  ) =>
      caller.callServerEndpoint<
        List<((int, String), {(_i8.SimpleData, double) namedSubRecord})>
      >(
        'recordParameters',
        'returnListOfNestedPositionalAndNamedRecord',
        {'recordList': _i16.mapContainerToJson(recordList)},
      );

  _i2.Stream<List<((int, String), {(_i8.SimpleData, double) namedSubRecord})?>?>
  streamNullableListOfNullableNestedPositionalAndNamedRecord(
    List<((int, String), {(_i8.SimpleData, double) namedSubRecord})?>?
    initialValue,
    _i2.Stream<
      List<((int, String), {(_i8.SimpleData, double) namedSubRecord})?>?
    >
    values,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<
          List<((int, String), {(_i8.SimpleData, double) namedSubRecord})?>?
        >,
        List<((int, String), {(_i8.SimpleData, double) namedSubRecord})?>?
      >(
        'recordParameters',
        'streamNullableListOfNullableNestedPositionalAndNamedRecord',
        {'initialValue': initialValue},
        {'values': values},
      );

  _i2.Future<_i22.TypesRecord> echoModelClassWithRecordField(
    _i22.TypesRecord value,
  ) => caller.callServerEndpoint<_i22.TypesRecord>(
    'recordParameters',
    'echoModelClassWithRecordField',
    {'value': value},
  );

  _i2.Future<_i22.TypesRecord?> echoNullableModelClassWithRecordField(
    _i22.TypesRecord? value,
  ) => caller.callServerEndpoint<_i22.TypesRecord?>(
    'recordParameters',
    'echoNullableModelClassWithRecordField',
    {'value': value},
  );

  _i2.Future<_i14.ModuleClass?>
  echoNullableModelClassWithRecordFieldFromExternalModule(
    _i14.ModuleClass? value,
  ) => caller.callServerEndpoint<_i14.ModuleClass?>(
    'recordParameters',
    'echoNullableModelClassWithRecordFieldFromExternalModule',
    {'value': value},
  );

  _i2.Stream<_i22.TypesRecord> streamOfModelClassWithRecordField(
    _i22.TypesRecord initialValue,
    _i2.Stream<_i22.TypesRecord> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i22.TypesRecord>,
        _i22.TypesRecord
      >(
        'recordParameters',
        'streamOfModelClassWithRecordField',
        {'initialValue': initialValue},
        {'values': values},
      );

  _i2.Stream<_i22.TypesRecord?> streamOfNullableModelClassWithRecordField(
    _i22.TypesRecord? initialValue,
    _i2.Stream<_i22.TypesRecord?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i22.TypesRecord?>,
        _i22.TypesRecord?
      >(
        'recordParameters',
        'streamOfNullableModelClassWithRecordField',
        {'initialValue': initialValue},
        {'values': values},
      );

  _i2.Stream<_i14.ModuleClass?>
  streamOfNullableModelClassWithRecordFieldFromExternalModule(
    _i14.ModuleClass? initialValue,
    _i2.Stream<_i14.ModuleClass?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i14.ModuleClass?>,
        _i14.ModuleClass?
      >(
        'recordParameters',
        'streamOfNullableModelClassWithRecordFieldFromExternalModule',
        {'initialValue': initialValue},
        {'values': values},
      );

  _i2.Future<int> recordParametersWithCustomNames(
    (int,) positionalRecord, {
    required (int,) namedRecord,
  }) => caller.callServerEndpoint<int>(
    'recordParameters',
    'recordParametersWithCustomNames',
    {
      'positionalRecord': _i16.mapRecordToJson(positionalRecord),
      'namedRecord': _i16.mapRecordToJson(namedRecord),
    },
  );
}

/// {@category Endpoint}
class EndpointRedis extends _i1.EndpointRef {
  EndpointRedis(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'redis';

  _i2.Future<void> setSimpleData(
    String key,
    _i8.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'redis',
    'setSimpleData',
    {
      'key': key,
      'data': data,
    },
  );

  _i2.Future<void> setSimpleDataWithLifetime(
    String key,
    _i8.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'redis',
    'setSimpleDataWithLifetime',
    {
      'key': key,
      'data': data,
    },
  );

  _i2.Future<_i8.SimpleData?> getSimpleData(String key) =>
      caller.callServerEndpoint<_i8.SimpleData?>(
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

  _i2.Future<_i8.SimpleData?> listenToChannel(String channel) =>
      caller.callServerEndpoint<_i8.SimpleData?>(
        'redis',
        'listenToChannel',
        {'channel': channel},
      );

  _i2.Future<void> postToChannel(
    String channel,
    _i8.SimpleData data,
  ) => caller.callServerEndpoint<void>(
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

  _i2.Future<_i23.ScopeServerOnlyField> getScopeServerOnlyField() =>
      caller.callServerEndpoint<_i23.ScopeServerOnlyField>(
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

  _i2.Future<_i24.ScopeServerOnlyFieldChild> getProtocolField() =>
      caller.callServerEndpoint<_i24.ScopeServerOnlyFieldChild>(
        'serverOnlyScopedFieldChildModel',
        'getProtocolField',
        {},
      );
}

/// {@category Endpoint}
class EndpointSessionAuthentication extends _i1.EndpointRef {
  EndpointSessionAuthentication(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'sessionAuthentication';

  /// Returns authenticated user identifier or null
  _i2.Future<String?> getAuthenticatedUserId() =>
      caller.callServerEndpoint<String?>(
        'sessionAuthentication',
        'getAuthenticatedUserId',
        {},
      );

  /// Returns all scope names
  _i2.Future<List<String>> getAuthenticatedScopes() =>
      caller.callServerEndpoint<List<String>>(
        'sessionAuthentication',
        'getAuthenticatedScopes',
        {},
      );

  /// Returns authenticated auth ID or null
  _i2.Future<String?> getAuthenticatedAuthId() =>
      caller.callServerEndpoint<String?>(
        'sessionAuthentication',
        'getAuthenticatedAuthId',
        {},
      );

  /// Returns full authentication info
  _i2.Future<_i25.SessionAuthInfo> getAuthenticationInfo() =>
      caller.callServerEndpoint<_i25.SessionAuthInfo>(
        'sessionAuthentication',
        'getAuthenticationInfo',
        {},
      );

  /// Returns authentication status as boolean
  _i2.Future<bool> isAuthenticated() => caller.callServerEndpoint<bool>(
    'sessionAuthentication',
    'isAuthenticated',
    {},
  );

  /// Stream that yields authenticated user ID
  _i2.Stream<String?> streamAuthenticatedUserId() =>
      caller.callStreamingServerEndpoint<_i2.Stream<String?>, String?>(
        'sessionAuthentication',
        'streamAuthenticatedUserId',
        {},
        {},
      );

  /// Stream that yields authentication status
  _i2.Stream<bool> streamIsAuthenticated() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'sessionAuthentication',
        'streamIsAuthenticated',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointSessionAuthenticationStreaming extends _i1.EndpointRef {
  EndpointSessionAuthenticationStreaming(_i1.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'sessionAuthenticationStreaming';
}

/// {@category Endpoint}
class EndpointSetParameters extends _i1.EndpointRef {
  EndpointSetParameters(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'setParameters';

  _i2.Future<Set<int>> returnIntSet(Set<int> set) =>
      caller.callServerEndpoint<Set<int>>(
        'setParameters',
        'returnIntSet',
        {'set': set},
      );

  _i2.Future<Set<Set<int>>> returnIntSetSet(Set<Set<int>> set) =>
      caller.callServerEndpoint<Set<Set<int>>>(
        'setParameters',
        'returnIntSetSet',
        {'set': set},
      );

  _i2.Future<Set<List<int>>> returnIntListSet(Set<List<int>> set) =>
      caller.callServerEndpoint<Set<List<int>>>(
        'setParameters',
        'returnIntListSet',
        {'set': set},
      );

  _i2.Future<Set<int>?> returnIntSetNullable(Set<int>? set) =>
      caller.callServerEndpoint<Set<int>?>(
        'setParameters',
        'returnIntSetNullable',
        {'set': set},
      );

  _i2.Future<Set<Set<int>?>> returnIntSetNullableSet(Set<Set<int>?> set) =>
      caller.callServerEndpoint<Set<Set<int>?>>(
        'setParameters',
        'returnIntSetNullableSet',
        {'set': set},
      );

  _i2.Future<Set<Set<int>>?> returnIntSetSetNullable(Set<Set<int>>? set) =>
      caller.callServerEndpoint<Set<Set<int>>?>(
        'setParameters',
        'returnIntSetSetNullable',
        {'set': set},
      );

  _i2.Future<Set<int?>> returnIntSetNullableInts(Set<int?> set) =>
      caller.callServerEndpoint<Set<int?>>(
        'setParameters',
        'returnIntSetNullableInts',
        {'set': set},
      );

  _i2.Future<Set<int?>?> returnNullableIntSetNullableInts(Set<int?>? set) =>
      caller.callServerEndpoint<Set<int?>?>(
        'setParameters',
        'returnNullableIntSetNullableInts',
        {'set': set},
      );

  _i2.Future<Set<double>> returnDoubleSet(Set<double> set) =>
      caller.callServerEndpoint<Set<double>>(
        'setParameters',
        'returnDoubleSet',
        {'set': set},
      );

  _i2.Future<Set<double?>> returnDoubleSetNullableDoubles(Set<double?> set) =>
      caller.callServerEndpoint<Set<double?>>(
        'setParameters',
        'returnDoubleSetNullableDoubles',
        {'set': set},
      );

  _i2.Future<Set<bool>> returnBoolSet(Set<bool> set) =>
      caller.callServerEndpoint<Set<bool>>(
        'setParameters',
        'returnBoolSet',
        {'set': set},
      );

  _i2.Future<Set<bool?>> returnBoolSetNullableBools(Set<bool?> set) =>
      caller.callServerEndpoint<Set<bool?>>(
        'setParameters',
        'returnBoolSetNullableBools',
        {'set': set},
      );

  _i2.Future<Set<String>> returnStringSet(Set<String> set) =>
      caller.callServerEndpoint<Set<String>>(
        'setParameters',
        'returnStringSet',
        {'set': set},
      );

  _i2.Future<Set<String?>> returnStringSetNullableStrings(Set<String?> set) =>
      caller.callServerEndpoint<Set<String?>>(
        'setParameters',
        'returnStringSetNullableStrings',
        {'set': set},
      );

  _i2.Future<Set<DateTime>> returnDateTimeSet(Set<DateTime> set) =>
      caller.callServerEndpoint<Set<DateTime>>(
        'setParameters',
        'returnDateTimeSet',
        {'set': set},
      );

  _i2.Future<Set<DateTime?>> returnDateTimeSetNullableDateTimes(
    Set<DateTime?> set,
  ) => caller.callServerEndpoint<Set<DateTime?>>(
    'setParameters',
    'returnDateTimeSetNullableDateTimes',
    {'set': set},
  );

  _i2.Future<Set<_i3.ByteData>> returnByteDataSet(Set<_i3.ByteData> set) =>
      caller.callServerEndpoint<Set<_i3.ByteData>>(
        'setParameters',
        'returnByteDataSet',
        {'set': set},
      );

  _i2.Future<Set<_i3.ByteData?>> returnByteDataSetNullableByteDatas(
    Set<_i3.ByteData?> set,
  ) => caller.callServerEndpoint<Set<_i3.ByteData?>>(
    'setParameters',
    'returnByteDataSetNullableByteDatas',
    {'set': set},
  );

  _i2.Future<Set<_i8.SimpleData>> returnSimpleDataSet(
    Set<_i8.SimpleData> set,
  ) => caller.callServerEndpoint<Set<_i8.SimpleData>>(
    'setParameters',
    'returnSimpleDataSet',
    {'set': set},
  );

  _i2.Future<Set<_i8.SimpleData?>> returnSimpleDataSetNullableSimpleData(
    Set<_i8.SimpleData?> set,
  ) => caller.callServerEndpoint<Set<_i8.SimpleData?>>(
    'setParameters',
    'returnSimpleDataSetNullableSimpleData',
    {'set': set},
  );

  _i2.Future<Set<Duration>> returnDurationSet(Set<Duration> set) =>
      caller.callServerEndpoint<Set<Duration>>(
        'setParameters',
        'returnDurationSet',
        {'set': set},
      );

  _i2.Future<Set<Duration?>> returnDurationSetNullableDurations(
    Set<Duration?> set,
  ) => caller.callServerEndpoint<Set<Duration?>>(
    'setParameters',
    'returnDurationSetNullableDurations',
    {'set': set},
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
  ]) => caller.callServerEndpoint<void>(
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

  _i2.Future<_i1.UuidValue> returnsSessionId() =>
      caller.callServerEndpoint<_i1.UuidValue>(
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

  _i2.Stream<_i1.UuidValue> returnsSessionIdFromStream() => caller
      .callStreamingServerEndpoint<_i2.Stream<_i1.UuidValue>, _i1.UuidValue>(
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

  _i2.Future<List<_i8.SimpleData>> returnsSimpleDataListFromInputStream(
    _i2.Stream<_i8.SimpleData> simpleDatas,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Future<List<_i8.SimpleData>>,
        List<_i8.SimpleData>
      >(
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

  _i2.Stream<_i8.SimpleData> returnsSimpleDataStreamFromInputStream(
    _i2.Stream<_i8.SimpleData> simpleDatas,
  ) => caller
      .callStreamingServerEndpoint<_i2.Stream<_i8.SimpleData>, _i8.SimpleData>(
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

  _i2.Future<List<_i8.SimpleData>> getAllSimpleData() =>
      caller.callServerEndpoint<List<_i8.SimpleData>>(
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

  _i2.Future<_i8.SimpleData> echoSimpleData(_i8.SimpleData simpleData) =>
      caller.callServerEndpoint<_i8.SimpleData>(
        'testTools',
        'echoSimpleData',
        {'simpleData': simpleData},
      );

  _i2.Future<List<_i8.SimpleData>> echoSimpleDatas(
    List<_i8.SimpleData> simpleDatas,
  ) => caller.callServerEndpoint<List<_i8.SimpleData>>(
    'testTools',
    'echoSimpleDatas',
    {'simpleDatas': simpleDatas},
  );

  _i2.Future<_i10.Types> echoTypes(_i10.Types typesModel) =>
      caller.callServerEndpoint<_i10.Types>(
        'testTools',
        'echoTypes',
        {'typesModel': typesModel},
      );

  _i2.Future<List<_i10.Types>> echoTypesList(List<_i10.Types> typesList) =>
      caller.callServerEndpoint<List<_i10.Types>>(
        'testTools',
        'echoTypesList',
        {'typesList': typesList},
      );

  /// Returns a model class which fields reference `ModuleClass` defined in another module
  _i2.Future<_i18.ModuleDatatype> echoModuleDatatype(
    _i18.ModuleDatatype moduleDatatype,
  ) => caller.callServerEndpoint<_i18.ModuleDatatype>(
    'testTools',
    'echoModuleDatatype',
    {'moduleDatatype': moduleDatatype},
  );

  _i2.Stream<_i18.ModuleDatatype?> streamModuleDatatype(
    _i18.ModuleDatatype? initialValue,
    _i2.Stream<_i18.ModuleDatatype?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i18.ModuleDatatype?>,
        _i18.ModuleDatatype?
      >(
        'testTools',
        'streamModuleDatatype',
        {'initialValue': initialValue},
        {'values': values},
      );

  /// Returns the given `ModuleClass` instance
  ///
  /// `ModuleClass` is defined in another module
  _i2.Future<_i14.ModuleClass> echoModuleClass(_i14.ModuleClass moduleClass) =>
      caller.callServerEndpoint<_i14.ModuleClass>(
        'testTools',
        'echoModuleClass',
        {'moduleClass': moduleClass},
      );

  _i2.Stream<_i14.ModuleClass?> streamModuleClass(
    _i14.ModuleClass? initialValue,
    _i2.Stream<_i14.ModuleClass?> values,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i14.ModuleClass?>,
        _i14.ModuleClass?
      >(
        'testTools',
        'streamModuleClass',
        {'initialValue': initialValue},
        {'values': values},
      );

  _i2.Future<(String, (int, bool))> echoRecord((String, (int, bool)) record) =>
      caller.callServerEndpoint<(String, (int, bool))>(
        'testTools',
        'echoRecord',
        {'record': _i16.mapRecordToJson(record)},
      );

  _i2.Future<List<(String, (int, bool))>> echoRecords(
    List<(String, (int, bool))> records,
  ) => caller.callServerEndpoint<List<(String, (int, bool))>>(
    'testTools',
    'echoRecords',
    {'records': _i16.mapContainerToJson(records)},
  );

  _i2.Future<(int, _i8.SimpleData)> returnRecordWithSerializableObject(
    int number,
    _i8.SimpleData data,
  ) => caller.callServerEndpoint<(int, _i8.SimpleData)>(
    'testTools',
    'returnRecordWithSerializableObject',
    {
      'number': number,
      'data': data,
    },
  );

  _i2.Stream<
    (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))
  >
  recordEchoStream(
    (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))
    initialValue,
    _i2.Stream<
      (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))
    >
    stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<
          (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))
        >,
        (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))
      >(
        'testTools',
        'recordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _i2.Stream<List<(String, int)>> listOfRecordEchoStream(
    List<(String, int)> initialValue,
    _i2.Stream<List<(String, int)>> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<List<(String, int)>>,
        List<(String, int)>
      >(
        'testTools',
        'listOfRecordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _i2.Stream<
    (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))?
  >
  nullableRecordEchoStream(
    (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))?
    initialValue,
    _i2.Stream<
      (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))?
    >
    stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<
          (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))?
        >,
        (String, (Map<String, int>, {bool flag, _i8.SimpleData simpleData}))?
      >(
        'testTools',
        'nullableRecordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _i2.Stream<List<(String, int)>?> nullableListOfRecordEchoStream(
    List<(String, int)>? initialValue,
    _i2.Stream<List<(String, int)>?> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<List<(String, int)>?>,
        List<(String, int)>?
      >(
        'testTools',
        'nullableListOfRecordEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
      );

  _i2.Stream<_i22.TypesRecord?> modelWithRecordsEchoStream(
    _i22.TypesRecord? initialValue,
    _i2.Stream<_i22.TypesRecord?> stream,
  ) =>
      caller.callStreamingServerEndpoint<
        _i2.Stream<_i22.TypesRecord?>,
        _i22.TypesRecord?
      >(
        'testTools',
        'modelWithRecordsEchoStream',
        {'initialValue': initialValue},
        {'stream': stream},
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

  _i2.Future<void> putInLocalCache(
    String key,
    _i8.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'testTools',
    'putInLocalCache',
    {
      'key': key,
      'data': data,
    },
  );

  _i2.Future<_i8.SimpleData?> getFromLocalCache(String key) =>
      caller.callServerEndpoint<_i8.SimpleData?>(
        'testTools',
        'getFromLocalCache',
        {'key': key},
      );

  _i2.Future<void> putInLocalPrioCache(
    String key,
    _i8.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'testTools',
    'putInLocalPrioCache',
    {
      'key': key,
      'data': data,
    },
  );

  _i2.Future<_i8.SimpleData?> getFromLocalPrioCache(String key) =>
      caller.callServerEndpoint<_i8.SimpleData?>(
        'testTools',
        'getFromLocalPrioCache',
        {'key': key},
      );

  _i2.Future<void> putInQueryCache(
    String key,
    _i8.SimpleData data,
  ) => caller.callServerEndpoint<void>(
    'testTools',
    'putInQueryCache',
    {
      'key': key,
      'data': data,
    },
  );

  _i2.Future<_i8.SimpleData?> getFromQueryCache(String key) =>
      caller.callServerEndpoint<_i8.SimpleData?>(
        'testTools',
        'getFromQueryCache',
        {'key': key},
      );

  _i2.Future<void> putInLocalCacheWithGroup(
    String key,
    _i8.SimpleData data,
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
class EndpointUnauthenticated extends _i14.EndpointUnauthenticated {
  EndpointUnauthenticated(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'unauthenticated';

  @override
  _i2.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'unauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  @override
  _i2.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'unauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointPartiallyUnauthenticated
    extends _i14.EndpointPartiallyUnauthenticated {
  EndpointPartiallyUnauthenticated(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'partiallyUnauthenticated';

  @override
  _i2.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'partiallyUnauthenticated',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  @override
  _i2.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'partiallyUnauthenticated',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );

  @override
  _i2.Future<bool> authenticatedMethod() => caller.callServerEndpoint<bool>(
    'partiallyUnauthenticated',
    'authenticatedMethod',
    {},
  );

  @override
  _i2.Stream<bool> authenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'partiallyUnauthenticated',
        'authenticatedStream',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointUnauthenticatedRequireLogin extends _i14.EndpointUnauthenticated {
  EndpointUnauthenticatedRequireLogin(_i1.EndpointCaller caller)
    : super(caller);

  @override
  String get name => 'unauthenticatedRequireLogin';

  @override
  _i2.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'unauthenticatedRequireLogin',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  @override
  _i2.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'unauthenticatedRequireLogin',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointRequireLogin extends _i1.EndpointRef {
  EndpointRequireLogin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'requireLogin';

  _i2.Future<bool> unauthenticatedMethod() => caller.callServerEndpoint<bool>(
    'requireLogin',
    'unauthenticatedMethod',
    {},
    authenticated: false,
  );

  _i2.Stream<bool> unauthenticatedStream() =>
      caller.callStreamingServerEndpoint<_i2.Stream<bool>, bool>(
        'requireLogin',
        'unauthenticatedStream',
        {},
        {},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointUpload extends _i1.EndpointRef {
  EndpointUpload(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'upload';

  _i2.Future<bool> uploadByteData(
    String path,
    _i3.ByteData data,
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
class EndpointMyFeature extends _i1.EndpointRef {
  EndpointMyFeature(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'myFeature';

  _i2.Future<String> myFeatureMethod() => caller.callServerEndpoint<String>(
    'myFeature',
    'myFeatureMethod',
    {},
  );

  _i2.Future<_i26.MyFeatureModel> myFeatureModel() =>
      caller.callServerEndpoint<_i26.MyFeatureModel>(
        'myFeature',
        'myFeatureModel',
        {},
      );
}

class Modules {
  Modules(Client client) {
    module = _i14.Caller(client);
  }

  late final _i14.Caller module;
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
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i27.Protocol(),
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
    futureCalls = EndpointFutureCalls(this);
    listParameters = EndpointListParameters(this);
    logging = EndpointLogging(this);
    streamLogging = EndpointStreamLogging(this);
    streamQueryLogging = EndpointStreamQueryLogging(this);
    loggingDisabled = EndpointLoggingDisabled(this);
    mapParameters = EndpointMapParameters(this);
    methodSignaturePermutations = EndpointMethodSignaturePermutations(this);
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
    sessionAuthenticationStreaming = EndpointSessionAuthenticationStreaming(
      this,
    );
    setParameters = EndpointSetParameters(this);
    signInRequired = EndpointSignInRequired(this);
    adminScopeRequired = EndpointAdminScopeRequired(this);
    simple = EndpointSimple(this);
    streaming = EndpointStreaming(this);
    streamingLogging = EndpointStreamingLogging(this);
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

  late final EndpointFutureCalls futureCalls;

  late final EndpointListParameters listParameters;

  late final EndpointLogging logging;

  late final EndpointStreamLogging streamLogging;

  late final EndpointStreamQueryLogging streamQueryLogging;

  late final EndpointLoggingDisabled loggingDisabled;

  late final EndpointMapParameters mapParameters;

  late final EndpointMethodSignaturePermutations methodSignaturePermutations;

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

  late final EndpointSessionAuthenticationStreaming
  sessionAuthenticationStreaming;

  late final EndpointSetParameters setParameters;

  late final EndpointSignInRequired signInRequired;

  late final EndpointAdminScopeRequired adminScopeRequired;

  late final EndpointSimple simple;

  late final EndpointStreaming streaming;

  late final EndpointStreamingLogging streamingLogging;

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
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'asyncTasks': asyncTasks,
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
    'futureCalls': futureCalls,
    'listParameters': listParameters,
    'logging': logging,
    'streamLogging': streamLogging,
    'streamQueryLogging': streamQueryLogging,
    'loggingDisabled': loggingDisabled,
    'mapParameters': mapParameters,
    'methodSignaturePermutations': methodSignaturePermutations,
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
    'sessionAuthenticationStreaming': sessionAuthenticationStreaming,
    'setParameters': setParameters,
    'signInRequired': signInRequired,
    'adminScopeRequired': adminScopeRequired,
    'simple': simple,
    'streaming': streaming,
    'streamingLogging': streamingLogging,
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
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'module': modules.module,
  };
}
