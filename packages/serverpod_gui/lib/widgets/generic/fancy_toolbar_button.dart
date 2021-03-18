import 'package:flutter/material.dart';

class FancyToolbarButton extends StatelessWidget {
  final double? width;
  final String? label;
  final IconData icon;
  final Color? color;
  final VoidCallback onPressed;

  FancyToolbarButton({
    required this.icon,
    required this.onPressed,
    this.label,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Widget button;

    button = Icon(
      icon,
      color: color,
      size: 22.0,
    );

    if (label != null) {
      button = Row(
        children: [
          button,
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      );
    }

    return TextButton(
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: button,
      ),
    );
  }
}

class FancyToolbarDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20.0,
      child: VerticalDivider(
        width: 8.0,
        thickness: 1.0,
      ),
    );
  }
}
