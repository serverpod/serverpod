import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

export 'package:pinput/pinput.dart' show PinTheme;

/// Theme for the authentication identity provider UI.
@immutable
class AuthIdpTheme extends ThemeExtension<AuthIdpTheme> {
  /// The default pin input theme used for unselected/idle state.
  final PinTheme defaultPinTheme;

  /// The pin input theme used when the field is focused.
  final PinTheme focusedPinTheme;

  /// The pin input theme used to indicate an error state.
  final PinTheme errorPinTheme;

  /// The separator between pin input fields.
  final Widget separator;

  /// Creates a new [AuthIdpTheme].
  ///
  /// All pin themes must be provided. Use [AuthIdpTheme.defaultTheme]
  /// to obtain sensible defaults.
  const AuthIdpTheme({
    required this.defaultPinTheme,
    required this.focusedPinTheme,
    required this.errorPinTheme,
    required this.separator,
  });

  /// Creates a default [AuthIdpTheme] with optional overrides.
  ///
  /// When [colorScheme] is provided, the pin colors are derived from it, so
  /// the fields follow the app's light or dark theme. The [IdpTheme.idpTheme]
  /// accessor passes the color scheme of the current [ThemeData].
  ///
  /// The focused pin uses [borderColor] for its border, falling back to the
  /// primary color of [colorScheme].
  ///
  /// If individual [PinTheme] values are not provided, sensible
  /// defaults will be used.
  factory AuthIdpTheme.defaultTheme({
    ColorScheme? colorScheme,
    Color? borderColor,
    PinTheme? defaultPinTheme,
    PinTheme? focusedPinTheme,
    PinTheme? errorPinTheme,
    Widget? separator,
  }) {
    // All states use the same border width, so the pin content does not shift
    // when the state changes.
    const borderWidth = 2.0;
    final borderRadius = BorderRadius.circular(8);

    defaultPinTheme =
        defaultPinTheme ??
        PinTheme(
          decoration: BoxDecoration(
            color:
                colorScheme?.surfaceContainerHighest ??
                const Color.fromRGBO(222, 231, 240, .57),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.transparent, width: borderWidth),
          ),
        );

    focusedPinTheme =
        focusedPinTheme ??
        defaultPinTheme.copyWith(
          decoration: (defaultPinTheme.decoration ?? const BoxDecoration())
              .copyWith(
                border: Border.all(
                  color: borderColor ?? colorScheme?.primary ?? Colors.black,
                  width: borderWidth,
                ),
              ),
        );

    errorPinTheme =
        errorPinTheme ??
        defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color:
                colorScheme?.errorContainer ??
                const Color.fromRGBO(238, 74, 104, 1),
            borderRadius: borderRadius,
            border: Border.all(
              color: colorScheme?.error ?? Colors.transparent,
              width: borderWidth,
            ),
          ),
        );

    return AuthIdpTheme(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      errorPinTheme: errorPinTheme,
      separator: separator ?? const SizedBox(width: 4),
    );
  }

  @override
  AuthIdpTheme copyWith({
    PinTheme? defaultPinTheme,
    PinTheme? focusedPinTheme,
    PinTheme? errorPinTheme,
    Widget? separator,
  }) {
    return AuthIdpTheme(
      defaultPinTheme: defaultPinTheme ?? this.defaultPinTheme,
      focusedPinTheme: focusedPinTheme ?? this.focusedPinTheme,
      errorPinTheme: errorPinTheme ?? this.errorPinTheme,
      separator: separator ?? this.separator,
    );
  }

  @override
  AuthIdpTheme lerp(ThemeExtension<AuthIdpTheme>? other, double t) {
    if (other is! AuthIdpTheme) return this;
    return t < 0.5 ? this : other;
  }
}

/// Extension on [ThemeData] to provide easy access to the
/// authentication identity provider theme.
extension IdpTheme on ThemeData {
  /// Accessor for the [AuthIdpTheme] stored in [ThemeData].
  ///
  /// When no [AuthIdpTheme] is registered, returns
  /// [AuthIdpTheme.defaultTheme] derived from this theme's [colorScheme].
  ///
  /// Example:
  ///
  /// ```dart
  /// Theme.of(context).idpTheme
  /// ```
  AuthIdpTheme get idpTheme =>
      extension<AuthIdpTheme>() ??
      AuthIdpTheme.defaultTheme(colorScheme: colorScheme);
}
