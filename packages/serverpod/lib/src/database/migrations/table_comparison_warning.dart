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
