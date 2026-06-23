import 'package:flutter/widgets.dart';

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

/// Styling shared by every sign-in button.
///
/// Pass this to [SignInWidget] to style all provider buttons at once instead of
/// configuring each widget. Each field is a default that an individual provider
/// widget can still override; `null` means "leave it to the widget". A button
/// resolves each property as: widget argument, then this style, then its own
/// default.
///
/// Apple is drawn by its native button and only follows the layout fields
/// ([size], [shape], [logoAlignment], [text], [minimumWidth]) — see [textStyle].
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

  /// Creates a shared button style. Unset fields fall through to each widget.
  const SignInButtonStyle({
    this.size,
    this.shape,
    this.logoAlignment,
    this.text,
    this.minimumWidth,
    this.textStyle,
  }) : assert(
         minimumWidth == null || (minimumWidth > 0 && minimumWidth <= 400),
         'Invalid minimumWidth. Must be between 0 and 400.',
       );

  /// A style that overrides nothing.
  static const defaults = SignInButtonStyle();

  /// Returns a copy with the given fields replaced.
  SignInButtonStyle copyWith({
    SignInButtonSize? size,
    SignInButtonShape? shape,
    SignInButtonLogoAlignment? logoAlignment,
    SignInButtonTextVariant? text,
    double? minimumWidth,
    TextStyle? textStyle,
  }) {
    return SignInButtonStyle(
      size: size ?? this.size,
      shape: shape ?? this.shape,
      logoAlignment: logoAlignment ?? this.logoAlignment,
      text: text ?? this.text,
      minimumWidth: minimumWidth ?? this.minimumWidth,
      textStyle: textStyle ?? this.textStyle,
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
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => Object.hash(
    size,
    shape,
    logoAlignment,
    text,
    minimumWidth,
    textStyle,
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
