import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';

var serviceClient = Client(
  serviceServerUrl,
  // ignore: deprecated_member_use
  authenticationKeyManager: TestServiceKeyManager(
    '0',
    'super_SECRET_password',
  ),
);
