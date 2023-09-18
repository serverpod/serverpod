BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "types" ADD COLUMN "anEnum" integer;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230918134058', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230918134058', "priority" = 2;


COMMIT;
