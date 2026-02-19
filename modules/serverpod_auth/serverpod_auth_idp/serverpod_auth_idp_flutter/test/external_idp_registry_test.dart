import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

// Mock endpoint types for testing
class MockIdpEndpoint extends EndpointIdpBase {
  MockIdpEndpoint(super.caller);

  @override
  String get name => 'mock';

  @override
  Future<bool> hasAccount() async => false;
}

class AnotherMockIdpEndpoint extends EndpointIdpBase {
  AnotherMockIdpEndpoint(super.caller);

  @override
  String get name => 'another';

  @override
  Future<bool> hasAccount() async => false;
}

class ThirdMockIdpEndpoint extends EndpointIdpBase {
  ThirdMockIdpEndpoint(super.caller);

  @override
  String get name => 'third';

  @override
  Future<bool> hasAccount() async => false;
}

// Mock widget builder for testing
Widget mockWidgetBuilder(
  BuildContext context,
  ServerpodClientShared client,
  VoidCallback? onAuthenticated,
  Function(Object error)? onError,
) {
  return Container();
}

Widget anotherMockWidgetBuilder(
  BuildContext context,
  ServerpodClientShared client,
  VoidCallback? onAuthenticated,
  Function(Object error)? onError,
) {
  return const SizedBox();
}

