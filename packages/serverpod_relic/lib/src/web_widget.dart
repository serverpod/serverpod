import 'package:mustache_template/mustache.dart';
import 'dart:convert';

import 'templates.dart';

abstract class AbstractWidget {}

class Widget extends AbstractWidget {
  final String name;
  late final Template template;
  Map<String, dynamic> values = <String, dynamic>{};

  Widget({
    required this.name,
  }) {
    assert(templates[name] != null,
        'Template $name.html missing for $runtimeType');
    template = templates[name]!;
  }

  @override
  String toString() {
    return template.renderString(values);
  }
}

class WidgetList extends AbstractWidget {
  final List<AbstractWidget> widgets;

  WidgetList({required this.widgets});

  @override
  String toString() {
    List<String> rendered = <String>[];
    for (AbstractWidget widget in widgets) {
      rendered.add(widget.toString());
    }
    return rendered.join('\n');
  }
}

class WidgetJson extends AbstractWidget {
  final dynamic object;

  WidgetJson({required this.object});

  @override
  String toString() {
    return jsonEncode(object);
  }
}

class WidgetRedirect extends AbstractWidget {
  final String url;

  WidgetRedirect({required this.url});

  @override
  String toString() {
    return '';
  }
}
