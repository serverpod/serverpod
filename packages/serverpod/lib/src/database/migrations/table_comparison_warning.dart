import 'package:serverpod/protocol.dart';

/// A generic class representing a comparison warning or mismatch when comparing
/// database entities (e.g., tables, columns, indexes, or foreign keys).
///
/// This class stores information about the mismatch, including the expected and found values
/// when applicable. It can also contain sub-warnings for more detailed comparison issues
/// within the primary entity.
abstract class ComparisonWarning<T extends ComparisonWarning<T>> {
  /// The parent comparison warning, if this is a sub-warning.
  final T? parent;

  /// The type of entity being compared (e.g., "table", "column").
  final String type;

  /// The name of the entity being compared.
  final String name;

  /// The expected value in the comparison, if any.
  final String? expected;

  /// The actual value found during the comparison, if any.
  final String? found;

  /// True if the entity is missing (expected but not found).
  final bool isMissing;

  /// True if the entity is newly added (found but not expected).
  final bool isAdded;

  /// True if the entity's properties mismatch (expected vs found).
  final bool isMismatch;

  /// A list of sub-warnings providing more detailed context or representing
  /// nested issues related to the primary warning.
  final List<T> subs;

  /// Creates a new [ComparisonWarning] with the given type, name, and optional expected
  /// and found values. Initializes the [subs] list and sets flags for missing,
  /// added, and mismatch states.
  ComparisonWarning({
    this.parent,
    required this.type,
    required this.name,
    this.expected, // The expected value in comparison.
    this.found, // The found value in comparison.
  })  : isMissing = expected != null && found == null,
        isAdded = expected == null && found != null,
        isMismatch = expected != null && found != null && expected != found,
        subs = [];

  /// Generates a formatted string representation of the warning and its sub-warnings.
  /// The output is indented according to the [indentLevel] for hierarchical clarity.
  @override
  String toString({int indentLevel = 0}) {
    StringBuffer buffer = StringBuffer();
    var indent = '  ' * indentLevel;

    // Write the main mismatch message with proper indentation.
    buffer.write(indentLevel == 0 ? indent : '$indent - ');
    buffer.write(_buildMessage());

    // Recursively format sub-warnings with increased indentation.
    for (var sub in subs) {
      buffer.write('\n${sub.toString(indentLevel: indentLevel + 1)}');
    }

    return buffer.toString();
  }

  /// Abstract method for returning a copy of this warning with a new parent.
  ///
  /// This is used when adding sub-warnings to associate them with their parent.
  T withParent(T parent);

  /// Adds a single sub-warning [sub] to the current warning, setting the parent-child relationship.
  ///
  /// This method allows the creation of structured hierarchies of warnings, where
  /// each sub-warning provides further details on the primary comparison issue.
  T addSub(T sub) {
    subs.add(sub.withParent(this as T));
    return this as T;
  }

  /// Adds multiple sub-warnings at once, assigning them the current warning as their parent.
  ///
  /// This method is useful when adding several related warnings in a batch to a comparison.
  T addSubs(List<T> subs) {
    this.subs.addAll(subs.map((e) => e.withParent(this as T)));
    return this as T;
  }

  /// Builds the comparison warning message based on the available fields.
  ///
  /// The message indicates whether the entity is missing, added, or mismatched,
  /// and prints the expected and found values if applicable.
  String _buildMessage() {
    StringBuffer buffer = StringBuffer();

    if (isMissing) {
      buffer.write('Missing $type "$name".');
    } else if (isMismatch) {
      // If this is the top-level mismatch, provide context about the mismatch.
      if (parent == null) {
        buffer.write('$type "$name" mismatch: ');
      }
      buffer.write('expected $name "$expected", found "$found".');
    } else if (isAdded) {
      buffer.write('New $type "$name" added.');
    } else {
      // Fallback for cases where both expected and found are null.
      buffer.write('$type "$name" mismatch: ');
    }
    return buffer.toString();
  }
}

/// Concrete class for table comparison warnings.
///
/// Represents warnings generated when comparing table definitions in a database schema.
/// Captures issues related to table properties, such as name, schema, or tablespace mismatches.
class TableComparisonWarning extends ComparisonWarning<TableComparisonWarning> {
  /// Creates a new [TableComparisonWarning] instance.
  TableComparisonWarning({
    super.parent,
    required super.name,
    super.expected,
    super.found,
  }) : super(type: 'Table');

  /// Creates a new [TableComparisonWarning] instance for name mismatch.
  factory TableComparisonWarning.nameMismatch(
    TableDefinition expected,
    TableDefinition found,
  ) {
    return TableComparisonWarning(
      name: 'name',
      expected: expected.name,
      found: found.name,
    );
  }

