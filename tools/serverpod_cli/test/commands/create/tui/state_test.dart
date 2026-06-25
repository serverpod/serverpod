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
        'then TemplateContext has the correct default value for auth',
        () {
          final context = state.toTemplateContext();
          expect(context.auth, isTrue);
        },
      );

      test(
        'when database is selected (default),'
        'then postgres is enabled in TemplateContext',
        () {
          final context = state.toTemplateContext();
          expect(context.postgres, isTrue);
        },
      );

      test(
        'when database is selected,'
        'then postgres is disabled in TemplateContext',
        () {
          // Deselect to disable
          state.form.updateSelectedOption(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.database,
          );

          final context = state.toTemplateContext();
          expect(context.postgres, isFalse);
        },
      );

      test(
        'when redis is not selected (default),'
        'then redis is disabled in TemplateContext',
        () {
          // By default redis is not selected
          final context = state.toTemplateContext();
          expect(context.redis, isFalse);
        },
      );

      test(
        'when redis is selected,'
        'then redis is enabled in TemplateContext',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.redis,
          );

          final context = state.toTemplateContext();
          expect(context.redis, isTrue);
        },
      );

      group(
        'when WebServerConfigOption is set to app only (default)',
        () {
          late TemplateContext context;
          setUp(() {
            context = state.toTemplateContext();
          });

          test('then webapp is enabled', () {
            expect(context.webapp, isTrue);
          });

          test('then website is disabled', () {
            expect(context.website, isFalse);
          });

          test('then webserver is enabled', () {
            expect(context.webserver, isTrue);
          });
        },
      );

      test(
        'when WebServerConfigOption is set to app and website,'
        'then webapp, website and webserver are all enabled',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.webserver,
            WebServerConfigOption.appAndWebsite,
          );
          final context = state.toTemplateContext();
          expect(context.webapp, isTrue);
          expect(context.website, isTrue);
          expect(context.webserver, isTrue);
        },
      );

      test(
        'when WebServerConfigOption is set to none,'
        'then webapp, website and webserver are all disabled',
        () {
          state.form.updateSelectedOption(
            ServerpodCreateConfig.webserver,
            WebServerConfigOption.none,
          );
          final context = state.toTemplateContext();
          expect(context.webapp, isFalse);
          expect(context.website, isFalse);
          expect(context.webserver, isFalse);
        },
      );

      test(
        'when auth is disabled then TemplateContext reflects disabled',
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
        'when ides are selected then TemplateContext contains ides',
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
          defaults: TemplateContext(postgres: true, webapp: true),
        );
      });

      test(
        'then TemplateContext has the default values for configs not exposed in the form',
        () {
          final context = state.toTemplateContext();
          expect(context.postgres, isTrue);
          expect(context.webapp, isTrue);
          expect(context.webserver, isTrue);
          expect(context.website, isFalse);
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
        state = CreateConfigState(ServerpodTemplateType.module);
      });

      test(
        'then webserver and auth configs are hidden '
        'for module template',
        () {
          final configs = state.form.configurations;
          expect(configs, isNot(contains(ServerpodCreateConfig.auth)));
          expect(configs, isNot(contains(ServerpodCreateConfig.webserver)));
          expect(configs, contains(ServerpodCreateConfig.database));
          expect(configs, contains(ServerpodCreateConfig.ide));
          expect(configs, contains(ServerpodCreateConfig.template));
        },
      );

      test(
        'then hidden configs resolve to false in TemplateContext',
        () {
          final context = state.toTemplateContext();
          expect(context.webapp, isFalse);
          expect(context.website, isFalse);
          expect(context.webserver, isFalse);
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

  group(
    'Given a CreateConfigState with all configs except ServerpodCreateConfig.template',
    () {
      late CreateConfigState state;

      setUp(() {
        final configs = ServerpodCreateConfig.values.toList()
          ..removeWhere((e) => e == ServerpodCreateConfig.template);
        state = CreateConfigState(
          ServerpodTemplateType.module,
          configs: configs,
        );
      });

      test(
        'when getting selected option for ServerpodCreateConfig.template, '
        'then startingTemplate option is returned',
        () {
          expect(
            state.form.getSelectedOptionFor(ServerpodCreateConfig.template),
            TemplateTypeOption.module,
          );
        },
      );

      test(
        'when converting to template context, '
        'then startingTemplate is set in the context for template field',
        () {
          final context = state.toTemplateContext();
          expect(context.template, ServerpodTemplateType.module);
        },
      );
    },
  );
}
