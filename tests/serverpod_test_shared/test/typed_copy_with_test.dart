import 'package:serverpod_test_shared/serverpod_test_shared.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Given shared models containing nullable subclasses and exceptions,',
    () {
      late SharedContainer original;

      setUp(() {
        final subclass = SharedSubclass(
          name: 'original',
          sharedSubclassField: 'child',
          sharedEnumField: SharedEnum.values.first,
        );
        final sealedChild = SharedSealedChild(
          sharedSealedField: 'parent',
          sharedSealedChildField: 'child',
        );
        final notFound = SharedNotFoundException(message: 'missing', code: 404);
        final extended = SharedExtendedAppException(
          message: 'failure',
          detail: 'detail',
        );
        original = SharedContainer(
          sharedModel: SharedModel(name: 'model'),
          sharedModelWithModuleAlias: SharedModel(name: 'module'),
          sharedSubclass: subclass,
          sharedSubclassNullable: subclass,
          sharedEnum: SharedEnum.values.first,
          sharedSealedParent: sealedChild,
          sharedSealedParentNullable: sealedChild,
          sharedSealedChild: sealedChild,
          sharedSealedChildNullable: sealedChild,
          sharedSealedAppException: notFound,
          sharedSealedAppExceptionNullable: notFound,
          sharedNotFoundException: notFound,
          sharedNotFoundExceptionNullable: notFound,
          sharedExtendedAppException: extended,
          sharedExtendedAppExceptionNullable: extended,
        );
      });

      test(
        'when copying without arguments and mutating the source, '
        'then ordinary and sealed-hierarchy children are deeply copied.',
        () {
          final copy = original.copyWith();
          original.sharedSubclassNullable!.name = 'changed';
          original.sharedSealedChildNullable!.sharedSealedChildField =
              'changed';
          original.sharedNotFoundExceptionNullable!.code = 500;
          original.sharedExtendedAppExceptionNullable!.detail = 'changed';

          expect(copy.sharedSubclassNullable!.name, 'original');
          expect(
            copy.sharedSealedChildNullable!.sharedSealedChildField,
            'child',
          );
          expect(copy.sharedNotFoundExceptionNullable!.code, 404);
          expect(copy.sharedExtendedAppExceptionNullable!.detail, 'detail');
          expect(copy.sharedSealedParentNullable, isA<SharedSealedChild>());
          expect(
            copy.sharedSealedAppExceptionNullable,
            isA<SharedNotFoundException>(),
          );
        },
      );

      test(
        'when copying with explicit nulls, '
        'then both typed fields and sealed fallback fields are cleared.',
        () {
          final copy = original.copyWith(
            sharedSubclassNullable: null,
            sharedSealedParentNullable: null,
            sharedSealedChildNullable: null,
            sharedSealedAppExceptionNullable: null,
            sharedNotFoundExceptionNullable: null,
            sharedExtendedAppExceptionNullable: null,
          );

          expect(copy.sharedSubclassNullable, isNull);
          expect(copy.sharedSealedParentNullable, isNull);
          expect(copy.sharedSealedChildNullable, isNull);
          expect(copy.sharedSealedAppExceptionNullable, isNull);
          expect(copy.sharedNotFoundExceptionNullable, isNull);
          expect(copy.sharedExtendedAppExceptionNullable, isNull);
        },
      );

      test(
        'when copying with a replacement exception, '
        'then its new values appear only in the copy.',
        () {
          final copy = original.copyWith(
            sharedNotFoundExceptionNullable: SharedNotFoundException(
              message: 'replacement',
              code: 410,
            ),
          );

          expect(copy.sharedNotFoundExceptionNullable!.code, 410);
          expect(original.sharedNotFoundExceptionNullable!.code, 404);
        },
      );

      test(
        'when a dynamic caller supplies a parent for a child field, '
        'then copyWith rejects the argument.',
        () {
          final dynamic dynamicOriginal = original;

          expect(
            () => dynamicOriginal.copyWith(
              sharedSubclassNullable: SharedModel(name: 'parent'),
            ),
            throwsA(isA<TypeError>()),
          );
        },
      );
    },
  );
}
