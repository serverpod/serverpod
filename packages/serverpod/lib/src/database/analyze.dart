import 'package:serverpod/protocol.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/interface/provider.dart';

/// Analyzes the structure of [Database]s.
class DatabaseAnalyzer {
  /// Analyze the structure of the [database].
  static Future<DatabaseDefinition> analyze(Database database) async {
    final databaseProvider = DatabaseProvider.forDialect(database.dialect);
    final analyzer = databaseProvider.createAnalyzer(database);

    return analyzer.analyze();
  }
}