  /// Creates a new [TableComparisonWarning] instance for tableSpace mismatch.
  factory TableComparisonWarning.tableSpaceMismatch(
    TableDefinition expected,
    TableDefinition found,
  ) {
    return TableComparisonWarning(
      name: 'tablespace',
      expected: expected.tableSpace,
      found: found.tableSpace,
    );
  }

  /// Creates a new [TableComparisonWarning] instance for schema mismatch.
  factory TableComparisonWarning.schemaMismatch(
    TableDefinition expected,
    TableDefinition found,
  ) {
    return TableComparisonWarning(
      name: 'schema',
      expected: expected.schema,
      found: found.schema,
    );
  }

  /// Creates a new [TableComparisonWarning] instance for managed mismatch.
  factory TableComparisonWarning.managedMismatch(
    TableDefinition expected,
    TableDefinition found,
  ) {
    return TableComparisonWarning(
      name: 'managed',
      expected: '${expected.managed}',
      found: '${found.managed}',
    );
  }

  @override
  TableComparisonWarning withParent(TableComparisonWarning parent) {
    return TableComparisonWarning(
      parent: parent,
      name: name,
      expected: expected,
      found: found,
    );
  }
}

/// Specialized class for column comparison warnings.
///
/// Represents warnings generated when comparing columns within tables, capturing
/// mismatches related to type, nullability, default values, or other column properties.
class ColumnComparisonWarning
    extends ComparisonWarning<ColumnComparisonWarning> {
  /// Creates a new [ColumnComparisonWarning] instance.
  ColumnComparisonWarning({
    super.parent,
    required super.name,
    super.expected,
    super.found,
  }) : super(type: 'Column');

  /// Creates a new [ColumnComparisonWarning] instance for name mismatch.
  factory ColumnComparisonWarning.nameMismatch(
    ColumnDefinition expected,
    ColumnDefinition found,
  ) {
    return ColumnComparisonWarning(
      name: 'name',
      expected: expected.name,
      found: found.name,
    );
  }

  /// Creates a new [ColumnComparisonWarning] instance for type mismatch.
  factory ColumnComparisonWarning.typeMismatch(
    ColumnDefinition expected,
    ColumnDefinition found,
  ) {
    return ColumnComparisonWarning(
      name: 'type',
      expected: '${expected.columnType}',
      found: '${found.columnType}',
    );
  }

  /// Creates a new [ColumnComparisonWarning] instance for isNullable mismatch.
  factory ColumnComparisonWarning.isNullableMismatch(
    ColumnDefinition expected,
    ColumnDefinition found,
  ) {
    return ColumnComparisonWarning(
      name: 'isNullable',
      expected: '${expected.isNullable}',
      found: '${found.isNullable}',
    );
  }

  /// Creates a new [ColumnComparisonWarning] instance for default value mismatch.
  factory ColumnComparisonWarning.defaultValueMismatch(
    ColumnDefinition expected,
    ColumnDefinition found,
  ) {
    return ColumnComparisonWarning(
      name: 'default value',
      expected: '${expected.columnDefault}',
      found: '${found.columnDefault}',
    );
  }

  @override
  ColumnComparisonWarning withParent(ColumnComparisonWarning parent) {
    return ColumnComparisonWarning(
      parent: parent,
      name: name,
      expected: expected,
      found: found,
    );
  }
}

/// Specialized class for index comparison warnings.
///
/// Represents warnings generated when comparing indexes in a table, capturing
/// mismatches such as index type, uniqueness, or tablespace differences.
class IndexComparisonWarning extends ComparisonWarning<IndexComparisonWarning> {
  /// Creates a new [IndexComparisonWarning] instance.
  IndexComparisonWarning({
    super.parent,
    required super.name,
    super.expected,
    super.found,
  }) : super(type: 'Index');

