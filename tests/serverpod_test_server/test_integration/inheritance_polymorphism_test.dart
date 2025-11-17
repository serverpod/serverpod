import 'dart:async';

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    hide Protocol;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() async {
  withServerpod('Polymorphism Integration Tests', (sessionBuilder, endpoints) {
    late String runtimeType;
    late PolymorphicParent returned;

    group('Given a PolymorphicParent object '
        'when sent through polymorphicRoundtrip', () {
      final original = PolymorphicParent(parent: 'This is a parent');

      setUpAll(() async {
        (runtimeType, returned) = await endpoints.inheritancePolymorphismTest
            .polymorphicRoundtrip(sessionBuilder, original);
      });

      test(
        'then the object received on the server has the expected runtimeType.',
        () async {
          expect(runtimeType, 'PolymorphicParent');
        },
      );

      test('then the returned object has the expected type.', () async {
        expect(returned, isA<PolymorphicParent>());
      });

      test('then the returned object matches the original.', () async {
        expect(returned.toJson(), original.toJson());
      });
    });

    group('Given a PolymorphicChild object '
        'when sent through polymorphicRoundtrip', () {
      final original = PolymorphicChild(
        parent: 'This is a parent',
        child: 'This is a child',
      );

      setUpAll(() async {
        (runtimeType, returned) = await endpoints.inheritancePolymorphismTest
            .polymorphicRoundtrip(sessionBuilder, original);
      });

      test(
        'then the object received on the server has the expected runtimeType.',
        () async {
          expect(runtimeType, 'PolymorphicChild');
        },
      );

      test('then the returned object has the expected type.', () async {
        expect(returned, isA<PolymorphicChild>());
      });

      test('then the returned object matches the original.', () async {
        expect(returned.toJson(), original.toJson());
      });
    });

    group('Given a PolymorphicGrandChild object '
        'when sent through polymorphicRoundtrip', () {
      final original = PolymorphicGrandChild(
        parent: 'This is a parent',
        child: 'This is a child',
        grandchild: 'This is a grandchild',
      );

      setUpAll(() async {
        (runtimeType, returned) = await endpoints.inheritancePolymorphismTest
            .polymorphicRoundtrip(sessionBuilder, original);
      });

      test(
        'then the object received on the server has the expected runtimeType.',
        () async {
          expect(runtimeType, '_PolymorphicGrandChildImpl');
        },
      );

      test('then the returned object has the expected type.', () async {
        expect(returned, isA<PolymorphicGrandChild>());
      });

      test('then the returned object matches the original.', () async {
        expect(returned.toJson(), original.toJson());
      });
    });

    group('Given a PolymorphicChildContainer object '
        'when sent through polymorphicContainerRoundtrip', () {
      var original = PolymorphicChildContainer(
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

      late PolymorphicChildContainer returned;
      setUpAll(() async {
        returned = await endpoints.inheritancePolymorphismTest
            .polymorphicContainerRoundtrip(sessionBuilder, original);
      });

      test(
        'then all polymorphic objects in the returned object has the expected types.',
        () {
          expect(returned.child, isA<PolymorphicGrandChild>());

          var childrenList = returned.childrenList;
          expect(childrenList[0], isA<PolymorphicChild>());
          expect(childrenList[0], isNot(isA<PolymorphicGrandChild>()));
          expect(childrenList[1], isA<PolymorphicGrandChild>());

          var childrenMap = returned.childrenMap;
          expect(childrenMap['child4'], isA<PolymorphicChild>());
          expect(childrenMap['child4'], isNot(isA<PolymorphicGrandChild>()));
          expect(childrenMap['child5'], isA<PolymorphicGrandChild>());
        },
      );

      test('then the returned object matches the original.', () async {
        expect(returned.toJson(), original.toJson());
      });
    });

    group('Given a ModulePolymorphicChildContainer object '
        'when sent through polymorphicContainerRoundtrip', () {
      var original = ModulePolymorphicChildContainer(
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

      late ModulePolymorphicChildContainer returned;
      setUpAll(() async {
        returned = await endpoints.inheritancePolymorphismTest
            .polymorphicModuleContainerRoundtrip(sessionBuilder, original);
      });

      test(
        'then all polymorphic objects in the returned object has the expected types.',
        () {
          expect(returned.moduleObject, isA<ModulePolymorphicGrandChild>());

          var moduleObjectList = returned.moduleObjectList;
          expect(moduleObjectList[0], isA<ModulePolymorphicChild>());
          expect(
            moduleObjectList[0],
            isNot(isA<ModulePolymorphicGrandChild>()),
          );
          expect(moduleObjectList[1], isA<ModulePolymorphicGrandChild>());

          var moduleObjectMap = returned.moduleObjectMap;
          expect(moduleObjectMap['child4'], isA<ModulePolymorphicChild>());
          expect(
            moduleObjectMap['child4'],
            isNot(isA<ModulePolymorphicGrandChild>()),
          );
          expect(moduleObjectMap['child5'], isA<ModulePolymorphicGrandChild>());
        },
      );

      test('then the returned object matches the original.', () async {
        expect(returned.toJson(), original.toJson());
      });
    });

    // NOTE: This already worked before the polymorphism fix due to the usage
    // of `deserializeByClassName` on the streaming endpoint.
    group('Given a PolymorphicChild object '
        'when sent through polymorphicStreamingRoundtrip', () {
      final original = PolymorphicChild(
        parent: 'This is a parent',
        child: 'This is a child',
      );

      late List<(String, PolymorphicParent)> results;

      setUpAll(() async {
        final stream = Stream<PolymorphicParent>.value(original);
        final outputStream = endpoints.inheritancePolymorphismTest
            .polymorphicStreamingRoundtrip(sessionBuilder, stream);
        results = await outputStream.toList();
      });

      test(
        'then the object received on the server has the expected runtimeType.',
        () {
          expect(results.length, 1);
          expect(results[0].$1, 'PolymorphicChild');
        },
      );

      test('then the returned object has the expected type.', () {
        expect(results[0].$2, isA<PolymorphicChild>());
      });

      test('then the returned object matches the original.', () {
        expect(results[0].$2.toJson(), original.toJson());
      });
    });
  });
}
