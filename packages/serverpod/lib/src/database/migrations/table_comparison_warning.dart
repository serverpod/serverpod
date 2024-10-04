/// A generic class representing a comparison warning or mismatch when comparing
/// database entities (e.g., tables, columns, indexes, or foreign keys).
///
/// This class is designed to store a primary name (e.g., Table, Column, Index),
/// along with a mismatch description, expected value, and found value if applicable.
/// The comparison may include sub-warnings to represent more specific issues within
/// the primary entity.
abstract class ComparisonWarning<T extends ComparisonWarning<T>> {
  /// The primary name describing the object being compared (e.g., Table, Column, Index).
  final String? name;

  /// The type of mismatch that occurred (e.g., "Type", "Nullability").
  final String? mismatch;

  /// The expected value (if applicable).
  final String? expected;

  /// The actual found value (if applicable).
  final String? found;

  /// A list of sub-warnings providing more detailed context or representing
  /// nested issues related to the primary warning.
  final List<T> subs;

  /// Creates a new [ComparisonWarning] with optional [name], [mismatch], [expected], and [found].
  /// The [subs] list starts empty but can be populated using [addSub] or [addSubs].
  ComparisonWarning({
    this.name,
    this.mismatch,
    this.expected,
    this.found,
  }) : subs = [];

  /// Generates a formatted string representation of the warning and its sub-warnings.
  /// The output is indented according to the [indentLevel], making it easier to
  /// read hierarchically nested warnings.
  @override
  String toString({int indentLevel = 0}) {
    StringBuffer buffer = StringBuffer();
    var indent = '  ' * indentLevel;

    // Write the main mismatch message with proper indentation.
    buffer.write(indentLevel == 0 ? indent : '$indent - ');
    buffer.write(_buildMessage(indent, indentLevel));

    // Recursively format sub-warnings with increased indentation.
    for (var sub in subs) {
      buffer.write('\n${sub.toString(indentLevel: indentLevel + 1)}');
    }

    return buffer.toString();
  }

  /// Adds a single sub-warning [sub] to the current warning.
  ///
  /// This method supports creating a structured hierarchy of warnings,
  /// where each sub-warning provides further details on the primary warning.
  T addSub(T sub) {
    subs.add(sub);
    return this as T;
  }

  /// Adds multiple sub-warnings at once.
  ///
  /// This method allows batch addition of sub-warnings, which is useful when
  /// adding several related warnings to a comparison.
  T addSubs(List<T> subs) {
    this.subs.addAll(subs);
    return this as T;
  }

  /// Builds the message string based on the available fields.
  /// If the mismatch contains sub-details (e.g., "Expected" and "Found"),
  /// they are printed accordingly.
  String _buildMessage(String space, int indentLevel) {
    StringBuffer buffer = StringBuffer();

    // Handle case 1: Main mismatch with name and type
    if (name != null && mismatch != null && indentLevel == 0) {
      buffer.write('$name $mismatch mismatch:');
    }
    // Handle case 2: Only the mismatch is present, e.g., sub-warnings
    else if (mismatch != null) {
      buffer.write('$mismatch mismatch:');
    }
    // If there's no mismatch, handle it as a general mismatch
    else if (name != null) {
      buffer.write('$name mismatch:');
    }

    // Include details about expected and found values, if they exist
    if (expected != null || found != null) {
      buffer.writeln();
      buffer.write('$space$space - expected "$expected", found "$found".');
    }

    return buffer.toString();
  }
}

/// Concrete implementation for table comparison warnings.
///
/// This class represents warnings generated when comparing table definitions
/// in a database schema. It allows for capturing mismatches related to
/// table properties, such as table name or schema differences.
class TableComparisonWarning extends ComparisonWarning<TableComparisonWarning> {
  /// Creates a new [TableComparisonWarning] with optional [mismatch], [expected], and [found].
  /// The [name] for this class is automatically set to 'Table'.
  TableComparisonWarning({
    super.mismatch,
    super.expected,
    super.found,
  }) : super(name: 'Table');

  /// Allows creating a sub-warning for a table comparison (used for nested warnings).
  TableComparisonWarning.sub({
    super.mismatch,
    super.expected,
    super.found,
  });
}

/// Specialized warning for column comparison
///
/// This class represents warnings generated when comparing columns in a table.
/// It captures issues related to column properties such as type, nullability,
/// or default values.
class ColumnComparisonWarning
    extends ComparisonWarning<ColumnComparisonWarning> {
  /// Creates a new [ColumnComparisonWarning] with optional [mismatch], [expected], and [found].
  /// The [name] for this class is automatically set to 'Column'.
  ColumnComparisonWarning({
    super.mismatch,
    super.expected,
    super.found,
  }) : super(name: 'Column');

  /// Allows creating a sub-warning for a column comparison (used for nested warnings).
  ColumnComparisonWarning.sub({
    super.mismatch,
    super.expected,
    super.found,
  });
}

/// Specialized warning for index comparison
///
/// This class represents warnings generated when comparing indexes in a table.
/// It captures issues such as index type, uniqueness, or tablespace mismatches.
class IndexComparisonWarning extends ComparisonWarning<IndexComparisonWarning> {
  /// Creates a new [IndexComparisonWarning] with optional [mismatch], [expected], and [found].
  /// The [name] for this class is automatically set to 'Index'.
  IndexComparisonWarning({
    super.mismatch,
    super.expected,
    super.found,
  }) : super(name: 'Index');

  /// Allows creating a sub-warning for a index comparison (used for nested warnings).
  IndexComparisonWarning.sub({
    super.mismatch,
    super.expected,
    super.found,
  });
}

/// Specialized warning for foreign key comparison
///
/// This class represents warnings related to foreign key mismatches, such as
/// differences in reference tables, actions on delete or update, and match types.
class ForeignKeyComparisonWarning
    extends ComparisonWarning<ForeignKeyComparisonWarning> {
  /// Creates a new [ForeignKeyComparisonWarning] with optional [mismatch], [expected], and [found].
  /// The [name] for this class is automatically set to 'Foreign Key'.
  ForeignKeyComparisonWarning({
    super.mismatch,
    super.expected,
    super.found,
  }) : super(name: 'Foreign Key');

  /// Allows creating a sub-warning for a foreign key comparison (used for nested warnings).
  ForeignKeyComparisonWarning.sub({
    super.mismatch,
    super.expected,
    super.found,
  });
}

/// An extension on the list of [ComparisonWarning]s to provide
/// a method to convert the list into a list of formatted string representations.
extension ListExt<ComparisonWarning> on List<ComparisonWarning> {
  /// Converts the list of comparison warnings into a list of formatted strings.
  ///
  /// Each string is a formatted version of the warning, including its sub-warnings.
  List<String> asStringList() {
    return fold(
      <String>[],
      (a, b) => <String>[...a, b.toString()],
    );
  }
}
