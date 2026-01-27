import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'twitch_sign_in_style.dart';

/// A styled button for Twitch Sign-In.
///
/// This widget renders a Twitch-branded button with proper styling,
/// loading states, and disabled states following Twitch's design guidelines.
class TwitchSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button type: icon or standard button.
  final TwitchButtonType type;

  /// The button style (black or white).
  final TwitchButtonStyle style;

  /// The button size (large or medium).
  final TwitchButtonSize size;

  /// The button text.
  final TwitchButtonText text;

  /// The button shape (rectangular, pill, or rounded).
  final TwitchButtonShape shape;

  /// The Twitch logo alignment: left or center.
  final TwitchButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates a Twitch Sign-In button.
  const TwitchSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type = TwitchButtonType.standard,
    this.style = TwitchButtonStyle.black,
    this.size = TwitchButtonSize.large,
    this.text = TwitchButtonText.continueWith,
    this.shape = TwitchButtonShape.pill,
    this.logoAlignment = TwitchButtonLogoAlignment.center,
    this.minimumWidth = 240,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TwitchSignInStyle.fromConfiguration(
      shape: shape,
      size: size,
      style: style,
      width: minimumWidth,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumWidth,
        maxWidth: 400,
        minHeight: buttonStyle.size.height,
        maxHeight: buttonStyle.size.height,
      ),
      child: ElevatedButton(
        onPressed: isLoading || isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonStyle.backgroundColor,
          foregroundColor: buttonStyle.foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: buttonStyle.borderRadius,
            side: style == TwitchButtonStyle.white
                ? buttonStyle.borderSide
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
          disabledBackgroundColor: buttonStyle.backgroundColor.withValues(
            alpha: 0.6,
          ),
          disabledForegroundColor: buttonStyle.foregroundColor.withValues(
            alpha: 0.6,
          ),
        ),
        child: _buildButtonContent(buttonStyle),
      ),
    );
  }

  Widget _buildButtonContent(TwitchSignInStyle buttonStyle) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            buttonStyle.foregroundColor,
          ),
        ),
      );
    }

    if (type == TwitchButtonType.icon) {
      return _buildTwitchLogo(buttonStyle);
    }

    final textWidget = Text(
      _getButtonText(),
      style: TextStyle(
        fontSize: size == TwitchButtonSize.large ? 16 : 14,
        fontWeight: FontWeight.w600,
        color: buttonStyle.foregroundColor,
      ),
    );

    if (logoAlignment == TwitchButtonLogoAlignment.center) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTwitchLogo(buttonStyle),
          const SizedBox(width: 12),
          textWidget,
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildTwitchLogo(buttonStyle),
          const SizedBox(width: 12),
          Expanded(child: textWidget),
        ],
      ),
    );
  }

  Widget _buildTwitchLogo(TwitchSignInStyle buttonStyle) {
    final iconSize = size == TwitchButtonSize.large ? 24.0 : 20.0;

    // Use the appropriate SVG based on the button style
    final svgAsset = style == TwitchButtonStyle.white
        ? 'assets/images/twitch-mark.svg'
        : 'assets/images/twitch-mark-white.svg';

    return SvgPicture.asset(
      svgAsset,
      package: 'serverpod_auth_idp_flutter',
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
    );
  }

  String _getButtonText() {
    return switch (text) {
      TwitchButtonText.signIn => 'Sign in with Twitch',
      TwitchButtonText.signUp => 'Sign up with Twitch',
      TwitchButtonText.continueWith => 'Continue with Twitch',
    };
  }
}
