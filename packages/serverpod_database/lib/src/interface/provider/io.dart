import 'package:serverpod_shared/serverpod_shared.dart';

import '../../adapters/postgres/database_provider.dart';
import '../../adapters/sqlite/database_provider.dart';
import '../provider.dart';

/// Creates a [DatabaseProvider] for the given [dialect].
DatabaseProvider createDatabaseProviderForDialect(DatabaseDialect dialect) =>
    switch (dialect) {
      DatabaseDialect.postgres => const PostgresDatabaseProvider(),
      DatabaseDialect.sqlite => const SqliteDatabaseProvider(),
    };
