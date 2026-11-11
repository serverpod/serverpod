-- The Serverpod-supported extension contract, exercised end-to-end against a
-- freshly built bundle: PostgreSQL contrib plus the types and operators from
-- Serverpod's model and column APIs. The bundle is NOT a full
-- PostGIS distribution (no raster / address standardizer / protobuf).
-- Executed by smoke_bundle.sh (unix socket) and smoke_bundle_windows.sh (TCP)
-- under ON_ERROR_STOP; a crash or load failure in any path fails the gate.

CREATE EXTENSION vector;
CREATE EXTENSION postgis;

-- The production image's PostgreSQL contrib extensions must all be available
-- and installable. Start with the geocoder to exercise its fuzzystrmatch
-- dependency on a fresh database (the missing dependency reported in #5949).
CREATE EXTENSION postgis_tiger_geocoder CASCADE;

DO $$
DECLARE
  extension_name text;
BEGIN
  FOREACH extension_name IN ARRAY ARRAY[
    'adminpack', 'amcheck', 'autoinc', 'bloom', 'btree_gin', 'btree_gist',
    'citext', 'cube', 'dblink', 'dict_int', 'dict_xsyn', 'earthdistance',
    'file_fdw', 'fuzzystrmatch', 'hstore', 'insert_username', 'intagg',
    'intarray', 'isn', 'lo', 'ltree', 'moddatetime', 'old_snapshot',
    'pageinspect', 'pg_buffercache', 'pg_freespacemap', 'pg_prewarm',
    'pg_stat_statements', 'pg_surgery', 'pg_trgm', 'pg_visibility',
    'pg_walinspect', 'pgcrypto', 'pgrowlocks', 'pgstattuple', 'postgres_fdw',
    'refint', 'seg', 'sslinfo', 'tablefunc', 'tcn', 'tsm_system_rows',
    'tsm_system_time', 'unaccent', 'uuid-ossp', 'xml2'
  ] LOOP
    EXECUTE format('CREATE EXTENSION IF NOT EXISTS %I CASCADE', extension_name);
  END LOOP;
END
$$;

-- Reproduce the exclusion constraint from #5949 and verify its enforcement.
CREATE TABLE smoke_booking (
  key integer,
  at timestamp,
  EXCLUDE USING gist (key WITH =, tsrange(at, at + interval '30 seconds') WITH &&)
);
INSERT INTO smoke_booking VALUES (1, '2026-01-01 00:00:00');
INSERT INTO smoke_booking VALUES (2, '2026-01-01 00:00:10');
INSERT INTO smoke_booking VALUES (1, '2026-01-01 00:00:30');

DO $$
BEGIN
  BEGIN
    INSERT INTO smoke_booking VALUES (1, '2026-01-01 00:00:10');
    RAISE EXCEPTION 'btree_gist failed to reject an overlapping booking';
  EXCEPTION WHEN exclusion_violation THEN
    NULL;
  END;
END
$$;

CREATE TABLE smoke_trgm (title text, description text);
CREATE INDEX smoke_trgm_gin ON smoke_trgm
  USING gin (title gin_trgm_ops, description gin_trgm_ops);
CREATE INDEX smoke_trgm_gist ON smoke_trgm USING gist (title gist_trgm_ops);
CREATE INDEX smoke_text_gin ON smoke_trgm USING gin (description);
INSERT INTO smoke_trgm VALUES ('Serverpod', 'embedded PostgreSQL');
SET enable_seqscan = off;

DO $$
DECLARE
  secret text := 'contrib compression and encryption round trip';
BEGIN
  IF (SELECT count(*) FROM smoke_trgm WHERE title ILIKE '%pod%') <> 1 THEN
    RAISE EXCEPTION 'trigram index query failed';
  END IF;

  IF 'Serverpod'::citext <> 'SERVERPOD'::citext
      OR ('key=>value'::hstore -> 'key') <> 'value'
      OR unaccent('Hôtel') <> 'Hotel'
      OR levenshtein('serverpod', 'serverpods') <> 1 THEN
    RAISE EXCEPTION 'contrib text functions returned unexpected values';
  END IF;

  IF encode(digest('abc', 'sha256'), 'hex') <>
      'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'
      OR pgp_sym_decrypt(pgp_sym_encrypt(secret, 'key', 'compress-algo=1'), 'key') <> secret THEN
    RAISE EXCEPTION 'pgcrypto digest or compressed encryption failed';
  END IF;

  IF substring(uuid_generate_v1()::text, 15, 1) <> '1'
      OR substring(uuid_generate_v1mc()::text, 15, 1) <> '1'
      OR uuid_generate_v3(uuid_ns_dns(), 'www.widgets.com') <>
         '3d813cbb-47fb-32ba-91df-831e1593ac29'::uuid
      OR substring(uuid_generate_v4()::text, 15, 1) <> '4'
      OR uuid_generate_v5(uuid_ns_dns(), 'www.widgets.com') <>
         '21f7f8de-8051-5b89-8680-0195ef798b6a'::uuid THEN
    RAISE EXCEPTION 'uuid-ossp generators returned unexpected UUIDs';
  END IF;

  IF xpath_string('<root>value</root>', '/root') <> 'value'
      OR xslt_process('<root>value</root>',
        '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:output method="text"/><xsl:template match="/"><xsl:value-of select="root"/></xsl:template></xsl:stylesheet>') <> 'value'
      OR ssl_is_used() THEN
    RAISE EXCEPTION 'XML/XSLT or SSL information functions failed';
  END IF;
END
$$;

RESET enable_seqscan;

-- ===== pgvector: every value type Serverpod maps =====
-- halfvec exercises pgvector's _Float16 code paths, which have miscompiled
-- on mingw before (backend ud2 crash on user machines).
CREATE TABLE smoke_vec (
  id int PRIMARY KEY,
  v vector(3),
  h halfvec(3),
  s sparsevec(3),
  b bit(3)
);
-- Every type/index-family combination Serverpod's model analyzer permits.
-- The chosen operator classes also cover the non-default L1, inner-product,
-- cosine, and Jaccard index paths; the SELECT below exercises every distance
-- operator on every value type that exposes it.
CREATE INDEX smoke_v_hnsw ON smoke_vec USING hnsw (v vector_l1_ops);
CREATE INDEX smoke_v_ivfflat ON smoke_vec
  USING ivfflat (v vector_ip_ops) WITH (lists = 1);
CREATE INDEX smoke_h_hnsw ON smoke_vec USING hnsw (h halfvec_l1_ops);
CREATE INDEX smoke_h_ivfflat ON smoke_vec
  USING ivfflat (h halfvec_cosine_ops) WITH (lists = 1);
CREATE INDEX smoke_s_hnsw ON smoke_vec USING hnsw (s sparsevec_l1_ops);
CREATE INDEX smoke_b_hnsw ON smoke_vec USING hnsw (b bit_jaccard_ops);
CREATE INDEX smoke_b_ivfflat ON smoke_vec
  USING ivfflat (b bit_hamming_ops) WITH (lists = 1);
INSERT INTO smoke_vec VALUES
  (1, '[1,2,3]', '[1,2,3]', '{1:1,3:3}/3', B'101'),
  (2, '[4,5,6]', '[4,5,6]', '{2:2}/3', B'111');
-- Every distance operator Serverpod's VectorDistanceExpression can emit:
-- l2 <->, inner product <#>, cosine <=>, l1 <+>, hamming <~>, jaccard <%>.
SELECT id,
       v <-> '[1,2,4]', v <#> '[1,2,4]', v <=> '[1,2,4]', v <+> '[1,2,4]',
       h <-> '[1,2,4]', h <#> '[1,2,4]', h <=> '[1,2,4]', h <+> '[1,2,4]',
       s <-> '{1:1}/3', s <#> '{1:1}/3', s <=> '{1:1}/3', s <+> '{1:1}/3',
       l2_normalize(h),
       b <~> B'110', b <%> B'110'
  FROM smoke_vec ORDER BY v <-> '[1,2,4]';

-- ===== PostGIS: the geography contract =====
-- Serverpod stores geography(...) columns for point / line string / polygon /
-- geometry collection and queries them with the operations below against
-- ST_GeogFromText literals.
CREATE TABLE smoke_geo (
  id int PRIMARY KEY,
  pt geography(Point, 4326),
  ln geography(LineString, 4326),
  pg geography(Polygon, 4326),
  gc geography(GeometryCollection, 4326)
);
INSERT INTO smoke_geo VALUES (
  1,
  ST_GeogFromText('SRID=4326;POINT(1 2)'),
  ST_GeogFromText('SRID=4326;LINESTRING(0 0, 1 1, 2 2)'),
  ST_GeogFromText('SRID=4326;POLYGON((0 0, 0 3, 3 3, 3 0, 0 0))'),
  ST_GeogFromText(
    'SRID=4326;GEOMETRYCOLLECTION(POINT(1 1), LINESTRING(0 0, 2 2))')
);
-- Both spatial index families Serverpod permits, for every mapped geography
-- type. These are separate PostGIS operator-class paths from the functions
-- below and must load on every published platform too.
CREATE INDEX smoke_pt_gist ON smoke_geo USING gist (pt);
CREATE INDEX smoke_pt_spgist ON smoke_geo USING spgist (pt);
CREATE INDEX smoke_ln_gist ON smoke_geo USING gist (ln);
CREATE INDEX smoke_ln_spgist ON smoke_geo USING spgist (ln);
CREATE INDEX smoke_pg_gist ON smoke_geo USING gist (pg);
CREATE INDEX smoke_pg_spgist ON smoke_geo USING spgist (pg);
CREATE INDEX smoke_gc_gist ON smoke_geo USING gist (gc);
CREATE INDEX smoke_gc_spgist ON smoke_geo USING spgist (gc);
SELECT id,
       ST_Intersects(pg, ST_GeogFromText('SRID=4326;POINT(1 2)')),
       ST_DWithin(pt, ST_GeogFromText('SRID=4326;POINT(1 2.001)'), 200),
       ST_Distance(pt, ST_GeogFromText('SRID=4326;POINT(2 2)')),
       ST_Covers(pg, ST_GeogFromText('SRID=4326;POINT(1 2)')),
       ST_CoveredBy(pt, pg),
       ST_AsText(ln), ST_AsText(gc)
  FROM smoke_geo;

-- Plain geometry round-trip, retained from the original battery.
CREATE TABLE smoke (id int PRIMARY KEY, g geometry(Point, 4326));
INSERT INTO smoke VALUES (1, ST_SetSRID(ST_MakePoint(1, 2), 4326));
SELECT id, ST_AsText(g) AS pt, postgis_version() FROM smoke;
