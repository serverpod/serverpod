BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "book" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "chapter" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "_bookChaptersBookId" bigint
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "chapter"
    ADD CONSTRAINT "chapter_fk_0"
    FOREIGN KEY("_bookChaptersBookId")
    REFERENCES "book"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250325155839760', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250325155839760', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
