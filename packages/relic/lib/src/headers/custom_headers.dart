part of '../headers.dart';

final _emptyCustomHeaders = CustomHeaders._empty();

/// Unmodifiable, key-insensitive header map.
class CustomHeaders extends UnmodifiableMapView<String, List<String>> {
  late final Map<String, String> singleValues = UnmodifiableMapView(
    CaseInsensitiveMap.from(
      map(
        (key, value) => MapEntry(
          key.toLowerCase(),
          _joinHeaderValues(value)!,
        ),
      ),
    ),
  );

  factory CustomHeaders(
    Map<String, String> values,
  ) {
    return CustomHeaders._(
      values.entries.map((e) => MapEntry(e.key, [e.value])),
    );
  }

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
  ) : super(
          CaseInsensitiveMap.from(
            _entriesToMap(
              entries
                  .where((e) => e.value.where((e) => e.isNotEmpty).isNotEmpty)
                  .map(
                    (e) => MapEntry(
                      e.key.toLowerCase(),
                      List.unmodifiable(e.value.where((el) => el.isNotEmpty)),
                    ),
                  ),
            ),
          ),
        );

  CustomHeaders._empty() : super(const {});

  factory CustomHeaders.empty() => _emptyCustomHeaders;

  static Map<String, List<String>> _entriesToMap(
    Iterable<MapEntry<String, List<String>>> entries,
  ) {
    var map = Map.fromEntries(entries);
    return map;
  }

  static String? _joinHeaderValues(List<String>? values) {
    if (values == null) return null;
    if (values.isEmpty) return '';
    if (values.length == 1) return values.single;
    return values.join(',');
  }
}
