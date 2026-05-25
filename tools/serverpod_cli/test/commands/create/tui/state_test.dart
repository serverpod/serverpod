import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/ide.dart';
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
}
