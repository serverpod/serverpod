import 'dart:io';

void copyDirectory(Directory source, Directory destination) {
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }

  source.listSync(recursive: true).forEach((entity) {
    if (entity is Directory) {
      var newDirectory = Directory(
        '${destination.path}/${entity.path.split(source.path).last}',
      );
      newDirectory.createSync(recursive: true);
    } else if (entity is File) {
      var newFile = File(
        '${destination.path}/${entity.path.split(source.path).last}',
      );
      entity.copySync(newFile.path);
    }
  });
}
