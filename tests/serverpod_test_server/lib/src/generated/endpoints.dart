/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/async_tasks.dart' as _i2;
import '../endpoints/authentication.dart' as _i3;
import '../endpoints/basic_types.dart' as _i4;
import '../endpoints/cloud_storage.dart' as _i5;
import '../endpoints/cloud_storage_s3.dart' as _i6;
import '../endpoints/column_operations/column_bool.dart' as _i7;
import '../endpoints/column_operations/column_date_time.dart' as _i8;
import '../endpoints/column_operations/column_double.dart' as _i9;
import '../endpoints/column_operations/column_duration.dart' as _i10;
import '../endpoints/column_operations/column_enum.dart' as _i11;
import '../endpoints/column_operations/column_int.dart' as _i12;
import '../endpoints/column_operations/column_string.dart' as _i13;
import '../endpoints/column_operations/column_uuid.dart' as _i14;
import '../endpoints/column_operations_legacy/column_bool.dart' as _i15;
import '../endpoints/column_operations_legacy/column_date_time.dart' as _i16;
import '../endpoints/column_operations_legacy/column_double.dart' as _i17;
import '../endpoints/column_operations_legacy/column_duration.dart' as _i18;
import '../endpoints/column_operations_legacy/column_enum.dart' as _i19;
import '../endpoints/column_operations_legacy/column_int.dart' as _i20;
import '../endpoints/column_operations_legacy/column_string.dart' as _i21;
import '../endpoints/column_operations_legacy/column_uuid.dart' as _i22;
import '../endpoints/custom_types.dart' as _i23;
import '../endpoints/database_basic.dart' as _i24;
import '../endpoints/database_basic_legacy.dart' as _i25;
import '../endpoints/database_batch.dart' as _i26;
import '../endpoints/database_batch_generated.dart' as _i27;
import '../endpoints/database_transactions.dart' as _i28;
import '../endpoints/entity_relation.dart' as _i29;
import '../endpoints/exception_test_endpoint.dart' as _i30;
import '../endpoints/failed_calls.dart' as _i31;
import '../endpoints/field_scopes.dart' as _i32;
import '../endpoints/future_calls.dart' as _i33;
import '../endpoints/list_parameters.dart' as _i34;
import '../endpoints/logging.dart' as _i35;
import '../endpoints/logging_disabled.dart' as _i36;
import '../endpoints/map_parameters.dart' as _i37;
import '../endpoints/module_serialization.dart' as _i38;
import '../endpoints/named_parameters.dart' as _i39;
import '../endpoints/optional_parameters.dart' as _i40;
import '../endpoints/redis.dart' as _i41;
import '../endpoints/signin_required.dart' as _i42;
import '../endpoints/simple.dart' as _i43;
import '../endpoints/streaming.dart' as _i44;
import '../endpoints/streaming_logging.dart' as _i45;
import '../endpoints/subDir/subSubDir/subsubdir_test_endpoint.dart' as _i46;
import '../endpoints/subDir/subdir_test_endpoint.dart' as _i47;
import 'dart:typed_data' as _i48;
import 'package:uuid/uuid.dart' as _i49;
import 'package:serverpod_test_server/src/generated/types.dart' as _i50;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i51;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i52;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i53;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i54;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i55;
import 'package:serverpod_test_server/src/generated/object_with_enum.dart'
    as _i56;
import 'package:serverpod_test_server/src/generated/object_with_object.dart'
    as _i57;
import 'package:serverpod_test_server/src/generated/unique_data.dart' as _i58;
import 'package:serverpod_test_server/src/generated/related_unique_data.dart'
    as _i59;
import 'package:serverpod_test_server/src/generated/entities_with_relations/citizen.dart'
    as _i60;
import 'package:serverpod_test_server/src/generated/entities_with_relations/company.dart'
    as _i61;
import 'package:serverpod_test_server/src/generated/entities_with_relations/address.dart'
    as _i62;
import 'package:serverpod_test_server/src/generated/entities_with_relations/town.dart'
    as _i63;
import 'package:serverpod_test_server/src/generated/entities_with_relations/post.dart'
    as _i64;
import 'package:serverpod_test_server/src/generated/object_field_scopes.dart'
    as _i65;
