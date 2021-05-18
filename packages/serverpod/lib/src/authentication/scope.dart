/// Used to define a scope accessible by any users (authenticated or not).
final scopeNone = const Scope(null);

/// Used to define who can access an [Endpoint]. Authenticated users can be
/// associated with a [Scope], if the same scope is defined in the [Endpoint]
/// the user is granted access. The scope is defined by its [name].
class Scope {
  /// The identifying [name] of this scope.
  final String? name;

  /// Creates a new [Scope].
  const Scope(this.name);

  @override
  bool operator==(o) => o is Scope && o.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Scope($name)';
}