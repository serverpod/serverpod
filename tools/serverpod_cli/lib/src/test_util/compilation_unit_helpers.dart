import 'package:analyzer/dart/ast/ast.dart';

abstract class CompilationUnitHelpers {
  /// Returns [TypeAlias] if the [unit] contains a type alias with the given
  /// [name], otherwise returns `null`.
  static TypeAlias? tryFindTypeAliasDeclaration(
    CompilationUnit unit, {
    required String name,
  }) {
    for (var declaration in unit.declarations.whereType<TypeAlias>()) {
      if (declaration.name.toString() == name) {
        return declaration;
      }
    }
    return null;
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
    for (var declaration in unit.declarations.whereType<ClassDeclaration>()) {
      if (declaration.name.toString() == name) {
        return declaration;
      }
    }
    return null;
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
    for (var declaration
        in unit.declarations.whereType<TopLevelVariableDeclaration>()) {
      for (var variable in declaration.variables.variables) {
        if (variable.name.toString() == name) {
          if (annotations != null &&
              !(declaration.metadata
                      .where((annotation) =>
                          annotations.contains(annotation.name.name))
                      .length ==
                  annotations.length)) {
            continue;
          }
          return declaration;
        }
      }
    }
    return null;
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
    return tryFindTopLevelVariableDeclaration(
          unit,
          name: name,
          annotations: annotations,
        ) !=
        null;
  }

  /// Return [ImportDirective] if the [unit] contains an import directive with
  /// the given [uri], otherwise returns `null`.
  static ImportDirective? tryFindImportDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    for (var directive in unit.directives.whereType<ImportDirective>()) {
      if (directive.uri.stringValue == uri) {
        return directive;
      }
    }
    return null;
  }

  /// Returns `true` if the [unit] contains an import directive with the given
  /// [uri].
  static bool hasImportDirective(
    CompilationUnit unit, {
    required String uri,
  }) {
    return tryFindImportDirective(unit, uri: uri) != null;
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

    if (extendsClause.superclass.name2.toString() == name) {
      return true;
    }

    return false;
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

    for (var type in implementsClause.interfaces) {
      if (type.name2.toString() == name) {
        return true;
      }
    }
    return false;
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
    for (var member
        in classDeclaration.members.whereType<ConstructorDeclaration>()) {
      if (member.name?.toString() == name) {
        if (parameters != null &&
            !(member.parameters.parameters
                    .where((p) => parameters.contains(p.toString()))
                    .length ==
                parameters.length)) {
          continue;
        }

        if (superArguments != null &&
            !(member.initializers
                    .whereType<SuperConstructorInvocation>()
                    .map((e) => e.argumentList.arguments)
                    .expand((e) => e)
                    .where((e) => superArguments.contains(e.toString()))
                    .length ==
                superArguments.length)) {
          continue;
        }

        return member;
      }
    }
    return null;
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
    return tryFindConstructorDeclaration(
          classDeclaration,
          name: name,
          parameters: parameters,
          superArguments: superArguments,
        ) !=
        null;
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
    for (var member
        in classDeclaration.members.whereType<MethodDeclaration>()) {
      if (member.name.toString() == name) {
        if (isStatic != null && member.isStatic != isStatic) {
          continue;
        }

        if (functionExpression != null &&
            !(member.body is ExpressionFunctionBody &&
                (member.body as ExpressionFunctionBody).expression.toString() ==
                    functionExpression)) {
          continue;
        }

        return member;
      }
    }
    return null;
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
    return tryFindMethodDeclaration(
          classDeclaration,
          name: name,
          isStatic: isStatic,
          functionExpression: functionExpression,
        ) !=
        null;
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
    String? initializerMethod,
  }) {
    for (var member in classDeclaration.members.whereType<FieldDeclaration>()) {
      if (member.fields.variables
          .any((variable) => variable.name.toString() == name)) {
        if (type != null && member.fields.type?.toString() != type) {
          continue;
        }

        if (isStatic != null && member.isStatic != isStatic) {
          continue;
        }

        if (isFinal != null && member.fields.isFinal != isFinal) {
          continue;
        }

        if (initializerMethod != null &&
            !(member.fields.variables
                .map((variable) => variable.initializer)
                .whereType<MethodInvocation>()
                .any((initializer) =>
                    initializer.methodName.toString() == initializerMethod))) {
          continue;
        }

        return member;
      }
    }
    return null;
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
    bool? isNullable,
    bool? isStatic,
    bool? isFinal,
    String? initializerMethod,
  }) {
    return tryFindFieldDeclaration(
          classDeclaration,
          name: name,
          type: type,
          isStatic: isStatic,
          isFinal: isFinal,
          initializerMethod: initializerMethod,
        ) !=
        null;
  }
}
