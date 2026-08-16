import 'package:flutter/widgets.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';

/// Builder function for external IDP sign-in widgets.
typedef ExternalIdpWidgetBuilder =
    Widget Function(
      BuildContext context,
      ServerpodClientShared client,
      VoidCallback? onAuthenticated,
      Function(Object error)? onError,
    );

/// Registry for external identity provider widgets.
///
/// Allows external packages to register sign-in widgets dynamically.
/// [SignInWidget] automatically discovers and renders registered providers.
class ExternalIdpRegistry {
  ExternalIdpRegistry._();

  /// Singleton instance.
  static final ExternalIdpRegistry instance = ExternalIdpRegistry._();

  final Map<Type, ExternalIdpWidgetBuilder> _registry = {};

  /// Registers a widget builder for endpoint type [T].
  ///
  /// Throws [StateError] if type [T] is already registered.
  void register<T extends EndpointIdpBase>(ExternalIdpWidgetBuilder builder) {
    if (_registry.containsKey(T)) {
      throw StateError(
        'External IDP widget builder for type $T is already registered. '
        'Each provider can only be registered once.',
      );
    }
    _registry[T] = builder;
  }

  /// Unregisters the widget builder for type [T].
  ///
  /// Returns `true` if a builder was removed, `false` otherwise.
  bool unregister<T extends EndpointIdpBase>() {
    return _registry.remove(T) != null;
  }

  /// Returns the widget builder for type [T], or `null` if not registered.
  ExternalIdpWidgetBuilder? getBuilder<T extends EndpointIdpBase>() {
    return _registry[T];
  }

  /// Returns `true` if a widget builder is registered for type [T].
  bool hasBuilder<T extends EndpointIdpBase>() {
    return _registry.containsKey(T);
  }

  /// Returns all registered endpoint types.
  List<Type> get registeredTypes => _registry.keys.toList();

  /// Clears all registered widget builders.
  void clear() => _registry.clear();

  /// Returns the number of registered widget builders.
  int get count => _registry.length;

  /// Returns `true` if any widget builders are registered.
  bool get hasRegistrations => _registry.isNotEmpty;
}
