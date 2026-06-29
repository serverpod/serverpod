import 'package:flutter/material.dart';

import '../common/button.dart';
import '../common/style.dart';
import 'wrapper.dart';

/// A widget that renders the Google Sign-In button for web.
class GoogleSignInWebButton extends GoogleSignInBaseButton {
  /// The pre-set locale of the button text.
  ///
  /// If not set, the device's default locale is used.
  ///
  /// Different users might see different versions of localized buttons, possibly
  /// with different sizes.
  final String? locale;

  /// Creates a Google Sign-In button for web.
  const GoogleSignInWebButton({
    super.type,
    super.theme,
    super.size,
    super.text,
    super.shape,
    super.logoAlignment,
    super.minimumWidth,
    this.locale,
    super.buttonWrapper,
    super.key,
  });

  /// Builds Google Sign-In button with the icon type.
  factory GoogleSignInWebButton.icon() =>
      const GoogleSignInWebButton(type: GSIButtonType.icon);

  /// Builds Google Sign-In button compatible with Material's filled button.
  factory GoogleSignInWebButton.filled({
    GSIButtonTheme theme = GSIButtonTheme.outline,
    GSIButtonSize size = GSIButtonSize.large,
    GSIButtonText text = GSIButtonText.continueWith,
    GSIButtonShape shape = GSIButtonShape.pill,
    GSIButtonLogoAlignment logoAlignment = GSIButtonLogoAlignment.left,
    double minimumWidth = 240,
  }) => GoogleSignInWebButton(
    theme: theme,
    size: size,
    text: text,
    shape: shape,
    logoAlignment: logoAlignment,
    minimumWidth: minimumWidth,
    buttonWrapper: GoogleSignInBaseButton.wrapAsFilled,
  );

  /// Builds Google Sign-In button compatible with Material's outline button.
  factory GoogleSignInWebButton.outlined({
    GSIButtonSize size = GSIButtonSize.large,
    GSIButtonText text = GSIButtonText.continueWith,
    GSIButtonShape shape = GSIButtonShape.pill,
    GSIButtonLogoAlignment logoAlignment = GSIButtonLogoAlignment.left,
    double minimumWidth = 240,
  }) => GoogleSignInWebButton(
    theme: GSIButtonTheme.outline,
    size: size,
    text: text,
    shape: shape,
    logoAlignment: logoAlignment,
    minimumWidth: minimumWidth,
    buttonWrapper: GoogleSignInBaseButton.wrapAsOutline,
  );

  /// Builds Google Sign-In button compatible with Material's elevated button.
  factory GoogleSignInWebButton.elevated({
    GSIButtonTheme theme = GSIButtonTheme.outline,
    GSIButtonSize size = GSIButtonSize.large,
    GSIButtonText text = GSIButtonText.continueWith,
    GSIButtonShape shape = GSIButtonShape.pill,
    GSIButtonLogoAlignment logoAlignment = GSIButtonLogoAlignment.left,
    double minimumWidth = 240,
  }) => GoogleSignInWebButton(
    theme: theme,
    size: size,
    text: text,
    shape: shape,
    logoAlignment: logoAlignment,
    minimumWidth: minimumWidth,
    buttonWrapper: GoogleSignInBaseButton.wrapAsElevated,
  );

  /// Render the button with the actual width.
  Widget _renderButton({double? width}) => renderButton(
    configuration: GSIButtonConfiguration(
      type: type,
      theme: theme,
      size: size,
      text: text,
      shape: shape,
      logoAlignment: logoAlignment,
      minimumWidth: width ?? minimumWidth,
      locale: locale,
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (type == GSIButtonType.icon) {
      return _renderButton();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.clamp(minimumWidth, 400).toDouble();

        final buttonStyle = GoogleSignInStyle.fromConfiguration(
          theme: theme,
          shape: shape,
          size: size,
          width: width,
        );

        final button = _renderButton(width: width);
        return SizedBox(
          height: buttonStyle.size.height,
          child:
              buttonWrapper?.call(
                style: buttonStyle,
                onPressed: () {},
                child: button,
              ) ??
              button,
        );
      },
    );
  }
}
