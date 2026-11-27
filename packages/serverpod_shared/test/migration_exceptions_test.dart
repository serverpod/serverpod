import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a live database definition exception with an address when converting to string then the address is included.',
    () {
      var exception = MigrationLiveDatabaseDefinitionException(
        exception: 'Connection refused',
        address: 'https://staging.example.com:8081/',
      );

      expect(
        exception.toString(),
        'Unable to fetch live database schema from server at '
        'https://staging.example.com:8081/. Make sure the server is running '
        'and is connected to the database.\nConnection refused',
      );
    },
  );

  test(
    'Given a live database definition exception without an address when converting to string then the message is unchanged.',
    () {
      var exception = MigrationLiveDatabaseDefinitionException(
        exception: 'Connection refused',
      );

      expect(
        exception.toString(),
        'Unable to fetch live database schema from server. Make sure the '
        'server is running and is connected to the database.\n'
        'Connection refused',
      );
    },
  );
}
