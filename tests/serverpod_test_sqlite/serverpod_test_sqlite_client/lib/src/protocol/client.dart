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
import 'package:serverpod_service_client/serverpod_service_client.dart' as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_database/serverpod_database.dart' as _i4;
import 'package:serverpod_test_sqlite_client/src/protocol/simple_data.dart'
    as _i5;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i6;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i7;
import 'package:serverpod_test_shared_module_client/serverpod_test_shared_module_client.dart'
    as _i8;
import 'package:http/http.dart' as _i9;
import 'protocol.dart' as _i10;
import 'package:serverpod_test_sqlite_client/migrations/migration_registry.dart';

/// Exposes the opt-in [InsightsDatabaseEndpoint] so the e2e migration tests
/// can reset and inspect the live database.
/// {@category Endpoint}
class EndpointInsightsDatabaseTest extends _i1.EndpointInsightsDatabase {
  EndpointInsightsDatabaseTest(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insightsDatabaseTest';

  /// Executes SQL commands. Returns the number of rows affected.
  @override
  _i3.Future<int> executeSql(String sql) => caller.callServerEndpoint<int>(
    'insightsDatabaseTest',
    'executeSql',
    {'sql': sql},
  );

  /// Exports raw data serialized in JSON from the database.
  @override
  _i3.Future<_i4.BulkData> fetchDatabaseBulkData({
    required String table,
    required int startingId,
    required int limit,
    _i4.Filter? filter,
  }) => caller.callServerEndpoint<_i4.BulkData>(
    'insightsDatabaseTest',
    'fetchDatabaseBulkData',
    {
      'table': table,
      'startingId': startingId,
      'limit': limit,
      'filter': filter,
    },
  );

  /// Executes a list of queries on the database and returns the last result.
  /// The queries are executed in a single transaction.
  @override
  _i3.Future<_i4.BulkQueryResult> runQueries(List<String> queries) =>
      caller.callServerEndpoint<_i4.BulkQueryResult>(
        'insightsDatabaseTest',
        'runQueries',
        {'queries': queries},
      );

  /// Returns the approximate number of rows in the provided [table].
  @override
  _i3.Future<int> getDatabaseRowCount({required String table}) =>
      caller.callServerEndpoint<int>(
        'insightsDatabaseTest',
        'getDatabaseRowCount',
        {'table': table},
      );
}

/// {@category Endpoint}
class EndpointTestTools extends _i2.EndpointRef {
  EndpointTestTools(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'testTools';

  _i3.Future<void> createSimpleData(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleData',
        {'data': data},
      );

  _i3.Future<List<_i5.SimpleData>> getAllSimpleData() =>
      caller.callServerEndpoint<List<_i5.SimpleData>>(
        'testTools',
        'getAllSimpleData',
        {},
      );

  _i3.Future<void> createSimpleDatasInsideTransactions(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInsideTransactions',
        {'data': data},
      );

  _i3.Future<void> createSimpleDataAndThrowInsideTransaction(int data) =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDataAndThrowInsideTransaction',
        {'data': data},
      );

  _i3.Future<void> createSimpleDatasInParallelTransactionCalls() =>
      caller.callServerEndpoint<void>(
        'testTools',
        'createSimpleDatasInParallelTransactionCalls',
        {},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i6.Caller(client);
    auth_idp = _i7.Caller(client);
    shared_module = _i8.Caller(client);
  }

  late final _i6.Caller auth;

  late final _i7.Caller auth_idp;

  late final _i8.Caller shared_module;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i9.Client? httpClientOverride,
  }) : super(
         host,
         _i10.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    insightsDatabaseTest = EndpointInsightsDatabaseTest(this);
    testTools = EndpointTestTools(this);
    modules = Modules(this);
  }

  late final EndpointInsightsDatabaseTest insightsDatabaseTest;

  late final EndpointTestTools testTools;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'insightsDatabaseTest': insightsDatabaseTest,
    'testTools': testTools,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'auth_idp': modules.auth_idp,
    'shared_module': modules.shared_module,
  };

  /// Creates a new client-side database session for the given path.
  ///
  /// The [path] is the file path to the SQLite database file. Since SQLite uses
  /// WAL mode, note that `[path]-shm` and `[path]-wal` files might also exist
  /// transiently for the database while the session is open.
  ///
  /// If [runMigrations] is true, pending migrations will be applied when
  /// opening the database. Be careful when setting this to false, as it might
  /// lead to inconsistencies between the models and the database.
  ///
  /// If [isDebugMode] is true, the database integrity will be verified after
  /// the migrations are applied to provide feedback of possible issues. On a
  /// Flutter application, this should be set to [kDebugMode].
  _i3.Future<_i4.ClientDatabaseSession> createSession(
    String path, {
    bool runMigrations = true,
    bool isDebugMode = false,
  }) async {
    return await _i4.ClientDatabaseSession.open(
      path,
      _i10.Protocol(),
      clientMigrations: MigrationRegistry.migrations,
      runMigrations: runMigrations,
      isDebugMode: isDebugMode,
    );
  }
}
