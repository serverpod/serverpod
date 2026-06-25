BEGIN;

--
-- CREATE POSTGIS EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'postgis') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS postgis';
  ELSE
    RAISE EXCEPTION 'Required extension "postgis" is not available on this instance. Please install PostGIS. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-postgis.';
  END IF;
END
$$;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_geography_index" (
    "id" bigserial PRIMARY KEY,
    "point" geography(Point,4326) NOT NULL,
    "pointIndexedGist" geography(Point,4326) NOT NULL,
    "pointIndexedSpgist" geography(Point,4326) NOT NULL
);

-- Indexes
CREATE INDEX "geography_index_default" ON "object_with_geography_index" USING gist ("point");
CREATE INDEX "geography_index_gist" ON "object_with_geography_index" USING gist ("pointIndexedGist");
CREATE INDEX "geography_index_spgist" ON "object_with_geography_index" USING spgist ("pointIndexedSpgist");


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260625164551675', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260625164551675', "timestamp" = now();

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
