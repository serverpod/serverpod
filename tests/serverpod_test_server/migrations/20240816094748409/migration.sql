BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "object_with_object" ADD COLUMN "nestedDataList" json;
ALTER TABLE "object_with_object" ADD COLUMN "nestedDataListInMap" json;
ALTER TABLE "object_with_object" ADD COLUMN "nestedDataMap" json;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240816094748409', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240816094748409', "timestamp" = now();

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
    VALUES ('serverpod_test_module', '20240115074247714', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074247714', "timestamp" = now();


COMMIT;
