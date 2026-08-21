import 'dart:io';

import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

import 'config.dart';

// The Dockerised `test_e2e` suite reaches the server as `serverpod_test_server`
// (see [serverUrl]); the host-based migration e2e runs it on localhost and
// overrides the URL via SERVERPOD_TEST_SERVER_URL.
final _serverUrl =
    Platform.environment['SERVERPOD_TEST_SERVER_URL'] ?? serverUrl;

final _client = Client(_serverUrl);

/// Runs [queries] on the live test server through the opt-in
/// [InsightsDatabaseTestEndpoint](../src/endpoints/insights_database.dart).
Future<BulkQueryResult> runQueries(List<String> queries) =>
    _client.insightsDatabaseTest.runQueries(queries);
