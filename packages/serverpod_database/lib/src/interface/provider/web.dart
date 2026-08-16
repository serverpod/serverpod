import 'package:serverpod_shared/serverpod_shared.dart';

import '../../adapters/sqlite/database_provider.dart';
import '../provider.dart';

/// Creates a [DatabaseProvider] for the given [dialect].
DatabaseProvider createDatabaseProviderForDialect(DatabaseDialect dialect) =>
    switch (dialect) {
      DatabaseDialect.sqlite => const SqliteDatabaseProvider(),
      _ => throw UnsupportedError(
        'Database provider for dialect $dialect is not available on web.',
      ),
    };
