import 'package:flutter/material.dart';
import 'package:auth_client/auth_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'profile_picture.dart';

class ProfileWidget extends StatefulWidget {
  final Client client;

  const ProfileWidget({super.key, required this.client});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  UserProfileModel? _userProfile;

  @override
  void initState() {
    super.initState();

    widget.client.modules.serverpod_auth_core.userProfileInfo.get().then((
      profile,
    ) {
      if (!mounted) return;
      setState(() {
        _userProfile = profile;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ProfilePictureWidget(
          userProfile: _userProfile,
          size: 100,
          elevation: 4,
          borderWidth: 2,
          borderColor: Colors.white,
        ),
        if (_userProfile == null) ...[
          const Opacity(
            opacity: 0.8,
            child: SizedBox(
              width: 100,
              height: 100,
              child: Material(
                shape: CircleBorder(),
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
              ),
            ),
          ),
          const CircularProgressIndicator(),
        ],
      ],
    );
  }
}
