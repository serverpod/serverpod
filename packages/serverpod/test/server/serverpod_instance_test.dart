import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

// NOTE: This file must never construct a Serverpod. `Serverpod.instance` is
// backed by a static field that is set the first time a Serverpod is created,
// so the "not initialized" state only holds in an isolate where no Serverpod
// exists. `dart test` runs each test file in its own isolate, which keeps this
// guarantee.
void main() {
  group('Given no Serverpod has been initialized, ', () {
    test(
      'when Serverpod.instance is accessed then a StateError is thrown.',
      () {
        expect(
          () => Serverpod.instance,
          throwsA(
            isA<StateError>().having(
              (e) => e.message,
              'message',
              'Serverpod has not been initialized. You need to create '
                  'the Serverpod object before calling this method.',
            ),
          ),
        );
      },
    );
  });
}
