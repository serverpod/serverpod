import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';

class CircularUserImage extends StatelessWidget {
  final UserInfo? userInfo;
  final double size;
  final double elevation;
  final double borderWidth;
  final Color borderColor;

  CircularUserImage({
    this.userInfo,
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
    }
    else {
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
          shape: CircleBorder(),
          color: Colors.grey[500],
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
      );
    }
    else {
      return SizedBox(
        width: size,
        height: size,
        child: Material(
          elevation: elevation,
          shape: CircleBorder(),
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
            )
          ),
        ),
      );
    }
  }
}
