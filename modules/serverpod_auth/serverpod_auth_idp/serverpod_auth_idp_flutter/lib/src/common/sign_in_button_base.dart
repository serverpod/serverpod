import 'package:flutter/material.dart';

import 'sign_in_button_style.dart';

/// The rendered dimensions of a sign-in button at a given [SignInButtonSize].
///
/// The same table applies to every provider, so buttons stay the same height
/// and their logos and labels stay in proportion regardless of brand.
@immutable
class SignInButtonDimensions {
  /// The button height, in pixels.
  final double height;

  /// The provider logo's square dimension, in pixels.
  final double logoSize;

  /// The label font size, in pixels.
  final double labelFontSize;

  /// Creates a set of resolved button dimensions.
  const SignInButtonDimensions({
    required this.height,
    required this.logoSize,
    required this.labelFontSize,
  });

  /// The dimensions for [size], shared by every provider.
  factory SignInButtonDimensions.of(SignInButtonSize size) => switch (size) {
    SignInButtonSize.large => const SignInButtonDimensions(
      height: 40,
      logoSize: 20,
      labelFontSize: 16,
    ),
    SignInButtonSize.medium => const SignInButtonDimensions(
      height: 32,
      logoSize: 16,
      labelFontSize: 14,
    ),
    SignInButtonSize.small => const SignInButtonDimensions(
      height: 20,
      logoSize: 12,
      labelFontSize: 12,
    ),
  };
}

/// The provider-specific pieces the shared [SignInButtonBase] needs.
///
/// Everything a sign-in button does — resolving the shared style, choosing
/// wrapped vs. brand colors, sizing, layout, loading and disabled states — lives
/// in [SignInButtonBase]. A provider only supplies this small config: its logo,
/// its standalone brand colors, and its label strings. External identity
/// providers can build on the same base by supplying their own config.
@immutable
class SignInButtonConfig {
  /// Builds the provider logo sized to [logoSize], or `null` for a text-only
  /// button (e.g. the anonymous button) whose label is simply centered.
  ///
  /// [foregroundColor] is the resolved label color: tint a monochrome logo with
  /// it (as GitHub and Apple do) and ignore it for a multicolor logo (as Google,
  /// Microsoft, and Facebook do). [isDisabled] lets the logo dim to match the
  /// button.
  final Widget Function({
    required double logoSize,
    required Color foregroundColor,
    required bool isDisabled,
  })?
  logoBuilder;

  /// The colors used when the button stands on its own, with no shared
  /// [SignInButtonStyle] in scope — the provider's own brand palette.
  final SignInButtonColors brandColors;

  /// Whether the brand preset draws a border when the button stands on its own.
  ///
  /// Light-on-white presets (e.g. GitHub white, Microsoft light) need one; dark
  /// filled presets do not.
  final bool brandShowBorder;

  /// Whether the button draws a background and border at all.
  ///
  /// `false` renders the button flat — transparent background, no border — in
  /// every context, including inside a [SignInWidget] whose shared style would
  /// otherwise apply them (e.g. the anonymous button). Only the label color is
  /// taken from the resolved colors.
  final bool hasBackground;

  /// The label for [variant], e.g. `signInWith` → "Sign in with GitHub".
  final String Function(SignInButtonTextVariant variant) label;

  /// A localized label that overrides [label] when non-null.
  final String? localizedLabel;

  /// Creates a provider button config.
  const SignInButtonConfig({
    required this.brandColors,
    required this.brandShowBorder,
    required this.label,
    this.logoBuilder,
    this.localizedLabel,
    this.hasBackground = true,
  });
}

/// The shared button that every provider's sign-in button is built from.
///
/// It resolves each property as: the shared [SignInButtonStyle] in scope (e.g.
/// from [SignInWidget]), then the widget argument, then the built-in default —
/// so a [SignInWidget] styles every button at once while a standalone button
/// keeps its own look. With a shared style in scope the button uses the common,
/// theme-aware colors from [SignInButtonStyle.resolveColors]; on its own it uses
/// the provider's [SignInButtonConfig.brandColors].
class SignInButtonBase extends StatelessWidget {
  /// The provider-specific logo, brand colors, and labels.
  final SignInButtonConfig config;

  /// Callback when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether the button is currently loading.
  final bool isLoading;

  /// Whether the button is disabled.
  final bool isDisabled;

  /// The button size.
  final SignInButtonSize size;

  /// The button shape.
  final SignInButtonShape shape;

  /// The button label variant.
  final SignInButtonTextVariant text;

