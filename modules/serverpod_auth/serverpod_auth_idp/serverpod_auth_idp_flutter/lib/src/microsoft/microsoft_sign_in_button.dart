import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/sign_in_button_style.dart';
import '../localization/sign_in_localization_provider.dart';
import 'microsoft_sign_in_style.dart';

/// A styled button for Microsoft Sign-In.
///
/// This widget renders a Microsoft-branded button with proper styling,
/// loading states, and disabled states following Microsoft's design guidelines.
///
/// The [size], [text], [shape], [logoAlignment], [minimumWidth], and
/// [textStyle] arguments fall back to the shared [SignInButtonStyle] in scope
/// when left null, then to Microsoft's own defaults.
class MicrosoftSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button type: icon or standard button.
  final MicrosoftButtonType type;

  /// The brand color preset (light or dark).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final MicrosoftButtonStyle style;

  /// The button size (large or medium).
  final MicrosoftButtonSize? size;

  /// The button text.
  final MicrosoftButtonText? text;

  /// The button shape (rectangular, pill, or rounded).
  final MicrosoftButtonShape? shape;

  /// The Microsoft logo alignment: left or center.
  final MicrosoftButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double? minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates a Microsoft Sign-In button.
  const MicrosoftSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type = MicrosoftButtonType.standard,
    this.style = MicrosoftButtonStyle.light,
    this.size,
    this.text,
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
    final texts = context.microsoftSignInTexts;
    final shared = SignInButtonStyleProvider.maybeOf(context);

    final size =
        this.size ??
        _toMicrosoftSize(shared?.size) ??
        MicrosoftButtonSize.large;
    final shape =
        this.shape ??
        _toMicrosoftShape(shared?.shape) ??
        MicrosoftButtonShape.pill;
    final text =
        this.text ??
        _toMicrosoftText(shared?.text) ??
        MicrosoftButtonText.continueWith;
    final logoAlignment =
        this.logoAlignment ??
        _toMicrosoftLogoAlignment(shared?.logoAlignment) ??
        MicrosoftButtonLogoAlignment.center;
    final minimumWidth = this.minimumWidth ?? shared?.minimumWidth ?? 240;
    final textStyle = this.textStyle ?? shared?.textStyle;

    final buttonStyle = MicrosoftSignInStyle.fromConfiguration(
      shape: shape,
      size: size,
      style: style,
      width: minimumWidth,
    );

    // A shared style (e.g. inside SignInWidget) applies the common, theme-aware
    // colors; on its own the button uses its Microsoft brand colors.
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
      foregroundColor = buttonStyle.foregroundColor;
      borderColor = buttonStyle.borderSide.color;
      showBorder = style == MicrosoftButtonStyle.light;
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
          padding: EdgeInsets.zero,
          elevation: 0,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.6),
        ),
        child: _buildButtonContent(
          texts,
          size: size,
          text: text,
          logoAlignment: logoAlignment,
          textStyle: textStyle,
          foregroundColor: foregroundColor,
        ),
      ),
    );
  }

  Widget _buildButtonContent(
    MicrosoftSignInTexts texts, {
    required MicrosoftButtonSize size,
    required MicrosoftButtonText text,
    required MicrosoftButtonLogoAlignment logoAlignment,
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

    if (type == MicrosoftButtonType.icon) {
      return _buildMicrosoftLogo(size);
    }

    final baseTextStyle = TextStyle(
      fontSize: size == MicrosoftButtonSize.large ? 16 : 14,
      color: foregroundColor,
    );
    final textWidget = Text(
      texts.signInButton ?? _getButtonText(text),
      style: textStyle != null ? baseTextStyle.merge(textStyle) : baseTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final logo = _buildMicrosoftLogo(size);
    final iconSize = size == MicrosoftButtonSize.large ? 20.0 : 16.0;

    // Center: center the [logo + label] group, matching the native Apple
    // button's centered layout.
    if (logoAlignment == MicrosoftButtonLogoAlignment.center) {
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
            iconSize;
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

  Widget _buildMicrosoftLogo(MicrosoftButtonSize size) {
    final logoSize = size == MicrosoftButtonSize.large ? 20.0 : 16.0;

    return SizedBox.square(
      dimension: logoSize,
      child: SvgPicture.asset(
        'assets/images/microsoft.svg',
        package: 'serverpod_auth_idp_flutter',
        colorFilter: isDisabled
            ? const ColorFilter.mode(Color(0xff9c9c9c), BlendMode.srcIn)
            : null,
        fit: BoxFit.scaleDown,
      ),
    );
  }

  String _getButtonText(MicrosoftButtonText text) {
    return switch (text) {
      MicrosoftButtonText.signIn => 'Sign in with Microsoft',
      MicrosoftButtonText.signUp => 'Sign up with Microsoft',
      MicrosoftButtonText.continueWith => 'Continue with Microsoft',
    };
  }
}

// Microsoft has no small size; it falls back to medium.
MicrosoftButtonSize? _toMicrosoftSize(SignInButtonSize? size) => switch (size) {
  null => null,
  SignInButtonSize.large => MicrosoftButtonSize.large,
  SignInButtonSize.medium => MicrosoftButtonSize.medium,
  SignInButtonSize.small => MicrosoftButtonSize.medium,
};

MicrosoftButtonShape? _toMicrosoftShape(SignInButtonShape? shape) =>
    switch (shape) {
      null => null,
      SignInButtonShape.rectangular => MicrosoftButtonShape.rectangular,
      SignInButtonShape.rounded => MicrosoftButtonShape.rounded,
      SignInButtonShape.pill => MicrosoftButtonShape.pill,
    };

MicrosoftButtonLogoAlignment? _toMicrosoftLogoAlignment(
  SignInButtonLogoAlignment? alignment,
) => switch (alignment) {
  null => null,
  SignInButtonLogoAlignment.left => MicrosoftButtonLogoAlignment.left,
  SignInButtonLogoAlignment.center => MicrosoftButtonLogoAlignment.center,
};

// Microsoft always appends its name, so the bare "sign in" maps to "Sign in
// with".
MicrosoftButtonText? _toMicrosoftText(SignInButtonTextVariant? text) =>
    switch (text) {
      null => null,
      SignInButtonTextVariant.signInWith => MicrosoftButtonText.signIn,
      SignInButtonTextVariant.signUpWith => MicrosoftButtonText.signUp,
      SignInButtonTextVariant.continueWith => MicrosoftButtonText.continueWith,
      SignInButtonTextVariant.signIn => MicrosoftButtonText.signIn,
    };
