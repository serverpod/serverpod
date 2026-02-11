import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'microsoft_sign_in_style.dart';

/// A styled button for Microsoft Sign-In.
///
/// This widget renders a Microsoft-branded button with proper styling,
/// loading states, and disabled states following Microsoft's design guidelines.
class MicrosoftSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button type: icon or standard button.
  final MicrosoftButtonType type;

  /// The button style (light or dark).
  final MicrosoftButtonStyle style;

  /// The button size (large or medium).
  final MicrosoftButtonSize size;

  /// The button text.
  final MicrosoftButtonText text;

  /// The button shape (rectangular, pill, or rounded).
  final MicrosoftButtonShape shape;

  /// The Microsoft logo alignment: left or center.
  final MicrosoftButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// Creates a Microsoft Sign-In button.
  const MicrosoftSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type = MicrosoftButtonType.standard,
    this.style = MicrosoftButtonStyle.light,
    this.size = MicrosoftButtonSize.large,
    this.text = MicrosoftButtonText.continueWith,
    this.shape = MicrosoftButtonShape.pill,
    this.logoAlignment = MicrosoftButtonLogoAlignment.center,
    this.minimumWidth = 240,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  Widget build(BuildContext context) {
    final buttonStyle = MicrosoftSignInStyle.fromConfiguration(
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
            side: style == MicrosoftButtonStyle.light
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

  Widget _buildButtonContent(MicrosoftSignInStyle buttonStyle) {
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

    if (type == MicrosoftButtonType.icon) {
      return _buildMicrosoftLogo(buttonStyle);
    }

    final textWidget = Text(
      _getButtonText(),
      style: TextStyle(
        fontSize: size == MicrosoftButtonSize.large ? 16 : 14,
        fontWeight: FontWeight.w600,
        color: buttonStyle.foregroundColor,
      ),
    );

    if (logoAlignment == MicrosoftButtonLogoAlignment.center) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMicrosoftLogo(buttonStyle),
          const SizedBox(width: 12),
          textWidget,
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildMicrosoftLogo(buttonStyle),
          const SizedBox(width: 12),
          Expanded(child: textWidget),
        ],
      ),
    );
  }

  Widget _buildMicrosoftLogo(MicrosoftSignInStyle buttonStyle) {
    final logoSize = size == MicrosoftButtonSize.large ? 20.0 : 18.0;

    return SvgPicture.asset(
      'assets/images/microsoft.svg',
      package: 'serverpod_auth_idp_flutter',
      width: logoSize,
      height: logoSize,
      fit: BoxFit.contain,
    );
  }

  String _getButtonText() {
    return switch (text) {
      MicrosoftButtonText.signIn => 'Sign in with Microsoft',
      MicrosoftButtonText.signUp => 'Sign up with Microsoft',
      MicrosoftButtonText.continueWith => 'Continue with Microsoft',
    };
  }
}
