import '../../server.dart';
import '../generated/protocol.dart';

const endpointNameInsights = 'insights';

class InsightsEndpoint extends Endpoint {
  final Serverpod pod;
  InsightsEndpoint(this.pod);

  Future<LogResult> getLog(Session session, int numEntries) async {
    print('getLog $numEntries');

    var rows = await server.database.find(
      tLogEntry,
      limit: numEntries,
      orderBy: tLogEntry.id,
      orderDescending: true,
    );
    return LogResult(
      entries: rows.cast<LogEntry>(),
    );
  }

  Future<Null> shutdown(Session session) async {
    server.serverpod.shutdown();
  }
}
