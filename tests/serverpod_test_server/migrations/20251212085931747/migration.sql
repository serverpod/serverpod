BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_postgis" (
    "id" bigserial PRIMARY KEY,
    "point" geography(Point) NOT NULL,
    "pointNullable" geography(Point),
    "lineString" geography(LineString) NOT NULL,
    "lineStringNullable" geography(LineString),
    "polygon" geography(Polygon) NOT NULL,
    "polygonNullable" geography(Polygon),
    "multiPolygon" geography(MultiPolygon) NOT NULL,
    "multiPolygonNullable" geography(MultiPolygon)
);

-- Indexes
CREATE INDEX "point_index" ON "object_with_postgis" USING gist ("point");
CREATE INDEX "line_string_index" ON "object_with_postgis" USING gist ("lineString");
CREATE INDEX "polygon_index" ON "object_with_postgis" USING gist ("polygon");
CREATE INDEX "multi_polygon_index" ON "object_with_postgis" USING gist ("multiPolygon");


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20251212085931747', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251212085931747', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20250825102429343-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102429343-v3-0-0', "timestamp" = now();


COMMIT;
