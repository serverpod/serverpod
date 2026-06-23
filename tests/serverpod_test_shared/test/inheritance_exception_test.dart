import 'package:serverpod_test_shared/serverpod_test_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a SharedNotFoundException object '
    'when serialized '
    'then it produces JSON with the concrete exception class name.',
    () {
      final exception = SharedNotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final json = exception.toJson();

      expect(json['__className__'], 'SharedNotFoundException');
      expect(json['message'], 'Resource missing');
      expect(json['code'], 404);
    },
  );

  test(
    'Given a SharedValidationException object '
    'when serialized '
    'then it produces JSON with the concrete exception class name.',
    () {
      final exception = SharedValidationException(
        message: 'Invalid input',
        field: 'email',
      );

      final json = exception.toJson();

      expect(json['__className__'], 'SharedValidationException');
      expect(json['message'], 'Invalid input');
      expect(json['field'], 'email');
    },
  );

  test(
    'Given a SharedNotFoundException object '
    'when deserialized as SharedSealedAppException '
    'then it maintains the runtime type.',
    () {
      final exception = SharedNotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final json = exception.toJson();
      final deserialized = Protocol().deserialize<SharedSealedAppException>(
        json,
      );

      expect(deserialized, isA<SharedNotFoundException>());
      deserialized as SharedNotFoundException;
      expect(deserialized.message, 'Resource missing');
      expect(deserialized.code, 404);
    },
  );

  test(
    'Given a SharedNotFoundException object '
    'when deserialized using deserializeByClassName '
    'then it deserializes as the concrete exception type.',
    () {
      final exception = SharedNotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final json = exception.toJson();
      final deserialized = Protocol().deserializeByClassName({
        'className': 'SharedNotFoundException',
        'data': json,
      });

      expect(deserialized, isA<SharedNotFoundException>());
      deserialized as SharedNotFoundException;
      expect(deserialized.message, 'Resource missing');
      expect(deserialized.code, 404);
    },
  );

  test(
    'Given JSON for a sealed shared exception subtype '
    'when deserialized using the sealed parent className '
    'then deserialization fails because the parent is not registered.',
    () {
      final exception = SharedNotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      expect(
        () => Protocol().deserializeByClassName({
          'className': 'SharedSealedAppException',
          'data': exception.toJson(),
        }),
        throwsFormatException,
      );
    },
  );

  test(
    'Given a SharedNotFoundException object '
    'when using copyWith through a sealed parent reference '
    'then it creates a copy with updated values.',
    () {
      final exception = SharedNotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final SharedSealedAppException parent = exception;
      final copied = parent.copyWith(message: 'Updated message');

      expect(copied.message, 'Updated message');
      expect(copied, isA<SharedNotFoundException>());
      copied as SharedNotFoundException;
      expect(copied.code, 404);
    },
  );

  test(
    'Given a SharedObjectWithSealedException '
    'when created with sealed exception fields '
    'then it serializes and deserializes correctly.',
    () {
      final notFound = SharedNotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final objectWithSealed = SharedObjectWithSealedException(
        sealedField: notFound,
        nullableSealedField: notFound,
        sealedList: [notFound],
      );

      final json = objectWithSealed.toJson();
      final deserialized = SharedObjectWithSealedException.fromJson(json);

      expect(deserialized.sealedField, isA<SharedNotFoundException>());
      expect(deserialized.nullableSealedField, isA<SharedNotFoundException>());
      expect(deserialized.sealedList.first, isA<SharedNotFoundException>());
    },
  );

  test(
    'Given a SharedExtendedAppException '
    'when created '
    'then it is a subtype of SharedBaseAppException.',
    () {
      final exception = SharedExtendedAppException(
        message: 'Base message',
        detail: 'Extra detail',
      );

      expect(exception, isA<SharedBaseAppException>());
    },
  );

  test(
    'Given a SharedExtendedAppException object '
    'when round-tripped through JSON '
    'then inherited and child fields are preserved.',
    () {
      final exception = SharedExtendedAppException(
        message: 'Base message',
        detail: 'Extra detail',
      );

      final json = exception.toJson();
      final deserialized = SharedExtendedAppException.fromJson(json);

      expect(deserialized.message, 'Base message');
      expect(deserialized.detail, 'Extra detail');
    },
  );
}
