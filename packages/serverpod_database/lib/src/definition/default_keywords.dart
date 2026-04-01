/// The name of the default primary key column.
const String defaultPrimaryKeyName = 'id';

/// Int for the default primary key type.
const String defaultIntSerial = 'serial';

/// The identifier for the default value to the current timestamp.
const String defaultDateTimeValueNow = 'now';

/// The identifier for the default value to boolean [true].
const String defaultBooleanTrue = 'true';

/// The identifier for the default value to boolean [false].
const String defaultBooleanFalse = 'false';

/// The identifier for the default value to a random UUID v4.
const String defaultUuidValueRandom = 'random';

/// The identifier for the default value to a random UUID v7.
const String defaultUuidValueRandomV7 = 'random_v7';

/// Allowed types for vector indexes.
enum VectorIndexType {
  /// HNSW index type.
  hnsw,

  /// IVF-FLAT index type.
  ivfflat,
}
