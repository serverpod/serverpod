import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'facebook_sign_in_style.dart';

/// A styled button for Facebook Sign-In.
///
/// This widget creates a custom Facebook Sign-In button following Facebook's
/// brand guidelines and adds loading and disabled states.
///
/// The [type], [size], [shape], [logoAlignment], [minimumWidth], and
/// [textStyle] arguments fall back to the shared [SignInButtonStyle] in scope
/// when left null, then to Facebook's own defaults.
class FacebookSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button text type.
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [FacebookButtonText.continueWith], when null.
  final FacebookButtonText? type;

  /// The brand color preset (blue or white).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final FacebookButtonStyle style;

  /// The button size.
  ///
  /// For example, small or large. Falls back to the shared [SignInButtonStyle],
  /// then to [FacebookButtonSize.large], when null.
  final FacebookButtonSize? size;

  /// The button shape.
  ///
  /// For example, rectangular or pill. Falls back to the shared
  /// [SignInButtonStyle], then to [FacebookButtonShape.pill], when null.
  final FacebookButtonShape? shape;

  /// The Facebook logo alignment: left or center.
  ///
  /// Falls back to the shared [SignInButtonStyle], then to
  /// [FacebookButtonLogoAlignment.center], when null.
  final FacebookButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels. Falls back to the shared
  /// [SignInButtonStyle], then to 240, when null.
  final double? minimumWidth;

  /// The text style applied to the button label.
  ///
  /// Falls back to the shared [SignInButtonStyle] when null.
  final TextStyle? textStyle;

  /// Creates a Facebook Sign-In button.
  const FacebookSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type,
    this.style = FacebookButtonStyle.blue,
    this.size,
    this.shape,
    this.logoAlignment,
    this.minimumWidth,
    this.textStyle,
    super.key,
  }) : assert(
         minimumWidth == null || (minimumWidth > 0 && minimumWidth <= 400),
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  @override
  Widget build(BuildContext context) {
    final localizations = context.facebookSignInTexts;
    final shared = SignInButtonStyleProvider.maybeOf(context);

    final type =
        this.type ??
        _toFacebookText(shared?.text) ??
        FacebookButtonText.continueWith;
    final size =
        this.size ?? _toFacebookSize(shared?.size) ?? FacebookButtonSize.large;
    final shape =
        this.shape ??
        _toFacebookShape(shared?.shape) ??
        FacebookButtonShape.pill;
    final logoAlignment =
        this.logoAlignment ??
        _toFacebookLogoAlignment(shared?.logoAlignment) ??
        FacebookButtonLogoAlignment.center;
    final minimumWidth = this.minimumWidth ?? shared?.minimumWidth ?? 240;
    final textStyle = this.textStyle ?? shared?.textStyle;

    final buttonStyle = FacebookSignInStyle.fromConfiguration(
      shape: shape,
      size: size,
      style: style,
      width: minimumWidth,
    );

    // A shared style (e.g. inside SignInWidget) applies the common, theme-aware
    // colors; on its own the button uses its Facebook brand colors.
    final Color backgroundColor;
    final Color foregroundColor;
    final Color borderColor;
    final bool showBorder;
    if (shared != null) {
      final colors = shared.resolveColors(context);
      backgroundColor = colors.background;
      foregroundColor = colors.foreground;
      borderColor = colors.border;
      showBorder = true;
    } else {
      backgroundColor = buttonStyle.backgroundColor;
      foregroundColor = buttonStyle.textColor;
      borderColor = const Color(0xFFE0E0E0);
      showBorder = style == FacebookButtonStyle.white;
    }

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
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: buttonStyle.borderRadius,
            side: showBorder ? BorderSide(color: borderColor) : BorderSide.none,
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
          disabledBackgroundColor: backgroundColor.withValues(alpha: .6),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.6),
        ),
        child: _buildButtonContent(
          localizations,
          type: type,
          buttonStyle: buttonStyle,
          logoAlignment: logoAlignment,
          textStyle: textStyle,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }

  Widget _buildButtonContent(
    FacebookSignInTexts localizations, {
    required FacebookButtonText type,
    required FacebookSignInStyle buttonStyle,
    required FacebookButtonLogoAlignment logoAlignment,
    required TextStyle? textStyle,
    required Color foregroundColor,
  }) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
        ),
      );
    }

    final logoSize = buttonStyle.logoSize;

    final logo = SizedBox.square(
      dimension: logoSize,
      child: Icon(
        Icons.facebook,
        size: logoSize,
        color: foregroundColor,
      ),
    );

    final baseTextStyle = TextStyle(
      fontSize: buttonStyle.labelFontSize,
      color: foregroundColor,
    );
    final textWidget = Text(
      localizations.signInButton ?? _getButtonText(type),
      style: textStyle != null ? baseTextStyle.merge(textStyle) : baseTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    // Center: center the [logo + label] group, matching the native Apple
    // button's centered layout.
    if (logoAlignment == FacebookButtonLogoAlignment.center) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo,
          const SizedBox(width: signInCenteredLogoGap),
          Flexible(child: textWidget),
        ],
      );
    }

    // Left: logo at the left column, with the label left-aligned starting where
    // the native Apple button's centered label starts, so the labels line up.
    return LayoutBuilder(
      builder: (context, constraints) {
        final raw =
            (constraints.maxWidth - signInLeftLabelWidth) / 2 -
            signInLeftLogoIndent -
            logoSize;
        final gap = raw < signInCenteredLogoGap ? signInCenteredLogoGap : raw;
        return Row(
          children: [
            const SizedBox(width: signInLeftLogoIndent),
            logo,
            SizedBox(width: gap),
            Flexible(child: textWidget),
          ],
        );
      },
    );
  }

  String _getButtonText(FacebookButtonText type) {
    return switch (type) {
      FacebookButtonText.signinWith => 'Sign in with Facebook',
      FacebookButtonText.continueWith => 'Continue with Facebook',
      FacebookButtonText.signupWith => 'Sign up with Facebook',
      FacebookButtonText.signIn => 'Sign in',
    };
  }
}

FacebookButtonSize? _toFacebookSize(SignInButtonSize? size) => switch (size) {
  null => null,
  SignInButtonSize.large => FacebookButtonSize.large,
  SignInButtonSize.medium => FacebookButtonSize.medium,
  SignInButtonSize.small => FacebookButtonSize.small,
};

FacebookButtonShape? _toFacebookShape(SignInButtonShape? shape) =>
    switch (shape) {
      null => null,
      SignInButtonShape.rectangular => FacebookButtonShape.rectangular,
      SignInButtonShape.rounded => FacebookButtonShape.rounded,
      SignInButtonShape.pill => FacebookButtonShape.pill,
    };

FacebookButtonLogoAlignment? _toFacebookLogoAlignment(
  SignInButtonLogoAlignment? alignment,
) => switch (alignment) {
  null => null,
  SignInButtonLogoAlignment.left => FacebookButtonLogoAlignment.left,
  SignInButtonLogoAlignment.center => FacebookButtonLogoAlignment.center,
};

FacebookButtonText? _toFacebookText(SignInButtonTextVariant? text) =>
    switch (text) {
      null => null,
      SignInButtonTextVariant.signInWith => FacebookButtonText.signinWith,
      SignInButtonTextVariant.signUpWith => FacebookButtonText.signupWith,
      SignInButtonTextVariant.continueWith => FacebookButtonText.continueWith,
      SignInButtonTextVariant.signIn => FacebookButtonText.signIn,
    };
