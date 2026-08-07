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
CREATE TABLE "object_with_geography_geometry_collection" (
    "id" bigserial PRIMARY KEY,
    "geometryCollection" geography(GeometryCollection,4326) NOT NULL,
    "geometryCollectionIndexedGist" geography(GeometryCollection,4326) NOT NULL,
    "geometryCollectionIndexedSpgist" geography(GeometryCollection,4326) NOT NULL
);

-- Indexes
CREATE INDEX "geography_geometry_collection_index_default" ON "object_with_geography_geometry_collection" USING gist ("geometryCollection");
CREATE INDEX "geography_geometry_collection_index_gist" ON "object_with_geography_geometry_collection" USING gist ("geometryCollectionIndexedGist");
CREATE INDEX "geography_geometry_collection_index_spgist" ON "object_with_geography_geometry_collection" USING spgist ("geometryCollectionIndexedSpgist");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_geography_line_string" (
    "id" bigserial PRIMARY KEY,
    "lineString" geography(LineString,4326) NOT NULL,
    "lineStringIndexedGist" geography(LineString,4326) NOT NULL,
    "lineStringIndexedSpgist" geography(LineString,4326) NOT NULL
);

-- Indexes
CREATE INDEX "geography_line_string_index_default" ON "object_with_geography_line_string" USING gist ("lineString");
CREATE INDEX "geography_line_string_index_gist" ON "object_with_geography_line_string" USING gist ("lineStringIndexedGist");
CREATE INDEX "geography_line_string_index_spgist" ON "object_with_geography_line_string" USING spgist ("lineStringIndexedSpgist");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_geography_point" (
    "id" bigserial PRIMARY KEY,
    "point" geography(Point,4326) NOT NULL,
    "pointIndexedGist" geography(Point,4326) NOT NULL,
    "pointIndexedSpgist" geography(Point,4326) NOT NULL
);

-- Indexes
CREATE INDEX "geography_point_index_default" ON "object_with_geography_point" USING gist ("point");
CREATE INDEX "geography_point_index_gist" ON "object_with_geography_point" USING gist ("pointIndexedGist");
CREATE INDEX "geography_point_index_spgist" ON "object_with_geography_point" USING spgist ("pointIndexedSpgist");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_geography_polygon" (
    "id" bigserial PRIMARY KEY,
    "polygon" geography(Polygon,4326) NOT NULL,
    "polygonIndexedGist" geography(Polygon,4326) NOT NULL,
    "polygonIndexedSpgist" geography(Polygon,4326) NOT NULL
);

-- Indexes
CREATE INDEX "geography_polygon_index_default" ON "object_with_geography_polygon" USING gist ("polygon");
CREATE INDEX "geography_polygon_index_gist" ON "object_with_geography_polygon" USING gist ("polygonIndexedGist");
CREATE INDEX "geography_polygon_index_spgist" ON "object_with_geography_polygon" USING spgist ("polygonIndexedSpgist");


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260625222607235', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260625222607235', "timestamp" = now();

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
