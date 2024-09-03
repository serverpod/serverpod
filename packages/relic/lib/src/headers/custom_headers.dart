part of '../headers.dart';

final _emptyCustomHeaders = CustomHeaders._empty();

/// Unmodifiable, key-insensitive header map.
class CustomHeaders extends UnmodifiableMapView<String, List<String>> {
  factory CustomHeaders.empty() => _emptyCustomHeaders;

  factory CustomHeaders(
    Map<String, String> values,
  ) {
    return CustomHeaders._(
      values.entries.map((e) => MapEntry(e.key, [e.value])),
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
