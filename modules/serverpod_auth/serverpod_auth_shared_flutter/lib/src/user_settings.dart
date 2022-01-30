import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';

import 'session_manager.dart';
import 'user_image_button.dart';

/// Simple user settings display, can currently only be used to edit the user's
/// image.
class UserSettings extends StatefulWidget {
  /// The session manager from the auth module.
  final SessionManager sessionManager;

  /// Display a compact version of the settings, defaults to true.
  final bool compact;

  /// Creates a new user settings display.
  const UserSettings({
    required this.sessionManager,
    this.compact = true,
  });

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  UserInfo? _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = widget.sessionManager.signedInUser;
    widget.sessionManager.addListener(_onSessionManagerUpdate);
  }

  void _onSessionManagerUpdate() {
    setState(() {
      _userInfo = widget.sessionManager.signedInUser;
    });
  }

  @override
  void dispose() {
    widget.sessionManager.removeListener(_onSessionManagerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo != null) {
      if (widget.compact) {
        return _CompactSettings(
          sessionManager: widget.sessionManager,
          userInfo: _userInfo,
          userName: _userInfo!.userName,
          fullName: _userInfo!.fullName,
        );
      } else {
        return _LargeSettings(
          sessionManager: widget.sessionManager,
          userInfo: _userInfo,
          userName: _userInfo!.userName,
          fullName: _userInfo!.fullName,
        );
      }
    } else {
      if (widget.compact) {
        return _CompactSettings(
          sessionManager: widget.sessionManager,
          userName: 'Not signed in',
        );
      } else {
        return _LargeSettings(
          sessionManager: widget.sessionManager,
          userName: 'Not signed in',
        );
      }
    }
  }
}

class _CompactSettings extends StatelessWidget {
  final SessionManager sessionManager;

  final String userName;
  final String? fullName;
  final UserInfo? userInfo;

  const _CompactSettings({
    required this.sessionManager,
    this.userInfo,
    required this.userName,
    this.fullName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserImageButton(
          sessionManager: sessionManager,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                if (fullName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      fullName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            color: Theme.of(context).textTheme.caption!.color,
                          ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LargeSettings extends StatelessWidget {
  final SessionManager sessionManager;

  final String userName;
  final String? fullName;
  final UserInfo? userInfo;

  const _LargeSettings({
    required this.sessionManager,
    this.userInfo,
    required this.userName,
    this.fullName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        UserImageButton(
          sessionManager: sessionManager,
          compact: false,
          borderWidth: 4,
          elevation: 2,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        if (fullName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              fullName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: Theme.of(context).textTheme.caption!.color,
                  ),
            ),
          ),
      ],
    );
  }
}
