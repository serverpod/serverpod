import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'profile_picture.dart';

class ProfileWidget extends StatelessWidget {
  final UserProfileModel? userProfile;

  const ProfileWidget({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ProfilePictureWidget(
          userProfile: userProfile,
          size: 100,
          elevation: 4,
          borderWidth: 2,
          borderColor: Colors.white,
        ),
        if (userProfile == null) ...[
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
