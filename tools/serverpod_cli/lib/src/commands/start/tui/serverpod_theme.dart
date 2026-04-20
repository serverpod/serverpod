import 'package:nocterm/nocterm.dart';

/// Serverpod-specific TUI theme colors layered on top of [TuiThemeData].
class ServerpodThemeData {
  const ServerpodThemeData({
    required this.activationKey,
    required this.activeTab,
    required this.spinner,
    required this.debugLevel,
    required this.infoLevel,
    required this.warningLevel,
    required this.errorLevel,
    required this.success,
    required this.failure,
    required this.subtleDivider,
  });

  /// Color for button activation characters (R, M, A, Q).
  final Color activationKey;

  /// Color for the selected tab label.
  final Color activeTab;

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

  /// Derives a [ServerpodThemeData] from a nocterm [TuiThemeData].
  ///
  /// Semantic slots map to the closest [TuiThemeData] role:
  /// log levels/success/failure use `warning`/`error`/`success`, muted
  /// elements (debug, divider) use `outline`/`outlineVariant`, and accents
  /// (active tab, spinner, info) use `primary` while the activation key
  /// uses `secondary` to stand apart from the active-tab color.
  factory ServerpodThemeData.fromTuiTheme(TuiThemeData theme) {
    return ServerpodThemeData(
      activationKey: theme.secondary,
      activeTab: theme.primary,
      spinner: theme.primary,
      debugLevel: theme.outline,
      infoLevel: theme.primary,
      warningLevel: theme.warning,
      errorLevel: theme.error,
      success: theme.success,
      failure: theme.error,
      subtleDivider: theme.outlineVariant,
    );
  }

  /// Default dark theme.
  static const dark = ServerpodThemeData(
    activationKey: Colors.magenta,
    activeTab: Colors.cyan,
    spinner: Colors.cyan,
    debugLevel: Colors.gray,
    infoLevel: Colors.blue,
    warningLevel: Colors.yellow,
    errorLevel: Colors.red,
    success: Colors.green,
    failure: Colors.red,
    subtleDivider: Colors.gray,
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
