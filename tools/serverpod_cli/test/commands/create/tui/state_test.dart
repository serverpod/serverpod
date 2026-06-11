import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_tui/serverpod_tui.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given a CreateConfigState, '
    'when converting to template context',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(ServerpodTemplateType.server);
      });

      test(
        'then TemplateContext has correct value for template',
        () {
          var context = state.toTemplateContext();
          expect(context.template, ServerpodTemplateType.server);

          state.form.updateSelectedOption(
            ServerpodCreateConfig.template,
            TemplateTypeOption.module,
          );

          context = state.toTemplateContext();
          expect(context.template, ServerpodTemplateType.module);
        },
      );

      test(
        'and database is enabled (default) then TemplateContext has correct value for postgres',
        () {
          final context = state.toTemplateContext();
          expect(context.postgres, isTrue);
          expect(context.sqlite, isFalse);
        },
      );

      test(
        'and database is disabled then TemplateContext has correct values',
        () {
          // Deselect Database (recommended)
          state.form.updateSelectedOption(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.database,
          );

          final context = state.toTemplateContext();
          expect(context.postgres, isFalse);
          expect(context.sqlite, isFalse);
        },
      );

      test(
        'and redis is enabled then TemplateContext reflects enabled',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.redis,
          );

          final context = state.toTemplateContext();
          expect(context.redis, isTrue);
        },
      );

      test(
        'and redis is not selected then TemplateContext reflects disabled',
        () {
          // By default redis is not selected (only database is default)
          final context = state.toTemplateContext();
          expect(context.redis, isFalse);
        },
      );

      test('and web is set to app only (default) then web is disabled', () {
        final context = state.toTemplateContext();
        expect(context.web, isFalse);
      });

      test('and web is set to app and website then web is enabled', () {
        state.form.updateSelectedOption(
          ServerpodCreateConfig.webserver,
          WebServerConfigOption.appAndWebsite,
        );

        final context = state.toTemplateContext();
        expect(context.web, isTrue);
      });

      test('and web is set to none then web is disabled', () {
        state.form.updateSelectedOption(
          ServerpodCreateConfig.webserver,
          WebServerConfigOption.none,
        );

        final context = state.toTemplateContext();
        expect(context.web, isFalse);
      });

      test(
        'and auth is enabled with server template, '
        'then TemplateContext has the correct value for auth',
        () {
          var context = state.toTemplateContext();
          // True by default
          expect(context.auth, isTrue);
        },
      );

      test(
        'and auth is disabled then TemplateContext reflects disabled',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.auth,
            BoolFormConfigOption.disabled,
          );

          final context = state.toTemplateContext();
          expect(context.auth, isFalse);
        },
      );

      test(
        'and ides are selected then TemplateContext contains ides',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.ide,
            IdeOption.antigravity,
          );
          state.form.updateSelectedOption(
            ServerpodCreateConfig.ide,
            IdeOption.vsCode,
          );

          final context = state.toTemplateContext();
          expect(
            context.ides,
            containsAll([TemplateIde.antigravity, TemplateIde.vscode]),
          );
        },
      );
    },
  );

  group(
    'Given a CreateConfigState exposing only the ide config with default values for the other configs, '
    'when converting to template context',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(
          ServerpodTemplateType.server,
          configs: const [ServerpodCreateConfig.ide],
          defaults: TemplateContext(postgres: true, web: true),
        );
      });

      test(
        'then TemplateContext has the default values for configs not exposed in the form',
        () {
          final context = state.toTemplateContext();
          expect(context.postgres, isTrue);
          expect(context.web, isTrue);
          expect(context.auth, isFalse);
          expect(context.redis, isFalse);
          expect(context.sqlite, isFalse);
        },
      );

      test(
        'then TemplateContext has the starting template',
        () {
          final context = state.toTemplateContext();
          expect(context.template, ServerpodTemplateType.server);
        },
      );
    },
  );

  group(
    'Given a CreateConfigState exposing only the ide config with an ide selected, '
    'when converting to template context',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(
          ServerpodTemplateType.server,
          configs: const [ServerpodCreateConfig.ide],
        );
        state.form.updateSelectedOption(
          ServerpodCreateConfig.ide,
          IdeOption.claude,
        );
      });

      test(
        'then TemplateContext contains the selected ide',
        () {
          final context = state.toTemplateContext();
          expect(context.ides, [TemplateIde.claude]);
        },
      );
    },
  );

  group(
    'Given a CreateConfigState with all configs '
    'and default values for the constrainable configs, '
    'when a config is hidden by an unsatisfied requirement',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(
          ServerpodTemplateType.server,
        );
        state.form.updateSelectedOption(
          ServerpodCreateConfig.template,
          TemplateTypeOption.module,
        );
      });

      test(
        'then database, web, and auth configs are hidden '
        'for module template',
        () {
          final configs = state.form.configurations;
          expect(configs, isNot(contains(ServerpodCreateConfig.database)));
          expect(configs, isNot(contains(ServerpodCreateConfig.webserver)));
          expect(configs, isNot(contains(ServerpodCreateConfig.auth)));
          expect(configs, contains(ServerpodCreateConfig.template));
          expect(configs, contains(ServerpodCreateConfig.ide));
        },
      );

      test(
        'then hidden configs resolve to false in TemplateContext',
        () {
          final context = state.toTemplateContext();
          expect(context.web, isFalse);
          expect(context.auth, isFalse);
        },
      );
    },
  );

  group(
    'Given a CreateConfigState with module template, '
    'when checking screen navigation',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(
          ServerpodTemplateType.module,
        );
      });

      test(
        'then initially on screen 0',
        () {
          expect(state.currentScreenIndex, 0);
        },
      );

      test(
        'then nextScreen advances to next config',
        () {
          state.nextScreen();
          expect(state.currentScreenIndex, 1);
        },
      );

      test(
        'then previousScreen goes back',
        () {
          state.nextScreen();
          state.previousScreen();
          expect(state.currentScreenIndex, 0);
        },
      );

      test(
        'then configScreenCount is less because some configs are hidden for module',
        () {
          // For module: template and ide are visible (database/web/auth hidden)
          expect(state.configScreenCount, 2);
        },
      );

      test(
        'then isSummary is true when past last config screen',
        () {
          state.nextScreen();
          state.nextScreen();
          expect(state.isSummary, isTrue);
        },
      );
    },
  );

  group(
    'Given a CreateConfigState that requires an ide selection',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(
          ServerpodTemplateType.server,
          configs: const [ServerpodCreateConfig.ide],
          requireIde: true,
        );
      });

      test(
        'when no ide is selected then the project can not be created',
        () {
          expect(state.canCreate, isFalse);
        },
      );

      test(
        'when an ide is selected then the project can be created',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.ide,
            IdeOption.vsCode,
          );

          expect(state.canCreate, isTrue);
        },
      );

      test(
        'when the only selected ide is deselected '
        'then the project can not be created',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.ide,
            IdeOption.vsCode,
          );
          state.form.updateSelectedOption(
            ServerpodCreateConfig.ide,
            IdeOption.vsCode,
          );

          expect(state.canCreate, isFalse);
        },
      );
    },
  );

  group(
    'Given a CreateConfigState that does not require an ide selection',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(ServerpodTemplateType.server);
      });

      test(
        'when no ide is selected then the project can be created',
        () {
          expect(state.canCreate, isTrue);
        },
      );
    },
  );
}
