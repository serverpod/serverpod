import 'package:flutter/material.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

Widget buildIsolatedElementsForStory(
  BuildContext context,
  Map<String, List<Widget>> elements,
) {
  final showTitles = context.knobs.boolean(label: 'Show titles', initial: true);

  final width = context.knobs.sliderInt(
    label: 'Column width',
    initial: 300,
    max: 400,
  );

  final divider = Divider(indent: 0, endIndent: 0);

  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var e in elements.entries) ...[
          divider,
          if (showTitles) Text(e.key),
          SignInWidgetsColumn(
            spacing: 8,
            width: width.toDouble(),
            children: e.value,
          ),
          if (e.key == elements.entries.last.key) divider,
        ],
      ],
    ),
  );
}

extension EnumAsOptionsList<T extends Enum> on Iterable<T> {
  List<Option<T>> asOptions() {
    return map((e) => Option<T>(label: e.name, value: e)).toList();
  }
}
