part of 'library_generator.dart';

extension ServerpodLibraryGenerator on LibraryGenerator {
  /// Generates the project's `Serverpod` class, a subclass of the framework's
  /// `Serverpod` that is pre-configured with the generated `Protocol` and
  /// `Endpoints`, so a server can be created with just `Serverpod(args)`.
  ///
  /// Executing this only makes sense for server packages of type
  /// [PackageType.server] (modules are never booted on their own).
  Library generateServerpodClass() {
    var library = LibraryBuilder();
    var syncModule = _syncModule;

    // Re-export the framework, hiding its Serverpod class in favor of the
    // generated one, so `server.dart` only needs to import this file.
    library.directives.add(
      Directive.export(serverpodUrl(true), hide: const ['Serverpod']),
    );

    // The futureCalls getter is an extension, which is only applicable when
    // imported without a prefix, so it must be re-exported here as well.
    if (protocolDefinition.shouldGenerateFutureCalls) {
      library.directives.add(
        Directive.export(
          'future_calls.dart',
          show: const ['ServerpodFutureCallsGetter'],
        ),
      );
    }

    library.body.add(
      Class(
        (c) => c
          ..docs.addAll([
            '/// The Serverpod server for this project.',
            '///',
            '/// Pre-configured with the generated Protocol serialization manager and',
            '/// Endpoints, so a server can be created with just the command line',
            '/// arguments:',
            '///',
            '/// ```dart',
            '/// final pod = Serverpod(args);',
            '/// ```',
            if (syncModule != null) ...[
              '///',
              '/// The `serverpod_offline_sync` engine is initialized with the tables',
              '/// declared with `database: sync`, using `crdtDatabaseInterceptor`',
              '/// unless a [databaseInterceptor] is provided.',
            ],
          ])
          ..name = 'Serverpod'
          ..extend = refer('Serverpod', serverpodUrl(true))
          ..constructors.add(
            Constructor((c) {
              c
                ..requiredParameters.add(
                  Parameter(
                    (p) => p
                      ..type = refer('List<String>')
                      ..name = 'args',
                  ),
                )
                ..optionalParameters.addAll([
                  Parameter(
                    (p) => p
                      ..name = 'serverDirectory'
                      ..named = true
                      ..type = refer('Directory?', 'dart:io'),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'config'
                      ..named = true
                      ..type = refer('ServerpodConfig?', serverpodUrl(true)),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'configOverride'
                      ..named = true
                      ..type = FunctionType(
                        (f) => f
                          ..isNullable = true
                          ..returnType = TypeReference(
                            (t) => t
                              ..symbol = 'ServerpodConfig'
                              ..url = serverpodUrl(true)
                              ..isNullable = false,
                          )
                          ..requiredParameters.add(
                            TypeReference(
                              (t) => t
                                ..symbol = 'ServerpodConfig'
                                ..url = serverpodUrl(true)
                                ..isNullable = false,
                            ),
                          ),
                      ),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'authenticationHandler'
                      ..named = true
                      ..type = refer(
                        'AuthenticationHandler?',
                        serverpodUrl(true),
                      ),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'healthCheckHandler'
                      ..named = true
                      ..type = refer('HealthCheckHandler?', serverpodUrl(true)),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'healthConfig'
                      ..named = true
                      ..type = refer('HealthConfig?', serverpodUrl(true)),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'httpResponseHeaders'
                      ..named = true
                      ..type = refer('Headers?', serverpodUrl(true)),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'httpOptionsResponseHeaders'
                      ..named = true
                      ..type = refer('Headers?', serverpodUrl(true)),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'securityContextConfig'
                      ..named = true
                      ..type = refer(
                        'SecurityContextConfig?',
                        serverpodUrl(true),
                      ),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'experimentalFeatures'
                      ..named = true
                      ..type = refer(
                        'ExperimentalFeatures?',
                        serverpodUrl(true),
                      ),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'runtimeParametersBuilder'
                      ..named = true
                      ..type = refer(
                        'RuntimeParametersListBuilder?',
                        serverpodUrl(true),
                      ),
                  ),
                  Parameter(
                    (p) => p
                      ..name = 'databaseInterceptor'
                      ..named = true
                      ..type = refer(
                        'DatabaseInterceptor?',
                        serverpodUrl(true),
                      ),
                  ),
                ])
                ..initializers.add(
                  refer('super')
                      .call(
                        [
                          refer('args'),
                          refer('Protocol', 'protocol.dart').call([]),
                          refer('Endpoints', 'endpoints.dart').call([]),
                        ],
                        {
                          'serverDirectory': refer('serverDirectory'),
                          'config': refer('config'),
                          'configOverride': refer('configOverride'),
                          'authenticationHandler': refer(
                            'authenticationHandler',
                          ),
                          'healthCheckHandler': refer('healthCheckHandler'),
                          'healthConfig': refer('healthConfig'),
                          'httpResponseHeaders': refer('httpResponseHeaders'),
                          'httpOptionsResponseHeaders': refer(
                            'httpOptionsResponseHeaders',
                          ),
                          'securityContextConfig': refer(
                            'securityContextConfig',
                          ),
                          'experimentalFeatures': refer('experimentalFeatures'),
                          'runtimeParametersBuilder': refer(
                            'runtimeParametersBuilder',
                          ),
                          'databaseInterceptor': syncModule == null
                              ? refer('databaseInterceptor')
                              : refer('databaseInterceptor').ifNullThen(
                                  refer(
                                    'crdtDatabaseInterceptor',
                                    syncModule.dartImportUrl(true),
                                  ),
                                ),
                        },
                      )
                      .code,
                );
              if (syncModule != null) {
                c.body = refer('initializeCrdtSync')
                    .call([], {
                      'syncTables': refer(
                        'Protocol',
                        'protocol.dart',
                      ).property('syncTables'),
                    })
                    .statement;
              }
            }),
          ),
      ),
    );

    return library.build();
  }
}
