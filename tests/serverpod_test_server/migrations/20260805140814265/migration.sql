BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "nulls_distinct_data" (
    "id" bigserial PRIMARY KEY,
    "tenantId" bigint NOT NULL,
    "category" text NOT NULL,
    "archivedAt" text,
    "deletedAt" text
);

-- Indexes
CREATE UNIQUE INDEX "nulls_distinct_data_unique_idx" ON "nulls_distinct_data" USING btree ("tenantId", "category", "archivedAt") NULLS DISTINCT;
CREATE UNIQUE INDEX "nulls_distinct_data_not_distinct_idx" ON "nulls_distinct_data" USING btree ("tenantId", "category", "deletedAt") NULLS NOT DISTINCT;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260805140814265', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260805140814265', "timestamp" = now();

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

--
-- MIGRATION VERSION FOR serverpod_test_shared_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_shared_module', '20260711022602028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260711022602028', "timestamp" = now();


COMMIT;
