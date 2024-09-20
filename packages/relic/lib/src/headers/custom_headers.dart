part of '../headers.dart';

final _emptyCustomHeaders = CustomHeaders._empty();

/// Unmodifiable, key-insensitive header map.
class CustomHeaders extends UnmodifiableMapView<String, List<String>> {
  factory CustomHeaders.empty() => _emptyCustomHeaders;

  factory CustomHeaders(
    Map<String, List<String>> values,
  ) {
    return CustomHeaders._(
      values.entries.map((e) => MapEntry(e.key, e.value)),
    );
  }

  CustomHeaders._empty() : super(const {});

  factory CustomHeaders._fromHttpHeaders(
    io.HttpHeaders headers, {
    Set<String> excludedHeaders = const {},
  }) {
    var custom = <MapEntry<String, List<String>>>[];

    headers.forEach((name, values) {
      // Skip headers that we support natively.
      if (excludedHeaders.contains(name.toLowerCase())) {
        return;
      }
      custom.add(MapEntry(name, values));
    });

    if (custom.isEmpty) return _emptyCustomHeaders;

    return CustomHeaders._(custom);
  }

  CustomHeaders._(
    Iterable<MapEntry<String, List<String>>> entries,
  ) : super(_toCaseInsensitiveMap(entries));

  /// Adds a new header or updates an existing one.
  CustomHeaders add(String key, List<String> values) {
    var updatedHeaders = Map<String, List<String>>.from(this);
    updatedHeaders[key] = values;
    return CustomHeaders(updatedHeaders);
  }

  /// Removes a header by its key.
  CustomHeaders removeKey(String key) {
    var updatedHeaders = Map<String, List<String>>.from(this);
    updatedHeaders.remove(key);
    return CustomHeaders(updatedHeaders);
  }

  /// Creates a copy of this instance with optional modifications.
  ///
  /// You can pass in a map of updated or new headers that will
  /// be added to the new instance.
  CustomHeaders copyWith({
    Map<String, List<String>>? newHeaders,
  }) {
    var updatedHeaders = Map<String, List<String>>.from(this);

    if (newHeaders != null) {
      for (var entry in newHeaders.entries) {
        updatedHeaders[entry.key] = entry.value;
      }
    }

    return CustomHeaders(updatedHeaders);
  }

  /// Sets headers from another `CustomHeaders` instance.
  CustomHeaders _withOther(CustomHeaders other) {
    if (other.isEmpty) return this;

    // Create a new map with all entries from the current instance.
    var mergedEntries = Map<String, List<String>>.from(this);

    // Add/override entries from the other instance.
    other.forEach((key, value) {
      mergedEntries[key] = List<String>.from(value);
    });

    return CustomHeaders(mergedEntries);
  }
}

CaseInsensitiveMap<List<String>> _toCaseInsensitiveMap(
  Iterable<MapEntry<String, List<String>>> entries,
) {
  final validEntries = entries
      .where((entry) => entry.value.isNotEmpty)
      .map((entry) => MapEntry(entry.key, _withNoEmptyValues(entry.value)));

  return CaseInsensitiveMap.from(
    Map.fromEntries(
      validEntries.map(
        (e) => MapEntry(
          e.key,
          List.unmodifiable(e.value),
        ),
      ),
    ),
  );
}

List<String> _withNoEmptyValues(List<String> values) =>
    values.where((value) => value.isNotEmpty).toList();
