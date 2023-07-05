import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';

class StatefulAnalyzer {
  final Map<String, SerializableEntityAnalyzer> _analyzers = {};
  List<SerializableEntityDefinition> _entities = [];

  Function(Uri, CodeGenerationCollector)? _onErrorsChangedNotifier;

  /// Validates all protocols by running the validater twice to make sure all
  /// references are resolved. The state is preserved to make future validations
  /// less expensive. This method is required to use for the initialisation of
  /// the state. Subsequent validations should use [validateAll] or [validateProtocol].
  List<SerializableEntityDefinition> initialValidation(
      List<ProtocolSource> sources) {
    for (var yamlSource in sources) {
      var analyzer = SerializableEntityAnalyzer(
        yaml: yamlSource.yaml,
        sourceFileName: yamlSource.uri.path,
        subDirectoryParts: [],
        collector: CodeGenerationCollector(),
      );

      _analyzers[yamlSource.uri.path] = analyzer;
    }

    _entities = _validateAllAnalyzers();
    _entities = _validateAllAnalyzers(_entities);
    return _entities;
  }

  /// Runs the validation on all protocols, assumes [initialValidation] has been
  /// run before, if not this returns an empty list.
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableEntityDefinition> validateAll() {
    _entities = _validateAllAnalyzers(_entities);
    return _entities;
  }

  /// Runs the validation on a single protocol, assumes [initialValidation] has been
  /// run before. The protocol must exist in the state, if not this returns
  /// the last validated state. To validate a new protocol, use [addYamlProtocol]
  /// and then run [validateAll] or [validateProtocol].
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableEntityDefinition> validateProtocol(String yaml, Uri uri) {
    var analyzer = _analyzers[uri.path];
    if (analyzer == null) return _entities;

    analyzer.collector.clearErrors();
    var document = analyzer.analyze(yaml: yaml, protocolEntities: _entities);
    if (document != null) {
      _upsertEntity(document, uri);
      // TODO if inserted, validate all again or we may miss errors.
    }

    _onErrorsChangedNotifier?.call(
      uri,
      (analyzer.collector as CodeGenerationCollector),
    );

    return _entities;
  }

  /// Adds a new protocol to the state but leaves the responsibility of validating
  /// it to the caller. Please note that the validation needs to be done twice
  /// for the first validation pass to detect all errors.
  void addYamlProtocol(ProtocolSource source) {
    var analyzer = SerializableEntityAnalyzer(
      yaml: source.yaml,
      sourceFileName: source.uri.path,
      subDirectoryParts: [],
      collector: CodeGenerationCollector(),
    );

    _analyzers[source.uri.path] = analyzer;
  }

  /// Removes a protocol from the state but leaves the responsibility of validating
  /// the new state to the caller.
  void removeYamlProtocol(Uri protocolUri) {
    _analyzers.remove(protocolUri.path);
    _entities.removeWhere((entity) => entity.sourceFileName == protocolUri.path);
  }

  /// Register a callback that is called when the errors in a file changes.
  void regsiterOnErrorsChangedNotifier(
    Function(Uri, CodeGenerationCollector) callback,
  ) {
    _onErrorsChangedNotifier = callback;
  }

  /// Unregister the callback that is called when the errors in a file changes.
  void unregisterOnErrorsChangedNotifier() {
    _onErrorsChangedNotifier = null;
  }

  /// Checks if a protocol is registered in the state.
  bool isProtocolRegistered(Uri uri) {
    return _analyzers.containsKey(uri.path);
  }

  /// Reset the internal state of the analyzer.
  void clearState() {
    _analyzers.clear();
    _entities.clear();
  }

  List<SerializableEntityDefinition> _validateAllAnalyzers(
      [List<SerializableEntityDefinition>? entities]) {
    List<SerializableEntityDefinition> parsedEntities = [];
    for (var analyzer in _analyzers.values) {
      analyzer.collector.clearErrors();
      var document = analyzer.analyze(protocolEntities: entities);
      if (document != null) {
        parsedEntities.add(document);
      }

      _onErrorsChangedNotifier?.call(
        Uri.file(analyzer.sourceFileName),
        analyzer.collector as CodeGenerationCollector,
      );
    }

    return parsedEntities;
  }

  void _upsertEntity(
    SerializableEntityDefinition entity,
    Uri uri,
  ) {
    var index = _entities.indexWhere(
      (element) => element.sourceFileName == uri.path,
    );

    if (index == -1) {
      _entities.add(entity);
    } else {
      _entities[index] = entity;
    }
  }
}
