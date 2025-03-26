import '../../../../test_tools/serverpod_test_tools.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() async {
  withServerpod(
    'Given an entity with an implicit one-to-many relation',
    (sessionBuilder, _) {
      var session = sessionBuilder.build();

      setUp(() async {
        var book = await Book.db.insertRow(
          session,
          Book(title: 'Book 1'),
        );

        var chapter = await Chapter.db.insertRow(
          session,
          Chapter(title: 'Chapter 1'),
        );

        await Book.db.attachRow.chapters(session, book, chapter);
      });

      test(
          'when updating field on "many" side then relation is still preserved',
          () async {
        var chapter = await Chapter.db.findFirstRow(session);

        await Chapter.db.updateRow(
          session,
          chapter!.copyWith(title: 'Chapter 2'),
        );

        var book = await Book.db.findFirstRow(
          session,
          include: Book.include(
            chapters: Chapter.includeList(),
          ),
        );

        expect(book?.chapters, hasLength(1));
      });

      test(
          'when creating a object to update entity with implicit relation, then relation is preserved',
          () async {
        var storedChapter = await Chapter.db.findFirstRow(session);
        expect(storedChapter, isNotNull);
        var newChapter = Chapter(
          title: storedChapter!.title,
          id: storedChapter.id,
        );

        await Chapter.db.updateRow(
          session,
          newChapter,
        );

        var book = await Book.db.findFirstRow(
          session,
          include: Book.include(
            chapters: Chapter.includeList(),
          ),
        );
        expect(book?.chapters, hasLength(1));
      });
    },
  );
}
