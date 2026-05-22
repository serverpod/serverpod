import 'dart:io';

import 'package:nocterm/nocterm.dart';

/// A check box component
class Checkbox extends StatelessComponent {
  const Checkbox({
    super.key,
    required this.label,
    required this.value,
    this.focused = false,
  });

  final String label;
  final bool value;
  final bool focused;

  String get indicator {
    if (Platform.isWindows || Platform.isLinux) {
      return value ? '🞕' : '🞎';
    }
    return value ? '■' : '□';
  }

  @override
  Component build(BuildContext context) {
    return Text(
      '$indicator $label',
      style: TextStyle(color: Color.defaultColor, reverse: focused),
    );
  }
}
