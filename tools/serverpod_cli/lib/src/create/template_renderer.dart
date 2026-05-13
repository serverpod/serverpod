import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:whiskers/whiskers.dart';

/// Responsible for rendering template files in a directory using provided context.
/// It processes both file contents and directory names,
/// allowing for dynamic project structures.
class TemplateRenderer {
  /// Creates a [TemplateRenderer].
  TemplateRenderer({required this.dir});

  /// The target directory containing the template files to be rendered.
  final Directory dir;

  /// Renders the templates in the target directory using [context].
  Future<void> render(TemplateContext context) async {
    try {
      await _renderDirectory(dir, context);
    } on FileSystemException {
      // Directory gone.
    }
  }

  /// Recursively renders all files and directories within the specified directory.
  Future<void> _renderDirectory(
    Directory dir,
    TemplateContext context,
  ) async {
    await for (final entity in dir.list(recursive: false, followLinks: false)) {
      if (entity is File) {
        await _renderFile(entity, context);
      } else if (entity is Directory) {
        await _handleDirectoryRendering(entity, context);
      }
    }
  }

  Future<void> _handleDirectoryRendering(
    Directory directory,
    TemplateContext context,
  ) async {
    try {
      final renderedName = _renderFileSystemEntityName(
        p.basename(directory.path),
        context,
      );
      final newPath = p.join(p.dirname(directory.path), renderedName);

      if (renderedName.isEmpty) {
        await directory.delete(recursive: true);
      } else if (newPath != directory.path) {
        await directory.rename(newPath);
        await _renderDirectory(Directory(newPath), context);
      } else {
        await _renderDirectory(directory, context);
      }
    } on FileSystemException {
      // Directory gone.
    }
  }

  String _renderTemplate(String content, TemplateContext context) {
    try {
      var template = Template(content, lenient: true);
      return template.renderString(
        context.toJson(),
        onMissingVariable: (name, context) {
          return '{{$name}}';
        },
      );
    } catch (_) {
      return content;
    }
  }

  /// Renders template directives in [file]'s base name and content.
  /// Rewrites [file] with the rendering result.
  /// If the [file] name or its content is empty after rendering, the [file] is deleted.
  Future<void> _renderFile(File file, TemplateContext context) async {
    try {
      final renderedFile = await _renderFileName(file, context);
      if (renderedFile != null) await _renderFileContent(renderedFile, context);
    } on FileSystemException {
      // File gone or not decodable.
    }
  }

  /// Renders template directives in [file]'s base name.
  /// If rendering results in an empty file name (excluding extension), the file is deleted.
  Future<File?> _renderFileName(File file, TemplateContext context) async {
    final fileName = p.basename(file.path);
    final renderedFileName = _renderFileSystemEntityName(fileName, context);
    late final extension = p.extension(fileName);

    if (fileName == renderedFileName) return file;

    if (renderedFileName.trim().isEmpty) {
      await file.delete();
      return null;
    } else if (extension.isNotEmpty) {
      final splits = renderedFileName.split(extension);
      if (splits.length != 2 || splits.first.trim().isEmpty) {
        await file.delete();
        return null;
      }
    }
    return await file.rename(p.join(p.dirname(file.path), renderedFileName));
  }

  /// Renders template directives in [file]'s content.
  /// If rendering results in a file with empty content, the file is deleted.
  Future<void> _renderFileContent(File file, TemplateContext context) async {
    final content = await file.readAsString();
    final processedContent = _preprocessContent(content);
    final renderedContent = _renderTemplate(processedContent, context);

    if (renderedContent.trim().isEmpty) {
      await file.delete();
    } else if (renderedContent != content) {
      await file.writeAsString(renderedContent);

      // Format rendered dart files
      final extension = p.extension(p.basename(file.path));
      if (extension == '.dart') await CommandLineTools.dartFormat(file);
    }
  }

  /// Preprocesses the content by removing comment markers from template directives.
  /// The comment markers allow template directives to be included in the source
  /// files without affecting the syntax of the code.
  /// For example, `// {{#enableAuth}}` will be transformed to `{{#enableAuth}}`.
  String _preprocessContent(String content) {
    var result = content;

    result = result.replaceAllMapped(
      RegExp(r'//\s*(\{\{[^}]+\}\})'),
      (match) => match.group(1)!,
    );

    result = result.replaceAllMapped(
      RegExp(r'#\s*(\{\{[^}]+\}\})'),
      (match) => match.group(1)!,
    );

    return result;
  }

  /// Formats the file/directory name as a template and returns the rendered name.
  String _renderFileSystemEntityName(String name, TemplateContext context) {
    return _renderTemplate(
      name.replaceAll(r'{{!', '{{/'),
      context,
    ).replaceAll(RegExp(r'\{\{/ ?\}\}'), '');
  }
}
