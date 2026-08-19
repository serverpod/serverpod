import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  group('WebWidget', () {
    test(
      'Given a template with variables, '
      'when render is called with onMissingVariable callback, '
      'then missing variables are delegated to the callback',
      () async {
        await d.file('template_missing_var.html', '''
<h1>Hello {{name}}</h1><p>{{missing}}</p>''').create();

        await templates.loadAll(Directory(d.sandbox));

        final widget = TemplateWidget(
          name: 'template_missing_var',
          values: {'name': 'World'},
        );

        final missingVars = <String>[];
        final output = widget.render(
          onMissingVariable: (name) {
            missingVars.add(name);
            return 'fallback:$name';
          },
        );

        expect(output, '<h1>Hello World</h1><p>fallback:missing</p>');
        expect(missingVars, ['missing']);
      },
    );

    test(
      'Given a ListWidget with multiple templates, '
      'when render is called with onMissingVariable, '
      'then the callback is forwarded to individual templates',
      () async {
        await d.file('1.html', '<p>{{value}}</p>').create();
        await d.file('2.html', '<span>{{value}}</span>').create();

        await templates.loadAll(Directory(d.sandbox));

        final missingVars = <String>[];
        final child1 = TemplateWidget(name: '1', values: {'value': 'hello'});
        final child2 = TemplateWidget(name: '2', values: {});
        final listWidget = ListWidget(widgets: [child1, child2]);

        final output = listWidget.render(
          onMissingVariable: (name) {
            missingVars.add(name);
            return 'fallback';
          },
        );

        expect(output, '<p>hello</p>\n<span>fallback</span>');
        expect(missingVars, ['value']);
      },
    );

    test(
      'Given a JsonWidget, when render is called with onMissingVariable, '
      'then the callback is not invoked',
      () {
        final widget = JsonWidget(object: {'key': '{{value}}'});

        final output = widget.render(
          onMissingVariable: (name) => 'SHOULD_NOT_APPEAR',
        );

        expect(output, contains('"key"'));
        expect(output, contains('"{{value}}"'));
      },
    );

    test(
      'Given a RedirectWidget, when render is called with onMissingVariable, '
      'then empty string is returned',
      () {
        final widget = RedirectWidget(url: '/redirected');

        final output = widget.render(
          onMissingVariable: (name) => 'SHOULD_NOT_APPEAR',
        );

        expect(output, '');
      },
    );

    test(
      'Given a template with a variable, '
      'when render is called without onMissingVariable, '
      'then missing variables are rendered as empty strings',
      () async {
        await d.file('template_no_callback.html', '''
<h1>Hello {{name}}</h1><p>{{missing}}</p>''').create();

        await templates.loadAll(Directory(d.sandbox));

        final widget = TemplateWidget(
          name: 'template_no_callback',
          values: {'name': 'World'},
        );

        final output = widget.render();

        expect(output, '<h1>Hello World</h1><p></p>');
      },
    );
  });
}
