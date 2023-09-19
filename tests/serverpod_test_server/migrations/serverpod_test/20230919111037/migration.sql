BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "address" ALTER COLUMN "inhabitantId" DROP NOT NULL;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230919111037', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230919111037', "priority" = 2;


COMMIT;
