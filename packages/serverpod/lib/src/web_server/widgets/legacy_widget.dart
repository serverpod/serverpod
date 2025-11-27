import 'package:serverpod/serverpod.dart';

// Deprecated aliases for migration support from the old Widget API
// These help users migrate from the original Widget names to the new naming structure

/// Deprecated alias for [WebWidget].
/// [AbstractWidget] was the base class for all widgets in the old API.
@Deprecated(
  'Use WebWidget instead. '
  'AbstractWidget has been renamed to WebWidget for better clarity. '
  'This class will be removed in a future version.',
)
abstract class AbstractWidget extends WebWidget {}

/// Deprecated alias for [TemplateWidget].
/// The base [Widget] class has been renamed to [TemplateWidget] for clarity.
@Deprecated(
  'Use TemplateWidget instead. '
  'Widget has been renamed to TemplateWidget to better distinguish it from the base WebWidget class. '
  'This class will be removed in a future version.',
)
class Widget extends TemplateWidget {
  /// Creates a new [Widget].
  Widget({required super.name});
}

/// Deprecated alias for [ListWidget].
/// [WidgetList] has been renamed to [ListWidget] for consistency.
@Deprecated(
  'Use ListWidget instead. '
  'WidgetList has been renamed to ListWidget for consistency. '
  'This class will be removed in a future version.',
)
class WidgetList extends ListWidget {
  /// Creates a new [WidgetList].
  WidgetList({required super.widgets});
}

/// Deprecated alias for [JsonWidget].
/// [WidgetJson] has been renamed to [JsonWidget] for consistency.
@Deprecated(
  'Use JsonWidget instead. '
  'WidgetJson has been renamed to JsonWidget for consistency. '
  'This class will be removed in a future version.',
)
class WidgetJson extends JsonWidget {
  /// Creates a new [WidgetJson].
  WidgetJson({required super.object});
}

/// Deprecated alias for [RedirectWidget].
/// [WidgetRedirect] has been renamed to [RedirectWidget] for consistency.
@Deprecated(
  'Use RedirectWidget instead. '
  'WidgetRedirect has been renamed to RedirectWidget for consistency. '
  'This class will be removed in a future version.',
)
class WidgetRedirect extends RedirectWidget {
  /// Creates a new [WidgetRedirect].
  WidgetRedirect({required super.url});
}
