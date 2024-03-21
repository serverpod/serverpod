import 'package:chat_client/chat_client.dart';
import 'package:chat_flutter/main.dart';
import 'package:chat_flutter/src/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

/// The MainPage contains a _ChatPage with the currently selected chat, and a
/// drawer where the user can pick which chat to interact with.
class MainPage extends StatefulWidget {
  final List<Channel> channels;
  final Map<String, ChatController> chatControllers;

  const MainPage({
    required this.channels,
    required this.chatControllers,
    super.key,
  });

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late String _selectedChannel;

  @override
  void initState() {
    super.initState();

    _selectedChannel = widget.channels[0].channel;
  }

  @override
  Widget build(BuildContext context) {
    // Find current chat controller and channel information
    var controller = widget.chatControllers[_selectedChannel];

    Channel? channel;
    for (var c in widget.channels) {
      if (c.channel == _selectedChannel) {
        channel = c;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(channel?.name ?? 'Serverpod Example'),
      ),
      drawer: _ChannelDrawer(
        channels: widget.channels,
        selectedChannel: _selectedChannel,
        onSelectChannel: (channel) {
          setState(() {
            _selectedChannel = channel;
          });
        },
      ),
      body: controller != null
          ? ChatPage(
              key: ValueKey(controller.channel),
              controller: controller,
            )
          : const Center(
              child: Text('Select a channel.'),
            ),
    );
  }
}

// The _ChannelDrawer displays a list of chat channels.
class _ChannelDrawer extends StatelessWidget {
  final List<Channel> channels;
  final String selectedChannel;
  final ValueChanged<String> onSelectChannel;

  const _ChannelDrawer({
    required this.channels,
    required this.selectedChannel,
    required this.onSelectChannel,
  });

  @override
  Widget build(BuildContext context) {
    var mt = MediaQuery.of(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: mt.padding.top,
          ),
          ListTile(
            title: const Text('You are signed in'),
            trailing: OutlinedButton(
              onPressed: _signOut,
              child: const Text('Sign Out'),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child:
                Text('Channels', style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: channels
                  .map<ListTile>(
                    (e) => ListTile(
                      title: Text(
                        e.name,
                        style: e.channel == selectedChannel
                            ? const TextStyle(fontWeight: FontWeight.bold)
                            : null,
                      ),
                      onTap: () {
                        // Select the channel
                        onSelectChannel(e.channel);

                        // Close the drawer
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  void _signOut() {
    sessionManager.signOut();
  }
}
