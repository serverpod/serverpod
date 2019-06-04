import '../../server.dart';

const endpointNameInsights = 'insights';

class InsightsEndpoint extends Endpoint {
  final Serverpod pod;
  InsightsEndpoint(this.pod);

  Future<int> getLog(Session session, int numEntries) async {
    return 0;
  }
}