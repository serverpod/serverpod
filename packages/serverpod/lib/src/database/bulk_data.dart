import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/database/database.dart';

/// Provides a way to export raw data from the database. The data is serialized
/// using JSON. Primarily used for Serverpod Insights.
class DatabaseBulkData {
  /// Exports data from the provided [table].
  static Future<String> exportTableData({
    required Database database,
    required String table,
    int startingId = 0,
    int limit = 100,
  }) async {
    var query = 'SELECT * FROM "$table" WHERE id >= $startingId LIMIT $limit';
    var data = await database.query(query);

    return SerializationManager.encode(data);
  }
}
