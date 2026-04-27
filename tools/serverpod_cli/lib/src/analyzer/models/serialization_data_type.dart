/// Serialization types for serializable columns.
///
/// Controls whether a serializable field is stored as text-based JSON
/// or as a structured binary format in the database.
enum SerializationDataType {
  /// The `json` data type stores an exact copy of the input text,
  /// which processing functions must reparse on each execution.
  json,

  /// The `jsonb` data type is stored in a decomposed binary format
  /// that makes it slightly slower to input due to added conversion overhead,
  /// but significantly faster to process, since no reparsing is needed.
  /// `jsonb` also supports indexing, which can be a significant advantage.
  jsonb,
}
