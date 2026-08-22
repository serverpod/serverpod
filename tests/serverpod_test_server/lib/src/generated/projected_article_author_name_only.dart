/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'projected_author.dart' as _iq5hz6n4;
import 'projected_article.dart';

abstract class ProjectedArticleAuthorNameOnly
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ProjectedArticleAuthorNameOnly._({
    this.id,
    required this.title,
    required this.summary,
    required this.authorName,
  });

  factory ProjectedArticleAuthorNameOnly({
    int? id,
    required String title,
    required String summary,
    required String authorName,
  }) = _ProjectedArticleAuthorNameOnlyImpl;

  factory ProjectedArticleAuthorNameOnly.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedArticleAuthorNameOnly(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      summary: jsonSerialization['summary'] as String,
      authorName:
          (jsonSerialization['authorName'] ??
                  (jsonSerialization['author'] as Map?)?['name'])
              as String,
    );
  }

  static const db = ProjectedArticleAuthorNameOnlyRepository._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String summary;

  String authorName;

  /// Returns a shallow copy of this [ProjectedArticleAuthorNameOnly]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedArticleAuthorNameOnly copyWith({
    int? id,
    String? title,
    String? summary,
    String? authorName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedArticleAuthorNameOnly',
      if (id != null) 'id': id,
      'title': title,
      'summary': summary,
      'authorName': authorName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedArticleAuthorNameOnly',
      if (id != null) 'id': id,
      'title': title,
      'summary': summary,
      'authorName': authorName,
    };
  }

  static ProjectedArticleInclude include() {
    return ProjectedArticleInclude.internal_(
      selectedColumns: [
        ProjectedArticle.t.id,
        ProjectedArticle.t.title,
        ProjectedArticle.t.summary,
      ],
      author: _iq5hz6n4.ProjectedAuthorInclude.internal_(
        selectedColumns: [_iq5hz6n4.ProjectedAuthor.t.name],
      ),
    );
  }

  static ProjectedArticleIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
  }) {
    return ProjectedArticle.includeList(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: ProjectedArticleAuthorNameOnly.include(),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedArticleAuthorNameOnlyImpl
    extends ProjectedArticleAuthorNameOnly {
  _ProjectedArticleAuthorNameOnlyImpl({
    int? id,
    required String title,
    required String summary,
    required String authorName,
  }) : super._(
         id: id,
         title: title,
         summary: summary,
         authorName: authorName,
       );

  /// Returns a shallow copy of this [ProjectedArticleAuthorNameOnly]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedArticleAuthorNameOnly copyWith({
    Object? id = _Undefined,
    String? title,
    String? summary,
    String? authorName,
  }) {
    return ProjectedArticleAuthorNameOnly(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      authorName: authorName ?? this.authorName,
    );
  }
}

class ProjectedArticleAuthorNameOnlyRepository {
  const ProjectedArticleAuthorNameOnlyRepository._();

  /// Returns a list of [ProjectedArticle]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ProjectedArticleAuthorNameOnly>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findAsJson<ProjectedArticle>(
          where: where?.call(ProjectedArticle.t),
          orderBy: orderBy?.call(ProjectedArticle.t),
          orderByList: orderByList?.call(ProjectedArticle.t),
          limit: limit,
          offset: offset,
          transaction: transaction,
          include: ProjectedArticleAuthorNameOnly.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (rows) => rows
              .map((e) => ProjectedArticleAuthorNameOnly.fromJson(e))
              .toList(),
        );
  }

  /// Returns the first matching [ProjectedArticle] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ProjectedArticleAuthorNameOnly?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedArticleTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedArticleTable>? orderBy,
    _is.OrderByListBuilder<ProjectedArticleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findFirstRowAsJson<ProjectedArticle>(
          where: where?.call(ProjectedArticle.t),
          orderBy: orderBy?.call(ProjectedArticle.t),
          orderByList: orderByList?.call(ProjectedArticle.t),
          offset: offset,
          transaction: transaction,
          include: ProjectedArticleAuthorNameOnly.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedArticleAuthorNameOnly.fromJson(e),
        );
  }

  /// Finds a single [ProjectedArticle] by its [id] or null if no such row exists.
  Future<ProjectedArticleAuthorNameOnly?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return await session.db
        .findByIdAsJson<ProjectedArticle>(
          id,
          transaction: transaction,
          include: ProjectedArticleAuthorNameOnly.include(),
          lockMode: lockMode,
          lockBehavior: lockBehavior,
        )
        .then(
          (e) => e == null ? null : ProjectedArticleAuthorNameOnly.fromJson(e),
        );
  }
}
