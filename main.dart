void main() {
  var content = sum([
    [1, 2, 3],
    [1, 2, 3]
  ]);
  print(content);
}

int sum(dynamic values) {
  print(values);
  if (values is List<List<int>>) {
    return sum(values.map((e) {
      return sum(e);
    }));
  } else if (values is List<int>) {
    if (values.isEmpty) return 0;
    return values.first + sum(values.sublist(1));
  }

  if(values is Iterable) {
    return sum(values.toList());
  }

  return values;
}
