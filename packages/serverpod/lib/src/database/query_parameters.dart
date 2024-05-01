/// Provides parameters for direct database queries with [Database.query]
abstract class QueryParameters {
  /// retrieve current parameters
  Object? get parameters;

  /// Named parameters are indicated by using @
  ///
  /// ```dart
  /// var result = await query(
  ///     'SELECT id FROM apparel WHERE color = @color AND size = @size',
  ///     QueryParameters.named({
  ///       'color': 'green',
  ///       'size': 'XL',
  ///     }));
  /// ```
  factory QueryParameters.named(Map<String, Object?> parameter) {
    return QueryParametersNamed(parameter);
  }

  /// Positional parameters are indicated by using $
  ///
  /// ```dart
  /// var result = await query(
  ///     'SELECT id FROM apparel WHERE color = $1 AND size = $2',
  ///     QueryParameters.positional(['green', 'XL']));
  /// ```
  factory QueryParameters.positional(List<Object?> parameter) {
    return QueryParametersPositional(parameter);
  }
}

/// Named parameters for query.
class QueryParametersNamed implements QueryParameters {
  /// Named parameters are indicated by using @
  ///
  /// ```dart
  /// var result = await query(
  ///     'SELECT id FROM apparel WHERE color = @color AND size = @size',
  ///     QueryParametersNamed({
  ///       'color': 'green',
  ///       'size': 'XL',
  ///     }));
  /// ```
  QueryParametersNamed(Map<String, Object?> parameters)
      : _parameters = parameters;

  final Map<String, Object?> _parameters;

  @override
  Map<String, Object?> get parameters => _parameters;
}

/// Positional Parameters for [query]
class QueryParametersPositional implements QueryParameters {
  /// pos params
  /// Positional parameters are indicated by using $
  ///
  /// ```dart
  /// var result = await query(
  ///     'SELECT id FROM apparel WHERE color = $1 AND size = $2',
  ///     QueryParametersPositional(['green', 'XL']));
  /// ```
  QueryParametersPositional(List<Object?> parameters)
      : _parameters = parameters;

  final List<Object?> _parameters;

  @override
  List<Object?> get parameters => _parameters;
}
