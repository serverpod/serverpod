--
-- Class ObjectWithObject as table object_with_object
--

CREATE TABLE object_with_object (
  "id" serial,
  "data" json NOT NULL,
  "nullableData" json,
  "dataList" json NOT NULL,
  "nullableDataList" json,
  "listWithNullableData" json NOT NULL,
  "nullableListWithNullableData" json
);

ALTER TABLE ONLY object_with_object
  ADD CONSTRAINT object_with_object_pkey PRIMARY KEY (id);


--
-- Class SimpleData as table simple_data
--

CREATE TABLE simple_data (
  "id" serial,
  "num" integer NOT NULL
);

ALTER TABLE ONLY simple_data
  ADD CONSTRAINT simple_data_pkey PRIMARY KEY (id);


--
-- Class Types as table types
--

CREATE TABLE types (
  "id" serial,
  "anInt" integer,
  "aBool" boolean,
  "aDouble" double precision,
  "aDateTime" timestamp without time zone,
  "aString" text,
  "aByteData" bytea
);

ALTER TABLE ONLY types
  ADD CONSTRAINT types_pkey PRIMARY KEY (id);


