import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/entities/validation/validate_node.dart';

class ClassYamlDefinition {
  late Set<ValidateNode> documentStructure;

  ValidateNode get fieldStructure {
    return documentStructure
        .firstWhere((element) => element.key == Keyword.fields)
        .nested
        .first;
  }

  ClassYamlDefinition(Restrictions restrictions) {
    documentStructure = {
      ValidateNode(
        Keyword.classType,
        isRequired: true,
        valueRestriction: restrictions.validateClassName,
      ),
      ValidateNode(
        Keyword.table,
        valueRestriction: restrictions.validateTableName,
      ),
      ValidateNode(
        Keyword.serverOnly,
        valueRestriction: BooleanValueRestriction().validate,
      ),
      ValidateNode(
        Keyword.fields,
        isRequired: true,
        nested: {
          ValidateNode(
            Keyword.any,
            keyRestriction: restrictions.validateFieldName,
            allowStringifiedNestedValue: const StringifiedNestedValues(
              isAllowed: true,
              hasImplicitFirstKey: true,
            ),
            isContextualParentNode: true,
            nested: {
              ValidateNode(
                Keyword.type,
                isRequired: true,
                valueRestriction: restrictions.validateFieldDataType,
              ),
              ValidateNode(
                Keyword.parent,
                isDeprecated: true,
                mutuallyExclusiveKeys: {Keyword.relation},
                alternativeUsageMessage:
                    'Use the relation keyword instead. E.g. relation(parent=parent_table)',
                valueRestriction: restrictions.validateParentName,
              ),
              ValidateNode(
                Keyword.relation,
                keyRestriction: restrictions.validateRelationKey,
                valueRestriction:
                    restrictions.validateRelationInterdependencies,
                mutuallyExclusiveKeys: {Keyword.parent},
                allowEmptyNestedValue: true,
                nested: {
                  ValidateNode(
                    Keyword.parent,
                    keyRestriction: restrictions.validateParentKey,
                    valueRestriction: restrictions.validateParentName,
                  ),
                  ValidateNode(
                    Keyword.optional,
                    keyRestriction: restrictions.validateOptionalKey,
                    valueRestriction: BooleanValueRestriction().validate,
                  ),
                },
              ),
              ValidateNode(
                Keyword.scope,
                mutuallyExclusiveKeys: {Keyword.database, Keyword.api},
                valueRestriction: EnumValueRestriction(
                  enums: EntityFieldScopeDefinition.values,
                ).validate,
              ),
              ValidateNode(
                Keyword.persist,
                keyRestriction: restrictions.validatePersistKey,
                valueRestriction: BooleanValueRestriction().validate,
                mutuallyExclusiveKeys: {Keyword.database, Keyword.api},
              ),
              ValidateNode(
                Keyword.database,
                valueRestriction: BooleanValueRestriction().validate,
                mutuallyExclusiveKeys: {
                  Keyword.api,
                  Keyword.scope,
                  Keyword.persist
                },
              ),
              ValidateNode(
                Keyword.api,
                isDeprecated: true,
                alternativeUsageMessage: 'Use "!persist" instead.',
                valueRestriction: BooleanValueRestriction().validate,
                mutuallyExclusiveKeys: {
                  Keyword.database,
                  Keyword.scope,
                  Keyword.parent,
                  Keyword.persist,
                },
              ),
            },
          ),
        },
      ),
      ValidateNode(
        Keyword.indexes,
        nested: {
          ValidateNode(
            Keyword.any,
            keyRestriction: restrictions.validateTableIndexName,
            nested: {
              ValidateNode(
                Keyword.fields,
                isRequired: true,
                valueRestriction: restrictions.validateIndexFieldsValue,
              ),
              ValidateNode(
                Keyword.type,
                valueRestriction: restrictions.validateIndexType,
              ),
              ValidateNode(
                Keyword.unique,
                valueRestriction: BooleanValueRestriction().validate,
              ),
            },
          )
        },
      ),
    };
  }
}
