import 'dart:io';

import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';

// The Dockerised `test_e2e` suite reaches the server as `serverpod_test_server`
// (see [serviceServerUrl]); the host-based migration e2e runs it on localhost
// and overrides the URL via SERVERPOD_TEST_SERVICE_URL.
final _serviceServerUrl =
    Platform.environment['SERVERPOD_TEST_SERVICE_URL'] ?? serviceServerUrl;

var serviceClient = Client(
  _serviceServerUrl,
  // ignore: deprecated_member_use
  authenticationKeyManager: TestServiceKeyManager(
    '0',
    'super_SECRET_password',
  ),
);