  /// Creates a new [IndexComparisonWarning] instance for missing index.
  factory IndexComparisonWarning.missingIndex(
    IndexDefinition index,
  ) {
    return IndexComparisonWarning(
      name: index.indexName,
      expected: index.indexName,
      found: null,
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for name mismatch.
  factory IndexComparisonWarning.nameMismatch(
    IndexDefinition expected,
    IndexDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'name',
      expected: expected.indexName,
      found: found.indexName,
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for type mismatch.
  factory IndexComparisonWarning.typeMismatch(
    IndexDefinition expected,
    IndexDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'type',
      expected: expected.type,
      found: found.type,
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for isUnique mismatch.
  factory IndexComparisonWarning.isUniqueMismatch(
    IndexDefinition expected,
    IndexDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'isUnique',
      expected: '${expected.isUnique}',
      found: '${found.isUnique}',
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for isPrimary mismatch.
  factory IndexComparisonWarning.isPrimaryMismatch(
    IndexDefinition expected,
    IndexDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'isPrimary',
      expected: '${expected.isPrimary}',
      found: '${found.isPrimary}',
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for predicate mismatch.
  factory IndexComparisonWarning.predicateMismatch(
    IndexDefinition expected,
    IndexDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'predicate',
      expected: expected.predicate,
      found: found.predicate,
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for tableSpace mismatch.
  factory IndexComparisonWarning.tableSpaceMismatch(
    IndexDefinition expected,
    IndexDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'tableSpace',
      expected: expected.tableSpace,
      found: found.tableSpace,
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for elements mismatch.
  factory IndexComparisonWarning.elementsMismatch(
    IndexDefinition expected,
    IndexDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'elements',
      expected: '${expected.elements.length}',
      found: '${found.elements.length}',
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for element type mismatch.
  factory IndexComparisonWarning.elementTypeMismatch(
    IndexElementDefinition expected,
    IndexElementDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'element type',
      expected: '${expected.type}',
      found: '${found.type}',
    );
  }

  /// Creates a new [IndexComparisonWarning] instance for element definition mismatch.
  factory IndexComparisonWarning.elementDefinitionMismatch(
    IndexElementDefinition expected,
    IndexElementDefinition found,
  ) {
    return IndexComparisonWarning(
      name: 'element definition',
      expected: expected.definition,
      found: found.definition,
    );
  }

  @override
  IndexComparisonWarning withParent(IndexComparisonWarning parent) {
    return IndexComparisonWarning(
      parent: parent,
      name: name,
      expected: expected,
      found: found,
    );
  }
}

/// Specialized class for foreign key comparison warnings.
///
/// Represents warnings related to foreign key constraints, such as mismatches
/// in reference tables, actions on delete or update, or match types.
class ForeignKeyComparisonWarning
    extends ComparisonWarning<ForeignKeyComparisonWarning> {
  /// Creates a new [ForeignKeyComparisonWarning] instance.
  ForeignKeyComparisonWarning({
    super.parent,
    required super.name,
    super.expected,
    super.found,
  }) : super(type: 'Foreign key');

  /// Creates a new [ForeignKeyComparisonWarning] instance for missing foreign key.
  factory ForeignKeyComparisonWarning.missingForeignKey(
    ForeignKeyDefinition foreignKey,
  ) {
    return ForeignKeyComparisonWarning(
      name: foreignKey.constraintName,
      expected: foreignKey.constraintName,
      found: null,
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for name mismatch.
  factory ForeignKeyComparisonWarning.nameMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'name',
      expected: expected.constraintName,
      found: found.constraintName,
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for columns mismatch.
  factory ForeignKeyComparisonWarning.columnsMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'columns',
      expected: '${expected.columns}',
      found: '${found.columns}',
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for reference table mismatch.
  factory ForeignKeyComparisonWarning.referenceTableMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'reference table',
      expected: expected.referenceTable,
      found: found.referenceTable,
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for reference table schema mismatch.
  factory ForeignKeyComparisonWarning.referenceTableSchemaMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'reference table schema',
      expected: expected.referenceTableSchema,
      found: found.referenceTableSchema,
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for reference columns mismatch.
  factory ForeignKeyComparisonWarning.referenceColumnsMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'reference columns',
      expected: '${expected.referenceColumns}',
      found: '${found.referenceColumns}',
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for onUpdate mismatch.
  factory ForeignKeyComparisonWarning.onUpdateMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'onUpdate',
      expected: '${expected.onUpdate}',
      found: '${found.onUpdate}',
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for onDelete mismatch.
  factory ForeignKeyComparisonWarning.onDeleteMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'onDelete',
      expected: '${expected.onDelete}',
      found: '${found.onDelete}',
    );
  }

  /// Creates a new [ForeignKeyComparisonWarning] instance for match type mismatch.
  factory ForeignKeyComparisonWarning.matchTypeMismatch(
    ForeignKeyDefinition expected,
    ForeignKeyDefinition found,
  ) {
    return ForeignKeyComparisonWarning(
      name: 'match type',
      expected: '${expected.matchType}',
      found: '${found.matchType}',
    );
  }

  @override
  ForeignKeyComparisonWarning withParent(ForeignKeyComparisonWarning parent) {
    return ForeignKeyComparisonWarning(
      parent: parent,
      name: name,
      expected: expected,
      found: found,
    );
  }
}

/// Extension on a list of comparison warnings to provide a method for converting
/// the list into a list of formatted string representations.
///
/// This allows for easier printing or logging of comparison warnings.
extension ListExt<ComparisonWarning> on List<ComparisonWarning> {
  /// Converts the list of comparison warnings into a list of formatted strings,
  /// where each string is the result of calling [toString] on the warning.
  List<String> asStringList() {
    return fold(
      <String>[],
      (a, b) => <String>[...a, b.toString()],
    );
  }
}
