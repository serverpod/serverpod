import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a NotFoundException object '
    'when serialized '
    'then it produces JSON with the concrete exception class name.',
    () {
      final exception = NotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final json = exception.toJson();

      expect(json['__className__'], 'NotFoundException');
      expect(json['message'], 'Resource missing');
      expect(json['code'], 404);
    },
  );

  test(
    'Given a ValidationException object '
    'when serialized '
    'then it produces JSON with the concrete exception class name.',
    () {
      final exception = ValidationException(
        message: 'Invalid input',
        field: 'email',
      );

      final json = exception.toJson();

      expect(json['__className__'], 'ValidationException');
      expect(json['message'], 'Invalid input');
      expect(json['field'], 'email');
    },
  );

  test(
    'Given a NotFoundException object '
    'when deserialized as SealedAppException '
    'then it maintains the runtime type.',
    () {
      final exception = NotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final json = exception.toJson();
      final deserialized = Protocol().deserialize<SealedAppException>(json);

      expect(deserialized, isA<NotFoundException>());
      deserialized as NotFoundException;
      expect(deserialized.message, 'Resource missing');
      expect(deserialized.code, 404);
    },
  );

  test(
    'Given a ValidationException object '
    'when deserialized as SealedAppException '
    'then it maintains the runtime type.',
    () {
      final exception = ValidationException(
        message: 'Invalid input',
        field: 'email',
      );

      final json = exception.toJson();
      final deserialized = Protocol().deserialize<SealedAppException>(json);

      expect(deserialized, isA<ValidationException>());
      deserialized as ValidationException;
      expect(deserialized.message, 'Invalid input');
      expect(deserialized.field, 'email');
    },
  );

  test(
    'Given a NotFoundException object '
    'when deserialized using deserializeByClassName '
    'then it deserializes as the concrete exception type.',
    () {
      final exception = NotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final json = exception.toJson();
      final deserialized = Protocol().deserializeByClassName({
        'className': 'NotFoundException',
        'data': json,
      });

      expect(deserialized, isA<NotFoundException>());
      deserialized as NotFoundException;
      expect(deserialized.message, 'Resource missing');
      expect(deserialized.code, 404);
    },
  );

  test(
    'Given JSON for a sealed exception subtype '
    'when deserialized using the sealed parent className '
    'then deserialization fails because the parent is not registered.',
    () {
      final exception = NotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      expect(
        () => Protocol().deserializeByClassName({
          'className': 'SealedAppException',
          'data': exception.toJson(),
        }),
        throwsFormatException,
      );
    },
  );

  test(
    'Given a NotFoundException object '
    'when using copyWith through a sealed parent reference '
    'then it creates a copy with updated values.',
    () {
      final exception = NotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final SealedAppException parent = exception;
      final copied = parent.copyWith(message: 'Updated message');

      expect(copied.message, 'Updated message');
      expect(copied, isA<NotFoundException>());
      copied as NotFoundException;
      expect(copied.code, 404);
    },
  );

  test(
    'Given an ObjectWithSealedException '
    'when created with sealed exception fields '
    'then it serializes and deserializes correctly.',
    () {
      final notFound = NotFoundException(
        message: 'Resource missing',
        code: 404,
      );

      final objectWithSealed = ObjectWithSealedException(
        sealedField: notFound,
        nullableSealedField: notFound,
        sealedList: [notFound],
      );

      final json = objectWithSealed.toJson();
      final deserialized = ObjectWithSealedException.fromJson(json);

      expect(deserialized.sealedField, isA<NotFoundException>());
      expect(deserialized.nullableSealedField, isA<NotFoundException>());
      expect(deserialized.sealedList.first, isA<NotFoundException>());
    },
  );

  test(
    'Given an ExtendedAppException '
    'when created '
    'then it is a subtype of BaseAppException.',
    () {
      final exception = ExtendedAppException(
        message: 'Base message',
        detail: 'Extra detail',
      );

      expect(exception, isA<BaseAppException>());
    },
  );

  test(
    'Given an ExtendedAppException object '
    'when round-tripped through JSON '
    'then inherited and child fields are preserved.',
    () {
      final exception = ExtendedAppException(
        message: 'Base message',
        detail: 'Extra detail',
      );

      final json = exception.toJson();
      final deserialized = ExtendedAppException.fromJson(json);

      expect(deserialized.message, 'Base message');
      expect(deserialized.detail, 'Extra detail');
    },
  );
}
