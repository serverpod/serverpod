import 'package:serverpod/protocol.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/adapters/postgres/postgres_analyzer.dart';

/// Analyzes the structure of [Database]s.
class DatabaseAnalyzer {
  /// Analyze the structure of the [database].
  static Future<DatabaseDefinition> analyze(Database database) async {
    final analyzer = PostgresDatabaseAnalyzer(database: database);

    return analyzer.analyze();
  }
}
