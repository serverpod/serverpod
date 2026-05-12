BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "upsert_test_model" (
    "id" bigserial PRIMARY KEY,
    "code" text NOT NULL,
    "category" text NOT NULL,
    "value" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "code_unique_idx" ON "upsert_test_model" USING btree ("code");
CREATE UNIQUE INDEX "category_value_unique_idx" ON "upsert_test_model" USING btree ("category", "value");


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260511161041736', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260511161041736', "timestamp" = now();

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
