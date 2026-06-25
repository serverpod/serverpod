import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../common/sign_in_button_style.dart';
import '../localization/sign_in_localization_provider.dart';
import 'github_sign_in_style.dart';

/// A styled button for GitHub Sign-In.
///
/// This widget renders a GitHub-branded button with proper styling,
/// loading states, and disabled states following GitHub's design guidelines.
///
/// The [size], [text], [shape], [logoAlignment], [minimumWidth], and
/// [textStyle] arguments fall back to the shared [SignInButtonStyle] in scope
/// when left null, then to GitHub's own defaults.
class GitHubSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button type: icon or standard button.
  final GitHubButtonType type;

  /// The brand color preset (black or white).
  ///
  /// Applies when the button is used on its own. Inside a [SignInWidget] (or any
  /// [SignInButtonStyle] in scope) the shared common style applies instead.
  final GitHubButtonStyle style;

  /// The button size (large or medium).
  final GitHubButtonSize? size;

  /// The button text.
  final GitHubButtonText? text;

  /// The button shape (rectangular, pill, or rounded).
  final GitHubButtonShape? shape;

  /// The GitHub logo alignment: left or center.
  final GitHubButtonLogoAlignment? logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double? minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates a GitHub Sign-In button.
  const GitHubSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type = GitHubButtonType.standard,
    this.style = GitHubButtonStyle.black,
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
    final localizations = context.githubSignInTexts;
    final shared = SignInButtonStyleProvider.maybeOf(context);

    final size =
        this.size ?? _toGitHubSize(shared?.size) ?? GitHubButtonSize.large;
    final shape =
        this.shape ?? _toGitHubShape(shared?.shape) ?? GitHubButtonShape.pill;
    final text =
        this.text ??
        _toGitHubText(shared?.text) ??
        GitHubButtonText.continueWith;
    final logoAlignment =
        this.logoAlignment ??
        _toGitHubLogoAlignment(shared?.logoAlignment) ??
        GitHubButtonLogoAlignment.center;
    final minimumWidth = this.minimumWidth ?? shared?.minimumWidth ?? 240;
    final textStyle = this.textStyle ?? shared?.textStyle;

    final buttonStyle = GitHubSignInStyle.fromConfiguration(
      shape: shape,
      size: size,
      style: style,
      width: minimumWidth,
    );

    // A shared style (e.g. inside SignInWidget) applies the common, theme-aware
    // colors; on its own the button uses its GitHub brand colors.
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
      showBorder = style == GitHubButtonStyle.white;
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
          localizations,
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
    GitHubSignInTexts localizations, {
    required GitHubButtonSize size,
    required GitHubButtonText text,
    required GitHubButtonLogoAlignment logoAlignment,
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

    if (type == GitHubButtonType.icon) {
      return _buildGitHubLogo(size, foregroundColor);
    }

    final baseTextStyle = TextStyle(
      fontSize: size == GitHubButtonSize.large ? 16 : 14,
      color: foregroundColor,
    );
    final textWidget = Text(
      localizations.signInButton ?? _getButtonText(text),
      style: textStyle != null ? baseTextStyle.merge(textStyle) : baseTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final logo = _buildGitHubLogo(size, foregroundColor);
    final iconSize = size == GitHubButtonSize.large ? 20.0 : 16.0;

    // Center: center the [logo + label] group, matching the native Apple
    // button's centered layout.
    if (logoAlignment == GitHubButtonLogoAlignment.center) {
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

  Widget _buildGitHubLogo(GitHubButtonSize size, Color foregroundColor) {
    final iconSize = size == GitHubButtonSize.large ? 20.0 : 16.0;

    // Pick the mark that matches the foreground (contrasts the background).
    final svgAsset = foregroundColor.computeLuminance() > 0.5
        ? 'assets/images/github-mark-white.svg'
        : 'assets/images/github-mark.svg';

    return SizedBox.square(
      dimension: iconSize,
      child: SvgPicture.asset(
        svgAsset,
        package: 'serverpod_auth_idp_flutter',
        colorFilter: isDisabled
            ? const ColorFilter.mode(Color(0xff9c9c9c), BlendMode.srcIn)
            : null,
        fit: BoxFit.scaleDown,
      ),
    );
  }

  String _getButtonText(GitHubButtonText text) {
    return switch (text) {
      GitHubButtonText.signIn => 'Sign in with GitHub',
      GitHubButtonText.signUp => 'Sign up with GitHub',
      GitHubButtonText.continueWith => 'Continue with GitHub',
    };
  }
}

// GitHub has no small size; it falls back to medium.
GitHubButtonSize? _toGitHubSize(SignInButtonSize? size) => switch (size) {
  null => null,
  SignInButtonSize.large => GitHubButtonSize.large,
  SignInButtonSize.medium => GitHubButtonSize.medium,
  SignInButtonSize.small => GitHubButtonSize.medium,
};

GitHubButtonShape? _toGitHubShape(SignInButtonShape? shape) => switch (shape) {
  null => null,
  SignInButtonShape.rectangular => GitHubButtonShape.rectangular,
  SignInButtonShape.rounded => GitHubButtonShape.rounded,
  SignInButtonShape.pill => GitHubButtonShape.pill,
};

GitHubButtonLogoAlignment? _toGitHubLogoAlignment(
  SignInButtonLogoAlignment? alignment,
) => switch (alignment) {
  null => null,
  SignInButtonLogoAlignment.left => GitHubButtonLogoAlignment.left,
  SignInButtonLogoAlignment.center => GitHubButtonLogoAlignment.center,
};

// GitHub always appends its name, so the bare "sign in" maps to "Sign in with".
GitHubButtonText? _toGitHubText(SignInButtonTextVariant? text) =>
    switch (text) {
      null => null,
      SignInButtonTextVariant.signInWith => GitHubButtonText.signIn,
      SignInButtonTextVariant.signUpWith => GitHubButtonText.signUp,
      SignInButtonTextVariant.continueWith => GitHubButtonText.continueWith,
      SignInButtonTextVariant.signIn => GitHubButtonText.signIn,
    };
