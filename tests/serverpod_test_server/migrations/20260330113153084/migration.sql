BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task_claim" (
    "id" bigserial PRIMARY KEY,
    "server" text NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "task_claim"
    ADD CONSTRAINT "task_claim_fk_0"
    FOREIGN KEY("id")
    REFERENCES "task"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260330113153084', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260330113153084', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260324085808546', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085808546', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260324085838223', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085838223', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260324085920616', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085920616', "timestamp" = now();


COMMIT;
