part of 'library_generator.dart';

extension FutureCallsLibraryGenerator on LibraryGenerator {
  /// Generates the interface for accessing future calls for the server side.
  Library generateServerFutureCalls() {
    var library = LibraryBuilder();

    library.body.add(
      Code.scope((allocate) {
        final type = allocate(
          refer('SerializableModel', serverpodUrl(true)),
        );

        return '''
/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, $type? object);

    /// Global variable for accessing future calls via a typed interface.
    final futureCalls = _FutureCalls();
''';
      }),
    );

    // FutureCalls class
    library.body.add(
      Class(
        (c) => c
          ..name = '_FutureCalls'
          ..extend = refer('FutureCallInitializer', serverpodUrl(true))
          ..fields.addAll([
            Field(
              (f) => f
                ..name = '_futureCallManager'
                ..type = refer('FutureCallManager?', serverpodUrl(true)),
            ),
            Field(
              (f) => f
                ..name = '_serverId'
                ..type = refer('String?'),
            ),
          ])
          ..methods.addAll([
            Method(
              (m) => m
                ..name = '_effectiveServerId'
                ..type = MethodType.getter
                ..returns = refer('String')
                ..body = const Code('''
                    if (_serverId == null) {
                      throw StateError('FutureCalls is not initialized.');
                    }
                    return _serverId!;
                  '''),
            ),

            Method(
              (m) => m
                ..name = '_effectiveFutureCallManager'
                ..type = MethodType.getter
                ..returns = refer('FutureCallManager', serverpodUrl(true))
                ..body = const Code('''
                    if (_futureCallManager == null) {
                      throw StateError('FutureCalls is not initialized.');
                    }
                    return _futureCallManager!;
                  '''),
            ),

            // Initialize method
            Method.returnsVoid(
              (m) => m
                ..annotations.add(refer('override'))
                ..name = 'initialize'
                ..requiredParameters.addAll([
                  Parameter(
                    ((p) => p
                      ..name = 'futureCallManager'
                      ..type = refer('FutureCallManager', serverpodUrl(true))),
                  ),
                  Parameter(
                    ((p) => p
                      ..name = 'serverId'
                      ..type = refer('String')),
                  ),
                ])
                ..body = Block.of([
                  _buildRegisteredFutureCalls(protocolDefinition.futureCalls),
                  _buildFutureCallDispatchInitializer(),
                ]),
            ),

            Method((m) {
              m
                ..name = 'callAtTime'
                ..returns = refer('_FutureCallRef')
                ..requiredParameters.add(
                  Parameter(
                    (p) => p
                      ..name = 'time'
                      ..type = refer('DateTime'),
                  ),
                )
                ..optionalParameters.add(
                  Parameter(
                    (p) => p
                      ..name = 'identifier'
                      ..named = true
                      ..type = refer('String?'),
                  ),
                )
                ..body = const Code('''
                    return _FutureCallRef(
                      (name, object) {
                        return _effectiveFutureCallManager.scheduleFutureCall(
                          name,
                          object,
                          time,
                          _effectiveServerId,
                          identifier,
                        );
                      },
                    );
                  ''');
            }),

            Method((m) {
              m
                ..name = 'callWithDelay'
                ..returns = refer('_FutureCallRef')
                ..requiredParameters.add(
                  Parameter(
                    (p) => p
                      ..name = 'delay'
                      ..type = refer('Duration'),
                  ),
                )
                ..optionalParameters.add(
                  Parameter(
                    (p) => p
                      ..name = 'identifier'
                      ..named = true
                      ..type = refer('String?'),
                  ),
                )
                ..body = const Code('''
                    return _FutureCallRef(
                      (name, object) {
                        return _effectiveFutureCallManager.scheduleFutureCall(
                          name,
                          object,
                          DateTime.now().toUtc().add(delay),
                          _effectiveServerId,
                          identifier,
                        );
                      },
                    );
                  ''');
            }),
          ]),
      ),
    );

    _generateFutureCallRef(library);
    _generateFutureCallDispatchers(library);
    _generateServerFutureCalls(library);

    return library.build();
  }

  Code _buildFutureCallDispatchInitializer() {
    return Block.of([
      const Code('''
        _futureCallManager = futureCallManager;
        _serverId = serverId;
        for (final entry in registeredFutureCalls.entries) {
          _futureCallManager?.registerFutureCall(entry.value, entry.key);
        }
'''),
    ]);
  }

  Code _buildRegisteredFutureCalls(List<FutureCallDefinition> futureCalls) {
    return refer('var registeredFutureCalls')
        .assign(
          literalMap(
            {
              for (var futureCall in futureCalls)
                for (var method in futureCall.methods)
                  if (!futureCall.isAbstract)
                    _getFutureCallClassName(
                      futureCall.name,
                      method.name,
                    ): refer(
                      _getFutureCallClassName(futureCall.name, method.name),
                    ).call([]),
            },
            refer('String'),
            refer('FutureCall', serverpodUrl(true)),
          ),
        )
        .statement;
  }

