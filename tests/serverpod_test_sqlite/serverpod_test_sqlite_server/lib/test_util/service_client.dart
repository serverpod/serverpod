import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_test_server/test_util/migration_test_utils.dart';
import 'package:serverpod_test_server/test_util/test_service_key_manager.dart';

late final Client serviceClient = _createServiceClient();

Client _createServiceClient() {
  MigrationTestUtils.setModuleName('serverpod_test_sqlite');
  MigrationTestUtils.setDatabaseDialect(DatabaseDialect.sqlite);

  return Client(
    'http://serverpod_test_sqlite_server:8081/',
    // ignore: deprecated_member_use
    authenticationKeyManager: TestServiceKeyManager(
      '0',
      'super_SECRET_password',
    ),
  );
}
