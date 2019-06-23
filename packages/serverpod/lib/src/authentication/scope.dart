final scopeNone = Scope(null);

class Scope {
  final String name;
  const Scope(this.name);

  bool operator==(o) => o is Scope && o.name == this.name;
  int get hashCode => name.hashCode;

  String toString() => 'Scope($name)';
}