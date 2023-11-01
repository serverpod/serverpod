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
import '../endpoints/column_operations_legacy/column_bool.dart' as _i7;
import '../endpoints/column_operations_legacy/column_date_time.dart' as _i8;
import '../endpoints/column_operations_legacy/column_double.dart' as _i9;
import '../endpoints/column_operations_legacy/column_duration.dart' as _i10;
import '../endpoints/column_operations_legacy/column_enum.dart' as _i11;
import '../endpoints/column_operations_legacy/column_int.dart' as _i12;
import '../endpoints/column_operations_legacy/column_string.dart' as _i13;
import '../endpoints/column_operations_legacy/column_uuid.dart' as _i14;
import '../endpoints/custom_types.dart' as _i15;
import '../endpoints/database_basic.dart' as _i16;
import '../endpoints/database_basic_legacy.dart' as _i17;
import '../endpoints/database_batch.dart' as _i18;
import '../endpoints/database_batch_generated.dart' as _i19;
import '../endpoints/database_list_relation_methods.dart' as _i20;
import '../endpoints/database_transactions.dart' as _i21;
import '../endpoints/entities_with_relations/one_to_many.dart' as _i22;
import '../endpoints/entity_relation.dart' as _i23;
import '../endpoints/exception_test_endpoint.dart' as _i24;
import '../endpoints/failed_calls.dart' as _i25;
import '../endpoints/field_scopes.dart' as _i26;
import '../endpoints/future_calls.dart' as _i27;
import '../endpoints/list_parameters.dart' as _i28;
import '../endpoints/logging.dart' as _i29;
import '../endpoints/logging_disabled.dart' as _i30;
import '../endpoints/map_parameters.dart' as _i31;
import '../endpoints/module_serialization.dart' as _i32;
import '../endpoints/named_parameters.dart' as _i33;
import '../endpoints/optional_parameters.dart' as _i34;
import '../endpoints/redis.dart' as _i35;
import '../endpoints/signin_required.dart' as _i36;
import '../endpoints/simple.dart' as _i37;
import '../endpoints/streaming.dart' as _i38;
import '../endpoints/streaming_logging.dart' as _i39;
import '../endpoints/subDir/subSubDir/subsubdir_test_endpoint.dart' as _i40;
import '../endpoints/subDir/subdir_test_endpoint.dart' as _i41;
import 'dart:typed_data' as _i42;
import 'package:uuid/uuid.dart' as _i43;
import 'package:serverpod_test_server/src/generated/types.dart' as _i44;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i45;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i46;
import 'package:serverpod_test_shared/src/external_custom_class.dart' as _i47;
import 'package:serverpod_test_shared/src/freezed_custom_class.dart' as _i48;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i49;
import 'package:serverpod_test_server/src/generated/object_with_enum.dart'
    as _i50;
import 'package:serverpod_test_server/src/generated/object_with_object.dart'
    as _i51;
import 'package:serverpod_test_server/src/generated/unique_data.dart' as _i52;
import 'package:serverpod_test_server/src/generated/related_unique_data.dart'
    as _i53;
import 'package:serverpod_test_server/src/generated/entities_with_list_relations/city.dart'
    as _i54;
import 'package:serverpod_test_server/src/generated/entities_with_list_relations/organization.dart'
    as _i55;
import 'package:serverpod_test_server/src/generated/entities_with_list_relations/person.dart'
    as _i56;
import 'package:serverpod_test_server/src/generated/entities_with_relations/one_to_many/comment.dart'
    as _i57;
import 'package:serverpod_test_server/src/generated/entities_with_relations/one_to_many/order.dart'
    as _i58;
import 'package:serverpod_test_server/src/generated/entities_with_relations/one_to_many/customer.dart'
    as _i59;
import 'package:serverpod_test_server/src/generated/entities_with_relations/one_to_one/citizen.dart'
    as _i60;
import 'package:serverpod_test_server/src/generated/entities_with_relations/one_to_one/company.dart'
    as _i61;
import 'package:serverpod_test_server/src/generated/entities_with_relations/one_to_one/address.dart'
    as _i62;
import 'package:serverpod_test_server/src/generated/entities_with_relations/one_to_one/town.dart'
    as _i63;
