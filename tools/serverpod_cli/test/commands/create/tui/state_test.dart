import 'package:serverpod_cli/src/commands/create/tui/config.dart';
import 'package:serverpod_cli/src/commands/create/tui/state.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given a CreateConfigState with module template',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(ServerpodTemplateType.module);
      });

      test('when created then defaults are correct', () {
        expect(state.focusedConfigIndex, 0);
        expect(state.creatingProject, false);
        expect(
          state.configValues,
          containsAll([
            ServerpodCreateConfig.template,
            ServerpodCreateConfig.database,
            ServerpodCreateConfig.redis,
            ServerpodCreateConfig.ide,
          ]),
        );
        expect(
          state.getStateFor(ServerpodCreateConfig.database)?.focusedOptionIndex,
          0,
        );
        expect(
          state.getStateFor(ServerpodCreateConfig.redis)?.focusedOptionIndex,
          0,
        );
      });

      test(
        'then toTemplateContext creates TemplateContext with defaults',
        () {
          final context = state.toTemplateContext();
          expect(context.auth, isFalse);
          expect(context.redis, isTrue);
          expect(context.postgres, isTrue);
          expect(context.sqlite, isFalse);
          expect(context.web, isFalse);
        },
      );

      test(
        'then the module config option is selected for template config',
        () {
          final selected = state.getSelectedOptionFor<TemplateTypeOption>(
            ServerpodCreateConfig.template,
          );

          expect(selected, TemplateTypeOption.module);
        },
      );
    },
  );

  group(
    'Given a CreateConfigState with server template',
    () {
      late CreateConfigState state;

      setUp(() {
        state = CreateConfigState(ServerpodTemplateType.server);
      });

      test('when created then defaults are correct', () {
        expect(state.focusedConfigIndex, 0);
        expect(state.creatingProject, false);

        expect(
          state.getStateFor(ServerpodCreateConfig.database)?.focusedOptionIndex,
          0,
        );
        expect(
          state.getStateFor(ServerpodCreateConfig.redis)?.focusedOptionIndex,
          0,
        );
        expect(
          state.getStateFor(ServerpodCreateConfig.web)?.focusedOptionIndex,
          0,
        );
        expect(
          state.getStateFor(ServerpodCreateConfig.auth)?.focusedOptionIndex,
          0,
        );
        expect(
          state.getStateFor(ServerpodCreateConfig.ide)?.focusedOptionIndex,
          -1,
        );
      });

      test(
        'then the server config option is selected for template config',
        () {
          final selected = state.getSelectedOptionFor<TemplateTypeOption>(
            ServerpodCreateConfig.template,
          );

          expect(selected, TemplateTypeOption.server);
        },
      );

      test(
        'then the config values are correct',
        () {
          expect(
            state.configValues,
            containsAllInOrder([
              ServerpodCreateConfig.template,
              ServerpodCreateConfig.database,
              ServerpodCreateConfig.redis,
              ServerpodCreateConfig.web,
              ServerpodCreateConfig.auth,
              ServerpodCreateConfig.ide,
            ]),
          );
        },
      );

      test(
        'when the template option is changed to module, '
        'then the config values are correct',
        () {
          state.selectConfigOption(1);

          expect(
            state.configValues,
            containsAllInOrder([
              ServerpodCreateConfig.template,
              ServerpodCreateConfig.database,
              ServerpodCreateConfig.redis,
              ServerpodCreateConfig.ide,
            ]),
          );
        },
      );

      test(
        'then toTemplateContext creates TemplateContext with defaults',
        () {
          final context = state.toTemplateContext();
          expect(context.auth, isTrue);
          expect(context.redis, isTrue);
          expect(context.postgres, isTrue);
          expect(context.sqlite, isFalse);
          expect(context.web, isTrue);
        },
      );

      test(
        'when updating the focused config with positive delta, '
        'then the focused config index is incremented',
        () {
          state.updateFocusedConfig(1);
          expect(state.focusedConfigIndex, 1);
        },
      );

      test(
        'when updating the focused config with positive delta '
        'and the current focused config index is the maximum index,'
        'then the focused config index wraps to 0',
        () {
          for (var i = 0; i < state.configValues.length; i++) {
            state.updateFocusedConfig(1);
          }
          expect(state.focusedConfigIndex, 0);
        },
      );

      test(
        'when updating the focused config with negative delta, '
        'then the focused config index is decremented',
        () {
          state.updateFocusedConfig(1);
          state.updateFocusedConfig(-1);
          expect(state.focusedConfigIndex, 0);
        },
      );

      test(
        'when updating the focused config with negative delta, '
        'and the current focused config index is 0,'
        'then the focused config index wraps to the max config index',
        () {
          state.updateFocusedConfig(-1);
          expect(state.focusedConfigIndex, state.maxFocusedConfigIndex);
        },
      );

      group(
        'when selecting focused config option with positive delta',
        () {
          group(
            'then the focused config option',
            () {
              late ServerpodCreateConfig config;
              late ServerpodCreateConfigState? configState;
              int initialFocusedOptionIndex = 0;

              setUp(() {
                config = state.configValues[state.focusedConfigIndex];
                configState = state.getStateFor(config);

                initialFocusedOptionIndex = configState!.focusedOptionIndex;
                state.selectConfigOption(1);
              });

              test('is incremented', () {
                expect(
                  configState?.focusedOptionIndex,
                  initialFocusedOptionIndex + 1,
                );
              });

              test('is selected', () {
                final expectedOption =
                    config.options[initialFocusedOptionIndex + 1];

                expect(
                  state.getSelectedOptionFor(config),
                  expectedOption,
                );
              });
            },
          );

          test(
            'and the current focused config option index is the max, '
            'then the focused config option index wraps to 0',
            () {
              final config = state.configValues[state.focusedConfigIndex];
              final optionsCount = config.options.length;

              for (var i = 0; i < optionsCount; i++) {
                state.selectConfigOption(1);
              }

              final configState = state.getStateFor(config);
              expect(configState!.focusedOptionIndex, 0);
            },
          );
        },
      );

      group(
        'when updating the focused config option with negative delta',
        () {
          group(
            'then the focused config option',
            () {
              late ServerpodCreateConfig config;
              late ServerpodCreateConfigState? configState;
              int indexAfterPositive = 0;

              setUp(() {
                config = state.configValues[state.focusedConfigIndex];
                state.selectConfigOption(1);
                configState = state.getStateFor(config);
                indexAfterPositive = configState!.focusedOptionIndex;
                state.selectConfigOption(-1);
                configState = state.getStateFor(config);
              });

              test(
                'is decremented',
                () {
                  expect(
                    configState?.focusedOptionIndex,
                    indexAfterPositive - 1,
                  );
                },
              );

              test('is selected', () {
                final expectedOption = config.options[indexAfterPositive - 1];

                expect(
                  state.getSelectedOptionFor(config),
                  expectedOption,
                );
              });
            },
          );

          test(
            'and the current focused config option index is 0, '
            'then the focused config option index wraps to the max config option index',
            () {
              final config = state.configValues[state.focusedConfigIndex];
              final configState = state.getStateFor(config);
              state.selectConfigOption(-1);
              expect(
                configState!.focusedOptionIndex,
                config.options.length - 1,
              );
            },
          );
        },
      );

      test(
        'then getStatus returns true for option that is selected for a config',
        () {
          final status = state.getStatus(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.postgres,
          );

          expect(status, isTrue);
        },
      );

      test(
        'then getStatus returns false for option that is not selected for a config',
        () {
          final status = state.getStatus(
            ServerpodCreateConfig.database,
            DatabaseConfigOption.sqlite,
          );

          expect(status, isFalse);
        },
      );

      test('then getStateFor returns the config state for a config', () {
        final configState = state.getStateFor(ServerpodCreateConfig.database);
        expect(configState, isNotNull);
        expect(configState!.config, ServerpodCreateConfig.database);
        expect(configState.focusedOptionIndex, 0);
      });

      test(
        'when selecting non-postgres database config option, '
        'then config requirements are evaluated for auth config',
        () {
          // Move to database config
          state.updateFocusedConfig(1);

          // Enabled by default
          var authSelection = state.getSelectedOptionFor<BoolConfigOption>(
            ServerpodCreateConfig.auth,
          );

          expect(authSelection, BoolConfigOption.enabled);

          // Select DatabaseConfigOption.none
          state.selectConfigOption(1);
          state.selectConfigOption(1);

          authSelection = state.getSelectedOptionFor<BoolConfigOption>(
            ServerpodCreateConfig.auth,
          );
          expect(authSelection, isNull);
        },
      );

      group(
        'Given a non-postgres database config option is selected',
        () {
          setUp(() {
            // Move to database config
            state.updateFocusedConfig(1);

            // Select DatabaseConfigOption.none
            state.selectConfigOption(1);
            state.selectConfigOption(1);
          });

          test(
            'then auth config option is null',
            () {
              final selected = state.getSelectedOptionFor<BoolConfigOption>(
                ServerpodCreateConfig.auth,
              );

              expect(selected, isNull);
            },
          );
        },
      );

      group('when converting to template context', () {
        test(
          'and database is sqlite then TemplateContext has correct value for sqlite',
          () {
            // Move to database config
            state.updateFocusedConfig(1);
            // Select DatabaseConfigOption.sqlite config option
            state.selectConfigOption(1);

            final context = state.toTemplateContext();
            expect(context.postgres, isFalse);
            expect(context.sqlite, isTrue);
          },
        );

        test(
          'and database is none then TemplateContext '
          'has correct values for postgres, sqlite and auth',
          () {
            // Move to database config
            state.updateFocusedConfig(1);
            // Select DatabaseConfigOption.none config option
            state.selectConfigOption(2);

            final context = state.toTemplateContext();
            expect(context.postgres, isFalse);
            expect(context.sqlite, isFalse);
            expect(context.auth, isFalse);
          },
        );

        test(
          'and redis is disabled then TemplateContext reflects disabled',
          () {
            // Move focus to redis config
            state.updateFocusedConfig(2);
            // Select disabled config option
            state.selectConfigOption(1);

            final context = state.toTemplateContext();
            expect(context.redis, isFalse);
          },
        );

        test('and web is disabled then TemplateContext reflects disabled', () {
          // Move focus to web config
          state.updateFocusedConfig(3);
          // Select disabled config option
          state.selectConfigOption(1);

          final context = state.toTemplateContext();
          expect(context.web, isFalse);
        });

        test(
          'with database set to postgres and auth enabled, '
          'then TemplateContext has the correct value for auth',
          () {
            var context = state.toTemplateContext();
            // True by default
            expect(context.auth, isTrue);

            // Move to database config
            state.updateFocusedConfig(1);
            // Select DatabaseConfigOption.sqlite config option
            state.selectConfigOption(1);

            context = state.toTemplateContext();
            // False for sqlite
            expect(context.auth, isFalse);

            // Select DatabaseConfigOption.postgres config option
            state.selectConfigOption(-1);

            context = state.toTemplateContext();
            expect(context.auth, isTrue);
          },
        );
      });
    },
  );
}
