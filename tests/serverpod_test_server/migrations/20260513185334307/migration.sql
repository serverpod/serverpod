BEGIN;

--
-- CREATE POSTGIS EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'postgis') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS postgis';
  ELSE
    RAISE EXCEPTION 'Required extension "postgis" is not available on this instance. Please install PostGIS.';
  END IF;
END
$$;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_geography_geometry_collection" (
    "id" bigserial PRIMARY KEY,
    "collection" geography(GeometryCollection,4326) NOT NULL,
    "collectionNullable" geography(GeometryCollection,4326)
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_geography_line_string" (
    "id" bigserial PRIMARY KEY,
    "lineString" geography(LineString,4326) NOT NULL,
    "lineStringNullable" geography(LineString,4326)
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_geography_polygon" (
    "id" bigserial PRIMARY KEY,
    "polygon" geography(Polygon,4326) NOT NULL,
    "polygonNullable" geography(Polygon,4326)
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260513185334307', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260513185334307', "timestamp" = now();

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
