import 'package:code_builder/code_builder.dart';

/// Generates immutable type declarations and ordered module fallback.
class ProtocolDeserializationGenerator {
  final String runtimeUrl;

  ProtocolDeserializationGenerator({required this.runtimeUrl});

  Reference provider({String? databaseRuntimeUrl}) {
    if (databaseRuntimeUrl != null) {
      return refer(
        'DatabaseProtocolDeserializationProvider',
        databaseRuntimeUrl,
      );
    }
    return refer('ProtocolDeserializationProvider', runtimeUrl);
  }

  Method metadata({
    required Iterable<Expression> types,
    required List<Expression> modules,
  }) {
    return Method(
      (m) => m
        ..annotations.add(refer('override'))
        ..name = 'deserializationMetadata'
        ..type = MethodType.getter
        ..returns = refer('ProtocolDeserialization', runtimeUrl)
        ..lambda = true
        ..body = refer('ProtocolDeserialization', runtimeUrl)
            .newInstanceNamed(
              'cached',
              [refer('this')],
              {
                'types': literalConstList([
                  for (final type in types)
                    TypeReference(
                      (b) => b
                        ..symbol = 'getType'
                        ..url = runtimeUrl
                        ..types.add(
                          type is InvokeExpression
                              ? type.typeArguments.single
                              : type as Reference,
                        ),
                    ),
                ]),
                'modules': literalConstList([
                  for (final module in modules)
                    (module as InvokeExpression).target.property('new'),
                ]),
              },
            )
            .code,
    );
  }

  Code moduleFallback() {
    return Code.scope(
      (a) =>
          '''
      final modules = dataClassName == null
          ? deserializationMetadata.modulesForType(t)
          : deserializationMetadata.modules;
      for (final module in modules) {
        try {
          return module.deserialize<T>(data, t);
        } on ${a(refer('DeserializationTypeNotFoundException', runtimeUrl))} catch (_) {}
      }
      ''',
    );
  }
}
