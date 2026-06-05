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
        'and database is postgres (default) then TemplateContext has correct value for postgres',
        () {
          final context = state.toTemplateContext();
          expect(context.postgres, isTrue);
        },
      );

      test(
        'and database is sqlite then TemplateContext has correct value for sqlite',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.sqlite,
          );

          final context = state.toTemplateContext();
          expect(context.postgres, isFalse);
          expect(context.sqlite, isTrue);
        },
      );

      test(
        'and database is disabled then TemplateContext '
        'has correct values for postgres, sqlite and auth',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.none,
          );

          final context = state.toTemplateContext();
          expect(context.postgres, isFalse);
          expect(context.sqlite, isFalse);
          expect(context.auth, isFalse);
        },
      );

      test(
        'and redis is disabled then TemplateContext reflects disabled',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.redis,
            BoolFormConfigOption.disabled,
          );

          final context = state.toTemplateContext();
          expect(context.redis, isFalse);
        },
      );

      test('and web is disabled then TemplateContext reflects disabled', () {
        state.form.updateSelectedOption(
          ServerpodCreateConfig.web,
          BoolFormConfigOption.disabled,
        );

        final context = state.toTemplateContext();
        expect(context.web, isFalse);
      });

      test(
        'and database is set to postgres with auth enabled, '
        'then TemplateContext has the correct value for auth',
        () {
          var context = state.toTemplateContext();
          // True by default
          expect(context.auth, isTrue);

          // Move to database config
          state.form.updateFocusedConfig(1);
          // Select DatabaseConfigOption.sqlite config option
          state.form.updateFocusedConfigOption(1);
          state.form.selectConfigOption();

          context = state.toTemplateContext();
          // False for sqlite
          expect(context.auth, isFalse);

          // Select DatabaseConfigOption.postgres config option
          state.form.updateFocusedConfigOption(-1);
          state.form.selectConfigOption();

          context = state.toTemplateContext();
          expect(context.auth, isTrue);
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
          defaults: TemplateContext(auth: true, web: true),
        );
        state.form.updateSelectedOption(
          ServerpodCreateConfig.template,
          TemplateTypeOption.module,
        );
      });

      test(
        'then TemplateContext resolves the hidden config from the form '
        'and not from the default values',
        () {
          final context = state.toTemplateContext();
          expect(context.web, isFalse);
          expect(context.auth, isFalse);
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
