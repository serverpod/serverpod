final scopeNone = Scope(null);

class Scope {
  final String? name;
  const Scope(this.name);

  @override
  bool operator==(o) => o is Scope && o.name == name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'Scope($name)';
}