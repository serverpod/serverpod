import 'package:flutter/material.dart';
import 'package:serverpod_gui/widgets/theme/theme_builder.dart';

class FancyCheckbox extends StatefulWidget {
  bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final size;
  final double cornerRadius;

  FancyCheckbox({
    required this.value,
    this.onChanged,
    this.label,
    this.size = 16.0,
    this.cornerRadius = 4.0,
  });

  @override
  _FancyCheckboxState createState() => _FancyCheckboxState();
}

class _FancyCheckboxState extends State<FancyCheckbox> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    Widget visual;
    if (widget.value) {
      var color = Theme.of(context).indicatorColor;
      if (_pressed)
        color = Color.lerp(color, Colors.black, 0.2)!;

      visual = Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.cornerRadius)),
          color: color,
          boxShadow: buildFancyBoxShadow(context),
        ),
        child: Icon(
          Icons.check,
          size: widget.size,
          color: Theme.of(context).cardColor,
        ),
      );
    }
    else {
      var color = Theme.of(context).cardColor;
      if (_pressed)
        color = Color.lerp(color, Colors.black, 0.2)!;

      visual = Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.cornerRadius)),
          color: color,
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
          boxShadow: buildFancyBoxShadow(context),
        ),
      );
    }

    if (widget.label != null) {
      visual = Row(
        children: [
          visual,
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              widget.label!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      );
    }

    if (widget.onChanged == null)
      return visual;

    return GestureDetector(
      onTap: () {
        widget.onChanged!(!widget.value);
      },
      onTapDown: (_) {
        setState(() {
          _pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          _pressed = false;
        });
      },
      onTapUp: (_) {
        setState(() {
          _pressed = false;
        });
      },
      child: visual,
    );
  }
}
