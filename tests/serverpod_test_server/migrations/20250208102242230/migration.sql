BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "types" ADD COLUMN "aList" json;
ALTER TABLE "types" ADD COLUMN "aMap" json;
ALTER TABLE "types" ADD COLUMN "aSet" json;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250208102242230', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250208102242230', "timestamp" = now();

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
