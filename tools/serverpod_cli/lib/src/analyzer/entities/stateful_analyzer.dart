import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';

class _ProtocolState {
  ProtocolSource source;
  SerializableEntityDefinition? entity;

  _ProtocolState({
    required this.source,
  });
}

class StatefulAnalyzer {
  final Map<String, _ProtocolState> _protocolStates = {};
  List<SerializableEntityDefinition> _entities = [];

  Function(Uri, CodeGenerationCollector)? _onErrorsChangedNotifier;

  StatefulAnalyzer(
    List<ProtocolSource> sources, [
    Function(Uri, CodeGenerationCollector)? callback,
  ]) {
    for (var yamlSource in sources) {
      _protocolStates[yamlSource.yamlSourceUri.path] = _ProtocolState(
        source: yamlSource,
      );
    }

    _onErrorsChangedNotifier = callback;
  }

  /// Loads all yaml protocols and initializes the state. The state is preserved
  /// to make future validations less expensive.
  /// Subsequent validations should use [validateAll] or [validateProtocol].
  List<SerializableEntityDefinition> initialValidation(
      List<ProtocolSource> sources) {
    for (var yamlSource in sources) {
      _protocolStates[yamlSource.yamlSourceUri.path] = _ProtocolState(
        source: yamlSource,
      );
    }

    _updateAllEntities();
    _validateAllProtocols();
    return _entities;
  }

  /// Runs the validation on all protocols, assumes protocols have been added
  /// by running [initialValidation] or adding them manually
  /// with [addYamlProtocol]. If not protocol has been initialized this method
  /// returns an empty list.
  /// Errors are reported through the [onErrorsChangedNotifier].
  List<SerializableEntityDefinition> validateAll() {
    _updateAllEntities();
    _validateAllProtocols();
    return _entities;
  }

  /// Runs the validation on a single protocol, assumes [initialValidation] has been
  /// run before. The protocol must exist in the state, if not this returns
  /// the last validated state. To validate a new protocol, use [addYamlProtocol]
  /// and then run [validateAll] or [validateProtocol].
  /// Errors are reported through the [registerOnErrorsChangedNotifier].
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
    return _entities;
  }

  /// Adds a new protocol to the state but leaves the responsibility of validating
  /// it to the caller. Please note that [validateAll] should be called to
  /// guarantee that all errors are found.
  void addYamlProtocol(ProtocolSource yamlSource) {
    var protocolState = _ProtocolState(
      source: yamlSource,
    );

    _protocolStates[yamlSource.yamlSourceUri.path] = protocolState;
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

  /// Checks if a protocol is registered in the state.
  bool isProtocolRegistered(Uri uri) {
    return _protocolStates.containsKey(uri.path);
  }

  void _updateAllEntities() {
    for (var state in _protocolStates.values) {
      var doc = SerializableEntityAnalyzer.extractEntityDefinition(
        state.source,
      );
      state.entity = doc;
    }

    _entities = _protocolStates.values
        .map((state) => state.entity)
        .whereType<SerializableEntityDefinition>()
        .toList();
  }

  void _validateAllProtocols() {
    for (var state in _protocolStates.values) {
      var collector = CodeGenerationCollector();
      SerializableEntityAnalyzer.validateYamlDefinition(
        state.source.yaml,
        state.source.yamlSourceUri.path,
        collector,
        state.entity,
        _entities,
      );

      _onErrorsChangedNotifier?.call(
        Uri.file(state.source.yamlSourceUri.path),
        collector,
      );
    }
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
