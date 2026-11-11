import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

class _Entry {}

class _Other {}

class _LegacyProtocol extends SerializationManager {}

class _Protocol extends SerializationManager
    implements ProtocolDeserializationProvider {
  @override
  late ProtocolDeserialization deserializationMetadata;

  _Protocol({
    Iterable<Type> types = const [],
    Iterable<String>? classNames = const [],
    String? prefix,
    List<SerializationManager> modules = const [],
  }) {
    deserializationMetadata = ProtocolDeserialization(
      types: types,
      classNames: classNames,
      classNamePrefix: prefix,
      modules: modules,
    );
  }
}

void main() {
  test(
    'Given a tagged model behind unrelated module dependencies, '
    'when resolving its route, '
    'then only the dependency reaching its owner is eligible.',
    () {
      final unrelated = _Protocol(classNames: ['Other']);
      final owner = _Protocol(
        types: [_Entry],
        classNames: ['Entry'],
        prefix: 'owner.',
      );
      final middle = _Protocol(modules: [unrelated, owner]);
      final root = _Protocol(modules: [unrelated, middle]);
      const requestedType = _Entry;
      const className = 'owner.Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [middle]);
    },
  );

  test(
    'Given an Object request with a module class discriminator, '
    'when resolving its route, '
    'then the class owner remains eligible without an Object handler.',
    () {
      final owner = _Protocol(classNames: ['Entry'], prefix: 'owner.');
      final root = _Protocol(modules: [_Protocol(), owner]);
      const requestedType = Object;
      const className = 'owner.Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [owner]);
    },
  );

  test(
    'Given a dynamic request with a module class discriminator, '
    'when resolving its route, '
    'then the class owner remains eligible without a dynamic handler.',
    () {
      final owner = _Protocol(classNames: ['Entry'], prefix: 'owner.');
      final root = _Protocol(modules: [_Protocol(), owner]);
      const requestedType = dynamic;
      const className = 'owner.Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [owner]);
    },
  );

  test(
    'Given identically named module classes and a qualified discriminator, '
    'when resolving its route, '
    'then only the named module is eligible.',
    () {
      final first = _Protocol(classNames: ['Entry'], prefix: 'first.');
      final second = _Protocol(classNames: ['Entry'], prefix: 'second.');
      final root = _Protocol(modules: [first, second]);
      const requestedType = Object;
      const className = 'second.Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [second]);
    },
  );

  test(
    'Given identically named module classes and an unqualified discriminator, '
    'when resolving its route, '
    'then both owners retain their original precedence.',
    () {
      final first = _Protocol(classNames: ['Entry'], prefix: 'first.');
      final second = _Protocol(classNames: ['Entry'], prefix: 'second.');
      final root = _Protocol(modules: [first, second]);
      const requestedType = Object;
      const className = 'Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [first, second]);
    },
  );

  test(
    'Given a tagged payload with an expected-type owner before its class-name owner, '
    'when resolving its route, '
    'then both candidates retain the existing fallback order.',
    () {
      final typed = _Protocol(types: [_Entry]);
      final tagged = _Protocol(classNames: ['Child']);
      final root = _Protocol(modules: [typed, _Protocol(), tagged]);
      const requestedType = _Entry;
      const className = 'Child';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [typed, tagged]);
    },
  );

  test(
    'Given an unknown subtype discriminator and a known expected type, '
    'when resolving its route, '
    'then the expected-type fallback remains eligible.',
    () {
      final owner = _Protocol(types: [_Entry], classNames: ['Entry']);
      final root = _Protocol(modules: [_Protocol(), owner]);
      const requestedType = _Entry;
      const className = 'NewChild';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [owner]);
    },
  );

  test(
    'Given a tagged payload and a module generated before class-name declarations, '
    'when resolving its route, '
    'then its unknown class-name handlers remain eligible.',
    () {
      final old = _Protocol(types: [_Other], classNames: null);
      final owner = _Protocol(classNames: ['Entry']);
      final root = _Protocol(modules: [_Protocol(), old, owner]);
      const requestedType = Object;
      const className = 'Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [old, owner]);
    },
  );

  test(
    'Given a tagged payload and a legacy module without routing metadata, '
    'when resolving its route, '
    'then the legacy module retains its original precedence.',
    () {
      final legacy = _LegacyProtocol();
      final owner = _Protocol(classNames: ['Entry']);
      final root = _Protocol(modules: [legacy, _Protocol(), owner]);
      const requestedType = Object;
      const className = 'Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [legacy, owner]);
    },
  );

  test(
    'Given an Object request for int and modules inheriting primitive class-name handlers, '
    'when resolving its route, '
    'then every inherited handler remains eligible.',
    () {
      final first = _Protocol();
      final second = _Protocol();
      final root = _Protocol(modules: [first, second]);
      const requestedType = Object;
      const className = 'int';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [first, second]);
    },
  );

  test(
    'Given a dynamic request for List and modules inheriting container class-name handlers, '
    'when resolving its route, '
    'then every inherited handler remains eligible.',
    () {
      final first = _Protocol();
      final second = _Protocol();
      final root = _Protocol(modules: [first, second]);
      const requestedType = dynamic;
      const className = 'List';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [first, second]);
    },
  );

  test(
    'Given a qualified discriminator and a parent and transitive owner stripping the same prefix, '
    'when resolving its route, '
    'then every module plans against the original object discriminator.',
    () {
      final owner = _Protocol(classNames: ['shared.Entry'], prefix: 'shared.');
      final middle = _Protocol(prefix: 'shared.', modules: [owner]);
      final root = _Protocol(modules: [middle]);
      const requestedType = Object;
      const className = 'shared.shared.Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [middle]);
    },
  );

  test(
    'Given a tagged payload and cyclic module metadata before its class-name owner, '
    'when resolving its route, '
    'then route planning terminates and preserves conservative ordering.',
    () {
      final cyclic = _Protocol();
      cyclic.deserializationMetadata = ProtocolDeserialization(
        types: [],
        classNames: [],
        modules: [cyclic],
      );
      final owner = _Protocol(classNames: ['Entry']);
      final root = _Protocol(modules: [cyclic, owner]);
      const requestedType = Object;
      const className = 'Entry';

      final candidates = root.deserializationMetadata.modulesForDeserialization(
        requestedType,
        className: className,
      );

      expect(candidates, [cyclic, owner]);
    },
  );

  group('Given a cached class-name miss behind an unchanged parent,', () {
    late _Protocol owner;
    late _Protocol middle;
    late _Protocol root;
    late List<SerializationManager> before;

    setUpAll(() {
      owner = _Protocol();
      middle = _Protocol(modules: [owner]);
      root = _Protocol(modules: [middle]);
      before = root.deserializationMetadata.modulesForDeserialization(
        Object,
        className: 'Entry',
      );
    });

    group(
      'when the transitive module gains the handler and the route is resolved again,',
      () {
        late List<SerializationManager> after;

        setUpAll(() {
          owner.deserializationMetadata = ProtocolDeserialization(
            types: [],
            classNames: ['Entry'],
            modules: [],
          );
          after = root.deserializationMetadata.modulesForDeserialization(
            Object,
            className: 'Entry',
          );
        });

        test('then the initial lookup had no eligible module.', () {
          expect(before, isEmpty);
        });

        test('then the cached route discovers the new owner.', () {
          expect(after, [middle]);
        });
      },
    );
  });

  group('Given a cached route to a class-name owner,', () {
    late _Protocol owner;
    late _Protocol root;
    late List<SerializationManager> before;

    setUpAll(() {
      owner = _Protocol(classNames: ['Entry']);
      root = _Protocol(modules: [owner]);
      before = root.deserializationMetadata.modulesForDeserialization(
        Object,
        className: 'Entry',
      );
    });

    group('when the handler is removed and the route is resolved again,', () {
      late List<SerializationManager> after;

      setUpAll(() {
        owner.deserializationMetadata = ProtocolDeserialization(
          types: [],
          classNames: [],
          modules: [],
        );
        after = root.deserializationMetadata.modulesForDeserialization(
          Object,
          className: 'Entry',
        );
      });

      test('then the initial lookup included the owner.', () {
        expect(before, [owner]);
      });

      test('then the route no longer includes that module.', () {
        expect(after, isEmpty);
      });
    });
  });

  group('Given cached metadata with unchanged declarations and prefix,', () {
    late _Protocol protocol;
    late ProtocolDeserialization first;

    setUpAll(() {
      protocol = _Protocol();
      first = ProtocolDeserialization.cached(
        protocol,
        types: const [],
        modules: const [],
        classNames: const ['Entry'],
        classNamePrefix: 'owner.',
      );
    });

    test(
      'when requesting the metadata again, '
      'then the protocol reuses its metadata.',
      () {
        final second = ProtocolDeserialization.cached(
          protocol,
          types: const [],
          modules: const [],
          classNames: const ['Entry'],
          classNamePrefix: 'owner.',
        );

        expect(second, same(first));
      },
    );
  });

  group('Given cached metadata and replacement class-name declarations,', () {
    late _Protocol protocol;
    late ProtocolDeserialization first;
    late List<String> replacementClassNames;

    setUpAll(() {
      protocol = _Protocol();
      first = ProtocolDeserialization.cached(
        protocol,
        types: const [],
        modules: const [],
        classNames: const ['Entry'],
      );
      replacementClassNames = const ['Other'];
    });

    test(
      'when requesting metadata with the replacement declarations, '
      'then the protocol replaces its metadata.',
      () {
        final second = ProtocolDeserialization.cached(
          protocol,
          types: const [],
          modules: const [],
          classNames: replacementClassNames,
        );

        expect(second, isNot(same(first)));
      },
    );
  });

  group('Given cached metadata and a replacement normalization prefix,', () {
    late _Protocol protocol;
    late ProtocolDeserialization first;
    late String replacementPrefix;

    setUpAll(() {
      protocol = _Protocol();
      first = ProtocolDeserialization.cached(
        protocol,
        types: const [],
        modules: const [],
        classNames: const ['Entry'],
        classNamePrefix: 'first.',
      );
      replacementPrefix = 'second.';
    });

    test(
      'when requesting metadata with the replacement prefix, '
      'then the protocol replaces its metadata.',
      () {
        final second = ProtocolDeserialization.cached(
          protocol,
          types: const [],
          modules: const [],
          classNames: const ['Entry'],
          classNamePrefix: replacementPrefix,
        );

        expect(second, isNot(same(first)));
      },
    );
  });
}
