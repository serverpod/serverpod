import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    hide Protocol;
import 'package:test/test.dart';

void main() {
  test(
    'Given a PolymorphicParent object '
    'when serialized '
    'then it produces the JSON with the className key containing only the class name.',
    () {
      final parent = PolymorphicParent(
        parent: 'This is a parent',
      );

      final json = parent.toJson();

      expect(json['__className__'], 'PolymorphicParent');
      expect(json['parent'], 'This is a parent');
    },
  );

  test(
    'Given a PolymorphicChild object '
    'when serialized '
    'then it produces the JSON with the className key containing only the class name.',
    () {
      final child = PolymorphicChild(
        parent: 'This is a parent',
        child: 'This is a child',
      );

      final json = child.toJson();

      expect(json['__className__'], 'PolymorphicChild');
      expect(json['child'], 'This is a child');
      expect(json['parent'], 'This is a parent');
    },
  );

  test(
    'Given a PolymorphicGrandChild object '
    'when serialized '
    'then it produces the JSON with the className key containing only the class name.',
    () {
      final grandPolymorphicChild = PolymorphicGrandChild(
        parent: 'This is a parent',
        child: 'This is a child',
        grandchild: 'This is a grandchild',
      );

      final json = grandPolymorphicChild.toJson();

      expect(json['__className__'], 'PolymorphicGrandChild');
      expect(json['grandchild'], 'This is a grandchild');
      expect(json['child'], 'This is a child');
      expect(json['parent'], 'This is a parent');
    },
  );

  test(
    'Given a ModulePolymorphicParent object '
    'when serialized '
    'then it produces the JSON with the className key containing the class name prefixed with the module namespace.',
    () {
      final moduleParent = ModulePolymorphicParent(
        parent: 'This is a parent',
      );

      final json = moduleParent.toJson();

      expect(
        json['__className__'],
        'serverpod_test_module.ModulePolymorphicParent',
      );
      expect(json['parent'], 'This is a parent');
    },
  );

  test(
    'Given a ModulePolymorphicChild object '
    'when serialized '
    'then it produces the JSON with the className key containing the class name prefixed with the module namespace.',
    () {
      final moduleChild = ModulePolymorphicChild(
        parent: 'This is a parent',
        child: 'This is a child',
      );

      final json = moduleChild.toJson();

      expect(
        json['__className__'],
        'serverpod_test_module.ModulePolymorphicChild',
      );
      expect(json['child'], 'This is a child');
      expect(json['parent'], 'This is a parent');
    },
  );

  test(
    'Given a ModulePolymorphicGrandChild object '
    'when serialized '
    'then it produces the JSON with the className key containing the class name prefixed with the module namespace.',
    () {
      final moduleGrandChild = ModulePolymorphicGrandChild(
        parent: 'This is a parent',
        child: 'This is a child',
        grandchild: 'This is a grandchild',
      );

      final json = moduleGrandChild.toJson();

      expect(
        json['__className__'],
        'serverpod_test_module.ModulePolymorphicGrandChild',
      );
      expect(json['grandchild'], 'This is a grandchild');
      expect(json['child'], 'This is a child');
      expect(json['parent'], 'This is a parent');
    },
  );

  test(
    'Given a backwards-compatible PolymorphicParent JSON without className field '
    'when deserialized '
    'then it deserializes as PolymorphicParent.',
    () {
      final json = {
        'parent': 'This is a parent',
      };

      final deserialized = Protocol().deserialize<PolymorphicParent>(json);

      expect(deserialized, isA<PolymorphicParent>());
      expect(deserialized.parent, 'This is a parent');
    },
  );

  test(
    'Given a backwards-compatible PolymorphicChild JSON without className field '
    'when deserialized '
    'then it deserializes as PolymorphicChild.',
    () {
      final json = {
        'parent': 'This is a parent',
        'child': 'This is a child',
      };

      final deserialized = Protocol().deserialize<PolymorphicChild>(json);

      expect(deserialized, isA<PolymorphicChild>());
      expect(deserialized.parent, 'This is a parent');
      expect(deserialized.child, 'This is a child');
    },
  );

  test(
    'Given a backwards-compatible PolymorphicGrandChild JSON without className field '
    'when deserialized '
    'then it deserializes as PolymorphicGrandChild.',
    () {
      final json = {
        'parent': 'This is a parent',
        'child': 'This is a child',
        'grandchild': 'This is a grandchild',
      };

      final deserialized = Protocol().deserialize<PolymorphicGrandChild>(json);

      expect(deserialized, isA<PolymorphicGrandChild>());
      expect(deserialized.parent, 'This is a parent');
      expect(deserialized.child, 'This is a child');
      expect(deserialized.grandchild, 'This is a grandchild');
    },
  );

  test('Given a PolymorphicChild object '
      'when deserialized as PolymorphicParent '
      'then it maintains the runtimeType as PolymorphicChild.', () {
    final child = PolymorphicChild(
      parent: 'This is a parent',
      child: 'This is a child',
    );

    final json = child.toJson();
    final deserialized = Protocol().deserialize<PolymorphicParent>(json);

    expect(deserialized.parent, 'This is a parent');
    expect(deserialized, isA<PolymorphicChild>());
    deserialized as PolymorphicChild;
    expect(deserialized.child, 'This is a child');
  });

  test('Given a PolymorphicGrandChild object '
      'when deserialized as PolymorphicParent '
      'then it maintains the runtimeType as PolymorphicGrandChild.', () {
    final grandPolymorphicChild = PolymorphicGrandChild(
      parent: 'This is a parent',
      child: 'This is a child',
      grandchild: 'This is a grandchild',
    );

    final json = grandPolymorphicChild.toJson();
    final deserialized = Protocol().deserialize<PolymorphicParent>(json);

    expect(deserialized.parent, 'This is a parent');
    expect(deserialized, isA<PolymorphicGrandChild>());
    deserialized as PolymorphicGrandChild;
    expect(deserialized.child, 'This is a child');
    expect(deserialized.grandchild, 'This is a grandchild');
  });

  test('Given a class that holds PolymorphicChild objects in a container '
      'when deserialized '
      'then PolymorphicGrandChild objects maintain their runtime type.', () {
    final container = PolymorphicChildContainer(
      child: PolymorphicGrandChild(
        parent: 'PolymorphicParent 1',
        child: 'PolymorphicChild 1',
        grandchild: 'PolymorphicGrandChild 1',
      ),
      childrenList: [
        PolymorphicChild(
          parent: 'PolymorphicParent 2',
          child: 'PolymorphicChild 2',
        ),
        PolymorphicGrandChild(
          parent: 'PolymorphicParent 3',
          child: 'PolymorphicChild 3',
          grandchild: 'PolymorphicGrandChild 3',
        ),
      ],
      nullableChildrenList: [
        null,
        PolymorphicGrandChild(
          parent: 'PolymorphicParent 6',
          child: 'PolymorphicChild 6',
          grandchild: 'PolymorphicGrandChild 6',
        ),
      ],
      childrenMap: {
        'child4': PolymorphicChild(
          parent: 'PolymorphicParent 4',
          child: 'PolymorphicChild 4',
        ),
        'child5': PolymorphicGrandChild(
          parent: 'PolymorphicParent 5',
          child: 'PolymorphicChild 5',
          grandchild: 'PolymorphicGrandChild 5',
        ),
      },
      nullableChildrenMap: {
        'child7': null,
        'child8': PolymorphicGrandChild(
          parent: 'PolymorphicParent 8',
          child: 'PolymorphicChild 8',
          grandchild: 'PolymorphicGrandChild 8',
        ),
      },
    );

    final json = container.toJson();
    final deserialized = Protocol().deserialize<PolymorphicChildContainer>(
      json,
    );

    expect(deserialized.child, isA<PolymorphicGrandChild>());
    expect(deserialized.childrenList[0], isA<PolymorphicChild>());
    expect(deserialized.childrenList[0], isNot(isA<PolymorphicGrandChild>()));
    expect(deserialized.childrenList[1], isA<PolymorphicGrandChild>());
    expect(deserialized.childrenMap['child4'], isA<PolymorphicChild>());
    expect(
      deserialized.childrenMap['child4'],
      isNot(isA<PolymorphicGrandChild>()),
    );
    expect(deserialized.childrenMap['child5'], isA<PolymorphicGrandChild>());
    expect(deserialized.nullableChildrenList[0], isNull);
    expect(deserialized.nullableChildrenList[1], isA<PolymorphicGrandChild>());
    expect(deserialized.nullableChildrenMap['child7'], isNull);
    expect(
      deserialized.nullableChildrenMap['child8'],
      isA<PolymorphicGrandChild>(),
    );
  });

  test(
    'Given a class that holds ModulePolymorphicChild objects defined in a module in a container '
    'when deserialized '
    'then ModulePolymorphicChild objects maintain their runtime type.',
    () {
      final container = ModulePolymorphicChildContainer(
        moduleObject: ModulePolymorphicGrandChild(
          parent: 'ModulePolymorphicParent 1',
          child: 'ModulePolymorphicChild 1',
          grandchild: 'ModulePolymorphicGrandChild 1',
        ),
        moduleObjectList: [
          ModulePolymorphicChild(
            parent: 'ModulePolymorphicParent 2',
            child: 'ModulePolymorphicChild 2',
          ),
          ModulePolymorphicGrandChild(
            parent: 'ModulePolymorphicParent 3',
            child: 'ModulePolymorphicChild 3',
            grandchild: 'ModulePolymorphicGrandChild 3',
          ),
        ],
        moduleObjectMap: {
          'child4': ModulePolymorphicChild(
            parent: 'ModulePolymorphicParent 4',
            child: 'ModulePolymorphicChild 4',
          ),
          'child5': ModulePolymorphicGrandChild(
            parent: 'ModulePolymorphicParent 5',
            child: 'ModulePolymorphicChild 5',
            grandchild: 'ModulePolymorphicGrandChild 5',
          ),
        },
      );

      final json = container.toJson();
      final deserialized = Protocol()
          .deserialize<ModulePolymorphicChildContainer>(json);

      expect(deserialized.moduleObject, isA<ModulePolymorphicGrandChild>());
      expect(deserialized.moduleObjectList[0], isA<ModulePolymorphicChild>());
      expect(
        deserialized.moduleObjectList[0],
        isNot(isA<ModulePolymorphicGrandChild>()),
      );
      expect(
        deserialized.moduleObjectList[1],
        isA<ModulePolymorphicGrandChild>(),
      );
      expect(
        deserialized.moduleObjectMap['child4'],
        isA<ModulePolymorphicChild>(),
      );
      expect(
        deserialized.moduleObjectMap['child4'],
        isNot(isA<ModulePolymorphicGrandChild>()),
      );
    },
  );

  // NOTE: This test would not fail before the changes to support polymorphism.
  // If a class was a subset of another with same types on all common fields,
  // it would deserialize as the other class.
  test('Given an object that has all fields of PolymorphicParent '
      'when deserialized as PolymorphicParent then '
      'it raises an exception.', () {
    final other = SimilarButNotParent(parent: 'This is not a parent');

    final json = other.toJson();

    expect(
      () => Protocol().deserialize<PolymorphicParent>(json),
      throwsA(isA<TypeError>()),
    );
  });

  test('Given an unrelated object that does not have PolymorphicParent fields '
      'when deserialized as PolymorphicParent '
      'then it raises an exception.', () {
    final unrelated = UnrelatedToPolymorphism(
      unrelated: 'An unrelated message',
    );

    final json = unrelated.toJson();

    expect(
      () => Protocol().deserialize<PolymorphicParent>(json),
      throwsA(isA<TypeError>()),
    );
  });

  test(
    'Given a PolymorphicChild object wrapped with the parent className '
    'when deserialized using deserializeByClassName '
    'then it deserializes correctly as the object type.',
    () {
      final child = PolymorphicChild(
        parent: 'This is a parent',
        child: 'This is a child',
      );

      final json = child.toJson();
      final deserialized = Protocol().deserializeByClassName({
        'className': 'PolymorphicParent',
        'data': json,
      });

      expect(deserialized, isA<PolymorphicChild>());
      deserialized as PolymorphicChild;
      expect(deserialized.parent, 'This is a parent');
      expect(deserialized.child, 'This is a child');
    },
  );

  test(
    'Given a ModulePolymorphicGrandChild object wrapped with the parent className '
    'when deserialized using deserializeByClassName '
    'then it deserializes correctly as the object type.',
    () {
      final moduleGrandChild = ModulePolymorphicGrandChild(
        parent: 'Module parent',
        child: 'Module child',
        grandchild: 'Module grandchild',
      );

      final json = moduleGrandChild.toJson();
      final deserialized = Protocol().deserializeByClassName({
        'className': 'serverpod_test_module.ModulePolymorphicParent',
        'data': json,
      });

      expect(deserialized, isA<ModulePolymorphicGrandChild>());
      deserialized as ModulePolymorphicGrandChild;
      expect(deserialized.parent, 'Module parent');
      expect(deserialized.child, 'Module child');
      expect(deserialized.grandchild, 'Module grandchild');
    },
  );
}
