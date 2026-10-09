import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

/// A hash that is the same for two lists of endpoint definitions when the code
/// generated from them is.
///
/// What an endpoint file declares does not only depend on that file: the type
/// of a parameter can come from an alias, a base class, or a documentation
/// template in another one. Comparing the hash of a file's definitions with
/// an earlier one tells whether such a change reached them without the file
/// itself changing.
int endpointDefinitionsHash(List<EndpointDefinition> endpoints) {
  final hash = _DefinitionHash();
  for (final endpoint in endpoints) {
    hash
      ..addClass(
        name: endpoint.name,
        className: endpoint.className,
        filePath: endpoint.filePath,
        documentationComment: endpoint.documentationComment,
        annotations: endpoint.annotations,
        isAbstract: endpoint.isAbstract,
      )
      ..add(endpoint.extendsClass?.className);
    endpoint.methods.forEach(hash.addMethod);
  }
  return hash.value;
}

/// A hash that is the same for two lists of future call definitions when the
/// code generated from them is. See [endpointDefinitionsHash].
int futureCallDefinitionsHash(List<FutureCallDefinition> futureCalls) {
  final hash = _DefinitionHash();
  for (final futureCall in futureCalls) {
    hash.addClass(
      name: futureCall.name,
      className: futureCall.className,
      filePath: futureCall.filePath,
      documentationComment: futureCall.documentationComment,
      annotations: futureCall.annotations,
      isAbstract: futureCall.isAbstract,
    );
    for (final method in futureCall.methods) {
      hash.addMethod(method);
      final parameter = method.futureCallMethodParameter;
      hash.add(parameter?.name);
      if (parameter == null) continue;
      hash
        ..addType(parameter.type)
        ..addParameters(parameter.parameters)
        ..addParameters(parameter.parametersPositional)
        ..addParameters(parameter.parametersNamed);
    }
  }
  return hash.value;
}

/// A 64-bit FNV-1a hash over the parts of definitions, taken in as they are
/// visited so that no text of all of them has to be built first.
///
/// Every part is closed off with a marker, and every list with its length, so
/// two definitions cannot hash alike by having their parts split differently.
class _DefinitionHash {
  static const _prime = 0x100000001b3;
  static const _endOfPart = 0x1f;
  static const _absent = 0x1e;

  int value = 0xcbf29ce484222325;

  void _addUnit(int unit) => value = (value ^ unit) * _prime;

  void add(String? part) {
    if (part == null) {
      _addUnit(_absent);
    } else {
      part.codeUnits.forEach(_addUnit);
    }
    _addUnit(_endOfPart);
  }

  void addCount(int count) {
    _addUnit(count);
    _addUnit(_endOfPart);
  }

  void addClass({
    required String name,
    required String className,
    required String filePath,
    required String? documentationComment,
    required List<AnnotationDefinition> annotations,
    required bool isAbstract,
  }) {
    add(name);
    add(className);
    add(filePath);
    add(documentationComment);
    addAnnotations(annotations);
    addCount(isAbstract ? 1 : 0);
  }

  void addMethod(MethodDefinition method) {
    // A call and a stream method of the same shape generate different code.
    add(method.runtimeType.toString());
    add(method.name);
    add(method.documentationComment);
    addAnnotations(method.annotations);
    addType(method.returnType);
    addParameters(method.parameters);
    addParameters(method.parametersPositional);
    addParameters(method.parametersNamed);
  }

  void addParameters(List<ParameterDefinition> parameters) {
    addCount(parameters.length);
    for (final parameter in parameters) {
      add(parameter.name);
      addType(parameter.type);
      addCount(parameter.required ? 1 : 0);
      add(parameter.defaultValue);
      addAnnotations(parameter.annotations);
    }
  }

  void addAnnotations(List<AnnotationDefinition> annotations) {
    addCount(annotations.length);
    for (final annotation in annotations) {
      add(annotation.name);
      final arguments = annotation.arguments;
      addCount(arguments?.length ?? -1);
      arguments?.forEach(add);
      add(annotation.methodCallAnalyzerIgnoreRule);
    }
  }

  /// The type as written, and where it and its type arguments are imported
  /// from, since the same name from another library generates another import.
  void addType(TypeDefinition type) {
    add(type.toString());
    add(type.url);
    addCount(type.generics.length);
    type.generics.forEach(addType);
  }
}
