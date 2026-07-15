-- The Serverpod-supported extension contract, exercised end-to-end against a
-- freshly built bundle. This is deliberately scoped to what Serverpod's model
-- and column APIs can emit (serverpod_database columns.dart + the
-- serverpod_serialization postgis/pgvector types) - the bundle is NOT a full
-- PostGIS distribution (no raster / address standardizer / protobuf).
-- Executed by smoke_bundle.sh (unix socket) and smoke_bundle_windows.sh (TCP)
-- under ON_ERROR_STOP; a crash or load failure in any path fails the gate.

CREATE EXTENSION vector;
CREATE EXTENSION postgis;

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
