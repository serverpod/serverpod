import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ChannelsEndpoint extends Endpoint {
  Future<List<Channel>> getChannels(Session session) async {
    // Get a list of all channels from the database
    return await Channel.db.find(
      session,
      where: (p0) =>
          p0.point.intersects(GeographyPoint(longitude: 2.55, latitude: 48.55)),
    );
  }
}
