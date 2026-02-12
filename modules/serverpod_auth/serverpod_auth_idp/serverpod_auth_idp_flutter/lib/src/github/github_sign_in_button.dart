import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'github_sign_in_style.dart';

/// A styled button for GitHub Sign-In.
///
/// This widget renders a GitHub-branded button with proper styling,
/// loading states, and disabled states following GitHub's design guidelines.
class GitHubSignInButton extends StatelessWidget {
  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button type: icon or standard button.
  final GitHubButtonType type;

  /// The button style (black or white).
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
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  @override
  Widget build(BuildContext context) {
    final buttonStyle = GitHubSignInStyle.fromConfiguration(
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
            side: style == GitHubButtonStyle.white
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

  Widget _buildButtonContent(GitHubSignInStyle buttonStyle) {
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

    if (type == GitHubButtonType.icon) {
      return _buildGitHubLogo(buttonStyle);
    }

    final textWidget = Text(
      _getButtonText(),
      style: TextStyle(
        fontSize: size == GitHubButtonSize.large ? 16 : 14,
        fontWeight: FontWeight.w600,
        color: buttonStyle.foregroundColor,
      ),
    );

    final logo = _buildGitHubLogo(buttonStyle);

    if (logoAlignment == GitHubButtonLogoAlignment.center) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          logo,
          const SizedBox(width: 12),
          textWidget,
        ],
      );
    }

    final logoSize = size == GitHubButtonSize.large ? 20.0 : 16.0;

    return Stack(
      children: [
        Positioned(
          left: 14,
          top: 0,
          bottom: 0,
          child: logo,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: logoSize),
            Center(child: textWidget),
            const SizedBox(width: 8),
          ],
        ),
      ],
    );
  }

  Widget _buildGitHubLogo(GitHubSignInStyle buttonStyle) {
    final iconSize = size == GitHubButtonSize.large ? 20.0 : 16.0;

    // Use the appropriate SVG based on the button style
    final svgAsset = style == GitHubButtonStyle.white
        ? 'assets/images/github-mark.svg'
        : 'assets/images/github-mark-white.svg';

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

  String _getButtonText() {
    return switch (text) {
      GitHubButtonText.signIn => 'Sign in with GitHub',
      GitHubButtonText.signUp => 'Sign up with GitHub',
      GitHubButtonText.continueWith => 'Continue with GitHub',
    };
  }
}
