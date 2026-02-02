import 'package:flutter/material.dart';

import 'facebook_sign_in_style.dart';

/// A styled button for Facebook Sign-In.
///
/// This widget creates a custom Facebook Sign-In button following Facebook's
/// brand guidelines and adds loading and disabled states.
class FacebookSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button text type.
  final FacebookButtonText type;

  /// The button style (blue or white).
  final FacebookButtonStyle style;

  /// The button size.
  ///
  /// For example, small or large.
  final FacebookButtonSize size;

  /// The button shape.
  ///
  /// For example, rectangular or pill.
  final FacebookButtonShape shape;

  /// The Facebook logo alignment: left or center.
  final FacebookButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates a Facebook Sign-In button.
  const FacebookSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type = FacebookButtonText.continueWith,
    this.style = FacebookButtonStyle.blue,
    this.size = FacebookButtonSize.large,
    this.shape = FacebookButtonShape.pill,
    this.logoAlignment = FacebookButtonLogoAlignment.center,
    this.minimumWidth = 240,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  Widget build(BuildContext context) {
    final buttonStyle = FacebookSignInStyle.fromConfiguration(
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
          foregroundColor: buttonStyle.textColor,
          disabledBackgroundColor: buttonStyle.backgroundColor.withValues(
            alpha: .6,
          ),
          disabledForegroundColor: buttonStyle.textColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: buttonStyle.borderRadius,
            side: style == FacebookButtonStyle.white
                ? BorderSide(color: Colors.grey.shade300)
                : BorderSide.none,
          ),
          elevation: style == FacebookButtonStyle.white ? 0 : 2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          minimumSize: buttonStyle.size,
          maximumSize: Size(400, buttonStyle.size.height),
        ),
        child: isLoading
            ? SizedBox(
                width: buttonStyle.size.height * 0.5,
                height: buttonStyle.size.height * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    buttonStyle.textColor,
                  ),
                ),
              )
            : _buildButtonContent(buttonStyle),
      ),
    );
  }

  Widget _buildButtonContent(FacebookSignInStyle buttonStyle) {
    final logo = Icon(
      Icons.facebook,
      size: buttonStyle.size.height * 0.6,
      color: buttonStyle.textColor,
    );

    final text = Text(
      _getButtonText(),
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
        color: buttonStyle.textColor,
      ),
      overflow: TextOverflow.ellipsis,
    );

    if (logoAlignment == FacebookButtonLogoAlignment.center) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo,
          const SizedBox(width: 8),
          Flexible(child: text),
        ],
      );
    }

    return Stack(
      children: [
        Positioned(
          left: 12,
          top: 0,
          bottom: 0,
          child: logo,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: buttonStyle.size.height * 0.5 + 8,
            ),
            Expanded(
              child: Center(child: text),
            ),
          ],
        ),
      ],
    );
  }

  String _getButtonText() {
    return switch (type) {
      FacebookButtonText.signinWith => 'Sign in with Facebook',
      FacebookButtonText.continueWith => 'Continue with Facebook',
      FacebookButtonText.signupWith => 'Sign up with Facebook',
      FacebookButtonText.signin => 'Sign in',
    };
  }

  double _getFontSize() {
    return switch (size) {
      FacebookButtonSize.large => 16.0,
      FacebookButtonSize.medium => 14.0,
      FacebookButtonSize.small => 12.0,
    };
  }
}
