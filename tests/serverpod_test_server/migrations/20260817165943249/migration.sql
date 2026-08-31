BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "deferrable_relation_initially_deferred" (
    "id" bigserial PRIMARY KEY,
    "parentId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "deferrable_relation_initially_immediate" (
    "id" bigserial PRIMARY KEY,
    "parentId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "deferrable_relation_parent" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "deferrable_relation_initially_deferred"
    ADD CONSTRAINT "deferrable_relation_initially_deferred_fk_0"
    FOREIGN KEY("parentId")
    REFERENCES "deferrable_relation_parent"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    DEFERRABLE INITIALLY DEFERRED;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "deferrable_relation_initially_immediate"
    ADD CONSTRAINT "deferrable_relation_initially_immediate_fk_0"
    FOREIGN KEY("parentId")
    REFERENCES "deferrable_relation_parent"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    DEFERRABLE INITIALLY IMMEDIATE;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260817165943249', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260817165943249', "timestamp" = now();

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

--
-- MIGRATION VERSION FOR serverpod_test_shared_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_shared_module', '20260711022602028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260711022602028', "timestamp" = now();


COMMIT;
