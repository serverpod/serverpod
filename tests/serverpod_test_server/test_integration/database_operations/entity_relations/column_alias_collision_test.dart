import 'package:serverpod/database.dart' as db;
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

/// Reproduces https://github.com/serverpod/serverpod/issues/5287
///
/// `BleedRoot` has two relations to the same child table (`bleed_child`) whose
/// relation field names are long enough that the generated SELECT column aliases
/// are truncated to the Postgres 63 character identifier limit. With these exact
/// names, the truncated alias of the first relation's `id` column collides with
/// the second relation's `bleedingText` column.
///
/// When both relations are included, the string value of `bleedingText` bleeds
/// into the int `id` field of the other relation, which currently throws:
///
///   type 'String' is not a subtype of type 'int?' in type cast
///
/// This test asserts the correct behavior (each relation keeps its own column
/// values), so it is expected to pass once the collision is fixed.
void main() async {
  var session = await IntegrationTestServer().session();

  group(
    'Given two relations to the same table with long relation field names',
    () {
      late int childId;

      setUp(() async {
        var child = await BleedChild.db.insertRow(
          session,
          BleedChild(bleedingText: 'zusa 2'),
        );
        childId = child.id!;

        // Both relations point at the same child row.
        await BleedRoot.db.insertRow(
          session,
          BleedRoot(
            name: 'root',
            firstChildId: childId,
            secondChildId: childId,
          ),
        );
      });

      tearDown(() async {
        await BleedRoot.db.deleteWhere(
          session,
          where: (_) => db.Constant.bool(true),
        );
        await BleedChild.db.deleteWhere(
          session,
          where: (_) => db.Constant.bool(true),
        );
      });

      test(
        'when fetching the root including both relations then each relation keeps its own column values.',
        () async {
          try {
            var root = await BleedRoot.db.findFirstRow(
              session,
              include: BleedRoot.include(
                childRelationWithExtremelyLongFieldNameForcingTrun24:
                    BleedChild.include(),
                childRelationWithExtremelyLongFieldNameForcingTrun23:
                    BleedChild.include(),
              ),
            );
            expect(root, isNotNull);

            var firstChild =
                root!.childRelationWithExtremelyLongFieldNameForcingTrun24;
            var secondChild =
                root.childRelationWithExtremelyLongFieldNameForcingTrun23;

            expect(firstChild?.id, childId);
            expect(firstChild?.bleedingText, 'zusa 2');
            expect(secondChild?.id, childId);
            expect(secondChild?.bleedingText, 'zusa 2');
          } catch (e) {
            fail('''
Database query failed, likely due to a column alias collision.

${e.toString()}''');
          }
        },
      );
    },
  );
}
