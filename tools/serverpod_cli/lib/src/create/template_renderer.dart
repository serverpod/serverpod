import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:whiskers/whiskers.dart';

/// Responsible for rendering template files in a directory using provided context.
/// It processes both file contents and directory names,
/// allowing for dynamic project structures.
class TemplateRenderer {
  static const Set<String> _defaultExcludedDirNames = <String>{
    '.git',
    '.dart_tool',
    '.idea',
    '.vscode',
    '.github',
    'node_modules',
    'Pods',
    // Dart/Flutter build output.
    'build',
    '.symlinks',
    // Serverpod runtime artefacts.
    'sqlite_data',
    'migrations',
    '.serverpod',
  };

  static final DartFormatter _dartFormatter = DartFormatter(
    // update in concert with `code_generator.dart`
    languageVersion: Version(3, 10, 0),
    trailingCommas: TrailingCommas.preserve,
  );

  /// Creates a [TemplateRenderer].
  ///
  /// [excludedDirNames] may be passed to override the default set of
  /// directory basenames that are skipped during traversal.
  TemplateRenderer({
    required this.dir,
    Set<String>? excludedDirNames,
  }) : excludedDirNames = excludedDirNames ?? _defaultExcludedDirNames;

  /// The target directory containing the template files to be rendered.
  final Directory dir;

  /// Directory basenames to skip while recursing.
  final Set<String> excludedDirNames;

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
        final basename = p.basename(entity.path);
        if (excludedDirNames.contains(basename)) continue;
        await _handleDirectoryRendering(entity, context);
      }
    }
  }

  Future<void> _handleDirectoryRendering(
    Directory directory,
    TemplateContext context,
  ) async {
    try {
      final basename = p.basename(directory.path);

      // Fast path! directory names without template directives can't be renamed,
      // so just recurse without invoking the Mustache parser.
      if (!_hasTemplateMarker(basename)) {
        await _renderDirectory(directory, context);
        return;
      }

      final renderedName = _renderFileSystemEntityName(basename, context);
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
        context.toMustacheMap(),
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
      // File gone.
    } on FormatException {
      // Non-UTF8 content (binary asset?). Skip silently!
    }
  }

  /// Renders template directives in [file]'s base name.
  /// If rendering results in an empty file name (excluding extension), the file is deleted.
  Future<File?> _renderFileName(File file, TemplateContext context) async {
    final fileName = p.basename(file.path);

    // Fast path! File names without template directives can't be renamed.
    if (!_hasTemplateMarker(fileName)) return file;

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

    // Fast path! Bail before invoking expensive regex preprocessor and Mustache parser.
    if (!_hasTemplateMarker(content)) return;

    final processedContent = _preprocessContent(content);
    final renderedContent = _renderTemplate(processedContent, context);

    if (renderedContent.trim().isEmpty) {
      await file.delete();
      return;
    }
    if (renderedContent == content) return;

    var toWrite = renderedContent;
    if (p.extension(file.path) == '.dart') {
      try {
        toWrite = _dartFormatter.format(renderedContent);
      } on FormatterException {
        // Rendered output isn't valid Dart!
        // Write the unformatted content rather than failing the render.
      }
    }
    await file.writeAsString(toWrite);
  }

  /// Cheap test for the presence of a Mustache opening delimiter.
  static bool _hasTemplateMarker(String s) => s.contains('{{');

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
