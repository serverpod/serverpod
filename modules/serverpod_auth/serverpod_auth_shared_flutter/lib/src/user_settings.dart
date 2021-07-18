import 'dart:typed_data';



import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';

import 'session_manager.dart';
import 'circular_user_image.dart';
import 'user_image_button.dart';

class UserSettings extends StatefulWidget {
  final Caller caller;
  final SessionManager sessionManager;
  final bool compact;

  UserSettings({
    required this.caller,
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
          caller: widget.caller,
          sessionManager: widget.sessionManager,
          userInfo: _userInfo,
          userName: _userInfo!.userName,
          fullName: _userInfo!.fullName,
        );
      }
      else {
        return _LargeSettings(
          caller: widget.caller,
          sessionManager: widget.sessionManager,
          userInfo: _userInfo,
          userName: _userInfo!.userName,
          fullName: _userInfo!.fullName,
        );
      }
    }
    else {
      if (widget.compact) {
        return _CompactSettings(
          caller: widget.caller,
          sessionManager: widget.sessionManager,
          userName: 'Not signed in',
        );
      }
      else {
        return _LargeSettings(
          caller: widget.caller,
          sessionManager: widget.sessionManager,
          userName: 'Not signed in',
        );
      }
    }
  }
}

class _CompactSettings extends StatelessWidget {
  final Caller caller;
  final SessionManager sessionManager;

  final String userName;
  final String? fullName;
  final UserInfo? userInfo;

  _CompactSettings({
    required this.caller,
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
          caller: caller,
          sessionManager: sessionManager,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 16),
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
                if (fullName != null) Padding(
                  padding: EdgeInsets.only(top: 4),
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
  final Caller caller;
  final SessionManager sessionManager;

  final String userName;
  final String? fullName;
  final UserInfo? userInfo;

  _LargeSettings({
    required this.caller,
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
          caller: caller,
          sessionManager: sessionManager,
          compact: false,
          borderWidth: 4,
          elevation: 2,
        ),
        Padding(
          padding: EdgeInsets.only(top: 24),
          child: Text(
            userName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        if (fullName != null) Padding(
          padding: EdgeInsets.only(top: 8),
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



