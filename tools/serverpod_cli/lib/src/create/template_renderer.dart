import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:whiskers/whiskers.dart';

/// Renders Mustache `{{...}}` directives in a known set of file paths
/// (typically the files [Copier] just wrote) and their ancestor
/// directory names.
///
/// Operating on an explicit path list - rather than walking the project
/// tree - guarantees the renderer never reads or rewrites a file the
/// caller didn't ask for, sidestepping any question of "should we have
/// entered `.dart_tool` / `build` / `.git`".
class TemplateRenderer {
  static final DartFormatter _dartFormatter = DartFormatter(
    // update in concert with `code_generator.dart`
    languageVersion: Version(3, 10, 0),
    trailingCommas: TrailingCommas.preserve,
  );

  const TemplateRenderer();

  /// Renders [paths] under [context]:
  ///
  /// 1. Each ancestor directory whose basename contains a Mustache
  ///    directive is renamed (deepest first). A directive that renders
  ///    to empty deletes the directory recursively. A pre-existing
  ///    target directory triggers a recursive merge instead of a
  ///    rename, so a second upgrade run doesn't leave literal `{{...}}`
  ///    directories behind on disk.
  /// 2. Each surviving file's basename is rendered (renaming or
  ///    deleting the file).
  /// 3. Each surviving file's contents are rendered, and reformatted
  ///    in-process via [DartFormatter] when the extension is `.dart`.
  Future<void> renderPaths(
    Iterable<String> paths,
    TemplateContext context,
  ) async {
    final pathList = paths.toList();
    await _renameAncestors(pathList, context);
    for (final original in pathList) {
      final current = _translateDirSegments(original, context);
      if (current == null) continue;
      final file = File(current);
      if (!await file.exists()) continue;
      await _renderFile(file, context);
    }
  }

  /// Renames every ancestor directory of any path in [paths] whose
  /// basename carries a Mustache directive. Deduplicated, deepest first
  /// so each rename sees its parents under their original names.
  Future<void> _renameAncestors(
    List<String> paths,
    TemplateContext context,
  ) async {
    final byDepth = <int, Set<String>>{};
    for (final filePath in paths) {
      var dir = p.dirname(filePath);
      // `p.dirname` of a filesystem root returns itself.
      while (dir != p.dirname(dir)) {
        if (_hasTemplateMarker(p.basename(dir))) {
          byDepth.putIfAbsent(p.split(dir).length, () => {}).add(dir);
        }
        dir = p.dirname(dir);
      }
    }
    final depths = byDepth.keys.toList()..sort((a, b) => b.compareTo(a));
    for (final depth in depths) {
      for (final dirPath in byDepth[depth]!) {
        await _renameAncestor(dirPath, context);
      }
    }
  }

  Future<void> _renameAncestor(
    String dirPath,
    TemplateContext context,
  ) async {
    final source = Directory(dirPath);
    if (!await source.exists()) return;
    final renderedName = _renderFileSystemEntityName(
      p.basename(dirPath),
      context,
    );
    try {
      if (renderedName.isEmpty) {
        await source.delete(recursive: true);
        return;
      }
      final destPath = p.join(p.dirname(dirPath), renderedName);
      if (destPath == dirPath) return;
      final dest = Directory(destPath);
      if (await dest.exists()) {
        await _mergeIntoDirectory(source, dest);
      } else {
        await source.rename(destPath);
      }
    } on FileSystemException {
      // Source vanished mid-flight (e.g. an outer rename already moved
      // it). Best-effort: skip.
    }
  }

  /// Computes [original]'s path after [_renameAncestors] has run, by
  /// re-rendering every *directory* segment. Returns `null` if any
  /// ancestor segment renders to empty (the file's parent was deleted).
  /// The file basename is preserved verbatim - [_renderFileName]
  /// handles that separately once we open the file.
  String? _translateDirSegments(String original, TemplateContext context) {
    final segments = p.split(original);
    final out = <String>[];
    for (var i = 0; i < segments.length; i++) {
      final seg = segments[i];
      final isFileBasename = i == segments.length - 1;
      if (!isFileBasename && _hasTemplateMarker(seg)) {
        final rendered = _renderFileSystemEntityName(seg, context);
        if (rendered.isEmpty) return null;
        out.add(rendered);
      } else {
        out.add(seg);
      }
    }
    return p.joinAll(out);
  }

  /// Recursively moves [source]'s contents into [destination],
  /// overwriting on file collision and merging on directory collision.
  /// [source] is deleted once empty.
  Future<void> _mergeIntoDirectory(
    Directory source,
    Directory destination,
  ) async {
    await for (final entity in source.list(followLinks: false)) {
      final destPath = p.join(destination.path, p.basename(entity.path));
      if (entity is File) {
        await entity.rename(destPath);
      } else if (entity is Directory) {
        final destDir = Directory(destPath);
        if (await destDir.exists()) {
          await _mergeIntoDirectory(entity, destDir);
        } else {
          await entity.rename(destPath);
        }
      }
    }
    await source.delete();
  }

  Future<void> _renderFile(File file, TemplateContext context) async {
    try {
      final renderedFile = await _renderFileName(file, context);
      if (renderedFile != null) await _renderFileContent(renderedFile, context);
    } on FileSystemException {
      // File gone.
    } on FormatException {
      // A binary file slipped into the path list. Skip it!
    }
  }

  /// Renames [file] if its basename carries a Mustache directive.
  /// Deletes the file if the directive renders to empty.
  Future<File?> _renderFileName(File file, TemplateContext context) async {
    final fileName = p.basename(file.path);
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

  Future<void> _renderFileContent(File file, TemplateContext context) async {
    final extension = p.extension(file.path);

    final content = await file.readAsString();
    if (!_hasTemplateMarker(content)) return;

    final processedContent = _preprocessContent(content);
    final renderedContent = _renderTemplate(processedContent, context);

    if (renderedContent.trim().isEmpty) {
      await file.delete();
      return;
    }
    if (renderedContent == content) return;

    String toWrite;
    if (extension == '.dart') {
      try {
        toWrite = _dartFormatter.format(renderedContent);
      } on FormatterException {
        // Rendered output isn't valid Dart - leave the file untouched
        // rather than persisting a broken intermediate (which would
        // also touch the file's mtime).
        return;
      }
    } else {
      toWrite = renderedContent;
    }
    await file.writeAsString(toWrite);
  }

  static bool _hasTemplateMarker(String s) => s.contains('{{');

  String _renderTemplate(String content, TemplateContext context) {
    try {
      var template = Template(content, lenient: true, htmlEscapeValues: false);
      return template.renderString(
        context.toMustacheMap(),
        onMissingVariable: (name, context) => '{{$name}}',
      );
    } catch (_) {
      return content;
    }
  }

  /// Preprocesses [content] by stripping `// ` / `# ` / `<!-- `
  /// comment prefixes from Mustache directives, so that templates
  /// can embed directives inside otherwise-valid source files.
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
    result = result.replaceAllMapped(
      RegExp(r'<!--\s*(\{\{[^}]+\}\})\s*-->'),
      (match) => match.group(1)!,
    );
    return result;
  }

  String _renderFileSystemEntityName(String name, TemplateContext context) {
    return _renderTemplate(
      name.replaceAll(r'{{!', '{{/'),
      context,
    ).replaceAll(RegExp(r'\{\{/ ?\}\}'), '');
  }
}
