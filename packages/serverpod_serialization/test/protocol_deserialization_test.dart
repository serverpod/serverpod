import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _Entry {}

class _Other {}

class _LegacyProtocol extends SerializationManager {}

class _DeclaredProtocol extends SerializationManager
    implements ProtocolDeserializationProvider {
  @override
  ProtocolDeserialization deserializationMetadata;

  _DeclaredProtocol({
    Iterable<Type> types = const [],
    List<SerializationManager> modules = const [],
  }) : deserializationMetadata = ProtocolDeserialization(
         types: types,
         modules: modules,
       );
}

class _RecursiveProtocol extends SerializationManager
    implements ProtocolDeserializationProvider {
  @override
  late final ProtocolDeserialization deserializationMetadata;
}

void main() {
  test(
    'Given unchanged generated declarations, '
    'when requesting metadata repeatedly, '
    'then the protocol reuses its cache.',
    () {
      final protocol = _DeclaredProtocol();
      final first = ProtocolDeserialization.cached(
        protocol,
        types: const [getType<_Entry>],
        modules: const [],
      );

      final second = ProtocolDeserialization.cached(
        protocol,
        types: const [getType<_Entry>],
        modules: const [],
      );

      expect(second, same(first));
    },
  );

  test(
    'Given a cached miss through a transitive module, '
    'when the module gains a handler, '
    'then the parent discovers the new route.',
    () {
      final owner = _DeclaredProtocol();
      owner.deserializationMetadata = ProtocolDeserialization.cached(
        owner,
        types: const [],
        modules: const [],
      );
      final intermediary = _DeclaredProtocol(modules: [owner]);
      final routing = ProtocolDeserialization(
        types: [],
        modules: [intermediary],
      );
      final before = routing.modulesForType(_Entry);

      owner.deserializationMetadata = ProtocolDeserialization.cached(
        owner,
        types: const [getType<_Entry>],
        modules: const [],
      );
      final after = routing.modulesForType(_Entry);

      expect(before, isEmpty);
      expect(after, [intermediary]);
    },
  );

  test(
    'Given a cached route to a later module, '
    'when an earlier module gains the same handler, '
    'then routing restores the original module precedence.',
    () {
      final first = _DeclaredProtocol();
      final second = _DeclaredProtocol(types: [_Entry]);
      final routing = ProtocolDeserialization(
        types: [],
        modules: [first, second],
      );
      final before = routing.modulesForType(_Entry);

      first.deserializationMetadata = ProtocolDeserialization(
        types: [_Entry],
        modules: [],
      );
      final after = routing.modulesForType(_Entry);

      expect(before, [second]);
      expect(after, [first, second]);
    },
  );

  test(
    'Given a cached route to a transitive owner, '
    'when that module removes its handler, '
    'then routing excludes the obsolete route.',
    () {
      final owner = _DeclaredProtocol(types: [_Entry]);
      final intermediary = _DeclaredProtocol(modules: [owner]);
      final routing = ProtocolDeserialization(
        types: [],
        modules: [intermediary],
      );
      final before = routing.modulesForType(_Entry);

      owner.deserializationMetadata = ProtocolDeserialization(
        types: [],
        modules: [],
      );
      final after = routing.modulesForType(_Entry);

      expect(before, [intermediary]);
      expect(after, isEmpty);
    },
  );

  test(
    'Given cached routes through a dependency cycle, '
    'when a reload replaces the cycle with an owning dependency, '
    'then routing excludes unrelated types and retains the owner.',
    () {
      final first = _DeclaredProtocol();
      final second = _DeclaredProtocol(modules: [first]);
      first.deserializationMetadata = ProtocolDeserialization(
        types: [],
        modules: [second],
      );
      final routing = ProtocolDeserialization(types: [], modules: [first]);
      final before = routing.modulesForType(_Entry);
      final unrelatedBefore = routing.modulesForType(_Other);
      final owner = _DeclaredProtocol(types: [_Entry]);

      second.deserializationMetadata = ProtocolDeserialization(
        types: [],
        modules: [owner],
      );
      final after = routing.modulesForType(_Entry);
      final other = routing.modulesForType(_Other);

      expect(before, [first]);
      expect(unrelatedBefore, [first]);
      expect(after, [first]);
      expect(other, isEmpty);
    },
  );

  test(
    'Given unrelated modules and a typed owner, '
    'when resolving the type, '
    'then only its owner remains eligible.',
    () {
      final unrelated = _DeclaredProtocol(types: {_Other});
      final owner = _DeclaredProtocol(types: {_Entry});
      final routing = ProtocolDeserialization(
        types: {},
        modules: [unrelated, owner],
      );

      final candidates = routing.modulesForType(_Entry);

      expect(candidates, [owner]);
    },
  );

  test(
    'Given legacy modules around a known owner, '
    'when resolving the type repeatedly, '
    'then legacy modules retain their original precedence.',
    () {
      final before = _LegacyProtocol();
      final owner = _DeclaredProtocol(types: {_Entry});
      final after = _LegacyProtocol();
      final routing = ProtocolDeserialization(
        types: {},
        modules: [before, _DeclaredProtocol(), owner, after],
      );

      final first = routing.modulesForType(_Entry);
      final second = routing.modulesForType(_Entry);

      expect(first, [before, owner, after]);
      expect(second, [before, owner, after]);
    },
  );

  test(
    'Given a transitive owner behind a module, '
    'when resolving its nullable container type, '
    'then the path to that owner remains eligible.',
    () {
      final owner = _DeclaredProtocol(types: {getType<List<_Entry?>?>()});
      final intermediary = _DeclaredProtocol(modules: [owner]);
      final routing = ProtocolDeserialization(
        types: {},
        modules: [_DeclaredProtocol(), intermediary],
      );

      final candidates = routing.modulesForType(getType<List<_Entry?>?>());

      expect(candidates, [intermediary]);
      expect(
        intermediary.deserializationMetadata.modulesForType(
          getType<List<_Entry?>?>(),
        ),
        [owner],
      );
    },
  );

  test(
    'Given a legacy module behind a regenerated module, '
    'when resolving an undeclared type, '
    'then the transitive legacy fallback remains eligible.',
    () {
      final legacy = _LegacyProtocol();
      final intermediary = _DeclaredProtocol(modules: [legacy]);
      final routing = ProtocolDeserialization(
        types: {},
        modules: [_DeclaredProtocol(), intermediary],
      );

      final candidates = routing.modulesForType(_Entry);

      expect(candidates, [intermediary]);
    },
  );

  test(
    'Given overlapping declarations, '
    'when resolving their shared type, '
    'then every owner retains its fallback position.',
    () {
      final first = _DeclaredProtocol(types: {_Entry});
      final second = _DeclaredProtocol(types: {_Entry});
      final routing = ProtocolDeserialization(
        types: {},
        modules: [first, second],
      );

      final candidates = routing.modulesForType(_Entry);

      expect(candidates, [first, second]);
    },
  );

  test(
    'Given a module with only inherited primitive handlers, '
    'when resolving a nullable primitive before an explicit owner, '
    'then inherited handlers keep their precedence.',
    () {
      final inherited = _DeclaredProtocol();
      final explicit = _DeclaredProtocol(types: {getType<int?>()});
      final routing = ProtocolDeserialization(
        types: {},
        modules: [inherited, explicit],
      );

      final candidates = routing.modulesForType(getType<int?>());

      expect(candidates, [inherited, explicit]);
    },
  );

  test(
    'Given immutable protocol declarations, '
    'when caller-owned collections change after construction, '
    'then routing retains the declared types and modules.',
    () {
      final types = <Type>[_Entry];
      final owner = _DeclaredProtocol(types: types);
      final modules = <SerializationManager>[owner];
      final routing = ProtocolDeserialization(types: {}, modules: modules);

      types.clear();
      modules.clear();
      final candidates = routing.modulesForType(_Entry);

      expect(candidates, [owner]);
      expect(routing.modules, [owner]);
      expect(() => candidates.clear(), throwsUnsupportedError);
      expect(() => routing.modules.clear(), throwsUnsupportedError);
    },
  );

  test(
    'Given a dependency cycle after a known owner, '
    'when resolving the owned type, '
    'then planning terminates and preserves the cyclic fallback after its owner.',
    () {
      final owner = _DeclaredProtocol(types: {_Entry});
      final first = _RecursiveProtocol();
      final second = _RecursiveProtocol();
      first.deserializationMetadata = ProtocolDeserialization(
        types: [],
        modules: [second],
      );
      second.deserializationMetadata = ProtocolDeserialization(
        types: [],
        modules: [first],
      );
      final routing = ProtocolDeserialization(
        types: [],
        modules: [owner, first],
      );

      final candidates = routing.modulesForType(_Entry);
      final repeated = routing.modulesForType(_Entry);

      expect(candidates, [owner, first]);
      expect(repeated, [owner, first]);
    },
  );

  test(
    'Given a self-dependent module before an owner, '
    'when resolving the owned type, '
    'then planning retains the original fallback order.',
    () {
      final cyclic = _RecursiveProtocol();
      cyclic.deserializationMetadata = ProtocolDeserialization(
        types: [],
        modules: [cyclic],
      );
      final owner = _DeclaredProtocol(types: {_Entry});
      final routing = ProtocolDeserialization(
        types: [],
        modules: [cyclic, owner],
      );

      final candidates = routing.modulesForType(_Entry);

      expect(candidates, [cyclic, owner]);
    },
  );

  test(
    'Given no legacy modules or declared handlers, '
    'when resolving an unknown type, '
    'then no module is eligible.',
    () {
      final routing = ProtocolDeserialization(
        types: {},
        modules: [_DeclaredProtocol()],
      );

      final candidates = routing.modulesForType(_Entry);

      expect(candidates, isEmpty);
    },
  );
}
