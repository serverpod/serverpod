import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/scope.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/validate_node.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

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
        keyRestriction: restrictions.validateTableNameKey,
        valueRestriction: restrictions.validateTableName,
      ),
      ValidateNode(
        Keyword.managedMigration,
        valueRestriction: BooleanValueRestriction().validate,
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
                valueRestriction: restrictions.validateFieldType,
              ),
              ValidateNode(
                Keyword.parent,
                isDeprecated: true,
                isRemoved: true,
                alternativeUsageMessage:
                    'Use the relation keyword instead. E.g. relation(parent=parent_table). Note that the default onDelete action changes from "Cascade" to "NoAction" when using the relation keyword.',
              ),
              ValidateNode(
                Keyword.relation,
                keyRestriction: restrictions.validateRelationKey,
                valueRestriction:
                    restrictions.validateRelationInterdependencies,
                allowEmptyNestedValue: true,
                nested: {
                  ValidateNode(
                    Keyword.parent,
                    keyRestriction: restrictions.validateParentKey,
                    valueRestriction: restrictions.validateParentName,
                  ),
                  ValidateNode(
                    Keyword.field,
                    keyRestriction: restrictions.validateRelationFieldKey,
                    valueRestriction: restrictions.validateRelationFieldName,
                  ),
                  ValidateNode(
                    Keyword.onUpdate,
                    keyRestriction: restrictions.validateDatabaseActionKey,
                    valueRestriction: EnumValueRestriction(
                      enums: ForeignKeyAction.values,
                    ).validate,
                  ),
                  ValidateNode(
                    Keyword.onDelete,
                    keyRestriction: restrictions.validateDatabaseActionKey,
                    valueRestriction: EnumValueRestriction(
                      enums: ForeignKeyAction.values,
                    ).validate,
                  ),
                  ValidateNode(
                    Keyword.optional,
                    keyRestriction: restrictions.validateOptionalKey,
                    valueRestriction: BooleanValueRestriction().validate,
                  ),
                  ValidateNode(
                    Keyword.name,
                    valueRestriction: restrictions.validateRelationName,
                  ),
                },
              ),
              ValidateNode(
                Keyword.scope,
                valueRestriction: EnumValueRestriction(
                  enums: ModelFieldScopeDefinition.values,
                  additionalRestriction: ScopeValueRestriction(
                    restrictions: restrictions,
                  ),
                ).validate,
              ),
              ValidateNode(
                Keyword.persist,
                keyRestriction: restrictions.validatePersistKey,
                valueRestriction: BooleanValueRestriction().validate,
                mutuallyExclusiveKeys: {
                  Keyword.relation,
                },
              ),
              ValidateNode(
                Keyword.database,
                isDeprecated: true,
                isRemoved: true,
                alternativeUsageMessage: 'Use "scope=serverOnly" instead.',
              ),
              ValidateNode(
                Keyword.api,
                isDeprecated: true,
                isRemoved: true,
                alternativeUsageMessage: 'Use "!persist" instead.',
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
