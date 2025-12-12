import 'package:flutter/material.dart';

/// A column widget to display sign-in widgets.
///
/// Constraints the width to 400px to match the maximum width of the Google
/// Sign-in web button to ensure design consistency across platforms and with
/// other sign-in providers.
class SignInWidgetsColumn extends StatelessWidget {
  /// The children to display in the column.
  final List<Widget> children;

  /// The width of the column. Defaults to 400px.
  final double width;

  /// The spacing between the children.
  final double spacing;

  /// Creates a sign-in widgets column.
  const SignInWidgetsColumn({
    this.width = 400,
    this.spacing = 0,
    required this.children,
    super.key,
  }) : assert(
         width > 0 && width <= 400,
         'Invalid width. Must be between 0 and 400.',
       );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: width),
          child: Column(
            spacing: spacing,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}