void main() {
  late ExternalIdpRegistry registry;

  setUp(() {
    registry = ExternalIdpRegistry.instance;
    registry.clear();
  });

  tearDown(() {
    registry.clear();
  });

  group('Given an empty registry', () {
    test(
      'when calling hasBuilder then it returns false.',
      () {
        final result = registry.hasBuilder<MockIdpEndpoint>();
        expect(result, isFalse);
      },
    );

    test(
      'when calling getBuilder then it returns null.',
      () {
        final builder = registry.getBuilder<MockIdpEndpoint>();
        expect(builder, isNull);
      },
    );

    test(
      'when calling unregister then it returns false.',
      () {
        final result = registry.unregister<MockIdpEndpoint>();
        expect(result, isFalse);
      },
    );

    test(
      'when calling registeredTypes then it returns empty list.',
      () {
        final types = registry.registeredTypes;
        expect(types, isEmpty);
      },
    );

    test(
      'when calling count then it returns 0.',
      () {
        final count = registry.count;
        expect(count, equals(0));
      },
    );

    test(
      'when calling hasRegistrations then it returns false.',
      () {
        final result = registry.hasRegistrations;
        expect(result, isFalse);
      },
    );

    test(
      'when registering a builder then it succeeds.',
      () {
        expect(
          () => registry.register<MockIdpEndpoint>(mockWidgetBuilder),
          returnsNormally,
        );
        expect(registry.hasBuilder<MockIdpEndpoint>(), isTrue);
      },
    );
  });

  group('Given a registry with one registered provider', () {
    setUp(() {
      registry.register<MockIdpEndpoint>(mockWidgetBuilder);
    });

    test(
      'when calling hasBuilder for registered type then it returns true.',
      () {
        final result = registry.hasBuilder<MockIdpEndpoint>();
        expect(result, isTrue);
      },
    );

    test(
      'when calling hasBuilder for unregistered type then it returns false.',
      () {
        final result = registry.hasBuilder<AnotherMockIdpEndpoint>();
        expect(result, isFalse);
      },
    );

    test(
      'when calling getBuilder for registered type then it returns the builder.',
      () {
        final builder = registry.getBuilder<MockIdpEndpoint>();
        expect(builder, isNotNull);
        expect(builder, equals(mockWidgetBuilder));
      },
    );

    test(
      'when calling getBuilder for unregistered type then it returns null.',
      () {
        final builder = registry.getBuilder<AnotherMockIdpEndpoint>();
        expect(builder, isNull);
      },
    );

    test(
      'when calling registeredTypes then it returns list with one type.',
      () {
        final types = registry.registeredTypes;
        expect(types, hasLength(1));
        expect(types, contains(MockIdpEndpoint));
      },
    );

    test(
      'when calling count then it returns 1.',
      () {
        final count = registry.count;
        expect(count, equals(1));
      },
    );

    test(
      'when calling hasRegistrations then it returns true.',
      () {
        final result = registry.hasRegistrations;
        expect(result, isTrue);
      },
    );

    test(
      'when unregistering the registered type then it returns true.',
      () {
        final result = registry.unregister<MockIdpEndpoint>();
        expect(result, isTrue);
        expect(registry.hasBuilder<MockIdpEndpoint>(), isFalse);
      },
    );

    test(
      'when unregistering an unregistered type then it returns false.',
      () {
        final result = registry.unregister<AnotherMockIdpEndpoint>();
        expect(result, isFalse);
        expect(registry.hasBuilder<MockIdpEndpoint>(), isTrue);
      },
    );

    test(
      'when registering the same type again then it throws StateError.',
      () {
        expect(
          () => registry.register<MockIdpEndpoint>(anotherMockWidgetBuilder),
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              contains('already registered'),
            ),
          ),
        );
      },
    );

    test(
      'when registering a different type then it succeeds.',
      () {
        expect(
          () => registry.register<AnotherMockIdpEndpoint>(
            anotherMockWidgetBuilder,
          ),
          returnsNormally,
        );
        expect(registry.count, equals(2));
        expect(registry.hasBuilder<MockIdpEndpoint>(), isTrue);
        expect(registry.hasBuilder<AnotherMockIdpEndpoint>(), isTrue);
      },
    );

    test(
      'when calling clear then all registrations are removed.',
      () {
        registry.clear();
        expect(registry.hasRegistrations, isFalse);
        expect(registry.count, equals(0));
        expect(registry.hasBuilder<MockIdpEndpoint>(), isFalse);
      },
    );
  });

  group('Given a registry with multiple registered providers', () {
    setUp(() {
      registry.register<MockIdpEndpoint>(mockWidgetBuilder);
      registry.register<AnotherMockIdpEndpoint>(anotherMockWidgetBuilder);
      registry.register<ThirdMockIdpEndpoint>(mockWidgetBuilder);
    });

    test(
      'when calling registeredTypes then it returns all registered types.',
      () {
        final types = registry.registeredTypes;
        expect(types, hasLength(3));
        expect(types, contains(MockIdpEndpoint));
        expect(types, contains(AnotherMockIdpEndpoint));
        expect(types, contains(ThirdMockIdpEndpoint));
      },
    );

    test(
      'when calling count then it returns 3.',
      () {
        final count = registry.count;
        expect(count, equals(3));
      },
    );

    test(
      'when calling hasRegistrations then it returns true.',
      () {
        final result = registry.hasRegistrations;
        expect(result, isTrue);
      },
    );

    test(
      'when unregistering one type then others remain registered.',
      () {
        final result = registry.unregister<MockIdpEndpoint>();
        expect(result, isTrue);
        expect(registry.count, equals(2));
        expect(registry.hasBuilder<MockIdpEndpoint>(), isFalse);
        expect(registry.hasBuilder<AnotherMockIdpEndpoint>(), isTrue);
        expect(registry.hasBuilder<ThirdMockIdpEndpoint>(), isTrue);
      },
    );

    test(
      'when calling clear then all registrations are removed.',
      () {
        registry.clear();
        expect(registry.hasRegistrations, isFalse);
        expect(registry.count, equals(0));
        expect(registry.registeredTypes, isEmpty);
        expect(registry.hasBuilder<MockIdpEndpoint>(), isFalse);
        expect(registry.hasBuilder<AnotherMockIdpEndpoint>(), isFalse);
        expect(registry.hasBuilder<ThirdMockIdpEndpoint>(), isFalse);
      },
    );

    test(
      'when getting builder for each type then correct builder is returned.',
      () {
        final builder1 = registry.getBuilder<MockIdpEndpoint>();
        final builder2 = registry.getBuilder<AnotherMockIdpEndpoint>();
        final builder3 = registry.getBuilder<ThirdMockIdpEndpoint>();

        expect(builder1, equals(mockWidgetBuilder));
        expect(builder2, equals(anotherMockWidgetBuilder));
        expect(builder3, equals(mockWidgetBuilder));
      },
    );
  });

  group('Given a registry after clear', () {
    setUp(() {
      registry.register<MockIdpEndpoint>(mockWidgetBuilder);
      registry.clear();
    });

    test(
      'when registering the previously registered type then it succeeds.',
      () {
        expect(
          () => registry.register<MockIdpEndpoint>(mockWidgetBuilder),
          returnsNormally,
        );
        expect(registry.hasBuilder<MockIdpEndpoint>(), isTrue);
      },
    );

    test(
      'when checking state then registry is empty.',
      () {
        expect(registry.hasRegistrations, isFalse);
        expect(registry.count, equals(0));
        expect(registry.hasBuilder<MockIdpEndpoint>(), isFalse);
      },
    );
  });
}
