import '../generated/auth_key.dart';

/// Used to define who can access an [Endpoint]. Authenticated users can be
/// associated with a [Scope], if the same scope is defined in the [Endpoint]
/// the user is granted access. The scope is defined by its [name].
class Scope {
  /// Used to define a scope accessible by any users (authenticated or not).
  static const Scope none = Scope(null);

  /// Grants access to all admin functions.
  static const Scope admin = Scope('serverpod.admin');

  /// The identifying [name] of this scope.
  final String? name;

  /// Creates a new [Scope].
  const Scope(this.name);

  @override
  bool operator ==(Object other) => other is Scope && other.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Scope($name)';
}

/// Adds methods for scopes on [AuthKey].
extension AuthKeyScopes on AuthKey {
  /// Returns a set containing the scopes this user has access to.
  Set<Scope> get scopes {
    Set<Scope> set = <Scope>{};
    for (String scopeStr in scopeNames) {
      set.add(Scope(scopeStr));
    }
    return set;
  }
}