  /// Where the logo sits relative to the label.
  final SignInButtonLogoAlignment logoAlignment;

  /// The minimum button width, in pixels. The maximum is 400.
  final double minimumWidth;

  /// The text style applied to the label, merged over the resolved defaults.
  final TextStyle? textStyle;

  /// Creates a shared sign-in button.
  const SignInButtonBase({
    required this.config,
    required this.onPressed,
    required this.isLoading,
    required this.isDisabled,
    this.size = SignInButtonSize.large,
    this.shape = SignInButtonShape.pill,
    this.text = SignInButtonTextVariant.continueWith,
    this.logoAlignment = SignInButtonLogoAlignment.center,
    this.minimumWidth = 240,
    this.textStyle,
    super.key,
  }) : assert(
         minimumWidth > 0 && minimumWidth <= 400,
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  @override
  Widget build(BuildContext context) {
    final shared = SignInButtonStyleProvider.maybeOf(context);

    final size = shared?.size ?? this.size;
    final shape = shared?.shape ?? this.shape;
    final text = shared?.text ?? this.text;
    final logoAlignment = shared?.logoAlignment ?? this.logoAlignment;
    final minimumWidth = shared?.minimumWidth ?? this.minimumWidth;
    final textStyle = shared?.textStyle ?? this.textStyle;

    final dimensions = SignInButtonDimensions.of(size);
    final borderRadius = switch (shape) {
      SignInButtonShape.rectangular => BorderRadius.circular(4),
      SignInButtonShape.rounded => BorderRadius.circular(8),
      SignInButtonShape.pill => BorderRadius.circular(dimensions.height / 2),
    };

    // Inside a SignInWidget the shared style applies the common, theme-aware
    // colors; on its own the button uses its provider brand colors. A flat
    // config (no background) only takes the label color from either.
    final SignInButtonColors colors;
    final bool showBorder;
    if (shared != null) {
      colors = shared.resolveColors(context);
      showBorder = config.hasBackground;
    } else {
      colors = config.brandColors;
      showBorder = config.hasBackground && config.brandShowBorder;
    }
    final background = config.hasBackground
        ? colors.background
        : Colors.transparent;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumWidth,
        maxWidth: 400,
        minHeight: dimensions.height,
        maxHeight: dimensions.height,
      ),
      child: ElevatedButton(
        onPressed: isLoading || isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: colors.foreground,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: showBorder
                ? BorderSide(color: colors.border)
                : BorderSide.none,
          ),
          padding: EdgeInsets.zero,
          // Flat by design: no resting elevation and no shadow in any state
          // (including hover/pressed), so every provider matches the natively
          // rendered buttons (Google, Apple) that cast no shadow.
          elevation: 0,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: config.hasBackground
              ? colors.background.withValues(alpha: 0.6)
              : Colors.transparent,
          disabledForegroundColor: colors.foreground.withValues(alpha: 0.6),
        ),
        child: _buildContent(
          dimensions: dimensions,
          text: text,
          logoAlignment: logoAlignment,
          textStyle: textStyle,
          foreground: colors.foreground,
        ),
      ),
    );
  }

  Widget _buildContent({
    required SignInButtonDimensions dimensions,
    required SignInButtonTextVariant text,
    required SignInButtonLogoAlignment logoAlignment,
    required TextStyle? textStyle,
    required Color foreground,
  }) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }

    final logo = config.logoBuilder?.call(
      logoSize: dimensions.logoSize,
      foregroundColor: foreground,
      isDisabled: isDisabled,
    );

    // No explicit color: the label inherits the button's foreground, so it dims
    // to the disabled foreground (60%) when the button is disabled, matching the
    // faded background and greyed logo.
    final baseTextStyle = TextStyle(fontSize: dimensions.labelFontSize);
    final textWidget = Text(
      config.localizedLabel ?? config.label(text),
      style: textStyle != null ? baseTextStyle.merge(textStyle) : baseTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );

    // Text-only button (no logo): simply center the label.
    if (logo == null) {
      return Center(child: textWidget);
    }

    // Center: center the [logo + label] group, matching the native Apple
    // button's centered layout.
    if (logoAlignment == SignInButtonLogoAlignment.center) {
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
    // button. The trailing gap balances the leading logo so the label stays
    // centered.
    return Row(
      children: [
        const SizedBox(width: signInLeftLogoIndent),
        logo,
        Expanded(child: textWidget),
        SizedBox(width: signInLeftLogoIndent + dimensions.logoSize),
      ],
    );
  }
}
