import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/base.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/default.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/scope.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/validate_node.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class InterfaceYamlDefinition {
  late Set<ValidateNode> documentStructure;

  InterfaceYamlDefinition(Restrictions restrictions) {
    documentStructure = {
      ValidateNode(
        Keyword.interfaceType,
        isRequired: true,
        valueRestriction: restrictions.validateClassName,
      ),
      ValidateNode(
        Keyword.isImplementing,
        valueRestriction: restrictions.validateImplementedInterfaceNames,
      ),
      ValidateNode(
        Keyword.fields,
        isRequired: false,
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
                mutuallyExclusiveKeys: {
                  Keyword.defaultKey,
                  Keyword.defaultModelKey,
                  Keyword.defaultPersistKey,
                },
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
                    mutuallyExclusiveKeys: {
                      Keyword.field,
                    },
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
              ValidateNode(
                Keyword.defaultKey,
                keyRestriction: restrictions.validateDefaultKey,
                valueRestriction: DefaultValueRestriction(
                  Keyword.defaultKey,
                  restrictions.documentDefinition,
                ).validate,
                mutuallyExclusiveKeys: {
                  Keyword.relation,
                },
              ),
              ValidateNode(
                Keyword.defaultModelKey,
                keyRestriction: restrictions.validateDefaultModelKey,
                valueRestriction: DefaultValueRestriction(
                  Keyword.defaultModelKey,
                  restrictions.documentDefinition,
                ).validate,
                mutuallyExclusiveKeys: {
                  Keyword.relation,
                },
              ),
              ValidateNode(
                Keyword.defaultPersistKey,
                keyRestriction: restrictions.validateDefaultPersistKey,
                valueRestriction: DefaultValueRestriction(
                  Keyword.defaultPersistKey,
                  restrictions.documentDefinition,
                ).validate,
                mutuallyExclusiveKeys: {
                  Keyword.relation,
                },
              ),
            },
          ),
        },
      ),
    };
  }
}
