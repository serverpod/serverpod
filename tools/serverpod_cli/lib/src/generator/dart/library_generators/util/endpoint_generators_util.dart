import 'package:code_builder/code_builder.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

/// Builds annotations for endpoint method calls, filtering out
/// annotations that should not be propagated to generated code.
///
/// This is used to transfer annotations like @deprecated and @Deprecated
/// from endpoint methods to generated client code and test framework methods.
Iterable<Expression> buildEndpointCallAnnotations(MethodDefinition methodDef) {
  return methodDef.annotations
      .where((e) => e.name != 'unauthenticatedClientCall')
      .map((annotation) {
        var args = annotation.arguments;
        return refer(
          args != null
              ? '${annotation.name}(${args.join(',')})'
              : annotation.name,
        );
      });
}
