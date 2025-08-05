import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';

abstract class CompilationUnitHelpers {
  /// Returns [TypeAlias] if the [unit] contains a type alias with the given
  /// [name], otherwise returns `null`.
  static TypeAlias? tryFindTypeAliasDeclaration(
    CompilationUnit unit, {
    required String name,
  }) {
    var aliasDeclaration = unit.declarations
        .whereType<TypeAlias>()
        .where((declaration) => declaration.name.toString() == name);

    return aliasDeclaration.isNotEmpty ? aliasDeclaration.first : null;
  }

  /// Returns `true` if the [unit] contains a type alias with the given [name].
  static bool hasTypeAliasDeclaration(
    CompilationUnit unit, {
    required String name,
  }) {
    return tryFindTypeAliasDeclaration(unit, name: name) != null;
  }

  static ClassDeclaration? tryFindClassDeclaration(
    CompilationUnit unit, {
    required String name,
  }) {
    var declaration = unit.declarations
        .whereType<ClassDeclaration>()
        .where((declaration) => declaration.name.toString() == name);

    return declaration.isNotEmpty ? declaration.first : null;
  }

  /// Returns `true` if the [unit] contains a class with the given [name].
  static bool hasClassDeclaration(
    CompilationUnit unit, {
    required String name,
  }) {
    return tryFindClassDeclaration(unit, name: name) != null;
  }

  /// Returns [TopLevelVariableDeclaration] if the [unit] contains a top level
  /// variable declaration with the given [name], otherwise returns `null`.
  ///
  /// If [annotations] is provided, the declaration must also have all of the
  /// given annotations.
  static TopLevelVariableDeclaration? tryFindTopLevelVariableDeclaration(
    CompilationUnit unit, {
    required String name,
    List<String>? annotations,
  }) {
    var topLevelDeclarations = unit.declarations
        .whereType<TopLevelVariableDeclaration>()
        .where((declaration) => declaration._hasMatchingVariable(name))
        .where(
            (declaration) => declaration._hasMatchingAnnotations(annotations));

    return topLevelDeclarations.isNotEmpty ? topLevelDeclarations.first : null;
  }

  /// Returns `true` if the [unit] contains a top level variable declaration
  /// with the given [name].
  ///
  /// If [annotations] is provided, the declaration must also have all of the
  /// given annotations.
  static bool hasTopLevelVariableDeclaration(
    CompilationUnit unit, {
    required String name,
    List<String>? annotations,
  }) {
    var maybeDeclaration = tryFindTopLevelVariableDeclaration(
      unit,
      name: name,
      annotations: annotations,
    );

    return maybeDeclaration != null;
  }

  /// Return [ImportDirective] if the [unit] contains an import directive with
  /// the given [uri], otherwise returns `null`.
  static ImportDirective? tryFindImportDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    var directives = unit.directives
        .whereType<ImportDirective>()
        .where((directive) => directive.uri.stringValue == uri);

