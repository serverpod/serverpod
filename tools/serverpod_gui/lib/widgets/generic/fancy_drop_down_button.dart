import 'package:flutter/material.dart';
import 'package:serverpod_gui/widgets/theme/theme_builder.dart';

class FancyDropdownButton<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T value;
  final void Function(T?) onChanged;
  final double width;

  FancyDropdownButton({
    required this.items,
    required this.value,
    required this.onChanged,
    this.width = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).dividerColor;
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        border: Border.all(
          color: borderColor,
          width: 1.0,
        ),
        boxShadow: buildFancyBoxShadow(context),
        color: Theme.of(context).cardColor,
      ),
      padding: EdgeInsets.only(left: 8.0, right: 2.0),
      child: DropdownButton<T>(
        icon: Icon(Icons.keyboard_arrow_down),
        iconSize: 18.0,
        style: Theme.of(context).textTheme.bodyText2,
        items: items,
        value: value,
        onChanged: onChanged,
        underline: SizedBox(),
        isDense: true,
        isExpanded: true,
      ),
    );
  }
}
