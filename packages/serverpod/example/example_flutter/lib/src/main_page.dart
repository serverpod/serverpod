import 'package:example_client/example_client.dart';
import 'package:example_flutter/main.dart';
import 'package:example_flutter/src/chat_channel.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_chat_flutter/serverpod_chat_flutter.dart';

import 'sign_in_dialog.dart';

class MainPage extends StatefulWidget {
  final List<Channel> channels;

  const MainPage({
    required this.channels,
    Key? key,
  }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Map<String, ChatController> _controllers = {};
  late String _selectedChannel;

  @override
  void initState() {
    super.initState();

    _selectedChannel = widget.channels[0].channel;

    // Setup chat controllers for each channel.
    for (var channel in widget.channels) {
      _controllers[channel.channel] = ChatController(
        channel: channel.channel,
        module: client.modules.chat,
        sessionManager: sessionManager,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();

    for (var controller in _controllers.values) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Find current chat controller and channel information
    var controller = _controllers[_selectedChannel];

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
          ? ChatChannel(controller: controller)
          : const Center(
              child: Text('Select a channel.'),
            ),
    );
  }
}

class _ChannelDrawer extends StatelessWidget {
  final List<Channel> channels;
  final String selectedChannel;
  final ValueChanged<String> onSelectChannel;

  const _ChannelDrawer({
    required this.channels,
    required this.selectedChannel,
    required this.onSelectChannel,
    Key? key,
  }) : super(key: key);

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
          _UserInfoTile(),
          Divider(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text('Channels', style: Theme.of(context).textTheme.caption),
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
                            ? TextStyle(fontWeight: FontWeight.bold)
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
}

class _UserInfoTile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserInfoTileState();
}

class _UserInfoTileState extends State<_UserInfoTile> {
  @override
  Widget build(BuildContext context) {
    var userInfo = sessionManager.signedInUser;

    if (userInfo == null) {
      return ListTile(
        title: const Text('Not signed in'),
        trailing: OutlinedButton(
          onPressed: _signIn,
          child: const Text('Sign In'),
        ),
      );
    } else {
      return ListTile(
        title: const Text('You are signed in'),
        trailing: OutlinedButton(
          onPressed: _signOut,
          child: const Text('Sign Out'),
        ),
      );
    }
  }

  void _signOut() {
    // Pop the drawer.
    Navigator.of(context).pop();

    // Sign out.
    sessionManager.signOut().then((bool success) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _signIn() {
    // Pop the drawer.
    Navigator.of(context).pop();

    // Open the sign in dialog.
    showSignInDialog(
      context: context,
      onSignedIn: () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }
}
