BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_jsonb" (
    "id" bigserial PRIMARY KEY,
    "indexed0" json NOT NULL,
    "indexed1" jsonb NOT NULL,
    "indexed2" jsonb NOT NULL,
    "indexed3" jsonb NOT NULL
);

-- Indexes
CREATE INDEX "jsonb_index_gin" ON "object_with_jsonb" USING GIN ("indexed2" jsonb_ops);
CREATE INDEX "jsonb_index_gin_with_operator_class" ON "object_with_jsonb" USING GIN ("indexed3" jsonb_path_ops);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_jsonb_class_level" (
    "id" bigserial PRIMARY KEY,
    "jsonb1" jsonb NOT NULL,
    "jsonb2" jsonb NOT NULL,
    "json" json NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260414092400332', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260414092400332', "timestamp" = now();

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
