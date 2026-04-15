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
    VALUES ('serverpod_test', '20260415153033359', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260415153033359', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260407154349528', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154349528', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260407154723760', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154723760', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260407154808499', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154808499', "timestamp" = now();


COMMIT;
