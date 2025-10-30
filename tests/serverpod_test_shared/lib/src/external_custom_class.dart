// TODO(https://github.com/serverpod/serverpod/issues/4107):
// Put public facing types in this file.

class ExternalCustomClass {
  final String value;

  const ExternalCustomClass(this.value);

  String toJson() => value;

  static ExternalCustomClass fromJson(dynamic data) {
    return ExternalCustomClass(data);
  }
}
