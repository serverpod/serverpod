import 'package:flutter/material.dart';

import '../../common/sign_in_button_style.dart';
import '../../localization/sign_in_localization_provider.dart';
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

  /// The text style applied to the button label.
  ///
  /// Merged over the default label style, so it can override the font while
  /// keeping the defaults for any unset properties.
  final TextStyle? textStyle;

  /// Overrides the shape-derived border radius when provided.
  ///
  /// Used to render shapes the web [GSIButtonShape] cannot express (e.g.
  /// rounded), since the native button is drawn in Flutter.
  final BorderRadius? borderRadius;

  /// Overrides the theme-derived background color when provided.
  final Color? backgroundColor;

  /// Overrides the theme-derived foreground color when provided.
  final Color? foregroundColor;

  /// Overrides the background-derived border color when provided.
  final Color? borderColor;

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
    this.textStyle,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
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
    final localizations = context.googleSignInTexts;
    final shared = SignInButtonStyleProvider.maybeOf(context);

    // Resolve the shared style so the standalone native button honors it too
    // (GoogleSignInWidget passes explicit values, which win when provided).
    final effectiveLogoAlignment =
        _toGoogleLogoAlignment(shared?.logoAlignment) ?? logoAlignment;
    final effectiveShape = _toGoogleShape(shared?.shape) ?? shape;
    // Inside a shared style, apply its common (theme-aware) colors; on its own
    // the button uses its Google brand theme.
    final sharedColors = shared?.resolveColors(context);
    // The web GSIButtonShape has no rounded option, so render the shared rounded
    // shape with an explicit radius.
    final effectiveBorderRadius =
        borderRadius ??
        (shared?.shape == SignInButtonShape.rounded
            ? BorderRadius.circular(8)
            : null);
    final buttonStyle = GoogleSignInStyle.fromConfiguration(
      theme: theme,
      shape: effectiveShape,
      size: size,
      width: minimumWidth,
      borderRadius: effectiveBorderRadius,
      backgroundColor: backgroundColor ?? sharedColors?.background,
      foregroundColor: foregroundColor ?? sharedColors?.foreground,
      borderColor: borderColor ?? sharedColors?.border,
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

    final logo = GoogleSignInIcon(
      isLoading: isLoading,
      isDisabled: isDisabled,
      isCentered: true,
      size: size,
      borderRadius: theme == GSIButtonTheme.outline
          ? null
          : buttonStyle.borderRadius,
      backgroundColor: theme == GSIButtonTheme.outline ? null : Colors.white,
    );

    final text = Padding(
      padding: switch (size) {
        GSIButtonSize.large => const EdgeInsets.symmetric(vertical: 10),
        GSIButtonSize.medium => const EdgeInsets.symmetric(vertical: 6),
        GSIButtonSize.small => const EdgeInsets.symmetric(vertical: 4),
      },
      child: Text(
        getButtonText?.call(isLoading: isLoading) ??
            localizations.signInButton ??
            _getButtonText(),
        // No font family, so the label inherits the theme font like the other
        // buttons; the shared textStyle is merged on top.
        style: TextStyle(
          fontSize: switch (size) {
            GSIButtonSize.large => 16.0,
            GSIButtonSize.medium => 14.0,
            GSIButtonSize.small => 12.0,
          },
        ).merge(textStyle ?? shared?.textStyle),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final iconSize = switch (size) {
      GSIButtonSize.large => 20.0,
      GSIButtonSize.medium => 16.0,
      GSIButtonSize.small => 12.0,
    };

    final buttonContents =
        (effectiveLogoAlignment == GSIButtonLogoAlignment.center)
        // Center: center the [logo + label] group, matching the native Apple
        // button's centered layout. Google's logo doesn't fill its box (scaled
        // SVG), so tighten the gap a little to match the other buttons.
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              logo,
              const SizedBox(width: signInCenteredLogoGap - 2),
              Flexible(child: text),
            ],
          )
        // Left: logo at the left column, with the label left-aligned starting
        // where the native Apple button's centered label starts.
        : LayoutBuilder(
            builder: (context, constraints) {
              final raw =
                  (constraints.maxWidth - signInLeftLabelWidth) / 2 -
                  signInLeftLogoIndent -
                  iconSize;
              final gap = raw < signInCenteredLogoGap
                  ? signInCenteredLogoGap
                  : raw;
              return Row(
                children: [
                  const SizedBox(width: signInLeftLogoIndent),
                  logo,
                  SizedBox(width: gap),
                  Flexible(child: text),
                ],
              );
            },
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
    return switch (text) {
      GSIButtonText.signinWith => 'Sign in with Google',
      GSIButtonText.signupWith => 'Sign up with Google',
      GSIButtonText.continueWith => 'Continue with Google',
      GSIButtonText.signin => 'Sign in',
    };
  }
}

GSIButtonLogoAlignment? _toGoogleLogoAlignment(
  SignInButtonLogoAlignment? alignment,
) => switch (alignment) {
  null => null,
  SignInButtonLogoAlignment.left => GSIButtonLogoAlignment.left,
  SignInButtonLogoAlignment.center => GSIButtonLogoAlignment.center,
};

// The web GSIButtonShape has no rounded option, so rounded maps to pill here;
// the native button applies the rounded radius via a borderRadius override.
GSIButtonShape? _toGoogleShape(SignInButtonShape? shape) => switch (shape) {
  null => null,
  SignInButtonShape.rectangular => GSIButtonShape.rectangular,
  SignInButtonShape.rounded => GSIButtonShape.pill,
  SignInButtonShape.pill => GSIButtonShape.pill,
};
