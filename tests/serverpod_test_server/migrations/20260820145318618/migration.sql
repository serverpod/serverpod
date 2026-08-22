BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "object_with_projection" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "projected_article" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "projected_article" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "authorId" bigint NOT NULL,
    "summary" text NOT NULL,
    "content" text NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "projected_author" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "projected_author" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "bio" text NOT NULL,
    "email" text NOT NULL,
    "phone" text NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "projected_article"
    ADD CONSTRAINT "projected_article_fk_0"
    FOREIGN KEY("authorId")
    REFERENCES "projected_author"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260820145318618', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260820145318618', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260417182239578', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182239578', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260417182416941', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182416941', "timestamp" = now();


COMMIT;
