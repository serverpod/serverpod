import 'package:serverpod/database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  group('Given a server with search_paths configured in the config', () {
    // Creates and migrates this suite's database with the default search
    // path, since the configured schemas below do not exist.
    setUpAll(() async {
      await IntegrationTestServer().session();
    });

    var config = ServerpodConfig(
      apiServer: ServerConfig(
        port: 8080,
        publicHost: 'localhost',
        publicPort: 8080,
        publicScheme: 'http',
      ),
      webServer: ServerConfig(
        port: 8080,
        publicHost: 'localhost',
        publicPort: 8081,
        publicScheme: 'http',
      ),
      database: DatabaseConfig(
        host: 'postgres',
        port: 5432,
        name: 'serverpod_test',
        user: 'postgres',
        password: 'password',
        searchPaths: ['first_path', 'second_path'],
      ),
      serviceSecret: 'longpasswordthatisrequired',
    );

    test(
      'when runtime parameters run statements then they run with the config search paths applied.',
      () async {
        var session = await IntegrationTestServer(
          config: config,
          runtimeParametersBuilder: (params) => [
            const _RecordSearchPathParameters(),
          ],
        ).session();

        var result = await session.db.unsafeQuery('SHOW application_name');

        expect(result.first.first, 'first_path, second_path');
      },
    );

    test(
      'when runtime parameters builder returns a const list then config search paths are used.',
      () async {
        var session = await IntegrationTestServer(
          config: config,
          runtimeParametersBuilder: (params) => const [
            _RecordSearchPathParameters(),
          ],
        ).session();

        var checkQuery = SearchPathsConfig().buildCheckValues();
        var result = await session.db.unsafeQuery(checkQuery);

        var row = result.first.toColumnMap();
        expect(row['search_path'], 'first_path, second_path');
      },
    );

    test(
      'when runtime parameters builder returns a shared list then the list is not modified.',
      () async {
        var sharedParameters = <RuntimeParameters>[
          const _RecordSearchPathParameters(),
        ];
        var session = await IntegrationTestServer(
          config: config,
          runtimeParametersBuilder: (params) => sharedParameters,
        ).session();

        await session.db.unsafeQuery('SELECT 1');

        expect(sharedParameters, hasLength(1));
        expect(sharedParameters.whereType<SearchPathsConfig>(), isEmpty);
      },
    );
  });
}

/// Records the search path in effect when its statement runs, in
/// `application_name`, so tests can tell in which order parameters are applied.
class _RecordSearchPathParameters extends RuntimeParameters {
  const _RecordSearchPathParameters();

  @override
  Map<String, dynamic> get options => const {};

  @override
  Iterable<String> buildStatements({required bool isLocal}) => [
    r"DO $$ BEGIN PERFORM set_config('application_name', "
        r"current_setting('search_path'), false); END $$;",
  ];
}
