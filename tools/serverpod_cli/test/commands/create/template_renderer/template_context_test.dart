import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a TemplateContext, '
    'when redis or postgres value is true, '
    'then docker value is true',
    () {
      var context = TemplateContext(redis: true, postgres: false);
      expect(context.docker, isTrue);
      context = TemplateContext(redis: false, postgres: true);
      expect(context.docker, isTrue);
    },
  );

  test(
    'Given a TemplateContext, '
    'when both redis and postgres values are false, '
    'then docker value is false',
    () {
      final context = TemplateContext(redis: false, postgres: false);
      expect(context.docker, isFalse);
    },
  );

  test(
    'Given a TemplateContext, '
    'when sqlite or postgres value is true, '
    'then database value is true',
    () {
      var context = TemplateContext(sqlite: true, postgres: false);
      expect(context.database, isTrue);
      context = TemplateContext(sqlite: false, postgres: true);
      expect(context.database, isTrue);
    },
  );

  test(
    'Given a TemplateContext, '
    'when both sqlite and postgres values are false, '
    'then database value is false',
    () {
      final context = TemplateContext(sqlite: false, postgres: false);
      expect(context.docker, isFalse);
    },
  );

  test(
    'Given a TemplateContext, '
    'when both auth and postgres values are true, '
    'then toMustacheMap returns a map with auth set to true',
    () {
      final context = TemplateContext(postgres: true, auth: true);
      expect(context.toMustacheMap(), containsPair('auth', true));
    },
  );

  test(
    'Given a TemplateContext, '
    'when auth or postgres value is false, '
    'then toMustacheMap returns a map with auth set to false',
    () {
      var context = TemplateContext(postgres: true, auth: false);
      expect(context.toMustacheMap(), containsPair('auth', false));
      context = TemplateContext(postgres: false, auth: true);
      expect(context.toMustacheMap(), containsPair('auth', false));
    },
  );

  test(
    'Given a TemplateContext, '
    'when webapp or website value is true, '
    'then webserver value is true',
    () {
      var context = TemplateContext(webapp: true, website: false);
      expect(context.webserver, isTrue);
      context = TemplateContext(webapp: false, website: true);
      expect(context.webserver, isTrue);
    },
  );

  test(
    'Given a TemplateContext, '
    'when both webapp and website values are false, '
    'then webserver value is false',
    () {
      final context = TemplateContext(webapp: false, website: false);
      expect(context.webserver, isFalse);
    },
  );

  test(
    'Given a TemplateContext, '
    'when toMustacheMap is called, '
    'then a map is returned with correct values',
    () {
      final context = TemplateContext(
        postgres: true,
        auth: true,
        redis: true,
        webapp: true,
        website: true,
        sqlite: true,
        flutterApp: true,
      );
      expect(
        context.toMustacheMap(),
        {
          'auth': true,
          'redis': true,
          'postgres': true,
          'sqlite': true,
          'webapp': true,
          'website': true,
          'webserver': true,
          'docker': true,
          'database': true,
          'flutterApp': true,
        },
      );
    },
  );
}
