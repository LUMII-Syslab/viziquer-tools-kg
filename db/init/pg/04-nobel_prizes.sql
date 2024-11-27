--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.13 (Ubuntu 14.13-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: nobel_prizes; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA nobel_prizes;


--
-- Name: SCHEMA nobel_prizes; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA nobel_prizes IS 'schema for rdf endpoint meta info; v0.1';


--
-- Name: tapprox(integer); Type: FUNCTION; Schema: nobel_prizes; Owner: -
--

CREATE FUNCTION nobel_prizes.tapprox(integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select concat(
	case cc when 0 then nn::text else round(ll::decimal,2-lsize)::text end,
case cc when 5 then 'P' when 4 then 'T' when 3 then 'G' 
	   	when 2 then 'M' when 1 then 'K' when 0 then '' else '' end) as ee
from
(select nn, cc, (c-cc*3)::integer as lsize, pp*(pow(10,c-cc*3)::integer) as ll from
(select nn, round((nn/pow(10,c))::decimal,2) as pp, floor(c/3) as cc, c from
(select case $1 when 0 then 0 else floor(log10($1)) end as c, $1 as nn) bb) aa) bb
$_$;


--
-- Name: tapprox(bigint); Type: FUNCTION; Schema: nobel_prizes; Owner: -
--

CREATE FUNCTION nobel_prizes.tapprox(bigint) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
select concat(
	case cc when 0 then nn::text else round(ll::decimal,2-lsize)::text end,
case cc when 5 then 'P' when 4 then 'T' when 3 then 'G' 
	   	when 2 then 'M' when 1 then 'K' when 0 then '' else '' end) as ee
from
(select nn, cc, (c-cc*3)::integer as lsize, pp*(pow(10,c-cc*3)::integer) as ll from
(select nn, round((nn/pow(10,c))::decimal,2) as pp, floor(c/3) as cc, c from
(select case $1 when 0 then 0 else floor(log10($1)) end as c, $1 as nn) bb) aa) bb
$_$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _h_classes; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


--
-- Name: TABLE _h_classes; Type: COMMENT; Schema: nobel_prizes; Owner: -
--

COMMENT ON TABLE nobel_prizes._h_classes IS '-- Helper table for large subclass id computation';


--
-- Name: annot_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.classes (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt bigint,
    data jsonb,
    props_in_schema boolean DEFAULT false NOT NULL,
    ns_id integer,
    local_name text,
    display_name text,
    classification_property_id integer,
    classification_property text,
    classification_adornment text,
    is_literal boolean DEFAULT false,
    datatype_id integer,
    instance_name_pattern jsonb,
    indirect_members boolean DEFAULT false NOT NULL,
    is_unique boolean DEFAULT false NOT NULL,
    large_superclass_id integer,
    hide_in_main boolean DEFAULT false,
    principal_super_class_id integer,
    self_cp_rels boolean DEFAULT true,
    cp_ask_endpoint boolean DEFAULT false,
    in_cnt bigint
);


--
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: nobel_prizes; Owner: -
--

COMMENT ON COLUMN nobel_prizes.classes.in_cnt IS 'Incoming link count';


--
-- Name: cp_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cp_rels (
    id integer NOT NULL,
    class_id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    object_cnt bigint,
    data_cnt_calc bigint GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), (0)::bigint)) STORED,
    max_cardinality bigint,
    min_cardinality bigint,
    cover_set_index integer,
    add_link_slots integer DEFAULT 1 NOT NULL,
    details_level integer DEFAULT 0 NOT NULL,
    sub_cover_complete boolean DEFAULT false NOT NULL,
    data_cnt bigint,
    principal_class_id integer,
    cnt_base bigint
);


--
-- Name: properties; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.properties (
    id integer NOT NULL,
    iri text NOT NULL,
    cnt bigint,
    data jsonb,
    ns_id integer,
    display_name text,
    local_name text,
    is_unique boolean DEFAULT false NOT NULL,
    object_cnt bigint,
    data_cnt_calc bigint GENERATED ALWAYS AS (GREATEST((cnt - object_cnt), (0)::bigint)) STORED,
    max_cardinality bigint,
    inverse_max_cardinality bigint,
    source_cover_complete boolean DEFAULT false NOT NULL,
    target_cover_complete boolean DEFAULT false NOT NULL,
    domain_class_id integer,
    range_class_id integer,
    data_cnt bigint,
    classes_in_schema boolean DEFAULT true NOT NULL,
    is_classifier boolean DEFAULT false,
    use_in_class boolean,
    classif_prefix text,
    values_have_cp boolean,
    props_in_schema boolean DEFAULT true,
    pp_ask_endpoint boolean DEFAULT false,
    pc_ask_endpoint boolean DEFAULT false,
    has_followers_ok boolean DEFAULT true,
    has_outgoing_props_ok boolean DEFAULT true,
    has_incoming_props_ok boolean DEFAULT true
);


--
-- Name: c_links; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((nobel_prizes.classes c1
     JOIN nobel_prizes.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN nobel_prizes.properties p ON ((cp1.property_id = p.id)))
     JOIN nobel_prizes.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN nobel_prizes.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


--
-- Name: cc_rel_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cc_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cc_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: class_annots; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rel_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpc_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: cpd_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: datatypes; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


--
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: instances; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.instances (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text,
    local_name_lowercase text,
    class_id integer,
    class_iri text,
    test tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, local_name)) STORED
);


--
-- Name: instances_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


--
-- Name: ns_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ns_stats; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.ns_stats (
    id integer NOT NULL,
    ns_id integer NOT NULL,
    cnt bigint,
    type_id integer,
    class_id integer,
    property_id integer
);


--
-- Name: COLUMN ns_stats.type_id; Type: COMMENT; Schema: nobel_prizes; Owner: -
--

COMMENT ON COLUMN nobel_prizes.ns_stats.type_id IS '1 - class, 2 - subject, 3 - object';


--
-- Name: ns_stats_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.ns_stats ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.ns_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: parameters; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


--
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pd_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rel_types; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.pp_rel_types (
    id integer NOT NULL,
    name text
);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: pp_rels; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: properties_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: property_annots; Type: TABLE; Schema: nobel_prizes; Owner: -
--

CREATE TABLE nobel_prizes.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


--
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: nobel_prizes; Owner: -
--

ALTER TABLE nobel_prizes.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: v_cc_rels; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cc_rels AS
 SELECT r.id,
    r.class_1_id,
    r.class_2_id,
    r.type_id,
    r.cnt,
    r.data,
    c1.iri AS iri1,
    c1.classification_property AS cprop1,
    c2.iri AS iri2,
    c2.classification_property AS cprop2
   FROM nobel_prizes.cc_rels r,
    nobel_prizes.classes c1,
    nobel_prizes.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