  /// Generates FutureCallRef for server side.
  void _generateFutureCallRef(LibraryBuilder libraryBuilder) {
    // FutureCallRef class
    libraryBuilder.body.add(
      Class(
        (c) => c
          ..name = '_FutureCallRef'
          ..fields.add(
            Field(
              (f) {
                f
                  ..modifier = FieldModifier.final$
                  ..name = '_invokeFutureCall'
                  ..type = refer('_InvokeFutureCall');
              },
            ),
          )
          ..constructors.add(
            Constructor(
              (c) => c
                ..requiredParameters.add(
                  Parameter(
                    (p) => p
                      ..toThis = true
                      ..name = '_invokeFutureCall',
                  ),
                ),
            ),
          )
          // Final fields for future call callers
          ..fields.addAll([
            for (var futureCall in protocolDefinition.futureCalls)
              if (!futureCall.isAbstract && futureCall.methods.isNotEmpty)
                Field(
                  (f) => f
                    ..late = true
                    ..name = futureCall.name
                    ..modifier = FieldModifier.final$
                    ..assignment = Code.scope((_) {
                      final dispatcherClassName =
                          _generateFutureCallDispatcherClassName(futureCall);
                      return '$dispatcherClassName(_invokeFutureCall)';
                    }),
                ),
          ]),
      ),
    );
  }

  String _generateFutureCallDispatcherClassName(
    FutureCallDefinition futureCall,
  ) {
    return '_${futureCall.name.pascalCase}FutureCallDispatcher';
  }

  /// Generates dispatchers for all future call classes.
  void _generateFutureCallDispatchers(LibraryBuilder libraryBuilder) {
    for (final futureCall in protocolDefinition.futureCalls) {
      if (futureCall.isAbstract || futureCall.methods.isEmpty) continue;
      // FutureCallDispatcher class
      libraryBuilder.body.add(
        Class(
          (c) => c
            ..name = _generateFutureCallDispatcherClassName(futureCall)
            ..fields.add(
              Field(
                (f) => f
                  ..modifier = FieldModifier.final$
                  ..name = '_invokeFutureCall'
                  ..type = refer('_InvokeFutureCall'),
              ),
            )
            ..constructors.add(
              Constructor(
                (c) => c
                  ..requiredParameters.add(
                    Parameter(
                      (p) => p
                        ..toThis = true
                        ..name = '_invokeFutureCall',
                    ),
                  ),
              ),
            )
            ..methods.addAll([
              for (var method in futureCall.methods)
                _buildFutureCallDispatcherMethod(futureCall.name, method),
            ]),
        ),
      );
    }
  }

  Method _buildFutureCallDispatcherMethod(
    String futureClassName,
    FutureCallMethodDefinition method,
  ) {
    final requiredParameters = method.parameters;
    final optionalParameters = method.parametersPositional;
    final namedParameters = method.parametersNamed;

    return Method(
      (m) => m
        ..name = method.name
        ..returns = TypeReference(
          (t) => t
            ..symbol = 'Future'
            ..types.add(refer('void')),
        )
        ..requiredParameters.addAll([
          for (var param in requiredParameters)
            Parameter(
              (p) => p
                ..name = param.name
                ..type = param.type.reference(
                  true,
                  config: config,
                ),
            ),
        ])
        ..optionalParameters.addAll([
          for (var param in optionalParameters)
            Parameter(
              (p) => p
                ..named = false
                ..name = param.name
                ..defaultTo = param.defaultValue != null
                    ? Code(param.defaultValue!)
                    : null
                ..type = param.type.reference(
                  true,
                  config: config,
                ),
            ),
          for (var param in namedParameters)
            Parameter(
              (p) => p
                ..named = true
                ..required = param.required
                ..name = param.name
                ..defaultTo = param.defaultValue != null
                    ? Code(param.defaultValue!)
                    : null
                ..type = param.type.reference(
                  true,
                  config: config,
                ),
            ),
        ])
        ..body = Block.of([
          // Generate serializable model instance
          if (method.futureCallMethodParameter != null) ...[
            refer('var object')
                .assign(
                  refer(
                    method.futureCallMethodParameter!.type.className,
                    TypeDefinition.getRef(
                      method.futureCallMethodParameter!.toSerializableModel(),
                    ),
                  ).call(
                    [],
                    {
                      for (final param in method.allParameters)
                        param.name: refer(param.name),
                    },
                  ),
                )
                .statement,
          ],

          refer('_invokeFutureCall')
              .call([
                literalString(
                  _getFutureCallClassName(futureClassName, method.name),
                ),
                if (method.futureCallMethodParameter != null)
                  refer('object')
                else if (method.parameters.isNotEmpty)
                  refer(method.parameters.first.name),
              ])
              .returned
              .statement,
        ]),
    );
  }

