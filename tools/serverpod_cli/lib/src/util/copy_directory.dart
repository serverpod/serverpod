import 'dart:io';

void copyDirectory(Directory source, Directory destination) {
  if (!destination.existsSync()) {
    destination.createSync(recursive: true);
  }

  source.listSync(recursive: true).forEach((model) {
    if (model is Directory) {
      var newDirectory = Directory(
        '${destination.path}/${model.path.split(source.path).last}',
      );
      newDirectory.createSync(recursive: true);
    } else if (model is File) {
      var newFile = File(
        '${destination.path}/${model.path.split(source.path).last}',
      );
      model.copySync(newFile.path);
    }
  });
}
