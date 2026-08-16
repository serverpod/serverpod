import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_database/src/util/column_alias_resolver.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../test_util/table_relation_builder.dart';

/// Unit coverage for the collision-resolution that fixes
/// https://github.com/serverpod/serverpod/issues/5287
void main() {
  var citizenTable = Table<int?>(tableName: 'citizen');
  var companyTable = Table<int?>(tableName: 'company');

  // Two distinct relations from `citizen` to `company` with long field names
  // whose `id` columns truncate to the same base alias.
  var firstRelation = TableRelationBuilder(companyTable).withRelationsFrom([
    BuilderRelation(
      citizenTable,
      'companyRelationWithAVeryLongFieldNameForcingTruncatio412',
    ),
  ]).build();
  var secondRelation = TableRelationBuilder(companyTable).withRelationsFrom([
    BuilderRelation(
      citizenTable,
      'companyRelationWithAVeryLongFieldNameForcingTruncatio129',
    ),
  ]).build();

  group('Given two columns whose truncated aliases collide', () {
    var base = truncateIdentifier(
      firstRelation.id.fieldQueryAlias,
      DatabaseConstants.pgsqlMaxNameLimitation,
    );

    test('then the two columns share the same plain truncated alias.', () {
      // Sanity check that this scenario actually triggers a collision.
      expect(
        truncateIdentifier(
          secondRelation.id.fieldQueryAlias,
          DatabaseConstants.pgsqlMaxNameLimitation,
        ),
        base,
      );
    });

    var resolver = ColumnAliasResolver.forColumns([
      firstRelation.id,
      secondRelation.id,
    ]);

    test('then each column resolves to a distinct alias.', () {
      expect(
        resolver.resolve(firstRelation.id),
        isNot(resolver.resolve(secondRelation.id)),
      );
    });

    test('then the first column keeps the base alias.', () {
      expect(resolver.resolve(firstRelation.id), base);
    });

    test('then the second column is suffixed to disambiguate.', () {
      expect(resolver.resolve(secondRelation.id), endsWith('_1'));
    });

    test('then the resolved aliases stay within the identifier limit.', () {
      expect(
        resolver.resolve(secondRelation.id).length,
        lessThanOrEqualTo(DatabaseConstants.pgsqlMaxNameLimitation),
      );
    });
  });

  group('Given columns that do not collide', () {
    var resolver = ColumnAliasResolver.forColumns([
      citizenTable.id,
      firstRelation.id,
    ]);

    test('then aliases are unchanged from the plain truncated form.', () {
      expect(resolver.resolve(citizenTable.id), 'citizen.id');
      expect(
        resolver.resolve(firstRelation.id),
        truncateIdentifier(
          firstRelation.id.fieldQueryAlias,
          DatabaseConstants.pgsqlMaxNameLimitation,
        ),
      );
    });
  });
}
