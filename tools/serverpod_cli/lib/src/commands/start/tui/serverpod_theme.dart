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
    return widget?.data ?? ServerpodThemeData.dark;
  }

  @override
  bool updateShouldNotify(ServerpodTheme oldComponent) =>
      data != oldComponent.data;
}
