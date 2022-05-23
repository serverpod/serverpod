--
-- Class ObjectWithObject as table object_with_object
--

CREATE TABLE object_with_object (
  "id" serial,
  "data" json NOT NULL,
  "nullableData" json,
  "dataList" json NOT NULL DEFAULT '[]',
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
  "num" integer NOT NULL DEFAULT '1'
);

ALTER TABLE ONLY simple_data
  ADD CONSTRAINT simple_data_pkey PRIMARY KEY (id);


--
-- Class Types as table types
--

CREATE TABLE types (
  "id" serial,
  "anInt" integer DEFAULT '0',
  "aBool" boolean,
  "aDouble" double precision,
  "aDoubleWithDefaultValue" double precision DEFAULT '100',
  "aDateTime" timestamp without time zone,
  "aString" text,
  "aStringWithDefaultValue" text DEFAULT 'Default Value',
  "aByteData" bytea
);

ALTER TABLE ONLY types
  ADD CONSTRAINT types_pkey PRIMARY KEY (id);


