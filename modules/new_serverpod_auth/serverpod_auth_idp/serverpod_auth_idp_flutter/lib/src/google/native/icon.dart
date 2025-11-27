import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/style.dart';

/// The Google icon for the Google Sign-In button.
class GoogleSignInIcon extends StatelessWidget {
  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The background color of the icon.
  final Color? backgroundColor;

  /// Whether the icon will be used centered in a button.
  final bool isCentered;

  /// The border radius of the icon.
  final BorderRadius? borderRadius;

  /// The size of the icon.
  final GSIButtonSize size;

  /// Creates a Google Sign-In icon.
  const GoogleSignInIcon({
    required this.isDisabled,
    required this.isLoading,
    this.backgroundColor,
    this.isCentered = false,
    this.borderRadius,
    this.size = GSIButtonSize.large,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final picture = isLoading
        ? const CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey,
          )
        : SvgPicture.asset(
            'assets/images/google.svg',
            package: 'serverpod_auth_idp_flutter',
            colorFilter: isDisabled
                ? const ColorFilter.mode(Color(0xff9c9c9c), BlendMode.srcIn)
                : null,
            fit: BoxFit.scaleDown,
          );

    final iconSize = switch (size) {
      GSIButtonSize.small => 12.0,
      GSIButtonSize.medium => 16.0,
      GSIButtonSize.large => 20.0,
    };

    final backgroundSize =
        (backgroundColor == null ? 2.0 : 0.0) +
        switch (size) {
          GSIButtonSize.small => iconSize + 10,
          GSIButtonSize.medium => iconSize + 12,
          GSIButtonSize.large => iconSize + 16,
        };

    return Center(
      child: Container(
        height: backgroundColor != null ? backgroundSize : null,
        width: backgroundColor != null || !isCentered ? backgroundSize : null,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Center(
          child: SizedBox(
            height: iconSize,
            width: iconSize,
            child: picture,
          ),
        ),
      ),
    );
  }
}
