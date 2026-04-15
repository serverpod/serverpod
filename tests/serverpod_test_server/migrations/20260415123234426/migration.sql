BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_jsonb" (
    "id" bigserial PRIMARY KEY,
    "notJsonb" json NOT NULL,
    "jsonb" jsonb NOT NULL,
    "jsonbIndexed" jsonb NOT NULL,
    "jsonbIndexedGin" jsonb NOT NULL,
    "jsonbIndexedGinJsonbPath" jsonb NOT NULL,
    "nullableJsonb" jsonb
);

-- Indexes
CREATE INDEX "jsonb_index_gin" ON "object_with_jsonb" USING gin ("jsonbIndexedGin" jsonb_ops);
CREATE INDEX "jsonb_index_gin_with_operator_class" ON "object_with_jsonb" USING gin ("jsonbIndexedGinJsonbPath" jsonb_path_ops);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_jsonb_class_level" (
    "id" bigserial PRIMARY KEY,
    "implicitJsonb" jsonb NOT NULL,
    "explicitJsonb" jsonb NOT NULL,
    "json" json NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260415123234426', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260415123234426', "timestamp" = now();

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
