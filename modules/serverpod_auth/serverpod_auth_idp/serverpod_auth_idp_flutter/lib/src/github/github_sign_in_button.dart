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
  final GitHubButtonSize size;

  /// The button text.
  final GitHubButtonText text;

  /// The button shape (rectangular, pill, or rounded).
  final GitHubButtonShape shape;

  /// The GitHub logo alignment: left or center.
  final GitHubButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// The text style applied to the button label.
  final TextStyle? textStyle;

  /// Creates a GitHub Sign-In button.
  const GitHubSignInButton({
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.type = GitHubButtonType.standard,
    this.style = GitHubButtonStyle.black,
    this.size = GitHubButtonSize.large,
    this.text = GitHubButtonText.continueWith,
    this.shape = GitHubButtonShape.pill,
    this.logoAlignment = GitHubButtonLogoAlignment.center,
    this.minimumWidth = 240,
    this.textStyle,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  @override
  Widget build(BuildContext context) {
    final localizations = context.githubSignInTexts;
    final shared = SignInButtonStyleProvider.maybeOf(context);

    final size = shared?.size?.toGitHub() ?? this.size;
    final shape = shared?.shape?.toGitHub() ?? this.shape;
    final text = shared?.text?.toGitHub() ?? this.text;
    final logoAlignment =
        shared?.logoAlignment?.toGitHub() ?? this.logoAlignment;
    final minimumWidth = shared?.minimumWidth ?? this.minimumWidth;
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
          buttonStyle: buttonStyle,
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
    required GitHubSignInStyle buttonStyle,
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
      return _buildGitHubLogo(buttonStyle.logoSize, foregroundColor);
    }

    final baseTextStyle = TextStyle(
      fontSize: buttonStyle.labelFontSize,
      color: foregroundColor,
    );
    final textWidget = Text(
      localizations.signInButton ?? _getButtonText(text),
      style: textStyle != null ? baseTextStyle.merge(textStyle) : baseTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    final logo = _buildGitHubLogo(buttonStyle.logoSize, foregroundColor);

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

    // Left: logo pinned to the left column with the label centered in the
    // button, matching the native Apple button's left layout. The trailing
    // gap balances the leading logo so the label stays centered.
    return Row(
      children: [
        const SizedBox(width: signInLeftLogoIndent),
        logo,
        Expanded(child: textWidget),
        SizedBox(width: signInLeftLogoIndent + buttonStyle.logoSize),
      ],
    );
  }

  Widget _buildGitHubLogo(double logoSize, Color foregroundColor) {
    // Pick the mark that matches the foreground (contrasts the background).
    final svgAsset = foregroundColor.computeLuminance() > 0.5
        ? 'assets/images/github-mark-white.svg'
        : 'assets/images/github-mark.svg';

    return SizedBox.square(
      dimension: logoSize,
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

extension on SignInButtonSize {
  // GitHub has no small size; it falls back to medium.
  GitHubButtonSize toGitHub() => switch (this) {
    SignInButtonSize.large => GitHubButtonSize.large,
    SignInButtonSize.medium => GitHubButtonSize.medium,
    SignInButtonSize.small => GitHubButtonSize.medium,
  };
}

extension on SignInButtonShape {
  GitHubButtonShape toGitHub() => switch (this) {
    SignInButtonShape.rectangular => GitHubButtonShape.rectangular,
    SignInButtonShape.rounded => GitHubButtonShape.rounded,
    SignInButtonShape.pill => GitHubButtonShape.pill,
  };
}

extension on SignInButtonLogoAlignment {
  GitHubButtonLogoAlignment toGitHub() => switch (this) {
    SignInButtonLogoAlignment.left => GitHubButtonLogoAlignment.left,
    SignInButtonLogoAlignment.center => GitHubButtonLogoAlignment.center,
  };
}

extension on SignInButtonTextVariant {
  // GitHub always appends its name, so the bare "sign in" maps to "Sign in
  // with".
  GitHubButtonText toGitHub() => switch (this) {
    SignInButtonTextVariant.signInWith => GitHubButtonText.signIn,
    SignInButtonTextVariant.signUpWith => GitHubButtonText.signUp,
    SignInButtonTextVariant.continueWith => GitHubButtonText.continueWith,
    SignInButtonTextVariant.signIn => GitHubButtonText.signIn,
  };
}
