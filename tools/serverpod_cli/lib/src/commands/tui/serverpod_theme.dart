import 'package:nocterm/nocterm.dart';

const _serverpodBlue = Color.fromRGB(147, 197, 253);
const _highlightDark = Color(0xff3b3937);
const _highlightLight = Color(0xffedeae6);

/// Serverpod-specific TUI theme colors layered on top of [TuiThemeData].
class ServerpodThemeData {
  const ServerpodThemeData({
    required this.primary,
    required this.activationKey,
    required this.spinner,
    required this.debugLevel,
    required this.infoLevel,
    required this.warningLevel,
    required this.errorLevel,
    required this.success,
    required this.failure,
    required this.subtleDivider,
    required this.brightText,
    required this.highlight,
  });

  ServerpodThemeData copyWith({
    Color? primary,
    Color? activationKey,
    Color? spinner,
    Color? debugLevel,
    Color? infoLevel,
    Color? warningLevel,
    Color? errorLevel,
    Color? success,
    Color? failure,
    Color? subtleDivider,
    Color? brightText,
    Color? highlight,
  }) {
    return ServerpodThemeData(
      primary: primary ?? this.primary,
      activationKey: activationKey ?? this.activationKey,
      spinner: spinner ?? this.spinner,
      debugLevel: debugLevel ?? this.debugLevel,
      infoLevel: infoLevel ?? this.infoLevel,
      warningLevel: warningLevel ?? this.warningLevel,
      errorLevel: errorLevel ?? this.errorLevel,
      success: success ?? this.success,
      failure: failure ?? this.failure,
      subtleDivider: subtleDivider ?? this.subtleDivider,
      brightText: brightText ?? this.brightText,
      highlight: highlight ?? this.highlight,
    );
  }

  /// Primary color;
  final Color primary;

  /// Color for button activation characters (R, M, A, Q).
  final Color activationKey;

  /// Color for the spinning progress indicator.
  final Color spinner;

  /// Log level colors.
  final Color debugLevel;
  final Color infoLevel;
  final Color warningLevel;
  final Color errorLevel;

  /// Tracked operation outcome colors.
  final Color success;
  final Color failure;

  /// Trailing divider on completed operations.
  final Color subtleDivider;

  /// Color for bright texts.
  final Color brightText;

  /// Color for highlighted elements.
  final Color highlight;

  /// Derives a [ServerpodThemeData] from a nocterm [TuiThemeData].
  ///
  /// Semantic slots map to the closest [TuiThemeData] role:
  /// log levels/success/failure use `warning`/`error`/`success`, muted
  /// elements (debug, divider) use `outline`/`outlineVariant`, and accents
  /// (active tab, spinner, info) use `primary` while the activation key
  /// uses `secondary` to stand apart from the active-tab color.
  factory ServerpodThemeData.fromTuiTheme(TuiThemeData theme) {
    final darkThemed = theme.brightness == Brightness.dark;
    return ServerpodThemeData(
      primary: _serverpodBlue,
      activationKey: Colors.magenta,
      spinner: _serverpodBlue,
      debugLevel: theme.outline,
      infoLevel: theme.primary,
      warningLevel: theme.warning,
      errorLevel: theme.error,
      success: theme.success,
      failure: theme.error,
      subtleDivider: theme.outlineVariant,
      brightText: darkThemed ? Colors.brightWhite : Colors.brightBlack,
      highlight: darkThemed ? _highlightDark : _highlightLight,
    );
  }

  /// Default dark theme.
  static const dark = ServerpodThemeData(
    primary: _serverpodBlue,
    activationKey: Colors.magenta,
    spinner: _serverpodBlue,
    debugLevel: Colors.gray,
    infoLevel: Colors.blue,
    warningLevel: Colors.yellow,
    errorLevel: Colors.red,
    success: Colors.green,
    failure: Colors.red,
    subtleDivider: Colors.gray,
    brightText: Colors.brightWhite,
    highlight: _highlightDark,
  );
}

/// Provides [ServerpodThemeData] to the widget tree.
class ServerpodTheme extends InheritedComponent {
  const ServerpodTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final ServerpodThemeData data;

  static ServerpodThemeData of(BuildContext context) {
    final widget = context
        .dependOnInheritedComponentOfExactType<ServerpodTheme>();
    if (widget != null) return widget.data;
    final tuiTheme = TuiTheme.maybeOf(context);
    if (tuiTheme != null) return ServerpodThemeData.fromTuiTheme(tuiTheme);
    return ServerpodThemeData.dark;
  }

  @override
  bool updateShouldNotify(ServerpodTheme oldComponent) =>
      data != oldComponent.data;
}