    return directives.isNotEmpty ? directives.first : null;
  }

  /// Returns `true` if the [unit] contains an import directive with the given
  /// [uri].
  static bool hasImportDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    return tryFindImportDirective(unit, uri: uri) != null;
  }

  /// Returns [ExportDirective] if the [unit] contains an export directive with
  /// the given [uri], otherwise returns `null`.
  static ExportDirective? tryFindExportDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    var directives = unit.directives
        .whereType<ExportDirective>()
        .where((directive) => directive.uri.stringValue == uri);

    return directives.isNotEmpty ? directives.first : null;
  }

  /// Returns `true` if the [unit] contains an export directive with the given
  /// [uri].
  static bool hasExportDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    return tryFindExportDirective(unit, uri: uri) != null;
  }

  /// This is a temporary workaround for this bug: https://github.com/dart-lang/sdk/issues/59629
  /// In which `directive.uri.stringValue` returns the path on windows without separators.
  /// Meaning on:
  /// linux: `sub_dir/filename.dart` and `../filename.dart`
  /// windows: `subdirfilename.dart` and `..filename.dart`
  static String applyWindowsBugfix(String input) {
    if (Platform.isWindows) {
      return input.replaceAll('/', '');
    }
    return input;
  }

  /// Returns [List<PartDirective>] if the [unit] contains a part directive with the
  /// given [uri], otherwise returns `null`.
  static PartDirective? tryFindPartDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    return unit.directives.whereType<PartDirective>().where((directive) {
      String directiveUri = directive.uri.stringValue!;

      uri = applyWindowsBugfix(uri);

      return directiveUri == uri;
    }).firstOrNull;
  }

  /// Returns `true` if the [unit] contains a part directive with the given
  /// [uri].
  static bool hasPartDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    return tryFindPartDirective(unit, uri: uri) != null;
  }

  /// Returns [PartOfDirective] if the [unit] contains a part of directive with
  /// the given [uri], otherwise returns `null`.
  static PartOfDirective? tryFindPartOfDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    return unit.directives.whereType<PartOfDirective>().where((directive) {
      String directiveUri = directive.uri!.stringValue!;

      uri = applyWindowsBugfix(uri);

      return directiveUri == uri;
    }).firstOrNull;
  }

  /// Returns `true` if the [unit] contains a part of directive with the given
  /// [uri].
  static bool hasPartOfDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    return tryFindPartOfDirective(unit, uri: uri) != null;
  }

  /// Returns `true` if the [classDeclaration] has an extends clause with the
  /// given [name].
  static bool hasExtendsClause(
    ClassDeclaration classDeclaration, {
    required String name,
  }) {
    var extendsClause = classDeclaration.extendsClause;
    if (extendsClause == null) {
      return false;
    }

    return extendsClause.superclass.name2.toString() == name;
  }

  /// Returns `true` if the [classDeclaration] has an implements clause with
  /// the given [name].
  static bool hasImplementsClause(
    ClassDeclaration classDeclaration, {
    required String name,
  }) {
    var implementsClause = classDeclaration.implementsClause;
    if (implementsClause == null) {
      return false;
    }

    var matchingImplementsClauses = implementsClause.interfaces
        .where((type) => type.name2.toString() == name);

    return matchingImplementsClauses.isNotEmpty;
  }

  /// Returns [NamedType] if the class has an implements clause with the
  /// given [name], otherwise returns `null`.
  static NamedType? tryFindImplementedClass(
    ClassDeclaration classDeclaration, {
    required String name,
  }) {
    var implementsClause = classDeclaration.implementsClause;
    if (implementsClause == null) {
      return null;
    }

    return implementsClause.interfaces
        .where((type) => type.name2.toString() == name)
        .firstOrNull;
  }

  /// Returns [ConstructorDeclaration] if the class has a constructor with the
  /// given name and parameters, otherwise returns `null`.
  ///
  /// If name is null, the default constructor is matched.
  /// If [parameters] is provided, the constructor must have all of the given
  /// parameters.
  /// If [superArguments] is provided, the constructor must have all of the
  /// given super arguments.
  static ConstructorDeclaration? tryFindConstructorDeclaration(
    ClassDeclaration classDeclaration, {
    required String? name,
    List<String>? parameters,
    List<String>? superArguments,
  }) {
    var members = classDeclaration.members
        .whereType<ConstructorDeclaration>()
        .where((member) => member.name?.toString() == name)
        .where((member) => member._hasMatchingParameters(parameters))
        .where((member) => member._hasMatchingSuperArguments(superArguments));

    return members.isNotEmpty ? members.first : null;
  }

  /// Returns `true` if the class has a constructor with the given name and
  /// parameters.
  ///
  /// If name is `null`, the default constructor is matched.
  /// If [parameters] is provided, the constructor must have all of the given
  /// parameters.
  /// If [superArguments] is provided, the constructor must have all of the
  /// given super arguments.
  static bool hasConstructorDeclaration(
    ClassDeclaration classDeclaration, {
    required String? name,
    List<String>? parameters,
    List<String>? superArguments,
  }) {
    var maybeDeclaration = tryFindConstructorDeclaration(
      classDeclaration,
      name: name,
      parameters: parameters,
      superArguments: superArguments,
    );

    return maybeDeclaration != null;
  }

  /// Returns [MethodDeclaration] if the class has a method with the given
  /// [name], otherwise returns `null`.
  ///
  /// If [isStatic] is provided, the method must have the given static-ness.
  /// If [functionExpression] is provided, the method must have the given
  /// function expression.
  static MethodDeclaration? tryFindMethodDeclaration(
    ClassDeclaration classDeclaration, {
    required String name,
    bool? isStatic,
    String? functionExpression,
  }) {
    var member = classDeclaration.members
        .whereType<MethodDeclaration>()
        .where((member) => member.name.toString() == name)
        .where((member) => member._hasMatchingStatic(isStatic))
        .where((member) =>
            member._hasMatchingFunctionExpression(functionExpression));

    return member.isNotEmpty ? member.first : null;
  }

  /// Returns `true` if the class has a method with the given [name].
  ///
  /// If [isStatic] is provided, the method must have the given static-ness.
  /// If [functionExpression] is provided, the method must have the given
  /// function expression.
  static bool hasMethodDeclaration(
    ClassDeclaration classDeclaration, {
    required String name,
    bool? isStatic,
    String? functionExpression,
  }) {
    var maybeDeclaration = tryFindMethodDeclaration(
      classDeclaration,
      name: name,
      isStatic: isStatic,
      functionExpression: functionExpression,
    );

    return maybeDeclaration != null;
  }

  /// Returns [Annotation] if the class has an annotation with the given [name],
  /// otherwise returns `null`.
  static Annotation? tryFindAnnotation(
    MethodDeclaration methodDeclaration, {
    required String name,
  }) {
    var annotations = methodDeclaration.metadata
        .where((annotation) => annotation.name.name == name);

    return annotations.isNotEmpty ? annotations.first : null;
  }

  /// Returns `true` if the class has an annotation with the given [name].
  static bool hasAnnotation(
    MethodDeclaration classDeclaration, {
    required String name,
  }) {
    var maybeAnnotation = tryFindAnnotation(
      classDeclaration,
      name: name,
    );

    return maybeAnnotation != null;
  }

  /// Returns [FieldDeclaration] if the class has a field with the given [name],
  /// otherwise returns `null`.
  ///
  /// If [type] is provided, the field must have the given type.
  /// If [isStatic] is provided, the field must have the given static-ness.
  /// If [isFinal] is provided, the field must have the given final-ness.
  /// If [initializerMethod] is provided, the field must have the given
  /// initializer method.
  static FieldDeclaration? tryFindFieldDeclaration(
    ClassDeclaration classDeclaration, {
    required String name,
    String? type,
    bool? isStatic,
    bool? isFinal,
    bool? isLate,
    String? initializerMethod,
  }) {
    var member = classDeclaration.members
        .whereType<FieldDeclaration>()
        .where((member) => member._hasMatchingVariable(name))
        .where((member) => member._hasMatchingType(type))
        .where((member) => member._hasMatchingStatic(isStatic))
        .where((member) => member._hasMatchingFinal(isFinal))
        .where((member) => member._hasMatchingLate(isLate))
        .where((member) =>
            member._hasMatchingInitializerMethod(initializerMethod));

    return member.isNotEmpty ? member.first : null;
  }

  /// Returns `true` if the class has a field with the given [name].
  ///
  /// If [type] is provided, the field must have the given type.
  /// If [isStatic] is provided, the field must have the given static-ness.
  /// If [isFinal] is provided, the field must have the given final-ness.
  /// If [initializerMethod] is provided, the field must have the given
  /// initializer method.
  static bool hasFieldDeclaration(
    ClassDeclaration classDeclaration, {
    required String name,
    String? type,
    bool? isStatic,
    bool? isFinal,
    bool? isLate,
    String? initializerMethod,
  }) {
    var maybeDeclaration = tryFindFieldDeclaration(
      classDeclaration,
      name: name,
      type: type,
      isStatic: isStatic,
      isFinal: isFinal,
      isLate: isLate,
      initializerMethod: initializerMethod,
    );

    return maybeDeclaration != null;
  }
}

