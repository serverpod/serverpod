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
    'then toJson returns a map with auth set to true',
    () {
      final context = TemplateContext(postgres: true, auth: true);
      expect(context.toJson(), containsPair('auth', true));
    },
  );

  test(
    'Given a TemplateContext, '
    'when auth or postgres value is false, '
    'then toJson returns a map with auth set to false',
    () {
      var context = TemplateContext(postgres: true, auth: false);
      expect(context.toJson(), containsPair('auth', false));
      context = TemplateContext(postgres: false, auth: true);
      expect(context.toJson(), containsPair('auth', false));
    },
  );

  test(
    'Given a TemplateContext, '
    'when toJson is called, '
    'then a map is returned with correct values',
    () {
      final context = TemplateContext(
        postgres: true,
        auth: true,
        redis: true,
        web: true,
        sqlite: true,
        skills: true,
      );
      expect(
        context.toJson(),
        {
          'auth': true,
          'redis': true,
          'postgres': true,
          'sqlite': true,
          'web': true,
          'docker': true,
          'database': true,
          'skills': true,
        },
      );
    },
  );
}
