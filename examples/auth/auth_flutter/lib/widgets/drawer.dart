import 'package:auth_client/auth_client.dart';
import 'package:auth_flutter/profile_model.dart';
import 'package:auth_flutter/screens/add_email_screen.dart';
import 'package:auth_flutter/widgets/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

class ExampleDrawer extends StatefulWidget {
  const ExampleDrawer({
    required this.userProfile,
    super.key,
  });

  final UserProfileModel? userProfile;

  @override
  State<ExampleDrawer> createState() => _ExampleDrawerState();
}

class _ExampleDrawerState extends State<ExampleDrawer> {
  bool? hasEmailAccount;
  bool? hasGoogleAccount;

  @override
  void initState() {
    super.initState();
    context.read<Client>().emailIdp.hasEmailAccount().then((value) {
      if (mounted) {
        setState(() {
          hasEmailAccount = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final client = context.read<Client>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[300],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ProfileWidget(userProfile: widget.userProfile),
                ),
                if (widget.userProfile != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(widget.userProfile!.display),
                  ),
              ],
            ),
          ),
          if (client.auth.idp.hasEmail && hasEmailAccount == false)
            ListTile(
              title: const Text('Connect Email'),
              onTap: () async {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddEmailScreen(
                      userProfile: widget.userProfile!,
                    ),
                  ),
                );
              },
            ),
          if (client.auth.idp.hasGoogle && hasGoogleAccount == true)
            ListTile(
              title: const Text('Disconnect Google'),
              onTap: client.auth.disconnectGoogleAccount,
            ),
          ListTile(
            title: const Text('Sign out'),
            onTap: client.auth.signOutDevice,
          ),
        ],
      ),
    );
  }
}
