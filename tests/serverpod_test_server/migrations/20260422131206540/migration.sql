BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_jsonb" (
    "id" bigserial PRIMARY KEY,
    "notJsonb" json NOT NULL,
    "jsonb" jsonb NOT NULL,
    "jsonbMap" jsonb NOT NULL,
    "jsonbObject" jsonb NOT NULL,
    "jsonbIndexed" jsonb NOT NULL,
    "jsonbIndexedGin" jsonb NOT NULL,
    "jsonbIndexedGinJsonbPath" jsonb NOT NULL,
    "jsonbIndexedImplicitGin" jsonb NOT NULL,
    "nullableJsonb" jsonb
);

-- Indexes
CREATE INDEX "jsonb_index_gin" ON "object_with_jsonb" USING gin ("jsonbIndexedGin" jsonb_ops);
CREATE INDEX "jsonb_index_gin_with_operator_class" ON "object_with_jsonb" USING gin ("jsonbIndexedGinJsonbPath" jsonb_path_ops);
CREATE INDEX "jsonb_index_implicit_gin" ON "object_with_jsonb" USING gin ("jsonbIndexedImplicitGin" jsonb_ops);

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
    VALUES ('serverpod_test', '20260422131206540', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260422131206540', "timestamp" = now();

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
