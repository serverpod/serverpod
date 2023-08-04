import 'package:analyzer/dart/ast/ast.dart';

abstract class CompilationUnitHelpers {
  static ClassDeclaration? tryFindClassDeclaration(CompilationUnit unit,
      {required String name}) {
    for (var declaration in unit.declarations) {
      if (declaration is ClassDeclaration &&
          declaration.name.toString() == name) {
        return declaration;
      }
    }
    return null;
  }

  static bool hasClassDeclaration(CompilationUnit unit,
      {required String name}) {
    return tryFindClassDeclaration(unit, name: name) != null;
  }

  static ImportDirective? tryFindImportDirective(CompilationUnit unit,
      {required String uri}) {
    for (var directive in unit.directives) {
      if (directive is ImportDirective && directive.uri.stringValue == uri) {
        return directive;
      }
    }
    return null;
  }

  static bool hasImportDirective(CompilationUnit unit, {required String uri}) {
    return tryFindImportDirective(unit, uri: uri) != null;
  }

  static bool hasExtendsClause(ClassDeclaration classDeclaration,
      {required String name}) {
    if (classDeclaration.extendsClause!.superclass.name2.toString() == name) {
      return true;
    }
    return false;
  }

  /// Returns [ConstructorDeclaration] if the class has a constructor with the
  /// given name and parameters.
  ///
  /// If name is null, the default constructor is matched.
  static ConstructorDeclaration? tryFindConstructorDeclaration(
    ClassDeclaration classDeclaration, {
    required String? name,
    List<String>? parameters,
    List<String>? superArguments,
  }) {
    for (var member in classDeclaration.members) {
      if (member is ConstructorDeclaration && member.name?.toString() == name) {
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

  /// Returns true if the class has a constructor with the given name and
  /// parameters.
  ///
  /// If name is null, the default constructor is matched.
  static bool hasConstructorDeclaration(
    ClassDeclaration classDeclaration, {
    required String? name,
    List<String>? parameters,
    List<String>? superArguments,
  }) {
    return tryFindConstructorDeclaration(classDeclaration,
            name: name,
            parameters: parameters,
            superArguments: superArguments) !=
        null;
  }

  static MethodDeclaration? tryFindMethodDeclaration(
      ClassDeclaration classDeclaration,
      {required String name,
      bool? isStatic}) {
    for (var member in classDeclaration.members) {
      if (member is MethodDeclaration && member.name.toString() == name) {
        if (isStatic != null && member.isStatic != isStatic) {
          continue;
        }

        return member;
      }
    }
    return null;
  }

  static bool hasMethodDeclaration(ClassDeclaration classDeclaration,
      {required String name, bool? isStatic}) {
    return tryFindMethodDeclaration(classDeclaration,
            name: name, isStatic: isStatic) !=
        null;
  }

  static FieldDeclaration? tryFindFieldDeclaration(
    ClassDeclaration classDeclaration, {
    required String name,
    String? type,
    bool? isStatic,
    bool? isFinal,
    String? initializerMethod,
  }) {
    for (var member in classDeclaration.members) {
      if (member is FieldDeclaration &&
          member.fields.variables
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

  static bool hasFieldDeclaration(ClassDeclaration classDeclaration,
      {required String name,
      String? type,
      bool? isNullable,
      bool? isStatic,
      bool? isFinal,
      String? initializerMethod}) {
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
