import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  group('TemplateWidget', () {
    test(
      'Given a template with placeholders when values parameter is passed to constructor then template renders with those values.',
      () async {
        await d.file('template_with_values.html', '''
<h1>Hello {{name}}</h1><p>{{message}}</p>''').create();

        await templates.loadAll(Directory(d.sandbox));

        var widget = TemplateWidget(
          name: 'template_with_values',
          values: {'name': 'World', 'message': 'Welcome!'},
        );

        expect(
          widget.toString(),
          equals('<h1>Hello World</h1><p>Welcome!</p>'),
        );
      },
    );

    test(
      'Given a template with placeholders when partial values are passed then template renders with provided values.',
      () async {
        await d.file('template_partial_values.html', '''
<h1>Hello {{name}}</h1>''').create();

        await templates.loadAll(Directory(d.sandbox));

        var widget = TemplateWidget(
          name: 'template_partial_values',
          values: {'name': 'World'},
        );

        expect(
          widget.toString(),
          equals('<h1>Hello World</h1>'),
        );
      },
    );

    test(
      'Given a template with placeholders when values are modified after construction then template renders with updated values.',
      () async {
        await d.file('template_modified_values.html', '''
<h1>Hello {{name}}</h1><p>{{message}}</p>''').create();

        await templates.loadAll(Directory(d.sandbox));

        var widget = TemplateWidget(
          name: 'template_modified_values',
          values: {'name': 'World', 'message': 'Initial'},
        );

        widget.values['message'] = 'Updated!';

        expect(
          widget.toString(),
          equals('<h1>Hello World</h1><p>Updated!</p>'),
        );
      },
    );

    test(
      'Given a template without placeholders when values parameter is passed then template still renders correctly.',
      () async {
        await d.file('static_content.html', '<p>Static content</p>').create();

        await templates.loadAll(Directory(d.sandbox));

        var widget = TemplateWidget(
          name: 'static_content',
          values: {'unused': 'value'},
        );

        expect(widget.toString(), equals('<p>Static content</p>'));
      },
    );

    test(
      'Given a template without placeholders when no values parameter is passed then template renders correctly.',
      () async {
        await d.file('static_no_values.html', '<p>Static content</p>').create();

        await templates.loadAll(Directory(d.sandbox));

        var widget = TemplateWidget(name: 'static_no_values');

        expect(widget.toString(), equals('<p>Static content</p>'));
      },
    );

    test(
      'Given missing template when TemplateWidget is created with values then StateError is thrown.',
      () async {
        expect(
          () => TemplateWidget(
            name: 'nonexistent_template_for_test',
            values: {'foo': 'bar'},
          ),
          throwsStateError,
        );
      },
    );
  });
}
