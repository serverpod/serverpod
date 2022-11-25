import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';

/// A circular image that represents a user, based on a [UserInfo] or
/// [UserInfoPublic]. If the user info is missing a link to an image, a default
/// gray circle with a user icon is used. The image is cached between sessions.
///
/// The image can be drawn with an optional border and be elevated (drawn with
/// a shadow).
class CircularUserImage extends StatelessWidget {
  /// The [UserInfo] to fetch the image from.
  final UserInfo? userInfo;

  /// The [UserInfoPublic] to fetch the image from.
  final UserInfoPublic? userInfoPublic;

  /// The size of the user image. Defaults to 20.
  final double size;

  /// Elevation of the user image. Defaults to 0.
  final double elevation;

  /// The width of the user image's border. Defaults to 0.
  final double borderWidth;

  /// The color of the user image's border. Only used if the [borderWidth] is
  /// non-zero. Defaults to white.
  final Color borderColor;

  /// Creates a circular image that represents a user.
  const CircularUserImage({
    this.userInfo,
    this.userInfoPublic,
    this.size = 20.0,
    this.elevation = 0,
    this.borderColor = Colors.white,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (userInfo != null && userInfo!.imageUrl != null) {
      child = CachedNetworkImage(
        imageUrl: userInfo!.imageUrl!,
      );
    } else if (userInfoPublic != null && userInfoPublic!.imageUrl != null) {
      child = CachedNetworkImage(
        imageUrl: userInfoPublic!.imageUrl!,
      );
    } else {
      child = Center(
        child: Icon(
          Icons.account_circle,
          size: size - borderWidth * 2,
          color: Colors.white,
        ),
      );
    }

    if (borderWidth == 0) {
      return SizedBox(
        width: size,
        height: size,
        child: Material(
          elevation: elevation,
          shape: const CircleBorder(),
          color: Colors.grey[500],
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      );
    } else {
      return SizedBox(
        width: size,
        height: size,
        child: Material(
          elevation: elevation,
          shape: const CircleBorder(),
          color: borderColor,
          clipBehavior: Clip.none,
          child: Center(
              child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[500],
            ),
            clipBehavior: Clip.antiAlias,
            width: size - borderWidth * 2,
            height: size - borderWidth * 2,
            child: child,
          )),
        ),
      );
    }
  }
}
