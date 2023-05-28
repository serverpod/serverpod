import '../../serverpod.dart';
import 'database.dart';

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
    final query = 'SELECT * FROM "$table" WHERE id >= $startingId LIMIT $limit';
    final data = await database.query(query);

    return SerializationManager.encode(data);
  }
}
