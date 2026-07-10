import 'package:flutter/material.dart';

import 'style.dart';

/// Base class for Google Sign-In buttons with shared wrapping logic.
abstract class GoogleSignInBaseButton extends StatelessWidget {
  /// The button type: icon, or standard button.
  final GSIButtonType type;

  /// The button theme.
  ///
  /// For example, filledBlue or filledBlack.
  final GSIButtonTheme theme;

  /// The button size.
  ///
  /// For example, small or large.
  final GSIButtonSize size;

  /// The button text.
  ///
  /// For example "Sign in with Google" or "Sign up with Google".
  final GSIButtonText text;

  /// The button shape.
  ///
  /// For example, rectangular or circular.
  final GSIButtonShape shape;

  /// The Google logo alignment: left or center.
  final GSIButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels.
  ///
  /// The maximum width is 400 pixels.
  final double minimumWidth;

  /// A wrapper function to the rendered button to ensure style consistency.
  ///
  /// This wrapper ensures the consistency of the rendered button with the rest
  /// of the application. Since the render configuration is done through enum
  /// values, the wrapper will be called with a [GoogleSignInStyle] object that
  /// translates the enum values to actual style properties. The [Widget] is the
  /// rendered Google button that should be wrapped.
  ///
  /// Be mindful that creating the button with no wrapper will also result in a
  /// dangling "Getting ready..." text that is returned while the iFrame is
  /// being built.
  final Widget Function({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  })?
  buttonWrapper;

  /// Creates a base Google Sign-In button.
  const GoogleSignInBaseButton({
    this.type = GSIButtonType.standard,
    this.theme = GSIButtonTheme.outline,
    this.size = GSIButtonSize.large,
    this.text = GSIButtonText.continueWith,
    this.shape = GSIButtonShape.pill,
    this.logoAlignment = GSIButtonLogoAlignment.center,
    this.minimumWidth = 240,
    this.buttonWrapper = wrapAsOutline,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be between 0 and 400.',
       ),
       assert(
         size != GSIButtonSize.small,
         'Small size is disabled due to Android Material and iOS Human '
         'Interface design guidelines regarding minimum target size. Use '
         'medium or large instead.',
       );

  /// Wraps the button to match Material's outlined button style.
  static Widget wrapAsOutline({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        side: style.borderSide,
        shape: RoundedRectangleBorder(borderRadius: style.borderRadius),
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }

  /// Wraps the button to match Material's filled button style.
  static Widget wrapAsFilled({
    required GoogleSignInStyle style,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: style.borderRadius,
          side: style.borderSide,
        ),
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }

  /// Wraps the button to match Material's elevated button style.
  static Widget wrapAsElevated({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: style.backgroundColor,
        foregroundColor: style.foregroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: style.borderRadius,
          side: style.borderSide,
        ),
        padding: EdgeInsets.zero,
      ),
      child: child,
    );
  }

  /// Maps a native [buttonWrapper] to a non-interactive web equivalent.
  ///
  /// Material buttons add focus and pressed overlays that clash with the
  /// Google-hosted iframe button on web. Custom wrappers are passed through.
  static Widget Function({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  })?
  resolveWebButtonWrapper(
    Widget Function({
      required GoogleSignInStyle style,
      required Widget child,
      required VoidCallback? onPressed,
    })?
    wrapper,
  ) {
    if (wrapper == null || wrapper == wrapAsOutline) {
      return wrapAsOutlineWeb;
    }
    if (wrapper == wrapAsFilled) return wrapAsFilledWeb;
    if (wrapper == wrapAsElevated) return wrapAsElevatedWeb;
    return wrapper;
  }

  /// Non-interactive shell for the GIS iframe button on web.
  ///
  /// Draws a single Flutter border and clips the iframe slightly so the GIS
  /// button's own border/focus ring does not stack on top and cause artifacts.
  static Widget wrapAsOutlineWeb({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return _wrapAsClippedWeb(style: style, child: child);
  }

  /// Non-interactive shell for the GIS iframe button on web.
  static Widget wrapAsFilledWeb({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return _wrapAsClippedWeb(style: style, child: child);
  }

  /// Non-interactive shell for the GIS iframe button on web.
  static Widget wrapAsElevatedWeb({
    required GoogleSignInStyle style,
    required Widget child,
    required VoidCallback? onPressed,
  }) {
    return _wrapAsClippedWeb(
      style: style,
      child: child,
      boxShadow: const [
        BoxShadow(
          color: Color(0x1F000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    );
  }

  /// Pads the GIS iframe so its outer edge is clipped, leaving only the
  /// Flutter-drawn border visible.
  static const double _gisClipBleed = 4;

  /// Insets the clip radius so the outer Flutter border sits outside the clip.
  static const double _gisClipRadiusInset = 1;

  /// Insets a [radius] by [inset] for the inner GIS clip.
  static BorderRadius _insetClipRadius(
    BorderRadius radius, {
    double inset = _gisClipRadiusInset,
  }) {
    Radius insetRadius(Radius r) => Radius.circular(
      (r.x - inset).clamp(0.0, double.infinity),
    );

    return BorderRadius.only(
      topLeft: insetRadius(radius.topLeft),
      topRight: insetRadius(radius.topRight),
      bottomLeft: insetRadius(radius.bottomLeft),
      bottomRight: insetRadius(radius.bottomRight),
    );
  }

  static Widget _wrapAsClippedWeb({
    required GoogleSignInStyle style,
    required Widget child,
    List<BoxShadow>? boxShadow,
  }) {
    const bleed = _gisClipBleed;
    final width = style.size.width;
    final height = style.size.height;
    final borderWidth = style.borderSide.width;
    final innerWidth = width - (borderWidth * 2);
    final innerHeight = height - (borderWidth * 2);
    final clipRadius = _insetClipRadius(
      style.borderRadius,
      inset: borderWidth + _gisClipRadiusInset,
    );

    // Flutter draws the only visible border. The GIS iframe sits inside a padded
    // gutter so Google's own border/outline is clipped away.
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: style.backgroundColor,
        shadows: boxShadow,
        shape: RoundedRectangleBorder(
          borderRadius: style.borderRadius,
          side: style.borderSide,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: ClipRRect(
          borderRadius: clipRadius,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            width: innerWidth,
            height: innerHeight,
            child: OverflowBox(
              alignment: Alignment.center,
              minWidth: innerWidth,
              maxWidth: innerWidth,
              minHeight: innerHeight,
              maxHeight: innerHeight,
              child: SizedBox(
                width: innerWidth + bleed,
                height: innerHeight + bleed,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