extension _TopLevelVariableDeclarationExtensions
    on TopLevelVariableDeclaration {
  bool _hasMatchingVariable(String name) {
    return variables.variables
        .any((variable) => variable.name.toString() == name);
  }

  bool _hasMatchingAnnotations(List<String>? annotations) {
    if (annotations == null) {
      return true;
    }

    var matchingAnnotations = metadata
        .where((annotation) => annotations.contains(annotation.name.name));

    return matchingAnnotations.length == annotations.length;
  }
}

extension _ConstructorDeclarationExtensions on ConstructorDeclaration {
  bool _hasMatchingParameters(List<String>? parameters) {
    if (parameters == null) {
      return true;
    }

    var memberParameters = this.parameters.parameters;
    var matchingParameters =
        memberParameters.where((p) => parameters.contains(p.toString()));

    return matchingParameters.length == parameters.length;
  }

  bool _hasMatchingSuperArguments(List<String>? superArguments) {
    if (superArguments == null) {
      return true;
    }

    var memberSuperArguments = initializers
        .whereType<SuperConstructorInvocation>()
        .map((e) => e.argumentList.arguments)
        .first;

    var matchingSuperArguments = memberSuperArguments
        .where((e) => superArguments.contains(e.toString()));

    return matchingSuperArguments.length == superArguments.length;
  }
}

extension _MethodDeclarationExtensions on MethodDeclaration {
  bool _hasMatchingStatic(bool? isStatic) {
    if (isStatic == null) {
      return true;
    }

    return this.isStatic == isStatic;
  }

  bool _hasMatchingFunctionExpression(String? functionExpression) {
    if (functionExpression == null) {
      return true;
    }

    return body is ExpressionFunctionBody &&
        (body as ExpressionFunctionBody).expression.toString() ==
            functionExpression;
  }
}

extension _FieldDeclarationExtensions on FieldDeclaration {
  bool _hasMatchingVariable(String name) {
    return fields.variables.any((variable) => variable.name.toString() == name);
  }

  bool _hasMatchingStatic(bool? isStatic) {
    if (isStatic == null) {
      return true;
    }

    return this.isStatic == isStatic;
  }

  bool _hasMatchingType(String? type) {
    if (type == null) {
      return true;
    }

    return fields.type?.toString() == type;
  }

  bool _hasMatchingFinal(bool? isFinal) {
    if (isFinal == null) {
      return true;
    }

    return fields.isFinal == isFinal;
  }

  bool _hasMatchingLate(bool? isLate) {
    if (isLate == null) {
      return true;
    }

    return fields.isLate == isLate;
  }

  bool _hasMatchingInitializerMethod(String? initializerMethod) {
    if (initializerMethod == null) {
      return true;
    }

    return fields.variables
        .map((variable) => variable.initializer)
        .whereType<MethodInvocation>()
        .any((initializer) =>
            initializer.methodName.toString() == initializerMethod);
  }
}
