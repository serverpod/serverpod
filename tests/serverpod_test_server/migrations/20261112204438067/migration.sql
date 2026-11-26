BEGIN;

--
-- CREATE PG_TRGM EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'pg_trgm') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS pg_trgm';
  ELSE
    RAISE EXCEPTION 'Required extension "pg_trgm" is not available on this instance. Please install the PostgreSQL pg_trgm contrib module. For instructions, see https://www.postgresql.org/docs/current/pgtrgm.html.';
  END IF;
END
$$;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_trgm" (
    "id" bigserial PRIMARY KEY,
    "searchText" text NOT NULL,
    "searchTextIndexed" text NOT NULL,
    "nullableSearchTextIndexed" text
);

-- Indexes
CREATE INDEX "search_text_trgm_idx" ON "object_with_trgm" USING gin ("searchTextIndexed" gin_trgm_ops);
CREATE INDEX "nullable_search_text_trgm_idx" ON "object_with_trgm" USING gin ("nullableSearchTextIndexed" gin_trgm_ops);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20261112204438067', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261112204438067', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260824182343939', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182343939', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260824182503455', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182503455', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_shared_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_shared_module', '20260824182514685', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182514685', "timestamp" = now();


COMMIT;