import 'package:serverpod_test_server/src/generated/entities_with_relations/self_relation/post.dart'
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
      'columnBoolLegacy': _i7.ColumnBoolLegacyEndpoint()
        ..initialize(
          server,
          'columnBoolLegacy',
          null,
        ),
      'columnDateTimeLegacy': _i8.ColumnDateTimeLegacyEndpoint()
        ..initialize(
          server,
          'columnDateTimeLegacy',
          null,
        ),
      'columnDoubleLegacy': _i9.ColumnDoubleLegacyEndpoint()
        ..initialize(
          server,
          'columnDoubleLegacy',
          null,
        ),
      'columnDurationLegacy': _i10.ColumnDurationLegacyEndpoint()
        ..initialize(
          server,
          'columnDurationLegacy',
          null,
        ),
      'columnEnumLegacy': _i11.ColumnEnumLegacyEndpoint()
        ..initialize(
          server,
          'columnEnumLegacy',
          null,
        ),
      'columnIntLegacy': _i12.ColumnIntLegacyEndpoint()
        ..initialize(
          server,
          'columnIntLegacy',
          null,
        ),
      'columnStringLegacy': _i13.ColumnStringLegacyEndpoint()
        ..initialize(
          server,
          'columnStringLegacy',
          null,
        ),
      'columnUuidLegacy': _i14.ColumnUuidLegacyEndpoint()
        ..initialize(
          server,
          'columnUuidLegacy',
          null,
        ),
      'customTypes': _i15.CustomTypesEndpoint()
        ..initialize(
          server,
          'customTypes',
          null,
        ),
      'basicDatabase': _i16.BasicDatabase()
        ..initialize(
          server,
          'basicDatabase',
          null,
        ),
      'basicDatabaseLegacy': _i17.BasicDatabaseLegacy()
        ..initialize(
          server,
          'basicDatabaseLegacy',
          null,
        ),
      'databaseBatch': _i18.DatabaseBatch()
        ..initialize(
          server,
          'databaseBatch',
          null,
        ),
      'databaseBatchGenerated': _i19.DatabaseBatchGenerated()
        ..initialize(
          server,
          'databaseBatchGenerated',
          null,
        ),
      'databaseListRelationMethods': _i20.DatabaseListRelationMethods()
        ..initialize(
          server,
          'databaseListRelationMethods',
          null,
        ),
      'transactionsDatabase': _i21.TransactionsDatabaseEndpoint()
        ..initialize(
          server,
          'transactionsDatabase',
          null,
        ),
      'oneToMany': _i22.OneToManyEndpoint()
        ..initialize(
          server,
          'oneToMany',
          null,
        ),
      'relation': _i23.RelationEndpoint()
        ..initialize(
          server,
          'relation',
          null,
        ),
      'exceptionTest': _i24.ExceptionTestEndpoint()
        ..initialize(
          server,
          'exceptionTest',
          null,
        ),
      'failedCalls': _i25.FailedCallsEndpoint()
        ..initialize(
          server,
          'failedCalls',
          null,
        ),
      'fieldScopes': _i26.FieldScopesEndpoint()
        ..initialize(
          server,
          'fieldScopes',
          null,
        ),
      'futureCalls': _i27.FutureCallsEndpoint()
        ..initialize(
          server,
          'futureCalls',
          null,
        ),
      'listParameters': _i28.ListParametersEndpoint()
        ..initialize(
          server,
          'listParameters',
          null,
        ),
      'logging': _i29.LoggingEndpoint()
        ..initialize(
          server,
          'logging',
          null,
        ),
      'loggingDisabled': _i30.LoggingDisabledEndpoint()
        ..initialize(
          server,
          'loggingDisabled',
          null,
        ),
      'mapParameters': _i31.MapParametersEndpoint()
        ..initialize(
          server,
          'mapParameters',
          null,
        ),
      'moduleSerialization': _i32.ModuleSerializationEndpoint()
        ..initialize(
          server,
          'moduleSerialization',
          null,
        ),
      'namedParameters': _i33.NamedParametersEndpoint()
        ..initialize(
          server,
          'namedParameters',
          null,
        ),
      'optionalParameters': _i34.OptionalParametersEndpoint()
        ..initialize(
          server,
          'optionalParameters',
          null,
        ),
      'redis': _i35.RedisEndpoint()
        ..initialize(
          server,
          'redis',
          null,
        ),
      'signInRequired': _i36.SignInRequiredEndpoint()
        ..initialize(
          server,
          'signInRequired',
          null,
        ),
      'simple': _i37.SimpleEndpoint()
        ..initialize(
          server,
          'simple',
          null,
        ),
      'streaming': _i38.StreamingEndpoint()
        ..initialize(
          server,
          'streaming',
          null,
        ),
      'streamingLogging': _i39.StreamingLoggingEndpoint()
        ..initialize(
          server,
          'streamingLogging',
          null,
        ),
      'subSubDirTest': _i40.SubSubDirTestEndpoint()
        ..initialize(
          server,
          'subSubDirTest',
          null,
        ),
      'subDirTest': _i41.SubDirTestEndpoint()
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
              type: _i1.getType<_i42.ByteData?>(),
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
              type: _i1.getType<_i43.UuidValue?>(),
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
              type: _i1.getType<_i42.ByteData>(),
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
              type: _i1.getType<_i42.ByteData>(),
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
    connectors['columnBoolLegacy'] = _i1.EndpointConnector(
      name: 'columnBoolLegacy',
      endpoint: endpoints['columnBoolLegacy']!,
      methodConnectors: {
        'insert': _i1.MethodConnector(
          name: 'insert',
          params: {
            'types': _i1.ParameterDescription(
              name: 'types',
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i7.ColumnBoolLegacyEndpoint)
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
              (endpoints['columnBoolLegacy'] as _i7.ColumnBoolLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnBoolLegacy'] as _i7.ColumnBoolLegacyEndpoint)
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
              (endpoints['columnBoolLegacy'] as _i7.ColumnBoolLegacyEndpoint)
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
              (endpoints['columnBoolLegacy'] as _i7.ColumnBoolLegacyEndpoint)
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
              (endpoints['columnBoolLegacy'] as _i7.ColumnBoolLegacyEndpoint)
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
              (endpoints['columnBoolLegacy'] as _i7.ColumnBoolLegacyEndpoint)
                  .notInSet(
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDateTimeLegacy']
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
                  .notInSet(
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
                      as _i8.ColumnDateTimeLegacyEndpoint)
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDoubleLegacy']
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
                  .notInSet(
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
                      as _i9.ColumnDoubleLegacyEndpoint)
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnDurationLegacy']
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
                  .notInSet(
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
                      as _i10.ColumnDurationLegacyEndpoint)
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i11.ColumnEnumLegacyEndpoint)
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
              (endpoints['columnEnumLegacy'] as _i11.ColumnEnumLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i11.ColumnEnumLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i45.TestEnum?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i11.ColumnEnumLegacyEndpoint)
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
              type: _i1.getType<_i45.TestEnum?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i11.ColumnEnumLegacyEndpoint)
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
              type: _i1.getType<List<_i45.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i11.ColumnEnumLegacyEndpoint)
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
              type: _i1.getType<List<_i45.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnEnumLegacy'] as _i11.ColumnEnumLegacyEndpoint)
                  .notInSet(
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
                  .notInSet(
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              (endpoints['columnIntLegacy'] as _i12.ColumnIntLegacyEndpoint)
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnStringLegacy']
                      as _i13.ColumnStringLegacyEndpoint)
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
                      as _i13.ColumnStringLegacyEndpoint)
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
                      as _i13.ColumnStringLegacyEndpoint)
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
                      as _i13.ColumnStringLegacyEndpoint)
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
                      as _i13.ColumnStringLegacyEndpoint)
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
                      as _i13.ColumnStringLegacyEndpoint)
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
                      as _i13.ColumnStringLegacyEndpoint)
                  .notInSet(
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
                      as _i13.ColumnStringLegacyEndpoint)
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
                      as _i13.ColumnStringLegacyEndpoint)
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i14.ColumnUuidLegacyEndpoint)
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
              (endpoints['columnUuidLegacy'] as _i14.ColumnUuidLegacyEndpoint)
                  .deleteAll(session),
        ),
        'findAll': _i1.MethodConnector(
          name: 'findAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i14.ColumnUuidLegacyEndpoint)
                  .findAll(session),
        ),
        'equals': _i1.MethodConnector(
          name: 'equals',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i43.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i14.ColumnUuidLegacyEndpoint)
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
              type: _i1.getType<_i43.UuidValue?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i14.ColumnUuidLegacyEndpoint)
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
              type: _i1.getType<List<_i43.UuidValue>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i14.ColumnUuidLegacyEndpoint)
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
              type: _i1.getType<List<_i43.UuidValue>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['columnUuidLegacy'] as _i14.ColumnUuidLegacyEndpoint)
                  .notInSet(
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
              type: _i1.getType<_i46.CustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              type: _i1.getType<_i46.CustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              type: _i1.getType<_i46.CustomClass2>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              type: _i1.getType<_i46.CustomClass2?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              type: _i1.getType<_i47.ExternalCustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              type: _i1.getType<_i47.ExternalCustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              type: _i1.getType<_i48.FreezedCustomClass>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              type: _i1.getType<_i48.FreezedCustomClass?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['customTypes'] as _i15.CustomTypesEndpoint)
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
              (endpoints['basicDatabase'] as _i16.BasicDatabase).findSimpleData(
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
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
                  .findFirstRowSimpleData(
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
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
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
              type: _i1.getType<_i49.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
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
              type: _i1.getType<_i49.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
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
              type: _i1.getType<_i49.SimpleData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
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
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
                  .deleteWhereSimpleData(session),
        ),
        'countSimpleData': _i1.MethodConnector(
          name: 'countSimpleData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
                  .countSimpleData(session),
        ),
        'insertTypes': _i1.MethodConnector(
          name: 'insertTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i44.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i16.BasicDatabase).insertTypes(
            session,
            params['value'],
          ),
        ),
        'updateTypes': _i1.MethodConnector(
          name: 'updateTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i44.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabase'] as _i16.BasicDatabase).updateTypes(
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
              (endpoints['basicDatabase'] as _i16.BasicDatabase)
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
              type: _i1.getType<_i44.Types>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              type: _i1.getType<_i50.ObjectWithEnum>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
                  .countTypesRows(session),
        ),
        'deleteAllInTypes': _i1.MethodConnector(
          name: 'deleteAllInTypes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
                  .countSimpleData(session),
        ),
        'deleteAllSimpleTestData': _i1.MethodConnector(
          name: 'deleteAllSimpleTestData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              type: _i1.getType<_i51.ObjectWithObject>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
                  .testByteDataStore(session),
        ),
        'testDurationStore': _i1.MethodConnector(
          name: 'testDurationStore',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['basicDatabaseLegacy'] as _i17.BasicDatabaseLegacy)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch).batchInsert(
            session,
            params['value'],
          ),
        ),
        'batchInsertTypes': _i1.MethodConnector(
          name: 'batchInsertTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch).batchUpdate(
            session,
            params['value'],
          ),
        ),
        'batchUpdateTypes': _i1.MethodConnector(
          name: 'batchUpdateTypes',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch).batchDelete(
            session,
            params['value'],
          ),
        ),
        'insertRelatedUniqueData': _i1.MethodConnector(
          name: 'insertRelatedUniqueData',
          params: {
            'value': _i1.ParameterDescription(
              name: 'value',
              type: _i1.getType<_i53.RelatedUniqueData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch)
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
              (endpoints['databaseBatch'] as _i18.DatabaseBatch).findByEmail(
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
              (endpoints['databaseBatch'] as _i18.DatabaseBatch).findById(
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
              (endpoints['databaseBatch'] as _i18.DatabaseBatch)
                  .findAll(session),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatch'] as _i18.DatabaseBatch)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i19.DatabaseBatchGenerated)
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i19.DatabaseBatchGenerated)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i19.DatabaseBatchGenerated)
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
              type: _i1.getType<List<_i44.Types>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i19.DatabaseBatchGenerated)
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
              type: _i1.getType<List<_i52.UniqueData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i19.DatabaseBatchGenerated)
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
              type: _i1.getType<_i53.RelatedUniqueData>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseBatchGenerated']
                      as _i19.DatabaseBatchGenerated)
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
                      as _i19.DatabaseBatchGenerated)
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
                      as _i19.DatabaseBatchGenerated)
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
                      as _i19.DatabaseBatchGenerated)
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
                      as _i19.DatabaseBatchGenerated)
                  .deleteAll(session),
        ),
      },
    );
    connectors['databaseListRelationMethods'] = _i1.EndpointConnector(
      name: 'databaseListRelationMethods',
      endpoint: endpoints['databaseListRelationMethods']!,
      methodConnectors: {
        'insertCity': _i1.MethodConnector(
          name: 'insertCity',
          params: {
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<_i54.City>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .insertCity(
            session,
            params['city'],
          ),
        ),
        'insertOrganization': _i1.MethodConnector(
          name: 'insertOrganization',
          params: {
            'organization': _i1.ParameterDescription(
              name: 'organization',
              type: _i1.getType<_i55.Organization>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .insertOrganization(
            session,
            params['organization'],
          ),
        ),
        'insertPerson': _i1.MethodConnector(
          name: 'insertPerson',
          params: {
            'person': _i1.ParameterDescription(
              name: 'person',
              type: _i1.getType<_i56.Person>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .insertPerson(
            session,
            params['person'],
          ),
        ),
        'implicitAttachRowCitizen': _i1.MethodConnector(
          name: 'implicitAttachRowCitizen',
          params: {
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<_i54.City>(),
              nullable: false,
            ),
            'citizen': _i1.ParameterDescription(
              name: 'citizen',
              type: _i1.getType<_i56.Person>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .implicitAttachRowCitizen(
            session,
            params['city'],
            params['citizen'],
          ),
        ),
        'implicitAttachCitizens': _i1.MethodConnector(
          name: 'implicitAttachCitizens',
          params: {
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<_i54.City>(),
              nullable: false,
            ),
            'citizens': _i1.ParameterDescription(
              name: 'citizens',
              type: _i1.getType<List<_i56.Person>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .implicitAttachCitizens(
            session,
            params['city'],
            params['citizens'],
          ),
        ),
        'implicitDetachRowCitizens': _i1.MethodConnector(
          name: 'implicitDetachRowCitizens',
          params: {
            'citizen': _i1.ParameterDescription(
              name: 'citizen',
              type: _i1.getType<_i56.Person>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .implicitDetachRowCitizens(
            session,
            params['citizen'],
          ),
        ),
        'implicitDetachCitizens': _i1.MethodConnector(
          name: 'implicitDetachCitizens',
          params: {
            'citizens': _i1.ParameterDescription(
              name: 'citizens',
              type: _i1.getType<List<_i56.Person>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .implicitDetachCitizens(
            session,
            params['citizens'],
          ),
        ),
        'cityFindById': _i1.MethodConnector(
          name: 'cityFindById',
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
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .cityFindById(
            session,
            params['id'],
          ),
        ),
        'explicitAttachRowPeople': _i1.MethodConnector(
          name: 'explicitAttachRowPeople',
          params: {
            'org': _i1.ParameterDescription(
              name: 'org',
              type: _i1.getType<_i55.Organization>(),
              nullable: false,
            ),
            'person': _i1.ParameterDescription(
              name: 'person',
              type: _i1.getType<_i56.Person>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .explicitAttachRowPeople(
            session,
            params['org'],
            params['person'],
          ),
        ),
        'explicitAttachPeople': _i1.MethodConnector(
          name: 'explicitAttachPeople',
          params: {
            'org': _i1.ParameterDescription(
              name: 'org',
              type: _i1.getType<_i55.Organization>(),
              nullable: false,
            ),
            'persons': _i1.ParameterDescription(
              name: 'persons',
              type: _i1.getType<List<_i56.Person>>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .explicitAttachPeople(
            session,
            params['org'],
            params['persons'],
          ),
        ),
        'explicitDetachRowPeople': _i1.MethodConnector(
          name: 'explicitDetachRowPeople',
          params: {
            'person': _i1.ParameterDescription(
              name: 'person',
              type: _i1.getType<_i56.Person>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .explicitDetachRowPeople(
            session,
            params['person'],
          ),
        ),
        'explicitDetachPeople': _i1.MethodConnector(
          name: 'explicitDetachPeople',
          params: {
            'persons': _i1.ParameterDescription(
              name: 'persons',
              type: _i1.getType<List<_i56.Person>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .explicitDetachPeople(
            session,
            params['persons'],
          ),
        ),
        'organizationFindById': _i1.MethodConnector(
          name: 'organizationFindById',
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
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
                  .organizationFindById(
            session,
            params['id'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['databaseListRelationMethods']
                      as _i20.DatabaseListRelationMethods)
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
                      as _i21.TransactionsDatabaseEndpoint)
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
                      as _i21.TransactionsDatabaseEndpoint)
                  .updateInsertDelete(
            session,
            params['numUpdate'],
            params['numInsert'],
            params['numDelete'],
          ),
        ),
      },
    );
    connectors['oneToMany'] = _i1.EndpointConnector(
      name: 'oneToMany',
      endpoint: endpoints['oneToMany']!,
      methodConnectors: {
        'customerOrderByOrderCountAscending': _i1.MethodConnector(
          name: 'customerOrderByOrderCountAscending',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['oneToMany'] as _i22.OneToManyEndpoint)
                  .customerOrderByOrderCountAscending(session),
        ),
        'customerOrderByOrderCountAscendingWhereDescriptionIs':
            _i1.MethodConnector(
          name: 'customerOrderByOrderCountAscendingWhereDescriptionIs',
          params: {
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['oneToMany'] as _i22.OneToManyEndpoint)
                  .customerOrderByOrderCountAscendingWhereDescriptionIs(
            session,
            params['description'],
          ),
        ),
        'commentInsert': _i1.MethodConnector(
          name: 'commentInsert',
          params: {
            'comments': _i1.ParameterDescription(
              name: 'comments',
              type: _i1.getType<List<_i57.Comment>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['oneToMany'] as _i22.OneToManyEndpoint).commentInsert(
            session,
            params['comments'],
          ),
        ),
        'orderInsert': _i1.MethodConnector(
          name: 'orderInsert',
          params: {
            'orders': _i1.ParameterDescription(
              name: 'orders',
              type: _i1.getType<List<_i58.Order>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['oneToMany'] as _i22.OneToManyEndpoint).orderInsert(
            session,
            params['orders'],
          ),
        ),
        'customerInsert': _i1.MethodConnector(
          name: 'customerInsert',
          params: {
            'customers': _i1.ParameterDescription(
              name: 'customers',
              type: _i1.getType<List<_i59.Customer>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['oneToMany'] as _i22.OneToManyEndpoint).customerInsert(
            session,
            params['customers'],
          ),
        ),
        'deleteAll': _i1.MethodConnector(
          name: 'deleteAll',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['oneToMany'] as _i22.OneToManyEndpoint)
                  .deleteAll(session),
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
                  .citizenFindOrderedByCompanyName(session),
        ),
        'citizenFindOrderedByCompanyTownName': _i1.MethodConnector(
          name: 'citizenFindOrderedByCompanyTownName',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
                  .citizenFindAll(session),
        ),
        'citizenFindAllWithDeepIncludes': _i1.MethodConnector(
          name: 'citizenFindAllWithDeepIncludes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i23.RelationEndpoint)
                  .citizenFindAllWithDeepIncludes(session),
        ),
        'citizenFindAllWithNamedRelationNoneOriginSide': _i1.MethodConnector(
          name: 'citizenFindAllWithNamedRelationNoneOriginSide',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i23.RelationEndpoint)
                  .citizenFindAllWithNamedRelationNoneOriginSide(session),
        ),
        'citizenFindAllWithShallowIncludes': _i1.MethodConnector(
          name: 'citizenFindAllWithShallowIncludes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint).addressFindById(
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['relation'] as _i23.RelationEndpoint).citizenInsert(
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
              (endpoints['relation'] as _i23.RelationEndpoint).companyInsert(
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
              (endpoints['relation'] as _i23.RelationEndpoint).townInsert(
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
              (endpoints['relation'] as _i23.RelationEndpoint).addressInsert(
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
              (endpoints['relation'] as _i23.RelationEndpoint).postInsert(
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
              (endpoints['relation'] as _i23.RelationEndpoint)
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
              (endpoints['exceptionTest'] as _i24.ExceptionTestEndpoint)
                  .throwNormalException(session),
        ),
        'throwExceptionWithData': _i1.MethodConnector(
          name: 'throwExceptionWithData',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i24.ExceptionTestEndpoint)
                  .throwExceptionWithData(session),
        ),
        'workingWithoutException': _i1.MethodConnector(
          name: 'workingWithoutException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['exceptionTest'] as _i24.ExceptionTestEndpoint)
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
              (endpoints['failedCalls'] as _i25.FailedCallsEndpoint)
                  .failedCall(session),
        ),
        'failedDatabaseQuery': _i1.MethodConnector(
          name: 'failedDatabaseQuery',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i25.FailedCallsEndpoint)
                  .failedDatabaseQuery(session),
        ),
        'failedDatabaseQueryCaughtException': _i1.MethodConnector(
          name: 'failedDatabaseQueryCaughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i25.FailedCallsEndpoint)
                  .failedDatabaseQueryCaughtException(session),
        ),
        'slowCall': _i1.MethodConnector(
          name: 'slowCall',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i25.FailedCallsEndpoint)
                  .slowCall(session),
        ),
        'caughtException': _i1.MethodConnector(
          name: 'caughtException',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['failedCalls'] as _i25.FailedCallsEndpoint)
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
              (endpoints['fieldScopes'] as _i26.FieldScopesEndpoint)
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
              (endpoints['fieldScopes'] as _i26.FieldScopesEndpoint)
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
              type: _i1.getType<_i49.SimpleData?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['futureCalls'] as _i27.FutureCallsEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              type: _i1.getType<List<_i42.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              type: _i1.getType<List<_i42.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              type: _i1.getType<List<_i49.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              type: _i1.getType<List<_i49.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              type: _i1.getType<List<_i49.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              type: _i1.getType<List<_i49.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['listParameters'] as _i28.ListParametersEndpoint)
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
              (endpoints['logging'] as _i29.LoggingEndpoint).logInfo(
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
              (endpoints['logging'] as _i29.LoggingEndpoint)
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
              (endpoints['logging'] as _i29.LoggingEndpoint)
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
              (endpoints['loggingDisabled'] as _i30.LoggingDisabledEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<_i45.TestEnum, int>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i45.TestEnum>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i42.ByteData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i42.ByteData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i49.SimpleData>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i49.SimpleData?>>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i49.SimpleData>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              type: _i1.getType<Map<String, _i49.SimpleData?>?>(),
              nullable: true,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
              (endpoints['mapParameters'] as _i31.MapParametersEndpoint)
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
                      as _i32.ModuleSerializationEndpoint)
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
                      as _i32.ModuleSerializationEndpoint)
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
                      as _i32.ModuleSerializationEndpoint)
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
              (endpoints['namedParameters'] as _i33.NamedParametersEndpoint)
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
              (endpoints['namedParameters'] as _i33.NamedParametersEndpoint)
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
                      as _i34.OptionalParametersEndpoint)
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
              type: _i1.getType<_i49.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i35.RedisEndpoint).setSimpleData(
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
              type: _i1.getType<_i49.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i35.RedisEndpoint)
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
              (endpoints['redis'] as _i35.RedisEndpoint).getSimpleData(
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
              (endpoints['redis'] as _i35.RedisEndpoint).deleteSimpleData(
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
              (endpoints['redis'] as _i35.RedisEndpoint)
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
              (endpoints['redis'] as _i35.RedisEndpoint).listenToChannel(
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
              type: _i1.getType<_i49.SimpleData>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['redis'] as _i35.RedisEndpoint).postToChannel(
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
              (endpoints['redis'] as _i35.RedisEndpoint)
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
              (endpoints['signInRequired'] as _i36.SignInRequiredEndpoint)
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
              (endpoints['simple'] as _i37.SimpleEndpoint).setGlobalInt(
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
              (endpoints['simple'] as _i37.SimpleEndpoint)
                  .addToGlobalInt(session),
        ),
        'getGlobalInt': _i1.MethodConnector(
          name: 'getGlobalInt',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['simple'] as _i37.SimpleEndpoint)
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
              (endpoints['simple'] as _i37.SimpleEndpoint).hello(
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
              (endpoints['subSubDirTest'] as _i40.SubSubDirTestEndpoint)
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
              (endpoints['subDirTest'] as _i41.SubDirTestEndpoint)
                  .testMethod(session),
        )
      },
    );
    modules['serverpod_test_module'] = _i66.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth'] = _i67.Endpoints()..initializeEndpoints(server);
  }
}
