import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/button.dart';
import '../common/style.dart';
import 'icon.dart';

/// A styled button for Google Sign-In on native platforms.
///
/// This widget is styled to match official Google rendered web button and
/// following available branding guidelines from:
/// https://developers.google.com/identity/branding-guidelines
class GoogleSignInNativeButton extends GoogleSignInBaseButton {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// A function to generate the button text based on the current configuration.
  final String Function({bool isLoading})? getButtonText;

  /// Creates a Google Sign-In button for native platforms.
  const GoogleSignInNativeButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    super.type,
    super.theme,
    super.size,
    super.text,
    super.shape,
    super.logoAlignment,
    super.minimumWidth,
    this.getButtonText,
    super.buttonWrapper,
    super.key,
  });

  /// Builds Google Sign-In button with the icon type.
  factory GoogleSignInNativeButton.icon({
    required VoidCallback? onPressed,
    required bool isLoading,
    required bool isDisabled,
  }) => GoogleSignInNativeButton(
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
    type: GSIButtonType.icon,
  );

  /// Builds Google Sign-In button compatible with Material's filled button.
  factory GoogleSignInNativeButton.filled({
    required VoidCallback onPressed,
    required bool isLoading,
    required bool isDisabled,
    GSIButtonTheme theme = GSIButtonTheme.outline,
    GSIButtonSize size = GSIButtonSize.large,
    GSIButtonText text = GSIButtonText.continueWith,
    GSIButtonShape shape = GSIButtonShape.pill,
    GSIButtonLogoAlignment logoAlignment = GSIButtonLogoAlignment.left,
    double minimumWidth = 240,
  }) => GoogleSignInNativeButton(
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
    theme: theme,
    size: size,
    text: text,
    shape: shape,
    logoAlignment: logoAlignment,
    minimumWidth: minimumWidth,
    buttonWrapper: GoogleSignInBaseButton.wrapAsFilled,
  );

  /// Builds Google Sign-In button compatible with Material's outline button.
  factory GoogleSignInNativeButton.outlined({
    required VoidCallback onPressed,
    required bool isLoading,
    required bool isDisabled,
    GSIButtonSize size = GSIButtonSize.large,
    GSIButtonText text = GSIButtonText.continueWith,
    GSIButtonShape shape = GSIButtonShape.pill,
    GSIButtonLogoAlignment logoAlignment = GSIButtonLogoAlignment.left,
    double minimumWidth = 240,
  }) => GoogleSignInNativeButton(
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
    theme: GSIButtonTheme.outline,
    size: size,
    text: text,
    shape: shape,
    logoAlignment: logoAlignment,
    minimumWidth: minimumWidth,
    buttonWrapper: GoogleSignInBaseButton.wrapAsOutline,
  );

  /// Builds Google Sign-In button compatible with Material's elevated button.
  factory GoogleSignInNativeButton.elevated({
    required VoidCallback onPressed,
    required bool isLoading,
    required bool isDisabled,
    GSIButtonTheme theme = GSIButtonTheme.outline,
    GSIButtonSize size = GSIButtonSize.large,
    GSIButtonText text = GSIButtonText.continueWith,
    GSIButtonShape shape = GSIButtonShape.pill,
    GSIButtonLogoAlignment logoAlignment = GSIButtonLogoAlignment.left,
    double minimumWidth = 240,
  }) => GoogleSignInNativeButton(
    onPressed: onPressed,
    isLoading: isLoading,
    isDisabled: isDisabled,
    theme: theme,
    size: size,
    text: text,
    shape: shape,
    logoAlignment: logoAlignment,
    minimumWidth: minimumWidth,
    buttonWrapper: GoogleSignInBaseButton.wrapAsElevated,
  );

  @override
  Widget build(BuildContext context) {
    final buttonStyle = GoogleSignInStyle.fromConfiguration(
      theme: theme,
      shape: shape,
      size: size,
      width: minimumWidth,
    );

    if (type == GSIButtonType.icon) {
      return SizedBox(
        width: buttonStyle.size.height,
        height: buttonStyle.size.height,
        child: OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: buttonStyle.borderSide,
            shape: const CircleBorder(),
            padding: EdgeInsets.zero,
          ),
          child: GoogleSignInIcon(
            isLoading: isLoading,
            isDisabled: isDisabled,
          ),
        ),
      );
    }

    final logo = Padding(
      padding: const EdgeInsets.only(left: 2),
      child: GoogleSignInIcon(
        isLoading: isLoading,
        isDisabled: isDisabled,
        isCentered: logoAlignment == GSIButtonLogoAlignment.center,
        size: size,
        borderRadius: theme == GSIButtonTheme.outline
            ? null
            : buttonStyle.borderRadius,
        backgroundColor: theme == GSIButtonTheme.outline ? null : Colors.white,
      ),
    );

    final text = Padding(
      padding: switch (size) {
        GSIButtonSize.large => const EdgeInsets.symmetric(vertical: 10),
        GSIButtonSize.medium => const EdgeInsets.symmetric(vertical: 6),
        GSIButtonSize.small => const EdgeInsets.symmetric(vertical: 4),
      },
      child: Text(
        getButtonText?.call(isLoading: isLoading) ?? _getButtonText(),
        style: GoogleFonts.roboto(
          fontSize: 14,
          letterSpacing: 0.7,
        ),
      ),
    );

    final buttonContents = (logoAlignment == GSIButtonLogoAlignment.center)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              logo,
              const SizedBox(width: 12),
              text,
            ],
          )
        : Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: logo,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: switch (size) {
                      GSIButtonSize.small => 12.0,
                      GSIButtonSize.medium => 18.0,
                      GSIButtonSize.large => 24.0,
                    },
                  ),
                  Center(
                    child: text,
                  ),
                ],
              ),
            ],
          );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumWidth,
        maxWidth: 400,
        minHeight: buttonStyle.size.height,
        maxHeight: buttonStyle.size.height,
      ),
      child:
          buttonWrapper?.call(
            style: buttonStyle,
            child: buttonContents,
            onPressed: isDisabled ? null : onPressed,
          ) ??
          buttonContents,
    );
  }

  String _getButtonText() {
    if (isLoading) return 'Signing in...';
    return switch (text) {
      GSIButtonText.signinWith => 'Sign in with Google',
      GSIButtonText.signupWith => 'Sign up with Google',
      GSIButtonText.continueWith => 'Continue with Google',
      GSIButtonText.signin => 'Sign in',
    };
  }
}