import 'package:serverpod_test_module_server/module.dart' as _i66;
import 'package:serverpod_auth_server/module.dart' as _i67;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'asyncTasks': _i2.AsyncTasksEndpoint()
        ..initialize(
          server,
          'asyncTasks',
          null,
        ),
      'authentication': _i3.AuthenticationEndpoint()
        ..initialize(
          server,
          'authentication',
          null,
        ),
      'basicTypes': _i4.BasicTypesEndpoint()
        ..initialize(
          server,
          'basicTypes',
          null,
        ),
      'cloudStorage': _i5.CloudStorageEndpoint()
        ..initialize(
          server,
          'cloudStorage',
          null,
        ),
      's3CloudStorage': _i6.S3CloudStorageEndpoint()
        ..initialize(
          server,
          's3CloudStorage',
          null,
        ),
      'columnBool': _i7.ColumnBoolEndpoint()
        ..initialize(
          server,
          'columnBool',
          null,
        ),
      'columnDateTime': _i8.ColumnDateTimeEndpoint()
        ..initialize(
          server,
          'columnDateTime',
          null,
        ),
      'columnDouble': _i9.ColumnDoubleEndpoint()
        ..initialize(
          server,
          'columnDouble',
          null,
        ),
      'columnDuration': _i10.ColumnDurationEndpoint()
        ..initialize(
          server,
          'columnDuration',
          null,
        ),
      'columnEnum': _i11.ColumnEnumEndpoint()
        ..initialize(
          server,
          'columnEnum',
          null,
        ),
      'columnInt': _i12.ColumnIntEndpoint()
        ..initialize(
          server,
          'columnInt',
          null,
        ),
      'columnString': _i13.ColumnStringEndpoint()
        ..initialize(
          server,
          'columnString',
          null,
        ),
      'columnUuid': _i14.ColumnUuidEndpoint()
        ..initialize(
          server,
          'columnUuid',
          null,
        ),
      'columnBoolLegacy': _i15.ColumnBoolLegacyEndpoint()
        ..initialize(
          server,
          'columnBoolLegacy',
          null,
        ),
      'columnDateTimeLegacy': _i16.ColumnDateTimeLegacyEndpoint()
        ..initialize(
          server,
          'columnDateTimeLegacy',
          null,
        ),
      'columnDoubleLegacy': _i17.ColumnDoubleLegacyEndpoint()
        ..initialize(
          server,
          'columnDoubleLegacy',
          null,
        ),
      'columnDurationLegacy': _i18.ColumnDurationLegacyEndpoint()
        ..initialize(
          server,
          'columnDurationLegacy',
          null,
        ),
      'columnEnumLegacy': _i19.ColumnEnumLegacyEndpoint()
        ..initialize(
          server,
          'columnEnumLegacy',
          null,
        ),
      'columnIntLegacy': _i20.ColumnIntLegacyEndpoint()
        ..initialize(
          server,
          'columnIntLegacy',
          null,
        ),
      'columnStringLegacy': _i21.ColumnStringLegacyEndpoint()
        ..initialize(
          server,
          'columnStringLegacy',
          null,
        ),
      'columnUuidLegacy': _i22.ColumnUuidLegacyEndpoint()
        ..initialize(
          server,
          'columnUuidLegacy',
          null,
        ),
      'customTypes': _i23.CustomTypesEndpoint()
        ..initialize(
          server,
          'customTypes',
          null,
        ),
      'basicDatabase': _i24.BasicDatabase()
        ..initialize(
          server,
          'basicDatabase',
          null,
        ),
      'basicDatabaseLegacy': _i25.BasicDatabaseLegacy()
        ..initialize(
          server,
          'basicDatabaseLegacy',
          null,
        ),
      'databaseBatch': _i26.DatabaseBatch()
        ..initialize(
          server,
          'databaseBatch',
          null,
        ),
      'databaseBatchGenerated': _i27.DatabaseBatchGenerated()
        ..initialize(
          server,
          'databaseBatchGenerated',
          null,
        ),
      'transactionsDatabase': _i28.TransactionsDatabaseEndpoint()
        ..initialize(
          server,
          'transactionsDatabase',
          null,
        ),
      'relation': _i29.RelationEndpoint()
        ..initialize(
          server,
          'relation',
          null,
        ),
      'exceptionTest': _i30.ExceptionTestEndpoint()
        ..initialize(
          server,
          'exceptionTest',
          null,
        ),
      'failedCalls': _i31.FailedCallsEndpoint()
        ..initialize(
          server,
          'failedCalls',
          null,
        ),
      'fieldScopes': _i32.FieldScopesEndpoint()
        ..initialize(
          server,
          'fieldScopes',
          null,
        ),
      'futureCalls': _i33.FutureCallsEndpoint()
        ..initialize(
          server,
          'futureCalls',
          null,
        ),
      'listParameters': _i34.ListParametersEndpoint()
        ..initialize(
          server,
          'listParameters',
          null,
        ),
      'logging': _i35.LoggingEndpoint()
        ..initialize(
          server,
          'logging',
          null,
        ),
      'loggingDisabled': _i36.LoggingDisabledEndpoint()
        ..initialize(
          server,
          'loggingDisabled',
          null,
        ),
      'mapParameters': _i37.MapParametersEndpoint()
        ..initialize(
          server,
          'mapParameters',
          null,
        ),
      'moduleSerialization': _i38.ModuleSerializationEndpoint()
        ..initialize(
          server,
          'moduleSerialization',
          null,
        ),
      'namedParameters': _i39.NamedParametersEndpoint()
        ..initialize(
          server,
          'namedParameters',
          null,
        ),
      'optionalParameters': _i40.OptionalParametersEndpoint()
        ..initialize(
          server,
          'optionalParameters',
          null,
        ),
      'redis': _i41.RedisEndpoint()
        ..initialize(
          server,
          'redis',
          null,
        ),
      'signInRequired': _i42.SignInRequiredEndpoint()
        ..initialize(
          server,
          'signInRequired',
          null,
        ),
      'simple': _i43.SimpleEndpoint()
        ..initialize(
          server,
          'simple',
          null,
        ),
      'streaming': _i44.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          null,
        ),
      'streamingLogging': _i45.StreamingLoggingEndpoint()
        ..initialize(
          server,
          'streamingLogging',
          null,
        ),
      'subSubDirTest': _i46.SubSubDirTestEndpoint()
        ..initialize(
          server,
          'subSubDirTest',
          null,
        ),
      'subDirTest': _i47.SubDirTestEndpoint()
        ..initialize(
          server,
          'subDirTest',
          null,
        ),
    };
    connectors['asyncTasks'] = _i1.EndpointConnector(
      name: 'asyncTasks',
      endpoint: endpoints['asyncTasks']!,
      methodConnectors: {
        'insertRowToSimpleDataAfterDelay': _i1.MethodConnector(
          name: 'insertRowToSimpleDataAfterDelay',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'seconds': _i1.ParameterDescription(
              name: 'seconds',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['asyncTasks'] as _i2.AsyncTasksEndpoint)
                  .insertRowToSimpleDataAfterDelay(
            session,
            params['num'],
            params['seconds'],
          ),
        ),
        'throwExceptionAfterDelay': _i1.MethodConnector(
          name: 'throwExceptionAfterDelay',
          params: {
            'seconds': _i1.ParameterDescription(
              name: 'seconds',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['asyncTasks'] as _i2.AsyncTasksEndpoint)
                  .throwExceptionAfterDelay(
            session,
            params['seconds'],
          ),
        ),
      },
    );
    connectors['authentication'] = _i1.EndpointConnector(
      name: 'authentication',
      endpoint: endpoints['authentication']!,
      methodConnectors: {
        'removeAllUsers': _i1.MethodConnector(
          name: 'removeAllUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .removeAllUsers(session),
        ),
        'countUsers': _i1.MethodConnector(
          name: 'countUsers',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .countUsers(session),
        ),
        'createUser': _i1.MethodConnector(
          name: 'createUser',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .createUser(
            session,
            params['email'],
            params['password'],
          ),
        ),
        'authenticate': _i1.MethodConnector(
          name: 'authenticate',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .authenticate(
            session,
            params['email'],
            params['password'],
          ),
        ),
        'signOut': _i1.MethodConnector(
          name: 'signOut',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['authentication'] as _i3.AuthenticationEndpoint)
                  .signOut(session),
        ),
      },
    );
    connectors['basicTypes'] = _i1.EndpointConnector(
      name: 'basicTypes',
      endpoint: endpoints['basicTypes']!,
      methodConnectors: {
        'testInt': _i1.MethodConnector(
          name: 'testInt',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testInt(
            session,
            params['value'],
          ),
        ),
        'testDouble': _i1.MethodConnector(
          name: 'testDouble',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testDouble(
            session,
            params['value'],
          ),
        ),
        'testBool': _i1.MethodConnector(
          name: 'testBool',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testBool(
            session,
            params['value'],
          ),
        ),
        'testDateTime': _i1.MethodConnector(
          name: 'testDateTime',
          params: {
            'dateTime': _i1.ParameterDescription(
              name: 'dateTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testDateTime(
            session,
            params['dateTime'],
          ),
        ),
        'testString': _i1.MethodConnector(
          name: 'testString',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testString(
            session,
            params['value'],
          ),
        ),
        'testByteData': _i1.MethodConnector(
          name: 'testByteData',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i48.ByteData?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testByteData(
            session,
            params['value'],
          ),
        ),
        'testDuration': _i1.MethodConnector(
          name: 'testDuration',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testDuration(
            session,
            params['value'],
          ),
        ),
        'testUuid': _i1.MethodConnector(
          name: 'testUuid',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicTypes'] as _i4.BasicTypesEndpoint).testUuid(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['cloudStorage'] = _i1.EndpointConnector(
      name: 'cloudStorage',
      endpoint: endpoints['cloudStorage']!,
      methodConnectors: {
        'reset': _i1.MethodConnector(
          name: 'reset',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .reset(session),
        ),
        'storePublicFile': _i1.MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'byteData': _i1.ParameterDescription(
              name: 'byteData',
              type: _i1.getType<_i48.ByteData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .storePublicFile(
            session,
            params['path'],
            params['byteData'],
          ),
        ),
        'retrievePublicFile': _i1.MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .retrievePublicFile(
            session,
            params['path'],
          ),
        ),
        'existsPublicFile': _i1.MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .existsPublicFile(
            session,
            params['path'],
          ),
        ),
        'deletePublicFile': _i1.MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .deletePublicFile(
            session,
            params['path'],
          ),
        ),
        'getPublicUrlForFile': _i1.MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .getPublicUrlForFile(
            session,
            params['path'],
          ),
        ),
        'getDirectFilePostUrl': _i1.MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .getDirectFilePostUrl(
            session,
            params['path'],
          ),
        ),
        'verifyDirectFileUpload': _i1.MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cloudStorage'] as _i5.CloudStorageEndpoint)
                  .verifyDirectFileUpload(
            session,
            params['path'],
          ),
        ),
      },
    );
    connectors['s3CloudStorage'] = _i1.EndpointConnector(
      name: 's3CloudStorage',
      endpoint: endpoints['s3CloudStorage']!,
      methodConnectors: {
        'storePublicFile': _i1.MethodConnector(
          name: 'storePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'byteData': _i1.ParameterDescription(
              name: 'byteData',
              type: _i1.getType<_i48.ByteData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
                  .storePublicFile(
            session,
            params['path'],
            params['byteData'],
          ),
        ),
        'retrievePublicFile': _i1.MethodConnector(
          name: 'retrievePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
                  .retrievePublicFile(
            session,
            params['path'],
          ),
        ),
        'existsPublicFile': _i1.MethodConnector(
          name: 'existsPublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
                  .existsPublicFile(
            session,
            params['path'],
          ),
        ),
        'deletePublicFile': _i1.MethodConnector(
          name: 'deletePublicFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
                  .deletePublicFile(
            session,
            params['path'],
          ),
        ),
        'getPublicUrlForFile': _i1.MethodConnector(
          name: 'getPublicUrlForFile',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
                  .getPublicUrlForFile(
            session,
            params['path'],
          ),
        ),
        'getDirectFilePostUrl': _i1.MethodConnector(
          name: 'getDirectFilePostUrl',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
                  .getDirectFilePostUrl(
            session,
            params['path'],
          ),
        ),
        'verifyDirectFileUpload': _i1.MethodConnector(
          name: 'verifyDirectFileUpload',
          params: {
            'path': _i1.ParameterDescription(
              name: 'path',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['s3CloudStorage'] as _i6.S3CloudStorageEndpoint)
                  .verifyDirectFileUpload(
            session,
            params['path'],
          ),
        ),
      },
    );
    connectors['columnBool'] = _i1.EndpointConnector(
      name: 'columnBool',
      endpoint: endpoints['columnBool']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint).insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint).equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint).notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint).inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint).notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBool'] as _i7.ColumnBoolEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['columnDateTime'] = _i1.EndpointConnector(
      name: 'columnDateTime',
      endpoint: endpoints['columnDateTime']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint).inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTime'] as _i8.ColumnDateTimeEndpoint)
                  .notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnDouble'] = _i1.EndpointConnector(
      name: 'columnDouble',
      endpoint: endpoints['columnDouble']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint).insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint).equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint).notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint).inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint).notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint).lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint).between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDouble'] as _i9.ColumnDoubleEndpoint)
                  .notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnDuration'] = _i1.EndpointConnector(
      name: 'columnDuration',
      endpoint: endpoints['columnDuration']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDuration'] as _i10.ColumnDurationEndpoint)
                  .notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnEnum'] = _i1.EndpointConnector(
      name: 'columnEnum',
      endpoint: endpoints['columnEnum']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint).insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint).equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint).notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i51.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint).inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i51.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint).notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnum'] as _i11.ColumnEnumEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['columnInt'] = _i1.EndpointConnector(
      name: 'columnInt',
      endpoint: endpoints['columnInt']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnInt'] as _i12.ColumnIntEndpoint).notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnString'] = _i1.EndpointConnector(
      name: 'columnString',
      endpoint: endpoints['columnString']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint).insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint).equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint).inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint).notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'like': _i1.MethodConnector(
          name: 'like',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint).like(
            session,
            params['value'],
          ),
        ),
        'ilike': _i1.MethodConnector(
          name: 'ilike',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnString'] as _i13.ColumnStringEndpoint).ilike(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['columnUuid'] = _i1.EndpointConnector(
      name: 'columnUuid',
      endpoint: endpoints['columnUuid']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint).insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint).equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint).notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i49.UuidValue>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint).inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i49.UuidValue>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint).notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuid'] as _i14.ColumnUuidEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['columnBoolLegacy'] = _i1.EndpointConnector(
      name: 'columnBoolLegacy',
      endpoint: endpoints['columnBoolLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<bool>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i15.ColumnBoolLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['columnDateTimeLegacy'] = _i1.EndpointConnector(
      name: 'columnDateTimeLegacy',
      endpoint: endpoints['columnDateTimeLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<DateTime>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i16.ColumnDateTimeLegacyEndpoint)
                  .notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnDoubleLegacy'] = _i1.EndpointConnector(
      name: 'columnDoubleLegacy',
      endpoint: endpoints['columnDoubleLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<double>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i17.ColumnDoubleLegacyEndpoint)
                  .notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnDurationLegacy'] = _i1.EndpointConnector(
      name: 'columnDurationLegacy',
      endpoint: endpoints['columnDurationLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<Duration>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<Duration>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i18.ColumnDurationLegacyEndpoint)
                  .notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnEnumLegacy'] = _i1.EndpointConnector(
      name: 'columnEnumLegacy',
      endpoint: endpoints['columnEnumLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i51.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i51.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i51.TestEnum>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i19.ColumnEnumLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['columnIntLegacy'] = _i1.EndpointConnector(
      name: 'columnIntLegacy',
      endpoint: endpoints['columnIntLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'greaterThan': _i1.MethodConnector(
          name: 'greaterThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .greaterThan(
            session,
            params['value'],
          ),
        ),
        'greaterOrEqualThan': _i1.MethodConnector(
          name: 'greaterOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .greaterOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'lessThan': _i1.MethodConnector(
          name: 'lessThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .lessThan(
            session,
            params['value'],
          ),
        ),
        'lessOrEqualThan': _i1.MethodConnector(
          name: 'lessOrEqualThan',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .lessOrEqualThan(
            session,
            params['value'],
          ),
        ),
        'between': _i1.MethodConnector(
          name: 'between',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .between(
            session,
            params['min'],
            params['max'],
          ),
        ),
        'notBetween': _i1.MethodConnector(
          name: 'notBetween',
          params: {
            'min': _i1.ParameterDescription(
              name: 'min',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'max': _i1.ParameterDescription(
              name: 'max',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i20.ColumnIntLegacyEndpoint)
                  .notBetween(
            session,
            params['min'],
            params['max'],
          ),
        ),
      },
    );
    connectors['columnStringLegacy'] = _i1.EndpointConnector(
      name: 'columnStringLegacy',
      endpoint: endpoints['columnStringLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'like': _i1.MethodConnector(
          name: 'like',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .like(
            session,
            params['value'],
          ),
        ),
        'ilike': _i1.MethodConnector(
          name: 'ilike',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i21.ColumnStringLegacyEndpoint)
                  .ilike(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['columnUuidLegacy'] = _i1.EndpointConnector(
      name: 'columnUuidLegacy',
      endpoint: endpoints['columnUuidLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .insert(
            session,
            params['types'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .equals(
            session,
            params['value'],
          ),
        ),
        'notEquals': _i1.MethodConnector(
          name: 'notEquals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .notEquals(
            session,
            params['value'],
          ),
        ),
        'inSet': _i1.MethodConnector(
          name: 'inSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i49.UuidValue>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .inSet(
            session,
            params['value'],
          ),
        ),
        'notInSet': _i1.MethodConnector(
          name: 'notInSet',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i49.UuidValue>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .notInSet(
            session,
            params['value'],
          ),
        ),
        'isDistinctFrom': _i1.MethodConnector(
          name: 'isDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .isDistinctFrom(
            session,
            params['value'],
          ),
        ),
        'isNotDistinctFrom': _i1.MethodConnector(
          name: 'isNotDistinctFrom',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i49.UuidValue>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i22.ColumnUuidLegacyEndpoint)
                  .isNotDistinctFrom(
            session,
            params['value'],
          ),
        ),
      },
    );
    connectors['customTypes'] = _i1.EndpointConnector(
      name: 'customTypes',
      endpoint: endpoints['customTypes']!,
      methodConnectors: {
        'returnCustomClass': _i1.MethodConnector(
          name: 'returnCustomClass',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i52.CustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnCustomClass(
            session,
            params['data'],
          ),
        ),
        'returnCustomClassNullable': _i1.MethodConnector(
          name: 'returnCustomClassNullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i52.CustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnCustomClassNullable(
            session,
            params['data'],
          ),
        ),
        'returnCustomClass2': _i1.MethodConnector(
          name: 'returnCustomClass2',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i52.CustomClass2>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnCustomClass2(
            session,
            params['data'],
          ),
        ),
        'returnCustomClass2Nullable': _i1.MethodConnector(
          name: 'returnCustomClass2Nullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i52.CustomClass2?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnCustomClass2Nullable(
            session,
            params['data'],
          ),
        ),
        'returnExternalCustomClass': _i1.MethodConnector(
          name: 'returnExternalCustomClass',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i53.ExternalCustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnExternalCustomClass(
            session,
            params['data'],
          ),
        ),
        'returnExternalCustomClassNullable': _i1.MethodConnector(
          name: 'returnExternalCustomClassNullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i53.ExternalCustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnExternalCustomClassNullable(
            session,
            params['data'],
          ),
        ),
        'returnFreezedCustomClass': _i1.MethodConnector(
          name: 'returnFreezedCustomClass',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i54.FreezedCustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnFreezedCustomClass(
            session,
            params['data'],
          ),
        ),
        'returnFreezedCustomClassNullable': _i1.MethodConnector(
          name: 'returnFreezedCustomClassNullable',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i54.FreezedCustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i23.CustomTypesEndpoint)
                  .returnFreezedCustomClassNullable(
            session,
            params['data'],
          ),
        ),
      },
    );
    connectors['basicDatabase'] = _i1.EndpointConnector(
      name: 'basicDatabase',
      endpoint: endpoints['basicDatabase']!,
      methodConnectors: {
        'findSimpleData': _i1.MethodConnector(
          name: 'findSimpleData',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase).findSimpleData(
            session,
            limit: params['limit'],
            offset: params['offset'],
          ),
        ),
        'findRowSimpleData': _i1.MethodConnector(
          name: 'findRowSimpleData',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .findRowSimpleData(
            session,
            params['num'],
          ),
        ),
        'findByIdSimpleData': _i1.MethodConnector(
          name: 'findByIdSimpleData',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .findByIdSimpleData(
            session,
            params['id'],
          ),
        ),
        'insertRowSimpleData': _i1.MethodConnector(
          name: 'insertRowSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i55.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .insertRowSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'updateRowSimpleData': _i1.MethodConnector(
          name: 'updateRowSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i55.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .updateRowSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'deleteRowSimpleData': _i1.MethodConnector(
          name: 'deleteRowSimpleData',
          params: {
            'simpleData': _i1.ParameterDescription(
              name: 'simpleData',
              type: _i1.getType<_i55.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .deleteRowSimpleData(
            session,
            params['simpleData'],
          ),
        ),
        'deleteWhereSimpleData': _i1.MethodConnector(
          name: 'deleteWhereSimpleData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .deleteWhereSimpleData(session),
        ),
        'countSimpleData': _i1.MethodConnector(
          name: 'countSimpleData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .countSimpleData(session),
        ),
        'insertTypes': _i1.MethodConnector(
          name: 'insertTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i50.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase).insertTypes(
            session,
            params['value'],
          ),
        ),
        'updateTypes': _i1.MethodConnector(
          name: 'updateTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i50.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase).updateTypes(
            session,
            params['value'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i24.BasicDatabase)
                  .deleteAll(session),
        ),
      },
    );
    connectors['basicDatabaseLegacy'] = _i1.EndpointConnector(
      name: 'basicDatabaseLegacy',
      endpoint: endpoints['basicDatabaseLegacy']!,
      methodConnectors: {
        'storeTypes': _i1.MethodConnector(
          name: 'storeTypes',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<_i50.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .storeTypes(
            session,
            params['types'],
          ),
        ),
        'getTypes': _i1.MethodConnector(
          name: 'getTypes',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .getTypes(
            session,
            params['id'],
          ),
        ),
        'storeObjectWithEnum': _i1.MethodConnector(
          name: 'storeObjectWithEnum',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i56.ObjectWithEnum>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .storeObjectWithEnum(
            session,
            params['object'],
          ),
        ),
        'getObjectWithEnum': _i1.MethodConnector(
          name: 'getObjectWithEnum',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .getObjectWithEnum(
            session,
            params['id'],
          ),
        ),
        'getTypesRawQuery': _i1.MethodConnector(
          name: 'getTypesRawQuery',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .getTypesRawQuery(
            session,
            params['id'],
          ),
        ),
        'countTypesRows': _i1.MethodConnector(
          name: 'countTypesRows',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .countTypesRows(session),
        ),
        'deleteAllInTypes': _i1.MethodConnector(
          name: 'deleteAllInTypes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .deleteAllInTypes(session),
        ),
        'createSimpleTestData': _i1.MethodConnector(
          name: 'createSimpleTestData',
          params: {
            'numRows': _i1.ParameterDescription(
              name: 'numRows',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .createSimpleTestData(
            session,
            params['numRows'],
          ),
        ),
        'countSimpleData': _i1.MethodConnector(
          name: 'countSimpleData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .countSimpleData(session),
        ),
        'deleteAllSimpleTestData': _i1.MethodConnector(
          name: 'deleteAllSimpleTestData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .deleteAllSimpleTestData(session),
        ),
        'deleteSimpleTestDataLessThan': _i1.MethodConnector(
          name: 'deleteSimpleTestDataLessThan',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .deleteSimpleTestDataLessThan(
            session,
            params['num'],
          ),
        ),
        'findAndDeleteSimpleTestData': _i1.MethodConnector(
          name: 'findAndDeleteSimpleTestData',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .findAndDeleteSimpleTestData(
            session,
            params['num'],
          ),
        ),
        'findSimpleDataRowsLessThan': _i1.MethodConnector(
          name: 'findSimpleDataRowsLessThan',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'descending': _i1.ParameterDescription(
              name: 'descending',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .findSimpleDataRowsLessThan(
            session,
            params['num'],
            params['offset'],
            params['limit'],
            params['descending'],
          ),
        ),
        'updateSimpleDataRow': _i1.MethodConnector(
          name: 'updateSimpleDataRow',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newNum': _i1.ParameterDescription(
              name: 'newNum',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .updateSimpleDataRow(
            session,
            params['num'],
            params['newNum'],
          ),
        ),
        'storeObjectWithObject': _i1.MethodConnector(
          name: 'storeObjectWithObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i57.ObjectWithObject>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .storeObjectWithObject(
            session,
            params['object'],
          ),
        ),
        'getObjectWithObject': _i1.MethodConnector(
          name: 'getObjectWithObject',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .getObjectWithObject(
            session,
            params['id'],
          ),
        ),
        'testByteDataStore': _i1.MethodConnector(
          name: 'testByteDataStore',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .testByteDataStore(session),
        ),
        'testDurationStore': _i1.MethodConnector(
          name: 'testDurationStore',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i25.BasicDatabaseLegacy)
                  .testDurationStore(session),
        ),
      },
    );
    connectors['databaseBatch'] = _i1.EndpointConnector(
      name: 'databaseBatch',
      endpoint: endpoints['databaseBatch']!,
      methodConnectors: {
        'batchInsert': _i1.MethodConnector(
          name: 'batchInsert',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch).batchInsert(
            session,
            params['value'],
          ),
        ),
        'batchInsertTypes': _i1.MethodConnector(
          name: 'batchInsertTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch)
                  .batchInsertTypes(
            session,
            params['value'],
          ),
        ),
        'batchUpdate': _i1.MethodConnector(
          name: 'batchUpdate',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch).batchUpdate(
            session,
            params['value'],
          ),
        ),
        'batchUpdateTypes': _i1.MethodConnector(
          name: 'batchUpdateTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch)
                  .batchUpdateTypes(
            session,
            params['value'],
          ),
        ),
        'batchUpdateWithInvalidColumn': _i1.MethodConnector(
          name: 'batchUpdateWithInvalidColumn',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch)
                  .batchUpdateWithInvalidColumn(
            session,
            params['value'],
          ),
        ),
        'batchUpdateNumberOnly': _i1.MethodConnector(
          name: 'batchUpdateNumberOnly',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch)
                  .batchUpdateNumberOnly(
            session,
            params['value'],
          ),
        ),
        'batchDelete': _i1.MethodConnector(
          name: 'batchDelete',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch).batchDelete(
            session,
            params['value'],
          ),
        ),
        'insertRelatedUniqueData': _i1.MethodConnector(
          name: 'insertRelatedUniqueData',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i59.RelatedUniqueData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch)
                  .insertRelatedUniqueData(
            session,
            params['value'],
          ),
        ),
        'findByEmail': _i1.MethodConnector(
          name: 'findByEmail',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch).findByEmail(
            session,
            params['email'],
          ),
        ),
        'findById': _i1.MethodConnector(
          name: 'findById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch).findById(
            session,
            params['id'],
          ),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch)
                  .findAll(session),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i26.DatabaseBatch)
                  .deleteAll(session),
        ),
      },
    );
    connectors['databaseBatchGenerated'] = _i1.EndpointConnector(
      name: 'databaseBatchGenerated',
      endpoint: endpoints['databaseBatchGenerated']!,
      methodConnectors: {
        'batchInsert': _i1.MethodConnector(
          name: 'batchInsert',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .batchInsert(
            session,
            params['value'],
          ),
        ),
        'batchInsertTypes': _i1.MethodConnector(
          name: 'batchInsertTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .batchInsertTypes(
            session,
            params['value'],
          ),
        ),
        'batchUpdate': _i1.MethodConnector(
          name: 'batchUpdate',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .batchUpdate(
            session,
            params['value'],
          ),
        ),
        'batchUpdateTypes': _i1.MethodConnector(
          name: 'batchUpdateTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i50.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .batchUpdateTypes(
            session,
            params['value'],
          ),
        ),
        'batchDelete': _i1.MethodConnector(
          name: 'batchDelete',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i58.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .batchDelete(
            session,
            params['value'],
          ),
        ),
        'insertRelatedUniqueData': _i1.MethodConnector(
          name: 'insertRelatedUniqueData',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i59.RelatedUniqueData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .insertRelatedUniqueData(
            session,
            params['value'],
          ),
        ),
        'findByEmail': _i1.MethodConnector(
          name: 'findByEmail',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .findByEmail(
            session,
            params['email'],
          ),
        ),
        'findById': _i1.MethodConnector(
          name: 'findById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .findById(
            session,
            params['id'],
          ),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .findAll(session),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i27.DatabaseBatchGenerated)
                  .deleteAll(session),
        ),
      },
    );
    connectors['transactionsDatabase'] = _i1.EndpointConnector(
      name: 'transactionsDatabase',
      endpoint: endpoints['transactionsDatabase']!,
      methodConnectors: {
        'removeRow': _i1.MethodConnector(
          name: 'removeRow',
          params: {
            'num': _i1.ParameterDescription(
              name: 'num',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transactionsDatabase']
                      as _i28.TransactionsDatabaseEndpoint)
                  .removeRow(
            session,
            params['num'],
          ),
        ),
        'updateInsertDelete': _i1.MethodConnector(
          name: 'updateInsertDelete',
          params: {
            'numUpdate': _i1.ParameterDescription(
              name: 'numUpdate',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'numInsert': _i1.ParameterDescription(
              name: 'numInsert',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'numDelete': _i1.ParameterDescription(
              name: 'numDelete',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['transactionsDatabase']
                      as _i28.TransactionsDatabaseEndpoint)
                  .updateInsertDelete(
            session,
            params['numUpdate'],
            params['numInsert'],
            params['numDelete'],
          ),
        ),
      },
    );
    connectors['relation'] = _i1.EndpointConnector(
      name: 'relation',
      endpoint: endpoints['relation']!,
      methodConnectors: {
        'citizenFindWhereCompanyNameIs': _i1.MethodConnector(
          name: 'citizenFindWhereCompanyNameIs',
          params: {
            'companyName': _i1.ParameterDescription(
              name: 'companyName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindWhereCompanyNameIs(
            session,
            companyName: params['companyName'],
          ),
        ),
        'citizenFindWhereCompanyTownNameIs': _i1.MethodConnector(
          name: 'citizenFindWhereCompanyTownNameIs',
          params: {
            'townName': _i1.ParameterDescription(
              name: 'townName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindWhereCompanyTownNameIs(
            session,
            townName: params['townName'],
          ),
        ),
        'citizenFindOrderedByCompanyName': _i1.MethodConnector(
          name: 'citizenFindOrderedByCompanyName',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindOrderedByCompanyName(session),
        ),
        'citizenFindOrderedByCompanyTownName': _i1.MethodConnector(
          name: 'citizenFindOrderedByCompanyTownName',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindOrderedByCompanyTownName(session),
        ),
        'citizenDeleteWhereCompanyNameIs': _i1.MethodConnector(
          name: 'citizenDeleteWhereCompanyNameIs',
          params: {
            'companyName': _i1.ParameterDescription(
              name: 'companyName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenDeleteWhereCompanyNameIs(
            session,
            companyName: params['companyName'],
          ),
        ),
        'citizenDeleteWhereCompanyTownNameIs': _i1.MethodConnector(
          name: 'citizenDeleteWhereCompanyTownNameIs',
          params: {
            'townName': _i1.ParameterDescription(
              name: 'townName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenDeleteWhereCompanyTownNameIs(
            session,
            townName: params['townName'],
          ),
        ),
        'citizenCountWhereCompanyNameIs': _i1.MethodConnector(
          name: 'citizenCountWhereCompanyNameIs',
          params: {
            'companyName': _i1.ParameterDescription(
              name: 'companyName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenCountWhereCompanyNameIs(
            session,
            companyName: params['companyName'],
          ),
        ),
        'citizenCountWhereCompanyTownNameIs': _i1.MethodConnector(
          name: 'citizenCountWhereCompanyTownNameIs',
          params: {
            'townName': _i1.ParameterDescription(
              name: 'townName',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenCountWhereCompanyTownNameIs(
            session,
            townName: params['townName'],
          ),
        ),
        'citizenFindAll': _i1.MethodConnector(
          name: 'citizenFindAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindAll(session),
        ),
        'citizenFindAllWithDeepIncludes': _i1.MethodConnector(
          name: 'citizenFindAllWithDeepIncludes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindAllWithDeepIncludes(session),
        ),
        'citizenFindAllWithNamedRelationNoneOriginSide': _i1.MethodConnector(
          name: 'citizenFindAllWithNamedRelationNoneOriginSide',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindAllWithNamedRelationNoneOriginSide(session),
        ),
        'citizenFindAllWithShallowIncludes': _i1.MethodConnector(
          name: 'citizenFindAllWithShallowIncludes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindAllWithShallowIncludes(session),
        ),
        'citizenFindByIdWithIncludes': _i1.MethodConnector(
          name: 'citizenFindByIdWithIncludes',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenFindByIdWithIncludes(
            session,
            params['id'],
          ),
        ),
        'addressFindAll': _i1.MethodConnector(
          name: 'addressFindAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .addressFindAll(session),
        ),
        'addressFindById': _i1.MethodConnector(
          name: 'addressFindById',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint).addressFindById(
            session,
            params['id'],
          ),
        ),
        'findAllPostsIncludingNextAndPrevious': _i1.MethodConnector(
          name: 'findAllPostsIncludingNextAndPrevious',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .findAllPostsIncludingNextAndPrevious(session),
        ),
        'citizenAttachCompany': _i1.MethodConnector(
          name: 'citizenAttachCompany',
          params: {
            'citizen': _i1.ParameterDescription(
              name: 'citizen',
              type: _i1.getType<_i60.Citizen>(),
              nullable: false,
            ),
            'company': _i1.ParameterDescription(
              name: 'company',
              type: _i1.getType<_i61.Company>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenAttachCompany(
            session,
            params['citizen'],
            params['company'],
          ),
        ),
        'citizenAttachAddress': _i1.MethodConnector(
          name: 'citizenAttachAddress',
          params: {
            'citizen': _i1.ParameterDescription(
              name: 'citizen',
              type: _i1.getType<_i60.Citizen>(),
              nullable: false,
            ),
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<_i62.Address>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenAttachAddress(
            session,
            params['citizen'],
            params['address'],
          ),
        ),
        'citizenDetachAddress': _i1.MethodConnector(
          name: 'citizenDetachAddress',
          params: {
            'citizen': _i1.ParameterDescription(
              name: 'citizen',
              type: _i1.getType<_i60.Citizen>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .citizenDetachAddress(
            session,
            params['citizen'],
          ),
        ),
        'addressAttachCitizen': _i1.MethodConnector(
          name: 'addressAttachCitizen',
          params: {
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<_i62.Address>(),
              nullable: false,
            ),
            'citizen': _i1.ParameterDescription(
              name: 'citizen',
              type: _i1.getType<_i60.Citizen>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .addressAttachCitizen(
            session,
            params['address'],
            params['citizen'],
          ),
        ),
        'addressDetachCitizen': _i1.MethodConnector(
          name: 'addressDetachCitizen',
          params: {
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<_i62.Address>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .addressDetachCitizen(
            session,
            params['address'],
          ),
        ),
        'companyFindAll': _i1.MethodConnector(
          name: 'companyFindAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .companyFindAll(session),
        ),
        'citizenInsert': _i1.MethodConnector(
          name: 'citizenInsert',
          params: {
            'citizen': _i1.ParameterDescription(
              name: 'citizen',
              type: _i1.getType<_i60.Citizen>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint).citizenInsert(
            session,
            params['citizen'],
          ),
        ),
        'companyInsert': _i1.MethodConnector(
          name: 'companyInsert',
          params: {
            'company': _i1.ParameterDescription(
              name: 'company',
              type: _i1.getType<_i61.Company>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint).companyInsert(
            session,
            params['company'],
          ),
        ),
        'townInsert': _i1.MethodConnector(
          name: 'townInsert',
          params: {
            'town': _i1.ParameterDescription(
              name: 'town',
              type: _i1.getType<_i63.Town>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint).townInsert(
            session,
            params['town'],
          ),
        ),
        'addressInsert': _i1.MethodConnector(
          name: 'addressInsert',
          params: {
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<_i62.Address>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint).addressInsert(
            session,
            params['address'],
          ),
        ),
        'postInsert': _i1.MethodConnector(
          name: 'postInsert',
          params: {
            'post': _i1.ParameterDescription(
              name: 'post',
              type: _i1.getType<_i64.Post>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint).postInsert(
            session,
            params['post'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i29.RelationEndpoint)
                  .deleteAll(session),
        ),
      },
    );
    connectors['exceptionTest'] = _i1.EndpointConnector(
      name: 'exceptionTest',
      endpoint: endpoints['exceptionTest']!,
      methodConnectors: {
        'throwNormalException': _i1.MethodConnector(
          name: 'throwNormalException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i30.ExceptionTestEndpoint)
                  .throwNormalException(session),
        ),
        'throwExceptionWithData': _i1.MethodConnector(
          name: 'throwExceptionWithData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i30.ExceptionTestEndpoint)
                  .throwExceptionWithData(session),
        ),
        'workingWithoutException': _i1.MethodConnector(
          name: 'workingWithoutException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i30.ExceptionTestEndpoint)
                  .workingWithoutException(session),
        ),
      },
    );
    connectors['failedCalls'] = _i1.EndpointConnector(
      name: 'failedCalls',
      endpoint: endpoints['failedCalls']!,
      methodConnectors: {
        'failedCall': _i1.MethodConnector(
          name: 'failedCall',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i31.FailedCallsEndpoint)
                  .failedCall(session),
        ),
        'failedDatabaseQuery': _i1.MethodConnector(
          name: 'failedDatabaseQuery',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i31.FailedCallsEndpoint)
                  .failedDatabaseQuery(session),
        ),
        'failedDatabaseQueryCaughtException': _i1.MethodConnector(
          name: 'failedDatabaseQueryCaughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i31.FailedCallsEndpoint)
                  .failedDatabaseQueryCaughtException(session),
        ),
        'slowCall': _i1.MethodConnector(
          name: 'slowCall',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i31.FailedCallsEndpoint)
                  .slowCall(session),
        ),
        'caughtException': _i1.MethodConnector(
          name: 'caughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i31.FailedCallsEndpoint)
                  .caughtException(session),
        ),
      },
    );
    connectors['fieldScopes'] = _i1.EndpointConnector(
      name: 'fieldScopes',
      endpoint: endpoints['fieldScopes']!,
      methodConnectors: {
        'storeObject': _i1.MethodConnector(
          name: 'storeObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i65.ObjectFieldScopes>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['fieldScopes'] as _i32.FieldScopesEndpoint)
                  .storeObject(
            session,
            params['object'],
          ),
        ),
        'retrieveObject': _i1.MethodConnector(
          name: 'retrieveObject',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['fieldScopes'] as _i32.FieldScopesEndpoint)
                  .retrieveObject(session),
        ),
      },
    );
    connectors['futureCalls'] = _i1.EndpointConnector(
      name: 'futureCalls',
      endpoint: endpoints['futureCalls']!,
      methodConnectors: {
        'makeFutureCall': _i1.MethodConnector(
          name: 'makeFutureCall',
          params: {
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i55.SimpleData?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['futureCalls'] as _i33.FutureCallsEndpoint)
                  .makeFutureCall(
            session,
            params['data'],
          ),
        )
      },
    );
    connectors['listParameters'] = _i1.EndpointConnector(
      name: 'listParameters',
      endpoint: endpoints['listParameters']!,
      methodConnectors: {
        'returnIntList': _i1.MethodConnector(
          name: 'returnIntList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnIntList(
            session,
            params['list'],
          ),
        ),
        'returnIntListList': _i1.MethodConnector(
          name: 'returnIntListList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<List<int>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnIntListList(
            session,
            params['list'],
          ),
        ),
        'returnIntListNullable': _i1.MethodConnector(
          name: 'returnIntListNullable',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnIntListNullable(
            session,
            params['list'],
          ),
        ),
        'returnIntListNullableList': _i1.MethodConnector(
          name: 'returnIntListNullableList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<List<int>?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnIntListNullableList(
            session,
            params['list'],
          ),
        ),
        'returnIntListListNullable': _i1.MethodConnector(
          name: 'returnIntListListNullable',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<List<int>>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnIntListListNullable(
            session,
            params['list'],
          ),
        ),
        'returnIntListNullableInts': _i1.MethodConnector(
          name: 'returnIntListNullableInts',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnIntListNullableInts(
            session,
            params['list'],
          ),
        ),
        'returnNullableIntListNullableInts': _i1.MethodConnector(
          name: 'returnNullableIntListNullableInts',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<int?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnNullableIntListNullableInts(
            session,
            params['list'],
          ),
        ),
        'returnDoubleList': _i1.MethodConnector(
          name: 'returnDoubleList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnDoubleList(
            session,
            params['list'],
          ),
        ),
        'returnDoubleListNullableDoubles': _i1.MethodConnector(
          name: 'returnDoubleListNullableDoubles',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<double?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnDoubleListNullableDoubles(
            session,
            params['list'],
          ),
        ),
        'returnBoolList': _i1.MethodConnector(
          name: 'returnBoolList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnBoolList(
            session,
            params['list'],
          ),
        ),
        'returnBoolListNullableBools': _i1.MethodConnector(
          name: 'returnBoolListNullableBools',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<bool?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnBoolListNullableBools(
            session,
            params['list'],
          ),
        ),
        'returnStringList': _i1.MethodConnector(
          name: 'returnStringList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnStringList(
            session,
            params['list'],
          ),
        ),
        'returnStringListNullableStrings': _i1.MethodConnector(
          name: 'returnStringListNullableStrings',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<String?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnStringListNullableStrings(
            session,
            params['list'],
          ),
        ),
        'returnDateTimeList': _i1.MethodConnector(
          name: 'returnDateTimeList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnDateTimeList(
            session,
            params['list'],
          ),
        ),
        'returnDateTimeListNullableDateTimes': _i1.MethodConnector(
          name: 'returnDateTimeListNullableDateTimes',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<DateTime?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnDateTimeListNullableDateTimes(
            session,
            params['list'],
          ),
        ),
        'returnByteDataList': _i1.MethodConnector(
          name: 'returnByteDataList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i48.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnByteDataList(
            session,
            params['list'],
          ),
        ),
        'returnByteDataListNullableByteDatas': _i1.MethodConnector(
          name: 'returnByteDataListNullableByteDatas',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i48.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnByteDataListNullableByteDatas(
            session,
            params['list'],
          ),
        ),
        'returnSimpleDataList': _i1.MethodConnector(
          name: 'returnSimpleDataList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i55.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnSimpleDataList(
            session,
            params['list'],
          ),
        ),
        'returnSimpleDataListNullableSimpleData': _i1.MethodConnector(
          name: 'returnSimpleDataListNullableSimpleData',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i55.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnSimpleDataListNullableSimpleData(
            session,
            params['list'],
          ),
        ),
        'returnSimpleDataListNullable': _i1.MethodConnector(
          name: 'returnSimpleDataListNullable',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i55.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnSimpleDataListNullable(
            session,
            params['list'],
          ),
        ),
        'returnNullableSimpleDataListNullableSimpleData': _i1.MethodConnector(
          name: 'returnNullableSimpleDataListNullableSimpleData',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<_i55.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnNullableSimpleDataListNullableSimpleData(
            session,
            params['list'],
          ),
        ),
        'returnDurationList': _i1.MethodConnector(
          name: 'returnDurationList',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnDurationList(
            session,
            params['list'],
          ),
        ),
        'returnDurationListNullableDurations': _i1.MethodConnector(
          name: 'returnDurationListNullableDurations',
          params: {
            'list': _i1.ParameterDescription(
              name: 'list',
              type: _i1.getType<List<Duration?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i34.ListParametersEndpoint)
                  .returnDurationListNullableDurations(
            session,
            params['list'],
          ),
        ),
      },
    );
    connectors['logging'] = _i1.EndpointConnector(
      name: 'logging',
      endpoint: endpoints['logging']!,
      methodConnectors: {
        'logInfo': _i1.MethodConnector(
          name: 'logInfo',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i35.LoggingEndpoint).logInfo(
            session,
            params['message'],
          ),
        ),
        'logDebugAndInfoAndError': _i1.MethodConnector(
          name: 'logDebugAndInfoAndError',
          params: {
            'debug': _i1.ParameterDescription(
              name: 'debug',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'info': _i1.ParameterDescription(
              name: 'info',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'error': _i1.ParameterDescription(
              name: 'error',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i35.LoggingEndpoint)
                  .logDebugAndInfoAndError(
            session,
            params['debug'],
            params['info'],
            params['error'],
          ),
        ),
        'twoQueries': _i1.MethodConnector(
          name: 'twoQueries',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['logging'] as _i35.LoggingEndpoint)
                  .twoQueries(session),
        ),
      },
    );
    connectors['loggingDisabled'] = _i1.EndpointConnector(
      name: 'loggingDisabled',
      endpoint: endpoints['loggingDisabled']!,
      methodConnectors: {
        'logInfo': _i1.MethodConnector(
          name: 'logInfo',
          params: {
            'message': _i1.ParameterDescription(
              name: 'message',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['loggingDisabled'] as _i36.LoggingDisabledEndpoint)
                  .logInfo(
            session,
            params['message'],
          ),
        )
      },
    );
    connectors['mapParameters'] = _i1.EndpointConnector(
      name: 'mapParameters',
      endpoint: endpoints['mapParameters']!,
      methodConnectors: {
        'returnIntMap': _i1.MethodConnector(
          name: 'returnIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnIntMap(
            session,
            params['map'],
          ),
        ),
        'returnIntMapNullable': _i1.MethodConnector(
          name: 'returnIntMapNullable',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnIntMapNullable(
            session,
            params['map'],
          ),
        ),
        'returnNestedIntMap': _i1.MethodConnector(
          name: 'returnNestedIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Map<String, int>>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnNestedIntMap(
            session,
            params['map'],
          ),
        ),
        'returnIntMapNullableInts': _i1.MethodConnector(
          name: 'returnIntMapNullableInts',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnIntMapNullableInts(
            session,
            params['map'],
          ),
        ),
        'returnNullableIntMapNullableInts': _i1.MethodConnector(
          name: 'returnNullableIntMapNullableInts',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, int?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnNullableIntMapNullableInts(
            session,
            params['map'],
          ),
        ),
        'returnIntIntMap': _i1.MethodConnector(
          name: 'returnIntIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<int, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnIntIntMap(
            session,
            params['map'],
          ),
        ),
        'returnEnumIntMap': _i1.MethodConnector(
          name: 'returnEnumIntMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<_i51.TestEnum, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnEnumIntMap(
            session,
            params['map'],
          ),
        ),
        'returnEnumMap': _i1.MethodConnector(
          name: 'returnEnumMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i51.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnEnumMap(
            session,
            params['map'],
          ),
        ),
        'returnDoubleMap': _i1.MethodConnector(
          name: 'returnDoubleMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, double>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnDoubleMap(
            session,
            params['map'],
          ),
        ),
        'returnDoubleMapNullableDoubles': _i1.MethodConnector(
          name: 'returnDoubleMapNullableDoubles',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, double?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnDoubleMapNullableDoubles(
            session,
            params['map'],
          ),
        ),
        'returnBoolMap': _i1.MethodConnector(
          name: 'returnBoolMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, bool>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnBoolMap(
            session,
            params['map'],
          ),
        ),
        'returnBoolMapNullableBools': _i1.MethodConnector(
          name: 'returnBoolMapNullableBools',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, bool?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnBoolMapNullableBools(
            session,
            params['map'],
          ),
        ),
        'returnStringMap': _i1.MethodConnector(
          name: 'returnStringMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, String>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnStringMap(
            session,
            params['map'],
          ),
        ),
        'returnStringMapNullableStrings': _i1.MethodConnector(
          name: 'returnStringMapNullableStrings',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, String?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnStringMapNullableStrings(
            session,
            params['map'],
          ),
        ),
        'returnDateTimeMap': _i1.MethodConnector(
          name: 'returnDateTimeMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, DateTime>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnDateTimeMap(
            session,
            params['map'],
          ),
        ),
        'returnDateTimeMapNullableDateTimes': _i1.MethodConnector(
          name: 'returnDateTimeMapNullableDateTimes',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, DateTime?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnDateTimeMapNullableDateTimes(
            session,
            params['map'],
          ),
        ),
        'returnByteDataMap': _i1.MethodConnector(
          name: 'returnByteDataMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i48.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnByteDataMap(
            session,
            params['map'],
          ),
        ),
        'returnByteDataMapNullableByteDatas': _i1.MethodConnector(
          name: 'returnByteDataMapNullableByteDatas',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i48.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnByteDataMapNullableByteDatas(
            session,
            params['map'],
          ),
        ),
        'returnSimpleDataMap': _i1.MethodConnector(
          name: 'returnSimpleDataMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i55.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnSimpleDataMap(
            session,
            params['map'],
          ),
        ),
        'returnSimpleDataMapNullableSimpleData': _i1.MethodConnector(
          name: 'returnSimpleDataMapNullableSimpleData',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i55.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnSimpleDataMapNullableSimpleData(
            session,
            params['map'],
          ),
        ),
        'returnSimpleDataMapNullable': _i1.MethodConnector(
          name: 'returnSimpleDataMapNullable',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i55.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnSimpleDataMapNullable(
            session,
            params['map'],
          ),
        ),
        'returnNullableSimpleDataMapNullableSimpleData': _i1.MethodConnector(
          name: 'returnNullableSimpleDataMapNullableSimpleData',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, _i55.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnNullableSimpleDataMapNullableSimpleData(
            session,
            params['map'],
          ),
        ),
        'returnDurationMap': _i1.MethodConnector(
          name: 'returnDurationMap',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Duration>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnDurationMap(
            session,
            params['map'],
          ),
        ),
        'returnDurationMapNullableDurations': _i1.MethodConnector(
          name: 'returnDurationMapNullableDurations',
          params: {
            'map': _i1.ParameterDescription(
              name: 'map',
              type: _i1.getType<Map<String, Duration?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i37.MapParametersEndpoint)
                  .returnDurationMapNullableDurations(
            session,
            params['map'],
          ),
        ),
      },
    );
    connectors['moduleSerialization'] = _i1.EndpointConnector(
      name: 'moduleSerialization',
      endpoint: endpoints['moduleSerialization']!,
      methodConnectors: {
        'serializeModuleObject': _i1.MethodConnector(
          name: 'serializeModuleObject',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleSerialization']
                      as _i38.ModuleSerializationEndpoint)
                  .serializeModuleObject(session),
        ),
        'modifyModuleObject': _i1.MethodConnector(
          name: 'modifyModuleObject',
          params: {
            'object': _i1.ParameterDescription(
              name: 'object',
              type: _i1.getType<_i66.ModuleClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleSerialization']
                      as _i38.ModuleSerializationEndpoint)
                  .modifyModuleObject(
            session,
            params['object'],
          ),
        ),
        'serializeNestedModuleObject': _i1.MethodConnector(
          name: 'serializeNestedModuleObject',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['moduleSerialization']
                      as _i38.ModuleSerializationEndpoint)
                  .serializeNestedModuleObject(session),
        ),
      },
    );
    connectors['namedParameters'] = _i1.EndpointConnector(
      name: 'namedParameters',
      endpoint: endpoints['namedParameters']!,
      methodConnectors: {
        'namedParametersMethod': _i1.MethodConnector(
          name: 'namedParametersMethod',
          params: {
            'namedInt': _i1.ParameterDescription(
              name: 'namedInt',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'intWithDefaultValue': _i1.ParameterDescription(
              name: 'intWithDefaultValue',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'nullableInt': _i1.ParameterDescription(
              name: 'nullableInt',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'nullableIntWithDefaultValue': _i1.ParameterDescription(
              name: 'nullableIntWithDefaultValue',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['namedParameters'] as _i39.NamedParametersEndpoint)
                  .namedParametersMethod(
            session,
            namedInt: params['namedInt'],
            intWithDefaultValue: params['intWithDefaultValue'],
            nullableInt: params['nullableInt'],
            nullableIntWithDefaultValue: params['nullableIntWithDefaultValue'],
          ),
        ),
        'namedParametersMethodEqualInts': _i1.MethodConnector(
          name: 'namedParametersMethodEqualInts',
          params: {
            'namedInt': _i1.ParameterDescription(
              name: 'namedInt',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'nullableInt': _i1.ParameterDescription(
              name: 'nullableInt',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['namedParameters'] as _i39.NamedParametersEndpoint)
                  .namedParametersMethodEqualInts(
            session,
            namedInt: params['namedInt'],
            nullableInt: params['nullableInt'],
          ),
        ),
      },
    );
    connectors['optionalParameters'] = _i1.EndpointConnector(
      name: 'optionalParameters',
      endpoint: endpoints['optionalParameters']!,
      methodConnectors: {
        'returnOptionalInt': _i1.MethodConnector(
          name: 'returnOptionalInt',
          params: {
            'optionalInt': _i1.ParameterDescription(
              name: 'optionalInt',
              type: _i1.getType<int?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['optionalParameters']
                      as _i40.OptionalParametersEndpoint)
                  .returnOptionalInt(
            session,
            params['optionalInt'],
          ),
        )
      },
    );
    connectors['redis'] = _i1.EndpointConnector(
      name: 'redis',
      endpoint: endpoints['redis']!,
      methodConnectors: {
        'setSimpleData': _i1.MethodConnector(
          name: 'setSimpleData',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i55.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint).setSimpleData(
            session,
            params['key'],
            params['data'],
          ),
        ),
        'setSimpleDataWithLifetime': _i1.MethodConnector(
          name: 'setSimpleDataWithLifetime',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i55.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint)
                  .setSimpleDataWithLifetime(
            session,
            params['key'],
            params['data'],
          ),
        ),
        'getSimpleData': _i1.MethodConnector(
          name: 'getSimpleData',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint).getSimpleData(
            session,
            params['key'],
          ),
        ),
        'deleteSimpleData': _i1.MethodConnector(
          name: 'deleteSimpleData',
          params: {
            'key': _i1.ParameterDescription(
              name: 'key',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint).deleteSimpleData(
            session,
            params['key'],
          ),
        ),
        'resetMessageCentralTest': _i1.MethodConnector(
          name: 'resetMessageCentralTest',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint)
                  .resetMessageCentralTest(session),
        ),
        'listenToChannel': _i1.MethodConnector(
          name: 'listenToChannel',
          params: {
            'channel': _i1.ParameterDescription(
              name: 'channel',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint).listenToChannel(
            session,
            params['channel'],
          ),
        ),
        'postToChannel': _i1.MethodConnector(
          name: 'postToChannel',
          params: {
            'channel': _i1.ParameterDescription(
              name: 'channel',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'data': _i1.ParameterDescription(
              name: 'data',
              type: _i1.getType<_i55.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint).postToChannel(
            session,
            params['channel'],
            params['data'],
          ),
        ),
        'countSubscribedChannels': _i1.MethodConnector(
          name: 'countSubscribedChannels',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i41.RedisEndpoint)
                  .countSubscribedChannels(session),
        ),
      },
    );
    connectors['signInRequired'] = _i1.EndpointConnector(
      name: 'signInRequired',
      endpoint: endpoints['signInRequired']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['signInRequired'] as _i42.SignInRequiredEndpoint)
                  .testMethod(session),
        )
      },
    );
    connectors['simple'] = _i1.EndpointConnector(
      name: 'simple',
      endpoint: endpoints['simple']!,
      methodConnectors: {
        'setGlobalInt': _i1.MethodConnector(
          name: 'setGlobalInt',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'secondValue': _i1.ParameterDescription(
              name: 'secondValue',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i43.SimpleEndpoint).setGlobalInt(
            session,
            params['value'],
            params['secondValue'],
          ),
        ),
        'addToGlobalInt': _i1.MethodConnector(
          name: 'addToGlobalInt',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i43.SimpleEndpoint)
                  .addToGlobalInt(session),
        ),
        'getGlobalInt': _i1.MethodConnector(
          name: 'getGlobalInt',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i43.SimpleEndpoint)
                  .getGlobalInt(session),
        ),
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i43.SimpleEndpoint).hello(
            session,
            params['name'],
          ),
        ),
      },
    );
    connectors['streaming'] = _i1.EndpointConnector(
      name: 'streaming',
      endpoint: endpoints['streaming']!,
      methodConnectors: {},
    );
    connectors['streamingLogging'] = _i1.EndpointConnector(
      name: 'streamingLogging',
      endpoint: endpoints['streamingLogging']!,
      methodConnectors: {},
    );
    connectors['subSubDirTest'] = _i1.EndpointConnector(
      name: 'subSubDirTest',
      endpoint: endpoints['subSubDirTest']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subSubDirTest'] as _i46.SubSubDirTestEndpoint)
                  .testMethod(session),
        )
      },
    );
    connectors['subDirTest'] = _i1.EndpointConnector(
      name: 'subDirTest',
      endpoint: endpoints['subDirTest']!,
      methodConnectors: {
        'testMethod': _i1.MethodConnector(
          name: 'testMethod',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['subDirTest'] as _i47.SubDirTestEndpoint)
                  .testMethod(session),
        )
      },
    );
    modules['serverpod_test_module'] = _i66.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i67.Endpoints()..initializeEndpoints(server);
  }
}
