import 'dart:math';

import 'package:auth_client/auth_client.dart';
import 'package:auth_flutter/profile_model.dart';
import 'package:auth_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class ConnectedScreen extends StatefulWidget {
  const ConnectedScreen({super.key});

  @override
  State<ConnectedScreen> createState() => _ConnectedScreenState();
}

class _ConnectedScreenState extends State<ConnectedScreen> {
  final _clicks = <Click>[];
  UserProfileModel? _userProfile;

  @override
  void initState() {
    super.initState();

    final client = context.read<Client>();

    client.modules.auth.userProfileInfo.get().then((profile) {
      setState(() {
        _userProfile = profile;
      });
    });

    // Load initial clicks from this user.
    client.clicks.getClicks().then((clicks) {
      setState(() {
        _clicks
          ..clear()
          ..addAll(clicks);
      });
    });
  }

  /// Writes a new click to the database, then saves the new list to the state.
  void increment() {
    context.read<Client>().clicks.increment().then((clicks) {
      setState(() {
        _clicks
          ..clear()
          ..addAll(clicks);
      });
    });
  }

  /// Deletes a click from the database, then saves the new list to the state.
  void delete(Click click) {
    context.read<Client>().clicks.delete(click).then((clicks) {
      setState(() {
        _clicks
          ..clear()
          ..addAll(clicks);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${_userProfile?.display}'),
      ),
      drawer: ExampleDrawer(userProfile: _userProfile),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: min(constraints.maxWidth * 0.8, 800),
              child: Column(
                spacing: 16,
                children: [
                  Text(
                    'You incremented the count this many times: '
                    '${_clicks.length}',
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: increment,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _clicks.length,
                      itemBuilder: (context, index) {
                        final click = _clicks[index];
                        return ListTile(
                          title: Text(click.createdAt.toIso8601String()),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => delete(click),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