  String _futureCallPath(FutureCallDefinition futureCall) {
    // For future calls defined in other packages, the filePath is the library uri.
    if (futureCall.filePath.startsWith('package:')) return futureCall.filePath;

    var relativePath = p.relative(
      futureCall.filePath,
      from: _buildGeneratedDirectoryPath(),
    );

    // Replace backslashes with forward slashes to make it work on Windows.
    return p.split(relativePath).join('/');
  }

  String _getFutureCallClassName(String futureCallName, [String? methodName]) {
    final buffer = StringBuffer()
      ..write(futureCallName.pascalCase)
      ..write(methodName == null ? '' : methodName.pascalCase)
      ..write('FutureCall');

    return buffer.toString();
  }

  String _getNullableClassName(String className) {
    if (!className.endsWith('?')) return '$className?';
    return className;
  }

  /// Generates future calls for the server.
  void _generateServerFutureCalls(LibraryBuilder libraryBuilder) {
    for (var futureCall in protocolDefinition.futureCalls) {
      if (futureCall.isAbstract) continue;
      // Generate a future call class for each method in the definition
      for (var method in futureCall.methods) {
        var futureCallClassName = _getFutureCallClassName(
          futureCall.name,
          method.name,
        );

        libraryBuilder.body.add(
          Class((c) {
            var requiredParameters = method.parameters;

            c
              ..docs.add(method.documentationComment ?? '')
              ..name = futureCallClassName
              ..extend = TypeReference(
                (t) => t
                  ..symbol = 'FutureCall'
                  ..url = serverpodUrl(true)
                  ..types.addAll([
                    if (method.futureCallMethodParameter != null)
                      refer(
                        method.futureCallMethodParameter!.type.className,
                        TypeDefinition.getRef(
                          method.futureCallMethodParameter!
                              .toSerializableModel(),
                        ),
                      )
                    else if (requiredParameters.isNotEmpty)
                      requiredParameters.first.type.asNonNullable.reference(
                        true,
                        config: config,
                      ),
                  ]),
              )
              ..abstract = futureCall.isAbstract;

            c.methods.add(
              Method(
                (m) => m
                  ..annotations.add(refer('override'))
                  ..modifier = MethodModifier.async
                  ..returns = method.returnType.reference(
                    true,
                    config: config,
                  )
                  ..name = 'invoke'
                  ..requiredParameters.addAll([
                    Parameter(
                      (p) => p
                        ..name = 'session'
                        ..type = refer('Session', serverpodUrl(true)),
                    ),
                    if (method.futureCallMethodParameter != null)
                      Parameter(
                        (p) => p
                          ..name = method.futureCallMethodParameter!.name
                          ..type = refer(
                            _getNullableClassName(
                              method.futureCallMethodParameter!.type.className,
                            ),
                            TypeDefinition.getRef(
                              method.futureCallMethodParameter!
                                  .toSerializableModel(),
                            ),
                          ),
                      )
                    else if (requiredParameters.isNotEmpty)
                      Parameter(
                        (p) => p
                          ..name = requiredParameters.first.name
                          ..type = requiredParameters.first.type.asNullable
                              .reference(
                                true,
                                config: config,
                              ),
                      ),
                  ])
                  ..body = futureCall.isAbstract
                      ? null
                      : _buildFutureCallMethodBody(futureCall, method),
              ),
            );
          }),
        );
      }
    }
  }

  Code _buildFutureCallMethodBody(
    FutureCallDefinition futureCall,
    FutureCallMethodDefinition method,
  ) {
    var requiredParameters = method.parameters;
    var optionalParameters = method.parametersPositional;
    var namedParameters = method.parametersNamed;

    Expression buildPositionalParameter() {
      final isPositionalParameterNullable =
          requiredParameters.firstOrNull?.type.nullable == true;

      if (isPositionalParameterNullable) {
        return refer(requiredParameters.first.name);
      } else {
        return refer(requiredParameters.first.name).nullChecked;
      }
    }

    return Block.of([
      if (method.futureCallMethodParameter != null)
        const Code('if(object != null) { await')
      else
        const Code('await'),
      refer(
            futureCall.className,
            _futureCallPath(futureCall),
          )
          .call([])
          .property(method.name)
          .call(
            [
              refer('session'),
              if (method.futureCallMethodParameter != null) ...[
                for (var param in requiredParameters)
                  refer('object.${param.name}'),
              ] else if (requiredParameters.isNotEmpty)
                buildPositionalParameter(),
              if (method.futureCallMethodParameter != null)
                for (var param in optionalParameters)
                  refer('object.${param.name}'),
            ],
            {
              if (method.futureCallMethodParameter != null)
                for (var param in namedParameters)
                  param.name: refer(
                    'object.${param.name}',
                  ),
            },
          )
          .statement,

      if (method.futureCallMethodParameter != null) const Code('}'),
    ]);
  }
}
