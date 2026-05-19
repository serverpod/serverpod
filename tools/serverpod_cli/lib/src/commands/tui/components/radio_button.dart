import 'package:nocterm/nocterm.dart';

/// A radio button component.
class RadioButton extends StatelessComponent {
  const RadioButton({
    required this.label,
    required this.value,
    this.focused = false,
  });

  final bool value;
  final String label;
  final bool focused;

  @override
  Component build(BuildContext context) {
    final indicator = value ? '◉' : '○';

    return Text(
      '$indicator $label',
      style: TextStyle(color: Color.defaultColor, reverse: focused),
    );
  }
}
