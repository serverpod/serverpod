import 'package:flutter/material.dart';

/// The gap between the logo and the label on a centered sign-in button, tuned
/// to match the native Apple button (whose logo sits in a wider box, leaving
/// ~5.8px between the logo and the label at the default size).
const double signInCenteredLogoGap = 6;

/// The left indent of the logo when a sign-in button is left-aligned, tuned so
/// the icons line up with the native Apple button (whose logo is centered in a
/// wider icon box, sitting a few pixels in from the edge).
const double signInLeftLogoIndent = 21;

/// Sign-in button size. Providers without [small] fall back to [medium].
enum SignInButtonSize {
  /// Large button (recommended).
  large,

  /// Medium button.
  medium,

  /// Small button.
  small,
}

/// Sign-in button shape.
enum SignInButtonShape {
  /// Sharp corners.
  rectangular,

  /// Moderate corner radius.
  rounded,

  /// Fully rounded ends.
  pill,
}

/// Where the provider logo sits relative to the label.
enum SignInButtonLogoAlignment {
  /// Left of the label.
  left,

  /// Centered with the label.
  center,
}

/// Sign-in button label. Each button appends the provider name, so
/// [signInWith] reads "Sign in with Google".
enum SignInButtonTextVariant {
  /// "Sign in with `<provider>`".
  signInWith,

  /// "Sign up with `<provider>`".
  signUpWith,

  /// "Continue with `<provider>`".
  continueWith,

  /// "Sign in", no provider name. Falls back to [signInWith] where unsupported.
  signIn,
}

/// The resolved background, foreground, and border colors of a sign-in button.
@immutable
class SignInButtonColors {
  /// The button background color.
  final Color background;

  /// The label (and monochrome logo) color.
  final Color foreground;

  /// The button border color.
  final Color border;

  /// Creates a resolved set of sign-in button colors.
  const SignInButtonColors({
    required this.background,
    required this.foreground,
    required this.border,
  });
}

/// Styling shared by every sign-in button.
///
/// Pass this to [SignInWidget] to style all provider buttons at once instead of
/// configuring each widget. Each field is a default that an individual provider
/// widget can still override; `null` means "leave it to the widget". A button
/// resolves each property as: widget argument, then this style, then its own
/// default.
///
/// By default the buttons share one neutral appearance (see [resolveColors]);
/// set [backgroundColor]/[foregroundColor]/[borderColor] to recolor them all,
/// or set a provider widget's own brand `style` to opt that one back into its
/// brand colors.
///
/// Apple is drawn by its native button and only approximates these colors with
/// its nearest black/white/outlined preset, and it ignores [textStyle] (it
/// always uses the system font).
@immutable
class SignInButtonStyle {
  /// Button size.
  final SignInButtonSize? size;

  /// Button shape.
  final SignInButtonShape? shape;

  /// Logo placement.
  final SignInButtonLogoAlignment? logoAlignment;

  /// Button label.
  final SignInButtonTextVariant? text;

  /// Minimum width in pixels, up to 400.
  final double? minimumWidth;

  /// Label text style. Apple ignores this — its native button always uses the
  /// system font.
  final TextStyle? textStyle;

  /// Button background color. Defaults to a theme-based neutral.
  final Color? backgroundColor;

  /// Label (and monochrome logo) color. Defaults to a theme-based neutral.
  final Color? foregroundColor;

  /// Button border color. Defaults to a theme-based neutral.
  final Color? borderColor;

  /// Creates a shared button style. Unset fields fall through to each widget.
  const SignInButtonStyle({
    this.size,
    this.shape,
    this.logoAlignment,
    this.text,
    this.minimumWidth,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  }) : assert(
         minimumWidth == null || (minimumWidth > 0 && minimumWidth <= 400),
         'Invalid minimumWidth. Must be greater than 0 and at most 400.',
       );

  /// A style that overrides nothing.
  static const defaults = SignInButtonStyle();

  /// Resolves the uniform button colors for the current theme, applying any
  /// [backgroundColor]/[foregroundColor]/[borderColor] overrides on top of a
  /// neutral default that follows the theme brightness.
  SignInButtonColors resolveColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SignInButtonColors(
      background:
          backgroundColor ??
          (isDark ? const Color(0xFF1F1F1F) : const Color(0xFFFFFFFF)),
      foreground:
          foregroundColor ??
          (isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1F1F1F)),
      border:
          borderColor ??
          (isDark ? const Color(0xFF5F6368) : const Color(0xFFDADCE0)),
    );
  }

  /// Returns a copy with the given fields replaced.
  SignInButtonStyle copyWith({
    SignInButtonSize? size,
    SignInButtonShape? shape,
    SignInButtonLogoAlignment? logoAlignment,
    SignInButtonTextVariant? text,
    double? minimumWidth,
    TextStyle? textStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? borderColor,
  }) {
    return SignInButtonStyle(
      size: size ?? this.size,
      shape: shape ?? this.shape,
      logoAlignment: logoAlignment ?? this.logoAlignment,
      text: text ?? this.text,
      minimumWidth: minimumWidth ?? this.minimumWidth,
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInButtonStyle &&
        other.size == size &&
        other.shape == shape &&
        other.logoAlignment == logoAlignment &&
        other.text == text &&
        other.minimumWidth == minimumWidth &&
        other.textStyle == textStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.borderColor == borderColor;
  }

  @override
  int get hashCode => Object.hash(
    size,
    shape,
    logoAlignment,
    text,
    minimumWidth,
    textStyle,
    backgroundColor,
    foregroundColor,
    borderColor,
  );
}

/// Exposes a [SignInButtonStyle] to the sign-in buttons below it.
///
/// [SignInWidget] inserts this for you, so every provider button — including
/// ones from external packages — picks up the shared style through context.
class SignInButtonStyleProvider extends InheritedWidget {
  /// The style shared with descendant buttons.
  final SignInButtonStyle style;

  /// Creates a [SignInButtonStyleProvider].
  const SignInButtonStyleProvider({
    required this.style,
    required super.child,
    super.key,
  });

  /// The nearest shared style, or `null` if there is none.
  static SignInButtonStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<SignInButtonStyleProvider>()
        ?.style;
  }

  @override
  bool updateShouldNotify(SignInButtonStyleProvider oldWidget) {
    return oldWidget.style != style;
  }
}

/// Reads the shared [SignInButtonStyle] from context.
extension SignInButtonStyleBuildContextExtension on BuildContext {
  /// The shared style in scope, or [SignInButtonStyle.defaults] if none.
  SignInButtonStyle get signInButtonStyle =>
      SignInButtonStyleProvider.maybeOf(this) ?? SignInButtonStyle.defaults;
}
