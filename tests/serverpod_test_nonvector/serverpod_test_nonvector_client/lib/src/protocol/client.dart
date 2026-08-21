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
import 'package:serverpod_test_nonvector_client/src/protocol/greeting.dart'
    as _i5;
import 'package:http/http.dart' as _i6;
import 'protocol.dart' as _i7;

/// Exposes the opt-in [InsightsDatabaseEndpoint] so the migration tests can
/// reset the live database.
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
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  _i3.Future<_i5.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i5.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
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
    _i6.Client? httpClientOverride,
  }) : super(
         host,
         _i7.Protocol(),
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
    greeting = EndpointGreeting(this);
  }

  late final EndpointInsightsDatabaseTest insightsDatabaseTest;

  late final EndpointGreeting greeting;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'insightsDatabaseTest': insightsDatabaseTest,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {};
}