--
-- Name: v_classes_ns; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property_id,
    c.classification_property,
    c.classification_adornment,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.classification_adornment, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    nobel_prizes.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (nobel_prizes.classes c
     LEFT JOIN nobel_prizes.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_main AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.large_superclass_id,
    v.hide_in_main,
    v.principal_super_class_id,
    v.self_cp_rels,
    v.cp_ask_endpoint,
    v.in_cnt
   FROM nobel_prizes.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM nobel_prizes.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


--
-- Name: v_classes_ns_plus; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_plus AS
 SELECT c.id,
    c.iri,
    c.cnt,
    c.ns_id,
    n.name AS prefix,
    c.props_in_schema,
    c.local_name,
    c.display_name,
    c.classification_property_id,
    c.classification_property,
    c.classification_adornment,
    c.is_literal,
    c.datatype_id,
    c.instance_name_pattern,
    c.indirect_members,
    c.is_unique,
    concat(n.name, ',', c.local_name, ',', c.display_name, ',', lower(c.display_name)) AS namestring,
    nobel_prizes.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM nobel_prizes.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (nobel_prizes.classes c
     LEFT JOIN nobel_prizes.ns n ON ((c.ns_id = n.id)));


--
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_main_plus AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.has_subclasses,
    v.large_superclass_id,
    v.hide_in_main,
    v.principal_super_class_id,
    v.self_cp_rels,
    v.cp_ask_endpoint,
    v.in_cnt
   FROM nobel_prizes.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM nobel_prizes.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


--
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_classes_ns_main_v01 AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.props_in_schema,
    v.local_name,
    v.display_name,
    v.classification_property_id,
    v.classification_property,
    v.classification_adornment,
    v.is_literal,
    v.datatype_id,
    v.instance_name_pattern,
    v.indirect_members,
    v.is_unique,
    v.namestring,
    v.cnt_x,
    v.is_local,
    v.in_cnt
   FROM (nobel_prizes.v_classes_ns v
     LEFT JOIN nobel_prizes.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


--
-- Name: v_cp_rels; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_rels AS
 SELECT r.id,
    r.class_id,
    r.property_id,
    r.type_id,
    r.cnt,
    r.data,
    r.object_cnt,
    r.data_cnt_calc AS data_cnt,
    r.max_cardinality,
    r.min_cardinality,
    r.cover_set_index,
    r.add_link_slots,
    r.details_level,
    r.sub_cover_complete,
    nobel_prizes.tapprox((r.cnt)::integer) AS cnt_x,
    nobel_prizes.tapprox(r.object_cnt) AS object_cnt_x,
    nobel_prizes.tapprox(r.data_cnt_calc) AS data_cnt_x,
    r.cnt_base,
        CASE
            WHEN (COALESCE(r.cnt_base, (0)::bigint) = 0) THEN r.cnt
            ELSE ((((r.cnt / r.cnt_base) * c.cnt))::integer)::bigint
        END AS cnt_estimate,
    c.iri AS class_iri,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    p.iri AS property_iri
   FROM nobel_prizes.cp_rels r,
    nobel_prizes.classes c,
    nobel_prizes.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


--
-- Name: v_cp_rels_card; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_rels_card AS
 SELECT r.id,
    r.class_id,
    r.property_id,
    r.type_id,
    r.cnt,
    r.data,
    r.object_cnt,
    r.data_cnt_calc,
    r.max_cardinality,
    r.min_cardinality,
    r.cover_set_index,
    r.add_link_slots,
    r.details_level,
    r.sub_cover_complete,
    r.data_cnt,
    COALESCE(r.max_cardinality,
        CASE r.type_id
            WHEN 2 THEN p.max_cardinality
            ELSE p.inverse_max_cardinality
        END, '-1'::bigint) AS x_max_cardinality,
    r.principal_class_id
   FROM nobel_prizes.cp_rels r,
    nobel_prizes.properties p
  WHERE (r.property_id = p.id);


--
-- Name: v_properties_ns; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_ns AS
 SELECT p.id,
    p.iri,
    p.cnt,
    p.ns_id,
    n.name AS prefix,
    p.display_name,
    p.local_name,
    p.is_unique,
    p.object_cnt,
    p.data_cnt_calc AS data_cnt,
    p.source_cover_complete,
    p.target_cover_complete,
    concat(n.name, ',', p.local_name, ',', p.display_name, ',', lower(p.display_name)) AS namestring,
    nobel_prizes.tapprox(p.cnt) AS cnt_x,
    nobel_prizes.tapprox(p.object_cnt) AS object_cnt_x,
    nobel_prizes.tapprox(p.data_cnt_calc) AS data_cnt_x,
    n.is_local,
    p.domain_class_id,
    p.range_class_id,
    p.classes_in_schema,
    p.is_classifier,
    p.use_in_class,
    p.classif_prefix,
    p.values_have_cp,
    p.props_in_schema,
    p.pp_ask_endpoint,
    p.pc_ask_endpoint,
    n.basic_order_level,
        CASE
            WHEN (p.max_cardinality IS NOT NULL) THEN p.max_cardinality
            ELSE '-1'::bigint
        END AS max_cardinality,
        CASE
            WHEN (p.inverse_max_cardinality IS NOT NULL) THEN p.inverse_max_cardinality
            ELSE '-1'::bigint
        END AS inverse_max_cardinality,
    p.has_followers_ok,
    p.has_incoming_props_ok,
    p.has_outgoing_props_ok
   FROM (nobel_prizes.properties p
     LEFT JOIN nobel_prizes.ns n ON ((p.ns_id = n.id)));


--
-- Name: v_cp_sources_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_sources_single AS
 SELECT r.class_id,
    v.id,
    v.iri,
    r.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    r.object_cnt AS o,
    v.namestring,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((nobel_prizes.v_cp_rels_card r
     JOIN nobel_prizes.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


--
-- Name: v_cp_targets_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_cp_targets_single AS
 SELECT r.class_id,
    v.id,
    v.iri,
    r.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    r.object_cnt AS o,
    v.namestring,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    r.x_max_cardinality
   FROM ((nobel_prizes.v_cp_rels_card r
     JOIN nobel_prizes.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


--
-- Name: v_pp_rels_names; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    nobel_prizes.tapprox((r.cnt)::integer) AS cnt_x
   FROM nobel_prizes.pp_rels r,
    nobel_prizes.properties p1,
    nobel_prizes.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


--
-- Name: v_properties_sources; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_sources AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS base_class_cprop_id,
    c.classification_property AS base_class_cprop,
    c.classification_adornment AS base_class_adornment,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
     LEFT JOIN ( SELECT r.id,
            r.property_id,
            r.cover_set_index,
            r.add_link_slots,
            c_1.id AS id_1,
            c_1.iri,
            c_1.ns_id,
            c_1.prefix,
            c_1.local_name,
            c_1.display_name,
            c_1.classification_property_id,
            c_1.classification_property,
            c_1.classification_adornment,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM nobel_prizes.cp_rels r,
            nobel_prizes.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_sources_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_sources_single AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.classification_adornment AS class_adornment,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((v.domain_class_id = c.id)));


--
-- Name: v_properties_targets; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_targets AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS base_class_cprop_id,
    c.classification_property AS base_class_cprop,
    c.classification_adornment AS base_class_adornment,
    c.is_literal AS base_class_is_literal,
    c.datatype_id AS base_cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
     LEFT JOIN ( SELECT r.id,
            r.property_id,
            r.cover_set_index,
            r.add_link_slots,
            c_1.id AS id_1,
            c_1.iri,
            c_1.ns_id,
            c_1.prefix,
            c_1.local_name,
            c_1.display_name,
            c_1.classification_property_id,
            c_1.classification_property,
            c_1.classification_adornment,
            c_1.is_literal,
            c_1.datatype_id,
            c_1.indirect_members,
            c_1.is_unique,
            c_1.namestring,
            c_1.is_local
           FROM nobel_prizes.cp_rels r,
            nobel_prizes.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


--
-- Name: v_properties_targets_single; Type: VIEW; Schema: nobel_prizes; Owner: -
--

CREATE VIEW nobel_prizes.v_properties_targets_single AS
 SELECT v.id,
    v.iri,
    v.cnt,
    v.ns_id,
    v.prefix,
    v.display_name,
    v.local_name,
    v.is_unique,
    v.object_cnt,
    v.data_cnt,
    v.source_cover_complete,
    v.target_cover_complete,
    v.namestring,
    v.cnt_x,
    v.object_cnt_x,
    v.data_cnt_x,
    v.is_local,
    c.iri AS class_iri,
    c.prefix AS class_prefix,
    c.display_name AS class_display_name,
    c.local_name AS class_local_name,
    c.classification_property_id AS class_cprop_id,
    c.classification_property AS class_cprop,
    c.classification_adornment AS class_adornment,
    c.is_literal AS class_is_literal,
    c.datatype_id AS cname_datatype_id,
    c.is_unique AS class_is_unique,
    c.namestring AS class_namestring,
    1 AS local_priority,
    c.is_local AS class_is_local,
    v.basic_order_level,
    v.max_cardinality,
    v.inverse_max_cardinality
   FROM (nobel_prizes.v_properties_ns v
     LEFT JOIN nobel_prizes.v_classes_ns c ON ((v.range_class_id = c.id)));


--
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes._h_classes (a, b) FROM stdin;
\.


--
-- Data for Name: annot_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
\.


--
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	1	20	1	\N	\N
2	1	17	3	\N	\N
3	1	20	3	\N	\N
4	2	20	1	\N	\N
5	2	17	3	\N	\N
6	2	20	3	\N	\N
7	3	25	1	\N	\N
8	3	30	3	\N	\N
9	3	25	3	\N	\N
10	4	18	1	\N	\N
11	4	30	3	\N	\N
12	4	18	3	\N	\N
13	5	25	1	\N	\N
14	5	30	3	\N	\N
15	5	25	3	\N	\N
16	6	25	1	\N	\N
17	6	30	3	\N	\N
18	6	25	3	\N	\N
19	7	18	1	\N	\N
20	7	30	3	\N	\N
21	7	18	3	\N	\N
22	8	18	1	\N	\N
23	8	30	3	\N	\N
24	8	18	3	\N	\N
25	9	25	1	\N	\N
26	9	30	3	\N	\N
27	9	25	3	\N	\N
28	10	18	1	\N	\N
29	10	30	3	\N	\N
30	10	18	3	\N	\N
31	11	18	1	\N	\N
32	11	30	3	\N	\N
33	11	18	3	\N	\N
34	12	25	1	\N	\N
35	12	30	3	\N	\N
36	12	25	3	\N	\N
37	13	25	1	\N	\N
38	13	30	3	\N	\N
39	13	25	3	\N	\N
40	14	18	1	\N	\N
41	14	30	3	\N	\N
42	14	18	3	\N	\N
43	17	23	3	\N	\N
44	17	20	3	\N	\N
45	18	30	1	\N	\N
46	18	30	3	\N	\N
47	20	17	1	\N	\N
48	20	17	3	\N	\N
49	23	17	1	\N	\N
50	23	17	3	\N	\N
51	25	30	1	\N	\N
52	25	30	3	\N	\N
53	30	18	3	\N	\N
54	30	25	3	\N	\N
\.


--
-- Data for Name: class_annots; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	"male"^^<http://www.w3.org/2001/XMLSchema#string>	889	\N	t	\N	male	male	21	http://xmlns.com/foaf/0.1/gender	gender	t	1	\N	f	f	\N	t	\N	t	f	\N
2	"female"^^<http://www.w3.org/2001/XMLSchema#string>	60	\N	t	\N	female	female	21	http://xmlns.com/foaf/0.1/gender	gender	t	1	\N	f	f	\N	t	\N	t	f	\N
3	http://data.nobelprize.org/resource/category/Literature	118	\N	t	71	Literature	Literature	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
4	http://data.nobelprize.org/terms/Peace	103	\N	t	69	Peace	Peace	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
5	http://data.nobelprize.org/resource/category/Chemistry	191	\N	t	71	Chemistry	Chemistry	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
6	http://data.nobelprize.org/resource/category/Physics	221	\N	t	71	Physics	Physics	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
7	http://data.nobelprize.org/terms/Economic_Sciences	53	\N	t	69	Economic_Sciences	Economic_Sciences	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
8	http://data.nobelprize.org/terms/Literature	114	\N	t	69	Literature	Literature	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
9	http://data.nobelprize.org/resource/category/Peace	140	\N	t	71	Peace	Peace	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
10	http://data.nobelprize.org/terms/Chemistry	114	\N	t	69	Chemistry	Chemistry	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
11	http://data.nobelprize.org/terms/Physics	115	\N	t	69	Physics	Physics	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
12	http://data.nobelprize.org/resource/category/Physiology_or_Medicine	225	\N	t	71	Physiology_or_Medicine	Physiology_or_Medicine	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
13	http://data.nobelprize.org/resource/category/Economic_Sciences	89	\N	t	71	Economic_Sciences	Economic_Sciences	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
15	http://purl.org/dc/terms/PeriodOfTime	1	\N	t	5	PeriodOfTime	PeriodOfTime	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
16	http://www.w3.org/ns/dcat#Distribution	3	\N	t	15	Distribution	Distribution	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3
17	http://data.nobelprize.org/terms/Laureate	976	\N	t	69	Laureate	Laureate	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1966
18	http://data.nobelprize.org/terms/NobelPrize	612	\N	t	69	NobelPrize	NobelPrize	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1964
19	http://purl.org/dc/terms/Standard	1	\N	t	5	Standard	Standard	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
20	http://xmlns.com/foaf/0.1/Person	949	\N	t	8	Person	Person	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1906
21	http://www.w3.org/ns/dcat#Dataset	1	\N	t	15	Dataset	Dataset	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
22	http://xmlns.com/foaf/0.1/Agent	1	\N	t	8	Agent	Agent	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2
23	http://xmlns.com/foaf/0.1/Organization	27	\N	t	8	Organization	Organization	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	60
24	http://dbpedia.org/ontology/University	341	\N	t	10	University	University	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1596
25	http://data.nobelprize.org/terms/LaureateAward	984	\N	t	69	LaureateAward	LaureateAward	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1966
26	http://www.w3.org/ns/dcat#Catalog	1	\N	t	15	Catalog	Catalog	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
27	http://www.w3.org/2006/vcard/ns#Individual	1	\N	t	39	Individual	Individual	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1
28	http://dbpedia.org/ontology/Country	127	\N	t	10	Country	Country	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	2104
29	http://dbpedia.org/ontology/City	951	\N	t	10	City	City	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1935
30	http://dbpedia.org/ontology/Award	1596	\N	t	10	Award	Award	25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	3930
14	http://data.nobelprize.org/terms/Physiology_or_Medicine	113	\N	t	69	Physiology_or_Medicine	Physiology_or_Medicine	46	http://data.nobelprize.org/terms/category	category	f	\N	\N	f	f	\N	t	\N	t	f	\N
\.


--
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	15	1	2	1	\N	0	1	1	1	1	2	t	1	\N	\N
2	17	2	2	1024	\N	0	-1	1	1	1	2	t	1024	\N	\N
3	22	2	2	1	\N	0	1	1	2	1	2	t	1	\N	\N
4	20	2	2	949	\N	0	1	1	0	1	2	t	949	\N	\N
5	23	2	2	75	\N	0	-1	1	0	1	2	t	75	\N	\N
6	20	3	2	1308	\N	1308	-1	0	1	1	2	t	0	\N	\N
7	17	3	2	1308	\N	1308	-1	0	0	1	2	t	0	\N	\N
8	28	3	1	676	\N	676	-1	0	1	1	2	t	\N	20	\N
9	29	3	1	632	\N	632	-1	0	2	1	2	t	\N	20	\N
10	21	4	2	1	\N	1	1	1	1	1	2	f	0	\N	\N
11	21	5	2	1	\N	0	1	1	1	1	2	t	1	\N	\N
12	26	5	2	1	\N	0	1	1	2	1	2	t	1	\N	\N
13	21	6	2	1	\N	1	1	1	1	1	2	f	0	\N	\N
14	25	7	2	984	\N	984	1	1	1	1	2	f	0	\N	\N
15	30	7	2	984	\N	984	1	0	0	1	2	f	0	\N	\N
16	18	7	1	982	\N	982	-1	1	1	1	2	t	\N	25	\N
17	30	7	1	982	\N	982	-1	0	0	1	2	t	\N	25	\N
18	27	8	2	1	\N	0	1	1	1	1	2	t	1	\N	\N
19	21	9	2	1	\N	1	1	1	1	1	2	t	0	27	\N
20	27	9	1	1	\N	1	1	1	1	1	2	t	\N	21	\N
21	23	10	2	26	\N	0	1	0	1	1	2	t	26	\N	\N
22	17	10	2	26	\N	0	1	0	0	1	2	t	26	\N	\N
23	20	11	2	797	\N	797	-1	0	1	1	2	t	0	24	\N
24	17	11	2	797	\N	797	-1	0	0	1	2	t	0	24	\N
25	24	11	1	797	\N	797	-1	1	1	1	2	t	\N	20	\N
26	26	12	2	1	\N	1	1	1	1	1	2	t	0	21	\N
27	21	12	1	1	\N	1	1	1	1	1	2	t	\N	26	\N
28	16	13	2	2	\N	2	1	0	1	1	2	t	0	19	\N
29	19	13	1	2	\N	2	-1	1	1	1	2	t	\N	16	\N
30	21	14	2	1	\N	0	1	1	1	1	2	t	1	\N	\N
31	17	15	2	984	\N	984	-1	1	1	1	2	f	0	\N	\N
32	20	15	2	954	\N	954	-1	1	0	1	2	f	0	\N	\N
33	23	15	2	30	\N	30	-1	1	0	1	2	f	0	18	\N
34	18	15	1	982	\N	982	-1	1	1	1	2	t	\N	17	\N
35	30	15	1	982	\N	982	-1	0	0	1	2	t	\N	17	\N
36	16	16	2	2	\N	2	1	0	1	1	2	f	0	\N	\N
37	17	17	2	984	\N	984	-1	1	1	1	2	t	0	25	\N
38	20	17	2	954	\N	954	-1	1	0	1	2	t	0	25	\N
39	23	17	2	30	\N	30	-1	1	0	1	2	t	0	25	\N
40	25	17	1	984	\N	984	1	1	1	1	2	t	\N	17	\N
41	30	17	1	984	\N	984	1	0	0	1	2	t	\N	17	\N
42	16	18	2	3	\N	3	1	1	1	1	2	f	0	\N	\N
43	21	19	2	1	\N	1	1	1	1	1	2	t	0	22	\N
44	26	19	2	1	\N	1	1	1	2	1	2	t	0	22	\N
45	22	19	1	2	\N	2	-1	1	1	1	2	t	\N	\N	\N
46	30	20	2	1966	\N	1966	-1	1	1	1	2	t	0	17	\N
47	25	20	2	984	\N	984	1	1	0	1	2	t	0	17	\N
48	18	20	2	982	\N	982	-1	1	0	1	2	t	0	17	\N
49	17	20	1	1966	\N	1966	-1	1	1	1	2	t	\N	30	\N
50	20	20	1	1906	\N	1906	-1	1	0	1	2	t	\N	30	\N
51	23	20	1	60	\N	60	-1	1	0	1	2	t	\N	30	\N
52	20	21	2	949	\N	0	1	1	1	1	2	t	949	\N	\N
53	17	21	2	949	\N	0	1	0	0	1	2	t	949	\N	\N
54	25	22	2	984	\N	0	1	1	1	1	2	t	984	\N	\N
55	30	22	2	984	\N	0	1	0	0	1	2	t	984	\N	\N
56	24	23	2	338	\N	338	1	0	1	1	2	t	0	29	\N
57	29	23	1	338	\N	338	-1	0	1	1	2	t	\N	24	\N
58	18	24	2	612	\N	0	1	1	1	1	2	t	612	\N	\N
59	30	24	2	612	\N	0	1	0	0	1	2	t	612	\N	\N
60	30	25	2	3192	\N	3192	-1	1	1	1	2	f	0	\N	\N
61	17	25	2	1952	\N	1952	-1	1	2	1	2	f	0	\N	\N
62	29	25	2	951	\N	951	1	1	3	1	2	f	0	\N	\N
63	24	25	2	341	\N	341	1	1	4	1	2	f	0	\N	\N
64	28	25	2	127	\N	127	1	1	5	1	2	f	0	\N	\N
65	16	25	2	3	\N	3	1	1	6	1	2	f	0	\N	\N
66	27	25	2	1	\N	1	1	1	7	1	2	f	0	\N	\N
67	19	25	2	1	\N	1	1	1	8	1	2	f	0	\N	\N
68	22	25	2	1	\N	1	1	1	9	1	2	f	0	\N	\N
69	21	25	2	1	\N	1	1	1	10	1	2	f	0	\N	\N
70	26	25	2	1	\N	1	1	1	11	1	2	f	0	\N	\N
71	15	25	2	1	\N	1	1	1	12	1	2	f	0	\N	\N
72	25	25	2	1968	\N	1968	-1	1	0	1	2	f	0	\N	\N
73	20	25	2	1898	\N	1898	-1	1	0	1	2	f	0	\N	\N
74	18	25	2	1224	\N	1224	-1	1	0	1	2	f	0	\N	\N
75	23	25	2	54	\N	54	-1	1	0	1	2	f	0	\N	\N
76	27	26	2	1	\N	1	1	1	1	1	2	f	0	\N	\N
77	20	27	2	949	\N	0	1	1	1	1	2	t	949	\N	\N
78	17	27	2	949	\N	0	1	0	0	1	2	t	949	\N	\N
79	30	28	2	1968	\N	0	-1	0	1	1	2	t	1968	\N	\N
80	25	28	2	1957	\N	0	-1	1	0	1	2	t	1957	\N	\N
81	18	28	2	11	\N	0	-1	0	0	1	2	t	11	\N	\N
82	20	29	2	650	\N	0	1	0	1	1	2	t	650	\N	\N
83	17	29	2	650	\N	0	1	0	0	1	2	t	650	\N	\N
84	24	30	2	345	\N	345	-1	0	1	1	2	t	0	28	\N
85	28	30	1	345	\N	345	-1	0	1	1	2	t	\N	24	\N
86	20	31	2	947	\N	0	1	0	1	1	2	t	947	\N	\N
87	17	31	2	947	\N	0	1	0	0	1	2	t	947	\N	\N
88	21	32	2	1	\N	1	1	1	1	1	2	f	0	\N	\N
89	25	33	2	799	\N	799	-1	0	1	1	2	t	0	24	\N
90	30	33	2	799	\N	799	-1	0	0	1	2	t	0	24	\N
91	24	33	1	799	\N	799	-1	1	1	1	2	t	\N	25	\N
92	17	34	2	976	\N	976	1	1	1	1	2	f	0	\N	\N
93	29	34	2	881	\N	881	1	0	2	1	2	f	0	\N	\N
94	28	34	2	90	\N	90	1	0	3	1	2	f	0	\N	\N
95	20	34	2	949	\N	949	1	1	0	1	2	f	0	\N	\N
96	23	34	2	27	\N	27	1	1	0	1	2	f	0	\N	\N
97	16	35	2	3	\N	3	1	1	1	1	2	f	0	\N	\N
98	21	36	2	1	\N	1	1	1	1	1	2	f	0	\N	\N
99	20	37	2	2004	\N	2004	-1	1	1	1	2	t	0	\N	\N
100	17	37	2	2004	\N	2004	-1	0	0	1	2	t	0	\N	\N
101	28	37	1	1060	\N	1060	-1	0	1	1	2	t	\N	20	\N
102	29	37	1	944	\N	944	-1	0	2	1	2	t	\N	20	\N
103	21	38	2	3	\N	3	-1	1	1	1	2	f	0	\N	\N
104	20	39	2	949	\N	0	1	1	1	1	2	t	949	\N	\N
105	17	39	2	949	\N	0	1	0	0	1	2	t	949	\N	\N
106	23	40	2	44	\N	44	-1	0	1	1	2	t	0	\N	\N
107	17	40	2	44	\N	44	-1	0	0	1	2	t	0	\N	\N
108	28	40	1	23	\N	23	-1	0	1	1	2	t	\N	23	\N
109	29	40	1	21	\N	21	-1	0	2	1	2	t	\N	23	\N
110	16	41	2	3	\N	0	1	1	1	1	2	t	3	\N	\N
111	21	42	2	3	\N	3	-1	1	1	1	2	t	0	16	\N
112	16	42	1	3	\N	3	1	1	1	1	2	t	\N	21	\N
113	18	43	2	982	\N	982	-1	1	1	1	2	t	0	25	\N
114	30	43	2	982	\N	982	-1	0	0	1	2	t	0	25	\N
115	25	43	1	982	\N	982	1	0	1	1	2	t	\N	18	\N
116	30	43	1	982	\N	982	1	0	0	1	2	t	\N	18	\N
117	21	44	2	1	\N	0	1	1	1	1	2	t	1	\N	\N
118	25	45	2	984	\N	0	1	1	1	1	2	t	984	\N	\N
119	30	45	2	984	\N	0	1	0	0	1	2	t	984	\N	\N
120	30	46	2	1596	\N	1596	1	1	1	1	2	f	0	\N	\N
121	25	46	2	984	\N	984	1	1	0	1	2	f	0	\N	\N
122	18	46	2	612	\N	612	1	1	0	1	2	f	0	\N	\N
123	23	47	2	26	\N	0	1	0	1	1	2	t	26	\N	\N
124	17	47	2	26	\N	0	1	0	0	1	2	t	26	\N	\N
125	30	48	2	4788	\N	0	-1	1	1	1	2	t	4788	\N	\N
126	29	48	2	2853	\N	0	-1	1	2	1	2	t	2853	\N	\N
127	24	48	2	1023	\N	0	-1	1	3	1	2	t	1023	\N	\N
128	17	48	2	975	\N	0	1	0	4	1	2	t	975	\N	\N
129	28	48	2	381	\N	0	-1	1	5	1	2	t	381	\N	\N
130	25	48	2	2952	\N	0	-1	1	0	1	2	t	2952	\N	\N
131	18	48	2	1836	\N	0	-1	1	0	1	2	t	1836	\N	\N
132	20	48	2	949	\N	0	1	1	0	1	2	t	949	\N	\N
133	23	48	2	26	\N	0	1	0	0	1	2	t	26	\N	\N
134	16	49	2	3	\N	0	1	1	1	1	2	t	3	\N	\N
135	19	49	2	1	\N	0	1	1	2	1	2	t	1	\N	\N
136	21	49	2	1	\N	0	1	1	3	1	2	t	1	\N	\N
137	26	49	2	1	\N	0	1	1	4	1	2	t	1	\N	\N
138	21	50	2	4	\N	4	-1	1	1	1	2	f	0	\N	\N
139	20	51	2	949	\N	0	1	1	1	1	2	t	949	\N	\N
140	17	51	2	949	\N	0	1	0	0	1	2	t	949	\N	\N
141	30	52	2	1596	\N	0	1	1	1	1	2	t	1596	\N	\N
142	25	52	2	984	\N	0	1	1	0	1	2	t	984	\N	\N
143	18	52	2	612	\N	0	1	1	0	1	2	t	612	\N	\N
\.


--
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	6	28	676	\N	1	\N
2	6	29	632	\N	2	\N
3	7	29	632	\N	2	\N
4	7	28	676	\N	1	\N
5	8	17	676	\N	0	\N
6	8	20	676	\N	1	\N
7	9	17	632	\N	0	\N
8	9	20	632	\N	1	\N
9	14	18	982	\N	1	\N
10	14	30	982	\N	0	\N
11	15	18	982	\N	1	\N
12	15	30	982	\N	0	\N
13	16	30	982	\N	0	\N
14	16	25	982	\N	1	\N
15	17	25	982	\N	1	\N
16	17	30	982	\N	0	\N
17	19	27	1	\N	1	\N
18	20	21	1	\N	1	\N
19	23	24	797	\N	1	\N
20	24	24	797	\N	1	\N
21	25	17	797	\N	0	\N
22	25	20	797	\N	1	\N
23	26	21	1	\N	1	\N
24	27	26	1	\N	1	\N
25	28	19	2	\N	1	\N
26	29	16	2	\N	1	\N
27	31	18	982	\N	1	\N
28	31	30	982	\N	0	\N
29	32	18	952	\N	1	\N
30	32	30	952	\N	0	\N
31	33	30	30	\N	0	\N
32	33	18	30	\N	1	\N
33	34	17	982	\N	1	\N
34	34	20	952	\N	0	\N
35	34	23	30	\N	0	\N
36	35	23	30	\N	0	\N
37	35	17	982	\N	1	\N
38	35	20	952	\N	0	\N
39	37	25	984	\N	1	\N
40	37	30	984	\N	0	\N
41	38	25	954	\N	1	\N
42	38	30	954	\N	0	\N
43	39	30	30	\N	0	\N
44	39	25	30	\N	1	\N
45	40	17	984	\N	1	\N
46	40	20	954	\N	0	\N
47	40	23	30	\N	0	\N
48	41	23	30	\N	0	\N
49	41	17	984	\N	1	\N
50	41	20	954	\N	0	\N
51	43	22	1	\N	1	\N
52	44	22	1	\N	1	\N
53	45	21	1	\N	1	\N
54	45	26	1	\N	2	\N
55	46	17	1966	\N	1	\N
56	46	20	1906	\N	0	\N
57	46	23	60	\N	0	\N
58	47	20	954	\N	0	\N
59	47	23	30	\N	0	\N
60	47	17	984	\N	1	\N
61	48	20	952	\N	0	\N
62	48	17	982	\N	1	\N
63	48	23	30	\N	0	\N
64	49	30	1966	\N	1	\N
65	49	18	982	\N	0	\N
66	49	25	984	\N	0	\N
67	50	25	954	\N	0	\N
68	50	18	952	\N	0	\N
69	50	30	1906	\N	1	\N
70	51	25	30	\N	0	\N
71	51	30	60	\N	1	\N
72	51	18	30	\N	0	\N
73	56	29	338	\N	1	\N
74	57	24	338	\N	1	\N
75	84	28	345	\N	1	\N
76	85	24	345	\N	1	\N
77	89	24	799	\N	1	\N
78	90	24	799	\N	1	\N
79	91	25	799	\N	1	\N
80	91	30	799	\N	0	\N
81	99	28	1060	\N	1	\N
82	99	29	944	\N	2	\N
83	100	29	944	\N	2	\N
84	100	28	1060	\N	1	\N
85	101	17	1060	\N	0	\N
86	101	20	1060	\N	1	\N
87	102	17	944	\N	0	\N
88	102	20	944	\N	1	\N
89	106	29	21	\N	2	\N
90	106	28	23	\N	1	\N
91	107	29	21	\N	2	\N
92	107	28	23	\N	1	\N
93	108	17	23	\N	0	\N
94	108	23	23	\N	1	\N
95	109	23	21	\N	1	\N
96	109	17	21	\N	0	\N
97	111	16	3	\N	1	\N
98	112	21	3	\N	1	\N
99	113	25	982	\N	1	\N
100	113	30	982	\N	0	\N
101	114	25	982	\N	1	\N
102	114	30	982	\N	0	\N
103	115	18	982	\N	1	\N
104	115	30	982	\N	0	\N
105	116	30	982	\N	0	\N
106	116	18	982	\N	1	\N
\.


--
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
1	1	2	1	\N	\N
2	2	1	949	\N	\N
3	2	3	75	\N	\N
4	3	3	1	\N	\N
5	4	1	949	\N	\N
6	5	3	75	\N	\N
7	11	3	1	\N	\N
8	12	3	1	\N	\N
9	18	1	1	\N	\N
10	21	4	26	\N	\N
11	22	4	26	\N	\N
12	30	3	1	\N	\N
13	52	1	949	\N	\N
14	53	1	949	\N	\N
15	54	5	984	\N	\N
16	55	5	984	\N	\N
17	58	5	612	\N	\N
18	59	5	612	\N	\N
19	77	4	949	\N	\N
20	78	4	949	\N	\N
21	79	3	1968	\N	\N
22	80	3	1957	\N	\N
23	81	3	11	\N	\N
24	82	4	650	\N	\N
25	83	4	650	\N	\N
26	86	1	947	\N	\N
27	87	1	947	\N	\N
28	104	1	949	\N	\N
29	105	1	949	\N	\N
30	110	1	3	\N	\N
31	117	2	1	\N	\N
32	118	5	984	\N	\N
33	119	5	984	\N	\N
34	123	4	26	\N	\N
35	124	4	26	\N	\N
36	125	3	4788	\N	\N
37	126	3	2853	\N	\N
38	127	3	1023	\N	\N
39	128	1	975	\N	\N
40	129	3	381	\N	\N
41	130	3	2952	\N	\N
42	131	3	1836	\N	\N
43	132	1	949	\N	\N
44	133	1	26	\N	\N
45	134	3	3	\N	\N
46	135	3	1	\N	\N
47	136	3	1	\N	\N
48	137	3	1	\N	\N
49	139	4	949	\N	\N
50	140	4	949	\N	\N
51	141	5	1596	\N	\N
52	142	5	984	\N	\N
53	143	5	612	\N	\N
\.


--
-- Data for Name: datatypes; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.datatypes (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2001/XMLSchema#string	3	string
2	http://www.w3.org/2001/XMLSchema#gYear	3	gYear
3	http://www.w3.org/1999/02/22-rdf-syntax-ns#langString	1	langString
4	http://www.w3.org/2001/XMLSchema#date	3	date
5	http://www.w3.org/2001/XMLSchema#integer	3	integer
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- Data for Name: ns; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
1	rdf	http://www.w3.org/1999/02/22-rdf-syntax-ns#	0	f	0
2	rdfs	http://www.w3.org/2000/01/rdf-schema#	0	f	0
3	xsd	http://www.w3.org/2001/XMLSchema#	0	f	0
4	skos	http://www.w3.org/2004/02/skos/core#	0	f	0
5	dct	http://purl.org/dc/terms/	0	f	0
6	dc	http://purl.org/dc/elements/1.1/	0	f	0
7	owl	http://www.w3.org/2002/07/owl#	0	f	0
8	foaf	http://xmlns.com/foaf/0.1/	0	f	0
9	schema	http://schema.org/	0	f	0
10	dbo	http://dbpedia.org/ontology/	0	f	0
11	yago	http://dbpedia.org/class/yago/	0	f	0
12	wd	http://www.wikidata.org/entity/	0	f	0
13	wdt	http://www.wikidata.org/prop/direct/	0	f	0
14	shacl	http://www.w3.org/ns/shacl#	0	f	0
15	dcat	http://www.w3.org/ns/dcat#	0	f	0
16	void	http://rdfs.org/ns/void#	0	f	0
17	virtrdf	http://www.openlinksw.com/schemas/virtrdf#	0	f	0
18	dav	http://www.openlinksw.com/schemas/DAV#	0	f	0
19	dbp	http://dbpedia.org/property/	0	f	0
20	dbr	http://dbpedia.org/resource/	0	f	0
21	dbt	http://dbpedia.org/resource/Template:	0	f	0
22	dbc	http://dbpedia.org/resource/Category:	0	f	0
23	cc	http://creativecommons.org/ns#	0	f	0
24	vann	http://purl.org/vocab/vann/	0	f	0
25	geo	http://www.w3.org/2003/01/geo/wgs84_pos#	0	f	0
26	prov	http://www.w3.org/ns/prov#	0	f	0
27	sd	http://www.w3.org/ns/sparql-service-description#	0	f	0
28	frbr	http://vocab.org/frbr/core#	0	f	0
29	georss	http://www.georss.org/georss/	0	f	0
30	gold	http://purl.org/linguistics/gold/	0	f	0
31	bibo	http://purl.org/ontology/bibo/	0	f	0
32	umbel	http://umbel.org/umbel#	0	f	0
33	umbel-rc	http://umbel.org/umbel/rc/	0	f	0
34	dul	http://www.ontologydesignpatterns.org/ont/dul/DUL.owl#	0	f	0
35	voaf	http://purl.org/vocommons/voaf#	0	f	0
36	gr	http://purl.org/goodrelations/v1#	0	f	0
37	org	http://www.w3.org/ns/org#	0	f	0
38	sioc	http://rdfs.org/sioc/ns#	0	f	0
39	vcard	http://www.w3.org/2006/vcard/ns#	0	f	0
40	obo	http://purl.obolibrary.org/obo/	0	f	0
68	bif	http://www.openlinksw.com/schemas/bif#	0	f	0
69		http://data.nobelprize.org/terms/	0	t	0
70	adms	http://www.w3.org/ns/adms#	0	f	0
72	sdo	https://schema.org/	0	f	0
71	ct	http://data.nobelprize.org/resource/category/	0	f	0
\.


--
-- Data for Name: ns_stats; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.ns_stats (id, ns_id, cnt, type_id, class_id, property_id) FROM stdin;
\.


--
-- Data for Name: parameters; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
210	instance_name_pattern	\N	\N	Default pattern for instance name presentation in visual query fields. Work in progress. Can be overriden on individual class level. Leave empty to present instances by their URIs.	10
330	use_instance_table	\N	\N	Mark, if a dedicated instance table is installed within the data schema (requires a custom solution).	8
230	instance_lookup_mode	\N	\N	table - use instances table, default - use data endpoint	19
250	direct_class_role	\N	\N	Default property to be used for instance-to-class relationship. Leave empty in the most typical case of the property being rdf:type.	5
260	indirect_class_role	\N	\N	Fill in, if an indirect class membership is to be used in the environment, along with the direct membership (normally leave empty).	6
20	schema_description	\N	\N	Description of the schema.	2
100	tree_profile_name	\N	\N	Look up public tree profile by this name (mutually exclusive with local tree_profile).	14
110	tree_profile	\N	\N	A custom configuration of the entity lookup pane tree (copy the initial value from the parameters of a similar schema).	11
220	show_instance_tab	\N	\N	Show instance tab in the entity lookup pane in the visual environment.	15
60	endpoint_public_url	\N	\N	Human readable web site of the endpoint, if available.	16
10	display_name_default	nobel_prizes	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	nobel_prizes	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://85.254.199.72:8890/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
40	named_graph	http://nobelprizes.local	\N	Default named graph for visual environment projects using this schema.	4
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"graphName": "http://nobelprizes.local", "endpointUrl": "http://85.254.199.72:8890/sparql", "correlationId": "744312466937420206", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "propertyLevelAndClassContext", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "yes", "calculateCardinalities": "propertyLevelAndClassContext", "exactCountCalculations": "yes", "calculateClosedClassSets": true, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateImportanceIndexes": "regular", "calculateSubClassRelations": true, "calculateInstanceNamespaces": "no", "calculateSourceAndTargetPairs": true, "simpleClassificationProperties": ["http://data.nobelprize.org/terms/category", "http://xmlns.com/foaf/0.1/gender"], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "calculatePropertyPropertyRelations": true, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": [], "sampleLimitForInstanceNamespacesCalculation": 1000}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-11-13T15:38:17.422Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-10-23	\N	\N	31
240	use_pp_rels	\N	true	Use the property-property relationships from the data schema in the query auto-completion (the property-property relationships must be retrieved from the data and stored in the pp_rels table).	9
\.


--
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
1	1	2	1	\N	\N
2	2	1	949	\N	\N
3	2	3	76	\N	\N
4	5	3	2	\N	\N
5	8	1	1	\N	\N
6	10	4	26	\N	\N
7	14	3	1	\N	\N
8	21	1	949	\N	\N
9	22	5	984	\N	\N
10	24	5	612	\N	\N
11	27	4	949	\N	\N
12	28	3	1968	\N	\N
13	29	4	650	\N	\N
14	31	1	947	\N	\N
15	39	1	949	\N	\N
16	41	1	3	\N	\N
17	44	2	1	\N	\N
18	45	5	984	\N	\N
19	47	4	26	\N	\N
20	48	1	975	\N	\N
21	48	3	9046	\N	\N
22	49	3	6	\N	\N
23	51	4	949	\N	\N
24	52	5	1596	\N	\N
\.


--
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
1	1	1	2	1	\N	\N
2	1	25	2	1	\N	\N
3	2	37	2	2004	\N	\N
4	2	25	2	1953	\N	\N
5	2	3	2	1308	\N	\N
6	2	2	2	1025	\N	\N
7	2	17	2	984	\N	\N
8	2	15	2	984	\N	\N
9	2	34	2	976	\N	\N
10	2	48	2	975	\N	\N
11	2	27	2	949	\N	\N
12	2	51	2	949	\N	\N
13	2	21	2	949	\N	\N
14	2	39	2	949	\N	\N
15	2	31	2	947	\N	\N
16	2	11	2	797	\N	\N
17	2	29	2	650	\N	\N
18	2	40	2	44	\N	\N
19	2	47	2	26	\N	\N
20	2	10	2	26	\N	\N
21	3	48	1	1113	\N	\N
22	3	25	1	371	\N	\N
23	3	34	1	349	\N	\N
24	3	3	3	1308	\N	\N
25	3	37	3	1266	\N	\N
26	3	30	3	345	\N	\N
27	3	23	3	233	\N	\N
28	3	40	3	38	\N	\N
29	3	37	2	1368	\N	\N
30	3	3	2	1308	\N	\N
31	3	25	2	1278	\N	\N
32	3	17	2	643	\N	\N
33	3	15	2	643	\N	\N
34	3	27	2	639	\N	\N
35	3	29	2	639	\N	\N
36	3	48	2	639	\N	\N
37	3	34	2	639	\N	\N
38	3	51	2	639	\N	\N
39	3	21	2	639	\N	\N
40	3	39	2	639	\N	\N
41	3	2	2	639	\N	\N
42	3	31	2	638	\N	\N
43	3	11	2	492	\N	\N
44	4	4	3	1	\N	\N
45	4	50	2	4	\N	\N
46	4	38	2	3	\N	\N
47	4	42	2	3	\N	\N
48	4	4	2	1	\N	\N
49	4	36	2	1	\N	\N
50	4	5	2	1	\N	\N
51	4	44	2	1	\N	\N
52	4	19	2	1	\N	\N
53	4	6	2	1	\N	\N
54	4	49	2	1	\N	\N
55	4	25	2	1	\N	\N
56	4	9	2	1	\N	\N
57	4	14	2	1	\N	\N
58	4	32	2	1	\N	\N
59	5	50	2	4	\N	\N
60	5	38	2	3	\N	\N
61	5	42	2	3	\N	\N
62	5	5	2	2	\N	\N
63	5	19	2	2	\N	\N
64	5	49	2	2	\N	\N
65	5	25	2	2	\N	\N
66	5	4	2	1	\N	\N
67	5	36	2	1	\N	\N
68	5	44	2	1	\N	\N
69	5	6	2	1	\N	\N
70	5	9	2	1	\N	\N
71	5	12	2	1	\N	\N
72	5	14	2	1	\N	\N
73	5	32	2	1	\N	\N
74	6	48	1	1	\N	\N
75	6	6	3	1	\N	\N
76	6	50	2	4	\N	\N
77	6	38	2	3	\N	\N
78	6	42	2	3	\N	\N
79	6	4	2	1	\N	\N
80	6	36	2	1	\N	\N
81	6	5	2	1	\N	\N
82	6	44	2	1	\N	\N
83	6	19	2	1	\N	\N
84	6	6	2	1	\N	\N
85	6	49	2	1	\N	\N
86	6	25	2	1	\N	\N
87	6	9	2	1	\N	\N
88	6	14	2	1	\N	\N
89	6	32	2	1	\N	\N
90	7	48	1	1836	\N	\N
91	7	25	1	1224	\N	\N
92	7	20	1	982	\N	\N
93	7	43	1	982	\N	\N
94	7	46	1	612	\N	\N
95	7	24	1	612	\N	\N
96	7	52	1	612	\N	\N
97	7	28	1	11	\N	\N
98	7	15	3	984	\N	\N
99	7	7	3	984	\N	\N
100	7	48	2	2952	\N	\N
101	7	25	2	1968	\N	\N
102	7	28	2	1957	\N	\N
103	7	46	2	984	\N	\N
104	7	20	2	984	\N	\N
105	7	45	2	984	\N	\N
106	7	22	2	984	\N	\N
107	7	52	2	984	\N	\N
108	7	7	2	984	\N	\N
109	7	33	2	799	\N	\N
110	8	25	2	1	\N	\N
111	8	8	2	1	\N	\N
112	8	26	2	1	\N	\N
113	9	25	1	1	\N	\N
114	9	8	1	1	\N	\N
115	9	26	1	1	\N	\N
116	9	9	3	1	\N	\N
117	9	50	2	4	\N	\N
118	9	38	2	3	\N	\N
119	9	42	2	3	\N	\N
120	9	4	2	1	\N	\N
121	9	36	2	1	\N	\N
122	9	5	2	1	\N	\N
123	9	44	2	1	\N	\N
124	9	19	2	1	\N	\N
125	9	6	2	1	\N	\N
126	9	49	2	1	\N	\N
127	9	25	2	1	\N	\N
128	9	9	2	1	\N	\N
129	9	14	2	1	\N	\N
130	9	32	2	1	\N	\N
131	10	2	2	72	\N	\N
132	10	25	2	52	\N	\N
133	10	40	2	44	\N	\N
134	10	17	2	29	\N	\N
135	10	15	2	29	\N	\N
136	10	47	2	26	\N	\N
137	10	34	2	26	\N	\N
138	10	10	2	26	\N	\N
139	10	48	2	25	\N	\N
140	11	48	1	1023	\N	\N
141	11	30	1	345	\N	\N
142	11	25	1	341	\N	\N
143	11	23	1	338	\N	\N
144	11	33	3	799	\N	\N
145	11	11	3	797	\N	\N
146	11	37	2	1508	\N	\N
147	11	25	2	1438	\N	\N
148	11	3	2	944	\N	\N
149	11	11	2	797	\N	\N
150	11	17	2	724	\N	\N
151	11	15	2	724	\N	\N
152	11	27	2	719	\N	\N
153	11	48	2	719	\N	\N
154	11	34	2	719	\N	\N
155	11	51	2	719	\N	\N
156	11	31	2	719	\N	\N
157	11	21	2	719	\N	\N
158	11	39	2	719	\N	\N
159	11	2	2	719	\N	\N
160	11	29	2	470	\N	\N
161	12	50	1	4	\N	\N
162	12	38	1	3	\N	\N
163	12	42	1	3	\N	\N
164	12	4	1	1	\N	\N
165	12	36	1	1	\N	\N
166	12	5	1	1	\N	\N
167	12	44	1	1	\N	\N
168	12	19	1	1	\N	\N
169	12	6	1	1	\N	\N
170	12	49	1	1	\N	\N
171	12	25	1	1	\N	\N
172	12	9	1	1	\N	\N
173	12	14	1	1	\N	\N
174	12	32	1	1	\N	\N
175	12	12	3	1	\N	\N
176	12	5	2	1	\N	\N
177	12	19	2	1	\N	\N
178	12	49	2	1	\N	\N
179	12	25	2	1	\N	\N
180	12	12	2	1	\N	\N
181	13	49	1	1	\N	\N
182	13	25	1	1	\N	\N
183	13	13	3	2	\N	\N
184	13	13	2	2	\N	\N
185	13	41	2	2	\N	\N
186	13	35	2	2	\N	\N
187	13	49	2	2	\N	\N
188	13	25	2	2	\N	\N
189	13	16	2	2	\N	\N
190	13	18	2	2	\N	\N
191	14	50	2	4	\N	\N
192	14	38	2	3	\N	\N
193	14	42	2	3	\N	\N
194	14	4	2	1	\N	\N
195	14	36	2	1	\N	\N
196	14	5	2	1	\N	\N
197	14	44	2	1	\N	\N
198	14	19	2	1	\N	\N
199	14	6	2	1	\N	\N
200	14	49	2	1	\N	\N
201	14	25	2	1	\N	\N
202	14	9	2	1	\N	\N
203	14	14	2	1	\N	\N
204	14	32	2	1	\N	\N
205	15	48	1	1836	\N	\N
206	15	25	1	1224	\N	\N
207	15	20	1	982	\N	\N
208	15	43	1	982	\N	\N
209	15	46	1	612	\N	\N
210	15	24	1	612	\N	\N
211	15	52	1	612	\N	\N
212	15	28	1	11	\N	\N
213	15	15	3	984	\N	\N
214	15	7	3	984	\N	\N
215	15	37	2	2004	\N	\N
216	15	25	2	1952	\N	\N
217	15	3	2	1308	\N	\N
218	15	2	2	1024	\N	\N
219	15	17	2	984	\N	\N
220	15	15	2	984	\N	\N
221	15	34	2	976	\N	\N
222	15	48	2	975	\N	\N
223	15	27	2	949	\N	\N
224	15	51	2	949	\N	\N
225	15	21	2	949	\N	\N
226	15	39	2	949	\N	\N
227	15	31	2	947	\N	\N
228	15	11	2	797	\N	\N
229	15	29	2	650	\N	\N
230	15	40	2	44	\N	\N
231	15	47	2	26	\N	\N
232	15	10	2	26	\N	\N
233	16	16	3	2	\N	\N
234	16	13	2	2	\N	\N
235	16	41	2	2	\N	\N
236	16	35	2	2	\N	\N
237	16	49	2	2	\N	\N
238	16	25	2	2	\N	\N
239	16	16	2	2	\N	\N
240	16	18	2	2	\N	\N
241	17	48	1	2952	\N	\N
242	17	25	1	1968	\N	\N
243	17	28	1	1957	\N	\N
244	17	46	1	984	\N	\N
245	17	20	1	984	\N	\N
246	17	45	1	984	\N	\N
247	17	22	1	984	\N	\N
248	17	52	1	984	\N	\N
249	17	7	1	984	\N	\N
250	17	33	1	799	\N	\N
251	17	17	3	984	\N	\N
252	17	43	3	982	\N	\N
253	17	37	2	2004	\N	\N
254	17	25	2	1952	\N	\N
255	17	3	2	1308	\N	\N
256	17	2	2	1024	\N	\N
257	17	17	2	984	\N	\N
258	17	15	2	984	\N	\N
259	17	34	2	976	\N	\N
260	17	48	2	975	\N	\N
261	17	27	2	949	\N	\N
262	17	51	2	949	\N	\N
263	17	21	2	949	\N	\N
264	17	39	2	949	\N	\N
265	17	31	2	947	\N	\N
266	17	11	2	797	\N	\N
267	17	29	2	650	\N	\N
268	17	40	2	44	\N	\N
269	17	47	2	26	\N	\N
270	17	10	2	26	\N	\N
271	18	18	3	3	\N	\N
272	18	41	2	3	\N	\N
273	18	35	2	3	\N	\N
274	18	49	2	3	\N	\N
275	18	25	2	3	\N	\N
276	18	18	2	3	\N	\N
277	18	13	2	2	\N	\N
278	18	16	2	2	\N	\N
279	19	25	1	1	\N	\N
280	19	2	1	1	\N	\N
281	19	19	3	2	\N	\N
282	19	50	2	4	\N	\N
283	19	38	2	3	\N	\N
284	19	42	2	3	\N	\N
285	19	5	2	2	\N	\N
286	19	19	2	2	\N	\N
287	19	49	2	2	\N	\N
288	19	25	2	2	\N	\N
289	19	4	2	1	\N	\N
290	19	36	2	1	\N	\N
291	19	44	2	1	\N	\N
292	19	6	2	1	\N	\N
293	19	9	2	1	\N	\N
294	19	12	2	1	\N	\N
295	19	14	2	1	\N	\N
296	19	32	2	1	\N	\N
297	20	37	1	2004	\N	\N
298	20	25	1	1952	\N	\N
299	20	3	1	1308	\N	\N
300	20	2	1	1024	\N	\N
301	20	17	1	984	\N	\N
302	20	15	1	984	\N	\N
303	20	34	1	976	\N	\N
304	20	48	1	975	\N	\N
305	20	27	1	949	\N	\N
306	20	51	1	949	\N	\N
307	20	21	1	949	\N	\N
308	20	39	1	949	\N	\N
309	20	31	1	947	\N	\N
310	20	11	1	797	\N	\N
311	20	29	1	650	\N	\N
312	20	40	1	44	\N	\N
313	20	47	1	26	\N	\N
314	20	10	1	26	\N	\N
315	20	20	3	1966	\N	\N
316	20	48	2	4788	\N	\N
317	20	25	2	3192	\N	\N
318	20	28	2	1968	\N	\N
319	20	20	2	1966	\N	\N
320	20	46	2	1596	\N	\N
321	20	52	2	1596	\N	\N
322	20	45	2	984	\N	\N
323	20	22	2	984	\N	\N
324	20	7	2	984	\N	\N
325	20	43	2	982	\N	\N
326	20	33	2	799	\N	\N
327	20	24	2	612	\N	\N
328	21	37	2	2004	\N	\N
329	21	25	2	1898	\N	\N
330	21	3	2	1308	\N	\N
331	21	17	2	954	\N	\N
332	21	15	2	954	\N	\N
333	21	27	2	949	\N	\N
334	21	48	2	949	\N	\N
335	21	34	2	949	\N	\N
336	21	51	2	949	\N	\N
337	21	21	2	949	\N	\N
338	21	39	2	949	\N	\N
339	21	2	2	949	\N	\N
340	21	31	2	947	\N	\N
341	21	11	2	797	\N	\N
342	21	29	2	650	\N	\N
343	22	48	2	2952	\N	\N
344	22	25	2	1968	\N	\N
345	22	28	2	1957	\N	\N
346	22	46	2	984	\N	\N
347	22	20	2	984	\N	\N
348	22	45	2	984	\N	\N
349	22	22	2	984	\N	\N
350	22	52	2	984	\N	\N
351	22	7	2	984	\N	\N
352	22	33	2	799	\N	\N
353	23	48	1	558	\N	\N
354	23	25	1	186	\N	\N
355	23	34	1	181	\N	\N
356	23	3	3	382	\N	\N
357	23	23	3	338	\N	\N
358	23	37	3	323	\N	\N
359	23	40	3	18	\N	\N
360	23	48	2	1014	\N	\N
361	23	30	2	344	\N	\N
362	23	23	2	338	\N	\N
363	23	25	2	338	\N	\N
364	24	48	2	1836	\N	\N
365	24	25	2	1224	\N	\N
366	24	20	2	982	\N	\N
367	24	43	2	982	\N	\N
368	24	46	2	612	\N	\N
369	24	24	2	612	\N	\N
370	24	52	2	612	\N	\N
371	24	28	2	11	\N	\N
372	25	25	3	6572	\N	\N
373	25	48	2	10003	\N	\N
374	25	25	2	6572	\N	\N
375	25	37	2	1988	\N	\N
376	25	20	2	1960	\N	\N
377	25	28	2	1956	\N	\N
378	25	34	2	1942	\N	\N
379	25	46	2	1586	\N	\N
380	25	52	2	1529	\N	\N
381	25	3	2	1297	\N	\N
382	25	2	2	1021	\N	\N
383	25	17	2	982	\N	\N
384	25	15	2	982	\N	\N
385	25	7	2	980	\N	\N
386	25	45	2	976	\N	\N
387	25	22	2	976	\N	\N
388	25	43	2	975	\N	\N
389	25	39	2	947	\N	\N
390	25	51	2	946	\N	\N
391	25	21	2	945	\N	\N
392	25	31	2	944	\N	\N
393	25	27	2	943	\N	\N
394	25	11	2	793	\N	\N
395	25	33	2	790	\N	\N
396	25	29	2	639	\N	\N
397	25	24	2	608	\N	\N
398	25	30	2	343	\N	\N
399	25	23	2	337	\N	\N
400	25	40	2	44	\N	\N
401	25	47	2	26	\N	\N
402	25	10	2	26	\N	\N
403	25	49	2	6	\N	\N
404	25	50	2	4	\N	\N
405	25	41	2	3	\N	\N
406	25	38	2	3	\N	\N
407	25	35	2	3	\N	\N
408	25	18	2	3	\N	\N
409	25	42	2	3	\N	\N
410	25	13	2	2	\N	\N
411	25	5	2	2	\N	\N
412	25	19	2	2	\N	\N
413	25	16	2	2	\N	\N
414	25	4	2	1	\N	\N
415	25	36	2	1	\N	\N
416	25	44	2	1	\N	\N
417	25	6	2	1	\N	\N
418	25	1	2	1	\N	\N
419	25	8	2	1	\N	\N
420	25	26	2	1	\N	\N
421	25	9	2	1	\N	\N
422	25	12	2	1	\N	\N
423	25	14	2	1	\N	\N
424	25	32	2	1	\N	\N
425	26	26	3	1	\N	\N
426	26	25	2	1	\N	\N
427	26	8	2	1	\N	\N
428	26	26	2	1	\N	\N
429	27	37	2	2004	\N	\N
430	27	25	2	1898	\N	\N
431	27	3	2	1308	\N	\N
432	27	17	2	954	\N	\N
433	27	15	2	954	\N	\N
434	27	27	2	949	\N	\N
435	27	48	2	949	\N	\N
436	27	34	2	949	\N	\N
437	27	51	2	949	\N	\N
438	27	21	2	949	\N	\N
439	27	39	2	949	\N	\N
440	27	2	2	949	\N	\N
441	27	31	2	947	\N	\N
442	27	11	2	797	\N	\N
443	27	29	2	650	\N	\N
444	28	48	2	2979	\N	\N
445	28	25	2	1986	\N	\N
446	28	28	2	1968	\N	\N
447	28	20	2	1007	\N	\N
448	28	46	2	993	\N	\N
449	28	52	2	993	\N	\N
450	28	45	2	984	\N	\N
451	28	22	2	984	\N	\N
452	28	7	2	984	\N	\N
453	28	33	2	799	\N	\N
454	28	43	2	23	\N	\N
455	28	24	2	9	\N	\N
456	29	37	2	1392	\N	\N
457	29	3	2	1308	\N	\N
458	29	25	2	1300	\N	\N
459	29	17	2	654	\N	\N
460	29	15	2	654	\N	\N
461	29	27	2	650	\N	\N
462	29	29	2	650	\N	\N
463	29	48	2	650	\N	\N
464	29	34	2	650	\N	\N
465	29	51	2	650	\N	\N
466	29	21	2	650	\N	\N
467	29	39	2	650	\N	\N
468	29	2	2	650	\N	\N
469	29	31	2	649	\N	\N
470	29	11	2	503	\N	\N
471	30	48	1	81	\N	\N
472	30	25	1	27	\N	\N
473	30	34	1	24	\N	\N
474	30	37	3	824	\N	\N
475	30	3	3	605	\N	\N
476	30	30	3	345	\N	\N
477	30	40	3	21	\N	\N
478	30	48	2	1017	\N	\N
479	30	30	2	345	\N	\N
480	30	25	2	339	\N	\N
481	30	23	2	338	\N	\N
482	31	37	2	1999	\N	\N
483	31	25	2	1894	\N	\N
484	31	3	2	1306	\N	\N
485	31	17	2	952	\N	\N
486	31	15	2	952	\N	\N
487	31	27	2	947	\N	\N
488	31	48	2	947	\N	\N
489	31	34	2	947	\N	\N
490	31	51	2	947	\N	\N
491	31	31	2	947	\N	\N
492	31	21	2	947	\N	\N
493	31	39	2	947	\N	\N
494	31	2	2	947	\N	\N
495	31	11	2	797	\N	\N
496	31	29	2	649	\N	\N
497	32	32	3	1	\N	\N
498	32	50	2	4	\N	\N
499	32	38	2	3	\N	\N
500	32	42	2	3	\N	\N
501	32	4	2	1	\N	\N
502	32	36	2	1	\N	\N
503	32	5	2	1	\N	\N
504	32	44	2	1	\N	\N
505	32	19	2	1	\N	\N
506	32	6	2	1	\N	\N
507	32	49	2	1	\N	\N
508	32	25	2	1	\N	\N
509	32	9	2	1	\N	\N
510	32	14	2	1	\N	\N
511	32	32	2	1	\N	\N
512	33	48	1	1023	\N	\N
513	33	30	1	345	\N	\N
514	33	25	1	341	\N	\N
515	33	23	1	338	\N	\N
516	33	33	3	799	\N	\N
517	33	11	3	797	\N	\N
518	33	48	2	2169	\N	\N
519	33	25	2	1446	\N	\N
520	33	28	2	1436	\N	\N
521	33	33	2	799	\N	\N
522	33	46	2	723	\N	\N
523	33	20	2	723	\N	\N
524	33	45	2	723	\N	\N
525	33	22	2	723	\N	\N
526	33	52	2	723	\N	\N
527	33	7	2	723	\N	\N
528	34	34	3	1947	\N	\N
529	34	48	2	3888	\N	\N
530	34	25	2	2923	\N	\N
531	34	37	2	2004	\N	\N
532	34	34	2	1947	\N	\N
533	34	3	2	1308	\N	\N
534	34	2	2	1024	\N	\N
535	34	17	2	984	\N	\N
536	34	15	2	984	\N	\N
537	34	27	2	949	\N	\N
538	34	51	2	949	\N	\N
539	34	21	2	949	\N	\N
540	34	39	2	949	\N	\N
541	34	31	2	947	\N	\N
542	34	11	2	797	\N	\N
543	34	29	2	650	\N	\N
544	34	40	2	44	\N	\N
545	34	47	2	26	\N	\N
546	34	10	2	26	\N	\N
547	35	35	3	3	\N	\N
548	35	41	2	3	\N	\N
549	35	35	2	3	\N	\N
550	35	49	2	3	\N	\N
551	35	25	2	3	\N	\N
552	35	18	2	3	\N	\N
553	35	13	2	2	\N	\N
554	35	16	2	2	\N	\N
555	36	36	3	1	\N	\N
556	36	50	2	4	\N	\N
557	36	38	2	3	\N	\N
558	36	42	2	3	\N	\N
559	36	4	2	1	\N	\N
560	36	36	2	1	\N	\N
561	36	5	2	1	\N	\N
562	36	44	2	1	\N	\N
563	36	19	2	1	\N	\N
564	36	6	2	1	\N	\N
565	36	49	2	1	\N	\N
566	36	25	2	1	\N	\N
567	36	9	2	1	\N	\N
568	36	14	2	1	\N	\N
569	36	32	2	1	\N	\N
570	37	48	1	2271	\N	\N
571	37	25	1	757	\N	\N
572	37	34	1	674	\N	\N
573	37	37	3	2004	\N	\N
574	37	3	3	1047	\N	\N
575	37	30	3	345	\N	\N
576	37	23	3	214	\N	\N
577	37	40	3	41	\N	\N
578	37	37	2	2004	\N	\N
579	37	25	2	1898	\N	\N
580	37	3	2	1308	\N	\N
581	37	17	2	954	\N	\N
582	37	15	2	954	\N	\N
583	37	27	2	949	\N	\N
584	37	48	2	949	\N	\N
585	37	34	2	949	\N	\N
586	37	51	2	949	\N	\N
587	37	21	2	949	\N	\N
588	37	39	2	949	\N	\N
589	37	2	2	949	\N	\N
590	37	31	2	947	\N	\N
591	37	11	2	797	\N	\N
592	37	29	2	650	\N	\N
593	38	38	3	3	\N	\N
594	38	50	2	4	\N	\N
595	38	38	2	3	\N	\N
596	38	42	2	3	\N	\N
597	38	4	2	1	\N	\N
598	38	36	2	1	\N	\N
599	38	5	2	1	\N	\N
600	38	44	2	1	\N	\N
601	38	19	2	1	\N	\N
602	38	6	2	1	\N	\N
603	38	49	2	1	\N	\N
604	38	25	2	1	\N	\N
605	38	9	2	1	\N	\N
606	38	14	2	1	\N	\N
607	38	32	2	1	\N	\N
608	39	37	2	2004	\N	\N
609	39	25	2	1898	\N	\N
610	39	3	2	1308	\N	\N
611	39	17	2	954	\N	\N
612	39	15	2	954	\N	\N
613	39	27	2	949	\N	\N
614	39	48	2	949	\N	\N
615	39	34	2	949	\N	\N
616	39	51	2	949	\N	\N
617	39	21	2	949	\N	\N
618	39	39	2	949	\N	\N
619	39	2	2	949	\N	\N
620	39	31	2	947	\N	\N
621	39	11	2	797	\N	\N
622	39	29	2	650	\N	\N
623	40	48	1	72	\N	\N
624	40	25	1	24	\N	\N
625	40	34	1	24	\N	\N
626	40	37	3	684	\N	\N
627	40	3	3	525	\N	\N
628	40	30	3	226	\N	\N
629	40	23	3	56	\N	\N
630	40	40	3	44	\N	\N
631	40	2	2	63	\N	\N
632	40	25	2	46	\N	\N
633	40	40	2	44	\N	\N
634	40	17	2	26	\N	\N
635	40	15	2	26	\N	\N
636	40	47	2	23	\N	\N
637	40	34	2	23	\N	\N
638	40	10	2	23	\N	\N
639	40	48	2	22	\N	\N
640	41	41	2	3	\N	\N
641	41	35	2	3	\N	\N
642	41	49	2	3	\N	\N
643	41	25	2	3	\N	\N
644	41	18	2	3	\N	\N
645	41	13	2	2	\N	\N
646	41	16	2	2	\N	\N
647	42	41	1	3	\N	\N
648	42	35	1	3	\N	\N
649	42	49	1	3	\N	\N
650	42	25	1	3	\N	\N
651	42	18	1	3	\N	\N
652	42	13	1	2	\N	\N
653	42	16	1	2	\N	\N
654	42	42	3	3	\N	\N
655	42	50	2	4	\N	\N
656	42	38	2	3	\N	\N
657	42	42	2	3	\N	\N
658	42	4	2	1	\N	\N
659	42	36	2	1	\N	\N
660	42	5	2	1	\N	\N
661	42	44	2	1	\N	\N
662	42	19	2	1	\N	\N
663	42	6	2	1	\N	\N
664	42	49	2	1	\N	\N
665	42	25	2	1	\N	\N
666	42	9	2	1	\N	\N
667	42	14	2	1	\N	\N
668	42	32	2	1	\N	\N
669	43	48	1	2946	\N	\N
670	43	25	1	1964	\N	\N
671	43	28	1	1953	\N	\N
672	43	46	1	982	\N	\N
673	43	20	1	982	\N	\N
674	43	45	1	982	\N	\N
675	43	22	1	982	\N	\N
676	43	52	1	982	\N	\N
677	43	7	1	982	\N	\N
678	43	33	1	796	\N	\N
679	43	17	3	982	\N	\N
680	43	43	3	982	\N	\N
681	43	48	2	1836	\N	\N
682	43	25	2	1224	\N	\N
683	43	20	2	982	\N	\N
684	43	43	2	982	\N	\N
685	43	46	2	612	\N	\N
686	43	24	2	612	\N	\N
687	43	52	2	612	\N	\N
688	43	28	2	11	\N	\N
689	44	50	2	4	\N	\N
690	44	38	2	3	\N	\N
691	44	42	2	3	\N	\N
692	44	4	2	1	\N	\N
693	44	36	2	1	\N	\N
694	44	5	2	1	\N	\N
695	44	44	2	1	\N	\N
696	44	19	2	1	\N	\N
697	44	6	2	1	\N	\N
698	44	49	2	1	\N	\N
699	44	25	2	1	\N	\N
700	44	9	2	1	\N	\N
701	44	14	2	1	\N	\N
702	44	32	2	1	\N	\N
703	45	48	2	2952	\N	\N
704	45	25	2	1968	\N	\N
705	45	28	2	1957	\N	\N
706	45	46	2	984	\N	\N
707	45	20	2	984	\N	\N
708	45	45	2	984	\N	\N
709	45	22	2	984	\N	\N
710	45	52	2	984	\N	\N
711	45	7	2	984	\N	\N
712	45	33	2	799	\N	\N
713	46	46	3	1596	\N	\N
714	46	48	2	4788	\N	\N
715	46	25	2	3192	\N	\N
716	46	28	2	1968	\N	\N
717	46	20	2	1966	\N	\N
718	46	46	2	1596	\N	\N
719	46	52	2	1596	\N	\N
720	46	45	2	984	\N	\N
721	46	22	2	984	\N	\N
722	46	7	2	984	\N	\N
723	46	43	2	982	\N	\N
724	46	33	2	799	\N	\N
725	46	24	2	612	\N	\N
726	47	2	2	72	\N	\N
727	47	25	2	52	\N	\N
728	47	40	2	44	\N	\N
729	47	17	2	29	\N	\N
730	47	15	2	29	\N	\N
731	47	47	2	26	\N	\N
732	47	34	2	26	\N	\N
733	47	10	2	26	\N	\N
734	47	48	2	25	\N	\N
735	48	48	2	10004	\N	\N
736	48	25	2	6561	\N	\N
737	48	37	2	1988	\N	\N
738	48	20	2	1960	\N	\N
739	48	28	2	1956	\N	\N
740	48	34	2	1941	\N	\N
741	48	46	2	1586	\N	\N
742	48	52	2	1529	\N	\N
743	48	3	2	1297	\N	\N
744	48	2	2	1017	\N	\N
745	48	17	2	981	\N	\N
746	48	15	2	981	\N	\N
747	48	7	2	980	\N	\N
748	48	45	2	976	\N	\N
749	48	22	2	976	\N	\N
750	48	43	2	975	\N	\N
751	48	39	2	947	\N	\N
752	48	51	2	946	\N	\N
753	48	21	2	945	\N	\N
754	48	31	2	944	\N	\N
755	48	27	2	943	\N	\N
756	48	11	2	793	\N	\N
757	48	33	2	790	\N	\N
758	48	29	2	639	\N	\N
759	48	24	2	608	\N	\N
760	48	30	2	343	\N	\N
761	48	23	2	337	\N	\N
762	48	40	2	42	\N	\N
763	48	47	2	25	\N	\N
764	48	10	2	25	\N	\N
765	49	49	2	6	\N	\N
766	49	25	2	6	\N	\N
767	49	50	2	4	\N	\N
768	49	41	2	3	\N	\N
769	49	38	2	3	\N	\N
770	49	35	2	3	\N	\N
771	49	18	2	3	\N	\N
772	49	42	2	3	\N	\N
773	49	13	2	2	\N	\N
774	49	5	2	2	\N	\N
775	49	19	2	2	\N	\N
776	49	16	2	2	\N	\N
777	49	4	2	1	\N	\N
778	49	36	2	1	\N	\N
779	49	44	2	1	\N	\N
780	49	6	2	1	\N	\N
781	49	9	2	1	\N	\N
782	49	12	2	1	\N	\N
783	49	14	2	1	\N	\N
784	49	32	2	1	\N	\N
785	50	50	3	4	\N	\N
786	50	50	2	4	\N	\N
787	50	38	2	3	\N	\N
788	50	42	2	3	\N	\N
789	50	4	2	1	\N	\N
790	50	36	2	1	\N	\N
791	50	5	2	1	\N	\N
792	50	44	2	1	\N	\N
793	50	19	2	1	\N	\N
794	50	6	2	1	\N	\N
795	50	49	2	1	\N	\N
796	50	25	2	1	\N	\N
797	50	9	2	1	\N	\N
798	50	14	2	1	\N	\N
799	50	32	2	1	\N	\N
800	51	37	2	2004	\N	\N
801	51	25	2	1898	\N	\N
802	51	3	2	1308	\N	\N
803	51	17	2	954	\N	\N
804	51	15	2	954	\N	\N
805	51	27	2	949	\N	\N
806	51	48	2	949	\N	\N
807	51	34	2	949	\N	\N
808	51	51	2	949	\N	\N
809	51	21	2	949	\N	\N
810	51	39	2	949	\N	\N
811	51	2	2	949	\N	\N
812	51	31	2	947	\N	\N
813	51	11	2	797	\N	\N
814	51	29	2	650	\N	\N
815	52	48	2	4788	\N	\N
816	52	25	2	3192	\N	\N
817	52	28	2	1968	\N	\N
818	52	20	2	1966	\N	\N
819	52	46	2	1596	\N	\N
820	52	52	2	1596	\N	\N
821	52	45	2	984	\N	\N
822	52	22	2	984	\N	\N
823	52	7	2	984	\N	\N
824	52	43	2	982	\N	\N
825	52	33	2	799	\N	\N
826	52	24	2	612	\N	\N
\.


--
-- Data for Name: properties; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint, has_followers_ok, has_outgoing_props_ok, has_incoming_props_ok) FROM stdin;
1	http://schema.org/startDate	1	\N	9	startDate	startDate	f	0	1	\N	t	f	15	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
2	http://xmlns.com/foaf/0.1/name	977	\N	8	name	name	f	0	-1	\N	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
3	http://dbpedia.org/ontology/deathPlace	639	\N	10	deathPlace	deathPlace	f	1308	-1	-1	t	t	20	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
4	http://purl.org/dc/terms/accessRights	1	\N	5	accessRights	accessRights	f	1	1	1	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
5	http://purl.org/dc/terms/description	2	\N	5	description	description	f	0	1	\N	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
6	http://purl.org/dc/terms/spatial	1	\N	5	spatial	spatial	f	1	1	1	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
7	http://purl.org/dc/terms/isPartOf	984	\N	5	isPartOf	isPartOf	f	984	1	-1	t	f	25	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
8	http://www.w3.org/2006/vcard/ns#fn	1	\N	39	fn	fn	f	0	1	\N	t	f	27	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
9	http://www.w3.org/ns/dcat#contactPoint	1	\N	15	contactPoint	contactPoint	f	1	1	1	t	t	21	27	\N	t	f	\N	\N	\N	t	f	f	t	t	t
10	https://schema.org/foundingDate	26	\N	72	foundingDate	foundingDate	f	0	1	\N	t	f	23	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
11	http://dbpedia.org/ontology/affiliation	719	\N	10	affiliation	affiliation	f	797	-1	-1	t	t	20	24	\N	t	f	\N	\N	\N	t	f	f	t	t	t
22	http://data.nobelprize.org/terms/sortOrder	984	\N	69	sortOrder	sortOrder	f	0	1	\N	t	f	25	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
12	http://www.w3.org/ns/dcat#dataset	1	\N	15	dataset	dataset	f	1	1	1	t	t	26	21	\N	t	f	\N	\N	\N	t	f	f	t	t	t
13	http://purl.org/dc/terms/conformsTo	2	\N	5	conformsTo	conformsTo	f	2	1	-1	t	t	16	19	\N	t	f	\N	\N	\N	t	f	f	t	t	t
14	http://www.w3.org/ns/dcat#keyword	1	\N	15	keyword	keyword	f	0	1	\N	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
15	http://data.nobelprize.org/terms/nobelPrize	976	\N	69	nobelPrize	nobelPrize	f	984	-1	-1	t	f	17	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
16	http://www.w3.org/ns/adms#status	2	\N	70	status	status	f	2	1	-1	t	f	16	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
39	http://xmlns.com/foaf/0.1/givenName	949	\N	8	givenName	givenName	f	0	1	\N	t	f	20	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
17	http://data.nobelprize.org/terms/laureateAward	976	\N	69	laureateAward	laureateAward	f	984	-1	1	t	t	17	25	\N	t	f	\N	\N	\N	t	f	f	t	t	t
18	http://www.w3.org/ns/dcat#accessURL	3	\N	15	accessURL	accessURL	f	3	1	1	t	f	16	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
19	http://purl.org/dc/terms/publisher	2	\N	5	publisher	publisher	f	2	1	-1	t	t	\N	22	\N	t	f	\N	\N	\N	t	f	f	t	t	t
23	http://dbpedia.org/ontology/city	338	\N	10	city	city	f	338	1	-1	t	t	24	29	\N	t	f	\N	\N	\N	t	f	f	t	t	t
20	http://data.nobelprize.org/terms/laureate	1596	\N	69	laureate	laureate	f	1966	-1	-1	t	t	30	17	\N	t	f	\N	\N	\N	t	f	f	t	t	t
24	http://data.nobelprize.org/terms/categoryOrder	612	\N	69	categoryOrder	categoryOrder	f	0	1	\N	t	f	18	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
26	http://www.w3.org/2006/vcard/ns#hasEmail	1	\N	39	hasEmail	hasEmail	f	1	1	1	t	f	27	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
27	http://dbpedia.org/property/dateOfBirth	949	\N	19	dateOfBirth	dateOfBirth	f	0	1	\N	t	f	20	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
28	http://data.nobelprize.org/terms/motivation	993	\N	69	motivation	motivation	f	0	-1	\N	t	f	30	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
29	http://dbpedia.org/property/dateOfDeath	650	\N	19	dateOfDeath	dateOfDeath	f	0	1	\N	t	f	20	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
33	http://data.nobelprize.org/terms/university	723	\N	69	university	university	f	799	-1	-1	t	t	25	24	\N	t	f	\N	\N	\N	t	f	f	t	t	t
30	http://dbpedia.org/ontology/country	339	\N	10	country	country	f	345	-1	-1	t	t	24	28	\N	t	f	\N	\N	\N	t	f	f	t	t	t
31	http://xmlns.com/foaf/0.1/familyName	947	\N	8	familyName	familyName	f	0	1	\N	t	f	20	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
32	http://www.w3.org/ns/dcat#landingPage	1	\N	15	landingPage	landingPage	f	1	1	1	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
34	http://www.w3.org/2002/07/owl#sameAs	1947	\N	7	sameAs	sameAs	f	1947	1	-1	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
35	http://purl.org/dc/terms/license	3	\N	5	license	license	f	3	1	-1	t	f	16	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
36	http://purl.org/dc/terms/accrualPeriodicity	1	\N	5	accrualPeriodicity	accrualPeriodicity	f	1	1	1	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
37	http://dbpedia.org/ontology/birthPlace	949	\N	10	birthPlace	birthPlace	f	2004	-1	-1	t	t	20	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
38	http://purl.org/dc/terms/language	1	\N	5	language	language	f	3	-1	1	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
40	https://schema.org/foundingLocation	23	\N	72	foundingLocation	foundingLocation	f	44	-1	-1	t	t	23	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
41	http://purl.org/dc/terms/format	3	\N	5	format	format	f	0	1	\N	t	f	16	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
44	http://purl.org/dc/terms/issued	1	\N	5	issued	issued	f	0	1	\N	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
42	http://www.w3.org/ns/dcat#distribution	1	\N	15	distribution	distribution	f	3	-1	1	t	t	21	16	\N	t	f	\N	\N	\N	t	f	f	t	t	t
43	http://purl.org/dc/terms/hasPart	612	\N	5	hasPart	hasPart	f	982	-1	1	t	t	18	25	\N	t	f	\N	\N	\N	t	f	f	t	t	t
45	http://data.nobelprize.org/terms/share	984	\N	69	share	share	f	0	1	\N	t	f	25	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
47	http://purl.org/dc/terms/created	26	\N	5	created	created	f	0	1	\N	t	f	23	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
48	http://www.w3.org/2000/01/rdf-schema#label	3991	\N	2	label	label	f	0	-1	\N	f	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
49	http://purl.org/dc/terms/title	6	\N	5	title	title	f	0	1	\N	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
50	http://www.w3.org/ns/dcat#theme	1	\N	15	theme	theme	f	4	-1	1	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
51	http://xmlns.com/foaf/0.1/birthday	949	\N	8	birthday	birthday	f	0	1	\N	t	f	20	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
52	http://data.nobelprize.org/terms/year	1596	\N	69	year	year	f	0	1	\N	t	f	30	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
25	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	4000	\N	1	type	type	f	6572	-1	-1	t	f	\N	\N	\N	t	t	t	\N	t	t	f	f	t	t	t
21	http://xmlns.com/foaf/0.1/gender	949	\N	8	gender	gender	f	0	1	\N	t	f	20	\N	\N	t	t	f	gender	f	t	f	f	t	t	t
46	http://data.nobelprize.org/terms/category	1596	\N	69	category	category	f	1596	1	-1	t	f	30	\N	\N	t	t	f	category	f	t	f	f	t	t	t
\.


--
-- Data for Name: property_annots; Type: TABLE DATA; Schema: nobel_prizes; Owner: -
--

COPY nobel_prizes.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.annot_types_id_seq', 7, true);


--
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cc_rel_types_id_seq', 3, true);


--
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cc_rels_id_seq', 54, true);


--
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.class_annots_id_seq', 1, false);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.classes_id_seq', 30, true);


--
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cp_rel_types_id_seq', 4, true);


--
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cp_rels_id_seq', 143, true);


--
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cpc_rels_id_seq', 106, true);


--
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.cpd_rels_id_seq', 53, true);


--
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.datatypes_id_seq', 5, true);


--
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.instances_id_seq', 1, false);


--
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.ns_id_seq', 72, true);


--
-- Name: ns_stats_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.ns_stats_id_seq', 1, false);


--
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.parameters_id_seq', 32, true);


--
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.pd_rels_id_seq', 24, true);


--
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.pp_rel_types_id_seq', 4, true);


--
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.pp_rels_id_seq', 826, true);


--
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.properties_id_seq', 52, true);


--
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes; Owner: -
--

SELECT pg_catalog.setval('nobel_prizes.property_annots_id_seq', 1, false);


--
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_annot_types_ns_fk ON nobel_prizes.annot_types USING btree (ns_id);


--
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cc_rels_class_1_fk ON nobel_prizes.cc_rels USING btree (class_1_id);


--
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cc_rels_class_2_fk ON nobel_prizes.cc_rels USING btree (class_2_id);


--
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cc_rels_type_fk ON nobel_prizes.cc_rels USING btree (type_id);


--
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_class_annots_class_fk ON nobel_prizes.class_annots USING btree (class_id);


--
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_classes_ns_fk ON nobel_prizes.classes USING btree (ns_id);


--
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_classes_superclass_fk ON nobel_prizes.classes USING btree (principal_super_class_id);


--
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_class_fk ON nobel_prizes.cp_rels USING btree (class_id);


--
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON nobel_prizes.properties USING btree (domain_class_id);


--
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_property_fk ON nobel_prizes.cp_rels USING btree (property_id);


--
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_range_classes_fk ON nobel_prizes.properties USING btree (range_class_id);


--
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_cp_rels_type_fk ON nobel_prizes.cp_rels USING btree (type_id);


--
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_datatypes_ns_fk ON nobel_prizes.datatypes USING btree (ns_id);


--
-- Name: fki_ns_stats_class_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_ns_stats_class_fk ON nobel_prizes.ns_stats USING btree (class_id);


--
-- Name: fki_ns_stats_property_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_ns_stats_property_fk ON nobel_prizes.ns_stats USING btree (property_id);


--
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_pp_rels_property_1_fk ON nobel_prizes.pp_rels USING btree (property_1_id);


--
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_pp_rels_property_2_fk ON nobel_prizes.pp_rels USING btree (property_2_id);


--
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_pp_rels_type_fk ON nobel_prizes.pp_rels USING btree (type_id);


--
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_properties_ns_fk ON nobel_prizes.properties USING btree (ns_id);


--
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX fki_property_annots_class_fk ON nobel_prizes.property_annots USING btree (property_id);


--
-- Name: idx_cc_rels_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cc_rels_data ON nobel_prizes.cc_rels USING gin (data);


--
-- Name: idx_classes_cnt; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_cnt ON nobel_prizes.classes USING btree (cnt);


--
-- Name: idx_classes_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_data ON nobel_prizes.classes USING gin (data);


--
-- Name: idx_classes_iri; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_iri ON nobel_prizes.classes USING btree (iri);


--
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_classes_large_superclass_id ON nobel_prizes.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_data ON nobel_prizes.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_class_prop_object ON nobel_prizes.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- Name: idx_cp_rels_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_data ON nobel_prizes.cp_rels USING gin (data);


--
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_cp_rels_prop_class ON nobel_prizes.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- Name: idx_instances_local_name; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_instances_local_name ON nobel_prizes.instances USING btree (local_name text_pattern_ops);


--
-- Name: idx_instances_test; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_instances_test ON nobel_prizes.instances USING gin (test);


--
-- Name: idx_pp_rels_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_data ON nobel_prizes.pp_rels USING gin (data);


--
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON nobel_prizes.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON nobel_prizes.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type ON nobel_prizes.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_1_type_ ON nobel_prizes.pp_rels USING btree (property_1_id, type_id);


--
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type ON nobel_prizes.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_pp_rels_property_2_type_ ON nobel_prizes.pp_rels USING btree (property_2_id, type_id);


--
-- Name: idx_properties_cnt; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_properties_cnt ON nobel_prizes.properties USING btree (cnt);


--
-- Name: idx_properties_data; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_properties_data ON nobel_prizes.properties USING gin (data);


--
-- Name: idx_properties_iri; Type: INDEX; Schema: nobel_prizes; Owner: -
--

CREATE INDEX idx_properties_iri ON nobel_prizes.properties USING btree (iri);


--
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.cc_rel_types(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.annot_types(id) ON DELETE CASCADE;


--
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes.datatypes(id) ON DELETE SET NULL;


--
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.cp_rel_types(id);


--
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES nobel_prizes.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES nobel_prizes.classes(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES nobel_prizes.cp_rels(id) ON DELETE CASCADE;


--
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes.datatypes(id) ON DELETE CASCADE;


--
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ns_stats ns_stats_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns_stats
    ADD CONSTRAINT ns_stats_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ns_stats ns_stats_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns_stats
    ADD CONSTRAINT ns_stats_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE CASCADE;


--
-- Name: ns_stats ns_stats_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.ns_stats
    ADD CONSTRAINT ns_stats_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes.properties(id);


--
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes.datatypes(id) ON DELETE CASCADE;


--
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.pp_rel_types(id);


--
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes.ns(id) ON DELETE SET NULL;


--
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES nobel_prizes.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes.properties(id) ON DELETE CASCADE;


--
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes; Owner: -
--

ALTER TABLE ONLY nobel_prizes.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes.annot_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

