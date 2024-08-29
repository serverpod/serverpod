class MimeType {
  final String primaryType;
  final String subType;

  const MimeType(this.primaryType, this.subType);

  factory MimeType.parse(String type) {
    var parts = type.split('/');
    if (parts.length != 2) {
      throw FormatException('Invalid mime type $type');
    }

    var primaryType = parts[0];
    var subType = parts[1];

    if (primaryType.isEmpty || subType.isEmpty) {
      throw FormatException('Invalid mime type $type');
    }
    return MimeType(primaryType, subType);
  }

  @override
  String toString() => '$primaryType/$subType';
}
