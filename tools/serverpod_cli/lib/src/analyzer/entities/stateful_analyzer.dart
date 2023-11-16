import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';

var onErrorsCollector = (CodeGenerationCollector collector) {
  return (Uri uri, CodeGenerationCollector collected) {
    collector.addErrors(collected.errors);
  };
};

class StatefulAnalyzer {
  final Map<String, _ProtocolState> _protocolStates = {};
  List<SerializableEntityDefinition> _entities = [];

  Function(Uri, CodeGenerationCollector)? _onErrorsChangedNotifier;

  StatefulAnalyzer(
    List<ProtocolSource> sources, [
    Function(Uri, CodeGenerationCollector)? onErrorsChangedNotifier,
  ]) {
    for (var yamlSource in sources) {
      _protocolStates[yamlSource.yamlSourceUri.path] = _ProtocolState(
        source: yamlSource,
      );
    }

    _onErrorsChangedNotifier = onErrorsChangedNotifier;
  }

  /// Returns all valid entities in the state.
  List<SerializableEntityDefinition> get _validEntities =>
      _protocolStates.values
          .where((state) => state.errors.isEmpty)
          .map((state) => state.entity)
          .whereType<SerializableEntityDefinition>()
          .toList();

  /// Adds a new protocol to the state but leaves the responsibility of validating
  /// it to the caller. Please note that [validateAll] should be called to
  /// guarantee that all errors are found.
  void addYamlProtocol(ProtocolSource yamlSource) {
    var protocolState = _ProtocolState(
      source: yamlSource,
    );

    _protocolStates[yamlSource.yamlSourceUri.path] = protocolState;
  }

  /// Checks if a protocol is registered in the state.
  bool isProtocolRegistered(Uri uri) {
    return _protocolStates.containsKey(uri.path);
  }

  /// Removes a protocol from the state but leaves the responsibility of validating
  /// the new state to the caller. Please note that [validateAll] should be called to
  /// guarantee that all related errors are cleared.
  void removeYamlProtocol(Uri protocolUri) {
    _protocolStates.remove(protocolUri.path);
    _entities.removeWhere(
      (entity) => entity.sourceFileName == protocolUri.path,
    );
  }

  /// Runs the validation on all protocols in the state. If no protocols are
  /// registered, this returns an empty list.
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableEntityDefinition> validateAll() {
    _updateAllEntities();
    _validateAllProtocols();
    return _validEntities;
  }

  /// Runs the validation on a single protocol. The protocol must exist in the
  /// state, if not this returns the last validated state.
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableEntityDefinition> validateProtocol(String yaml, Uri uri) {
    var state = _protocolStates[uri.path];
    if (state == null) return _entities;

    state.source.yaml = yaml;

    var doc = SerializableEntityAnalyzer.extractEntityDefinition(state.source);
    state.entity = doc;
    if (doc != null) {
      _upsertEntity(doc, uri);
    }

    // This can be optimized to only validate the files we know have related errors.
    _validateAllProtocols();
    return _validEntities;
  }

  void _updateAllEntities() {
    for (var state in _protocolStates.values) {
      var entity = SerializableEntityAnalyzer.extractEntityDefinition(
        state.source,
      );
      state.entity = entity;
    }

    _entities = _protocolStates.values
        .map((state) => state.entity)
        .whereType<SerializableEntityDefinition>()
        .toList();

    SerializableEntityAnalyzer.resolveEntityDependencies(_entities);
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

    // Can be optimized to only resolve the entity we know has changed.
    SerializableEntityAnalyzer.resolveEntityDependencies(_entities);
  }

  void _validateAllProtocols() {
    for (var state in _protocolStates.values) {
      var collector = CodeGenerationCollector();
      SerializableEntityAnalyzer.validateYamlDefinition(
        state.source.yaml,
        state.source.yamlSourceUri,
        collector,
        state.entity,
        _entities,
      );

      if (collector.hasSeverErrors) {
        state.errors = collector.errors;
      } else {
        state.errors = [];
      }

      _onErrorsChangedNotifier?.call(
        Uri.file(state.source.yamlSourceUri.path),
        collector,
      );
    }
  }
}

class _ProtocolState {
  ProtocolSource source;
  List<SourceSpanException> errors = [];
  SerializableEntityDefinition? entity;

  _ProtocolState({
    required this.source,
  });
}
