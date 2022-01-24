import 'package:example_server/src/generated/channel.dart';
import 'package:example_server/src/generated/channel_list.dart';
import 'package:serverpod/serverpod.dart';

class ChannelsEndpoint extends Endpoint {
  Future<ChannelList> getChannels(Session session) async {
    // Get a list of all channels from the database
    var channels = await Channel.find(session);

    // Return the channel list to the client
    return ChannelList(channels: channels);
  }
}
