import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  group('Database and api keyword tests', () {
    test(
      'Given a class with a field with two database keywords, then collect an error that only one database is allowed.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String?, database, database
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(error.message,
            'The field option "database" is defined more than once.');
      },
    );

    test(
      'Given a class with a field with two api keywords, then collect an error that only one api is allowed.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String?, api, api
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
            error.message, 'The field option "api" is defined more than once.');
      },
    );

    test(
      'Given a class with a field with a negated api keyword, then the generated model should be persisted.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String, !api
            ''',
          ).build(),
        ];

        StatefulAnalyzer analyzer = StatefulAnalyzer(config, models);
        var definitions = analyzer.validateAll();
        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fields.last.shouldPersist,
          isTrue,
        );
      },
    );

    test(
      'Given a class with a field with a negated database keyword, then the generated model has the scope all.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String, !database
            ''',
          ).build(),
        ];

        StatefulAnalyzer analyzer = StatefulAnalyzer(config, models);
        var definitions = analyzer.validateAll();
        var definition = definitions.first as ClassDefinition;

        expect(
          definition.fields.last.scope,
          ModelFieldScopeDefinition.all,
        );
      },
    );

    test(
      'Given a class with a field with both the api and database keywords, then collect an error that only one of them is allowed.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String?, api, database
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          hasLength(greaterThan(1)),
        );

        var message1 =
            'The "api" property is mutually exclusive with the "database" property.';
        var message2 =
            'The "database" property is mutually exclusive with the "api" property.';

        var hasDatabaseError = collector.errors.any(
          (error) => error.message == message1,
        );

        var hasApiError = collector.errors.any(
          (error) => error.message == message2,
        );

        expect(hasDatabaseError, isTrue);
        expect(hasApiError, isTrue);
      },
    );

    group(
      'Given a class with a field with the scope set to database',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String?, database
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        );
        var definitions = analyzer.validateAll();
        var definition = definitions.first as ClassDefinition;

        test('then an error is reported', () {
          expect(collector.errors, isNotEmpty);
        });

        test('then an deprecated error message is reported.', () {
          var error = collector.errors.first as SourceSpanSeverityException;
          expect(
            error.message,
            'The "database" property is deprecated. Use "scope=serverOnly" instead.',
          );

          expect(error.severity, SourceSpanSeverity.info);
        }, skip: collector.errors.isEmpty);

        test('then the generated model has the serverOnly scope.', () {
          expect(
            definition.fields.last.scope,
            ModelFieldScopeDefinition.serverOnly,
          );
        });
      },
    );

    group(
      'Given a class with a field with the scope set to api',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String?, api
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer analyzer =
            StatefulAnalyzer(config, models, onErrorsCollector(collector));
        var definitions = analyzer.validateAll();
        var definition = definitions.first as ClassDefinition;

        test('then an error is reported', () {
          expect(collector.errors, isNotEmpty);
        });

        test('then an deprecated error message is reported.', () {
          var error = collector.errors.first as SourceSpanSeverityException;
          expect(
            error.message,
            'The "api" property is deprecated. Use "!persist" instead.',
          );

          expect(error.severity, SourceSpanSeverity.info);
        }, skip: collector.errors.isEmpty);

        test('then the generated model should not be persisted.', () {
          expect(
            definition.fields.last.shouldPersist,
            isFalse,
          );
        });
      },
    );

    test(
      'Given a class with a field with database set to an invalid value, then collect an error that the value must be a bool.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String?, database=INVALID
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors.length, greaterThan(0));

        var error = collector.errors.first;

        expect(error.message, 'The value must be a boolean.');
      },
    );

    test(
      'Given a class with a field with api set to an invalid value, then collect an error that the value must be a bool.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              name: String?, api=INVALID
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors.length, greaterThan(0));

        var error = collector.errors.first;

        expect(error.message, 'The value must be a boolean.');
      },
    );

    test(
      'Given a class with a field with the scope set to api and a parent table, then report an error that the parent keyword and api scope is not valid together.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              nextId: int?, parent=example, api
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();

        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error, none was found.',
        );

        var message =
            'The "api" property is mutually exclusive with the "parent" property.';

        var hasError = collector.errors.any(
          (error) => error.message == message,
        );

        expect(hasError, isTrue, reason: 'Expected error message: $message');
      },
    );
  });

  test(
    'Given a class with a field with no scope set, then the generated model has the all scope.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.last.scope, ModelFieldScopeDefinition.all);
    },
  );

  test(
      'Given server only class with a field with no scope set, then the generated model has the server only scope.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        serverOnly: true
        fields:
          name: String
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

    expect(definition.fields.last.scope, ModelFieldScopeDefinition.serverOnly);
  });

  group(
    'Given a class with a field with the scope set',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String?, scope=serverOnly
            example: String, scope=all
            town: String?, scope=none
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      test('then no errors are collected.', () {
        expect(collector.errors, isEmpty);
      });

      test('then the generated model has the scope.', () {
        expect(
          definition.fields[0].scope,
          ModelFieldScopeDefinition.serverOnly,
        );
      });

      test('then the generated model has the scope.', () {
        expect(
          definition.fields[1].scope,
          ModelFieldScopeDefinition.all,
        );
      });

      test('then the generated model has the scope.', () {
        expect(definition.fields[2].scope, ModelFieldScopeDefinition.none);
      });
    },
  );

  test(
      'Given a class with a field with the scope set to null, then collect an error informing the user about the correct types.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          name: String?, scope=
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error for invalid scope name, none was found.',
    );

    expect(
      collector.errors.first.message,
      '"" is not a valid property. Valid properties are (all, serverOnly, none).',
    );
  });

  test(
    'Given a class with a field with the scope set to an invalid value, then collect an error informing the user about the correct types.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          name: String?, scope=InvalidScope
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors.length,
        greaterThan(0),
        reason: 'Expected an error for invalid scope name, none was found.',
      );

      expect(
        collector.errors.first.message,
        '"InvalidScope" is not a valid property. Valid properties are (all, serverOnly, none).',
      );
    },
  );

  test(
    'Given a class with a field with both the scope and database keywords, then collect an error that only one of them is allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String?, scope=serverOnly, database
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(collector.errors, hasLength(greaterThan(1)));

      var error1 = collector.errors[0];
      var error2 = collector.errors[1];

      expect(
        error1.message,
        'The "scope" property is mutually exclusive with the "database" property.',
      );
      expect(
        error2.message,
        'The "database" property is mutually exclusive with the "scope" property.',
      );
    },
  );

  test(
    'Given a class with a field with both the scope and api keywords, then collect an error that only one of them is allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String?, scope=serverOnly, api
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(collector.errors, hasLength(greaterThan(1)));

      var error1 = collector.errors[0];
      var error2 = collector.errors[1];

      expect(
        error1.message,
        'The "scope" property is mutually exclusive with the "api" property.',
      );
      expect(
        error2.message,
        'The "api" property is mutually exclusive with the "scope" property.',
      );
    },
  );

  test(
    'Given a class with a none nullable field with the scope serverOnly then an error is collected notifying that only nullable fields are allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String, scope=serverOnly
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field "name" must be nullable when the "scope" property is set to "serverOnly".',
      );
    },
  );

  group(
    'Given a server only class with a none nullable field with the scope serverOnly',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          serverOnly: true
          fields:
            name: String, scope=serverOnly
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      test('then an error is collected.', () {
        expect(collector.errors, isNotEmpty);
      });

      test('then error collected is tagged "unnecessary.', () {
        var error = collector.errors.first as SourceSpanSeverityException;
        expect(error.tags, contains(SourceSpanTag.unnecessary));
      });

      test('then error collected has info severity.', () {
        var error = collector.errors.first as SourceSpanSeverityException;
        expect(error.severity, SourceSpanSeverity.info);
      });

      test(
          'then error message informs user that scope declaration is redundant.',
          () {
        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The field "name" belongs to a server only class which makes setting the "scope" to "serverOnly" redundant.',
        );
      });
      test('then the field is declared with the server only scope.', () {
        var definition = definitions.first as ClassDefinition;
        expect(
          definition.fields.first.scope,
          ModelFieldScopeDefinition.serverOnly,
        );
      });
    },
  );

  test(
    'Given a class with a none nullable field with the scope none then an error is collected notifying that only nullable fields are allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String, scope=none
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field "name" must be nullable when the "scope" property is set to "none".',
      );
    },
  );

  test(
    'Given a server only class with a none nullable field with the scope none then an error is collected notifying that only nullable fields are allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          serverOnly: true
          fields:
            name: String, scope=none
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;

      expect(
        error.message,
        'The field "name" must be nullable when the "scope" property is set to "none".',
      );
    },
  );

  test(
    'Given a server only class with a nullable field with the scope none then field has scope none.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          serverOnly: true
          fields:
            name: String?, scope=none
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      expect(collector.errors, isEmpty);

      var definition = definitions.first as ClassDefinition;
      expect(
        definition.fields.first.scope,
        ModelFieldScopeDefinition.none,
      );
    },
  );

  group('Given class with server only property and field with scope all', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        serverOnly: true
        fields:
          name: String, scope=all
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    test('then error is collected.', () {
      expect(collector.errors, isNotEmpty);
    });

    test('then error message informs about the allowed scopes.', () {
      var error = collector.errors.first as SourceSpanSeverityException;
      expect(
        error.message,
        'The field "name" cannot have the "scope" property set to "all" when the class is marked as server only. Allowed properties are (serverOnly, none).',
      );
    });
  });

  group('Given server only class referenced from all scoped class', () {
    var models = [
      ModelSourceBuilder().withFileName('server_only_class').withYaml(
        '''
        class: ServerOnlyClass
        serverOnly: true
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          fieldOfServerOnlyClass: ServerOnlyClass
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    test('then an error is collected.', () {
      expect(collector.errors, isNotEmpty);
    });

    test(
        'then error informs that scope must be compatible with server only scoped classes.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The type "ServerOnlyClass" is a server only class and can only be used fields with scope (serverOnly, none) (e.g fieldOfServerOnlyClass: ServerOnlyClass, scope=serverOnly).',
      );
    });
  });

  test(
      'Given server only class referenced from server only scoped class then field is defined.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('server_only_class').withYaml(
        '''
        class: ServerOnlyClass
        serverOnly: true
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        serverOnly: true
        fields:
          fieldOfServerOnlyClass: ServerOnlyClass
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    expect(collector.errors, isEmpty);

    var definition = definitions.firstOrNull as ClassDefinition?;
    expect(definition, isNotNull);
  });

  group('Given server only class referenced from all scoped field', () {
    var models = [
      ModelSourceBuilder().withFileName('server_only_class').withYaml(
        '''
        class: ServerOnlyClass
        serverOnly: true
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          fieldOfServerOnlyClass: ServerOnlyClass, scope=all
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    test('then an error is collected.', () {
      expect(collector.errors, isNotEmpty);
    });

    test(
        'then error informs that scope must be compatible with server only scoped classes.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The type "ServerOnlyClass" is a server only class and can only be used fields with scope (serverOnly, none) (e.g fieldOfServerOnlyClass: ServerOnlyClass, scope=serverOnly).',
      );
    });
  });

  group('Given server only class referenced from Map in an all scoped field',
      () {
    var models = [
      ModelSourceBuilder().withFileName('server_only_class').withYaml(
        '''
        class: ServerOnlyClass
        serverOnly: true
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          fieldOfServerOnlyClass: Map<String, ServerOnlyClass>, scope=all
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    test('then an error is collected.', () {
      expect(collector.errors, isNotEmpty);
    });

    test(
        'then error informs that scope must be compatible with server only scoped classes.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The type "ServerOnlyClass" is a server only class and can only be used fields with scope (serverOnly, none) (e.g fieldOfServerOnlyClass: ServerOnlyClass, scope=serverOnly).',
      );
    });
  });

  test(
      'Given server only class referenced from server only scoped field then field is defined.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('server_only_class').withYaml(
        '''
        class: ServerOnlyClass
        serverOnly: true
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          fieldOfServerOnlyClass: ServerOnlyClass?, scope=serverOnly
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    expect(collector.errors, isEmpty);

    var definition = definitions.firstOrNull as ClassDefinition?;
    expect(definition, isNotNull);
  });

  test(
      'Given server only class referenced from none scoped field then field is defined.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('server_only_class').withYaml(
        '''
        class: ServerOnlyClass
        serverOnly: true
        fields:
          name: String
        ''',
      ).build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          fieldOfServerOnlyClass: ServerOnlyClass?, scope=none
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    expect(collector.errors, isEmpty);

    var definition = definitions.firstOrNull as ClassDefinition?;
    expect(definition, isNotNull);
  });
}
