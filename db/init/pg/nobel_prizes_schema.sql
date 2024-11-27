--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5
-- Dumped by pg_dump version 14.4

-- Started on 2024-11-25 23:51:22

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
-- TOC entry 125 (class 2615 OID 353979)
-- Name: nobel_prizes_schema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA nobel_prizes_schema;


ALTER SCHEMA nobel_prizes_schema OWNER TO postgres;

--
-- TOC entry 20960 (class 0 OID 0)
-- Dependencies: 125
-- Name: SCHEMA nobel_prizes_schema; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA nobel_prizes_schema IS 'schema for rdf endpoint meta info; v0.1';


--
-- TOC entry 7018 (class 1255 OID 353980)
-- Name: tapprox(integer); Type: FUNCTION; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE FUNCTION nobel_prizes_schema.tapprox(integer) RETURNS text
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


ALTER FUNCTION nobel_prizes_schema.tapprox(integer) OWNER TO postgres;

--
-- TOC entry 7017 (class 1255 OID 353981)
-- Name: tapprox(bigint); Type: FUNCTION; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE FUNCTION nobel_prizes_schema.tapprox(bigint) RETURNS text
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


ALTER FUNCTION nobel_prizes_schema.tapprox(bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 6675 (class 1259 OID 353982)
-- Name: _h_classes; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema._h_classes (
    a integer NOT NULL,
    b integer NOT NULL
);


ALTER TABLE nobel_prizes_schema._h_classes OWNER TO postgres;

--
-- TOC entry 20963 (class 0 OID 0)
-- Dependencies: 6675
-- Name: TABLE _h_classes; Type: COMMENT; Schema: nobel_prizes_schema; Owner: postgres
--

COMMENT ON TABLE nobel_prizes_schema._h_classes IS '-- Helper table for large subclass id computation';


--
-- TOC entry 6676 (class 1259 OID 353985)
-- Name: annot_types; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.annot_types (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


ALTER TABLE nobel_prizes_schema.annot_types OWNER TO postgres;

--
-- TOC entry 6677 (class 1259 OID 353990)
-- Name: annot_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.annot_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.annot_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6678 (class 1259 OID 353991)
-- Name: classes; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.classes (
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


ALTER TABLE nobel_prizes_schema.classes OWNER TO postgres;

--
-- TOC entry 20964 (class 0 OID 0)
-- Dependencies: 6678
-- Name: COLUMN classes.in_cnt; Type: COMMENT; Schema: nobel_prizes_schema; Owner: postgres
--

COMMENT ON COLUMN nobel_prizes_schema.classes.in_cnt IS 'Incoming link count';


--
-- TOC entry 6679 (class 1259 OID 354003)
-- Name: cp_rels; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.cp_rels (
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


ALTER TABLE nobel_prizes_schema.cp_rels OWNER TO postgres;

--
-- TOC entry 6680 (class 1259 OID 354012)
-- Name: properties; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.properties (
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


ALTER TABLE nobel_prizes_schema.properties OWNER TO postgres;

--
-- TOC entry 6681 (class 1259 OID 354029)
-- Name: c_links; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.c_links AS
 SELECT c1.id AS c1_id,
    p.id AS p_id,
    c2.id AS c2_id
   FROM ((((nobel_prizes_schema.classes c1
     JOIN nobel_prizes_schema.cp_rels cp1 ON ((c1.id = cp1.class_id)))
     JOIN nobel_prizes_schema.properties p ON ((cp1.property_id = p.id)))
     JOIN nobel_prizes_schema.cp_rels cp2 ON ((cp2.property_id = p.id)))
     JOIN nobel_prizes_schema.classes c2 ON ((c2.id = cp2.class_id)))
  WHERE ((cp1.type_id = 1) AND (cp2.type_id = 2));


ALTER TABLE nobel_prizes_schema.c_links OWNER TO postgres;

--
-- TOC entry 6682 (class 1259 OID 354034)
-- Name: cc_rel_types; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.cc_rel_types (
    id integer NOT NULL,
    name text
);


ALTER TABLE nobel_prizes_schema.cc_rel_types OWNER TO postgres;

--
-- TOC entry 6683 (class 1259 OID 354039)
-- Name: cc_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.cc_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.cc_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6684 (class 1259 OID 354040)
-- Name: cc_rels; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.cc_rels (
    id integer NOT NULL,
    class_1_id integer NOT NULL,
    class_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb
);


ALTER TABLE nobel_prizes_schema.cc_rels OWNER TO postgres;

--
-- TOC entry 6685 (class 1259 OID 354045)
-- Name: cc_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.cc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.cc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6686 (class 1259 OID 354046)
-- Name: class_annots; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.class_annots (
    id integer NOT NULL,
    class_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


ALTER TABLE nobel_prizes_schema.class_annots OWNER TO postgres;

--
-- TOC entry 6687 (class 1259 OID 354052)
-- Name: class_annots_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.class_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.class_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6688 (class 1259 OID 354053)
-- Name: classes_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.classes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6689 (class 1259 OID 354054)
-- Name: cp_rel_types; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.cp_rel_types (
    id integer NOT NULL,
    name text
);


ALTER TABLE nobel_prizes_schema.cp_rel_types OWNER TO postgres;

--
-- TOC entry 6690 (class 1259 OID 354059)
-- Name: cp_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.cp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.cp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6691 (class 1259 OID 354060)
-- Name: cp_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.cp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.cp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6692 (class 1259 OID 354061)
-- Name: cpc_rels; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.cpc_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    other_class_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cover_set_index integer,
    cnt_base bigint
);


ALTER TABLE nobel_prizes_schema.cpc_rels OWNER TO postgres;

--
-- TOC entry 6693 (class 1259 OID 354066)
-- Name: cpc_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.cpc_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.cpc_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6694 (class 1259 OID 354067)
-- Name: cpd_rels; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.cpd_rels (
    id integer NOT NULL,
    cp_rel_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


ALTER TABLE nobel_prizes_schema.cpd_rels OWNER TO postgres;

--
-- TOC entry 6695 (class 1259 OID 354072)
-- Name: cpd_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.cpd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.cpd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6696 (class 1259 OID 354073)
-- Name: datatypes; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.datatypes (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text
);


ALTER TABLE nobel_prizes_schema.datatypes OWNER TO postgres;

--
-- TOC entry 6697 (class 1259 OID 354078)
-- Name: datatypes_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.datatypes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.datatypes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6698 (class 1259 OID 354079)
-- Name: instances; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.instances (
    id integer NOT NULL,
    iri text NOT NULL,
    ns_id integer,
    local_name text,
    local_name_lowercase text,
    class_id integer,
    class_iri text,
    test tsvector GENERATED ALWAYS AS (to_tsvector('english'::regconfig, local_name)) STORED
);


ALTER TABLE nobel_prizes_schema.instances OWNER TO postgres;

--
-- TOC entry 6699 (class 1259 OID 354085)
-- Name: instances_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.instances ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6700 (class 1259 OID 354086)
-- Name: ns; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.ns (
    id integer NOT NULL,
    name text NOT NULL,
    value text NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    is_local boolean DEFAULT false NOT NULL,
    basic_order_level integer DEFAULT 0 NOT NULL
);


ALTER TABLE nobel_prizes_schema.ns OWNER TO postgres;

--
-- TOC entry 6701 (class 1259 OID 354094)
-- Name: ns_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.ns ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.ns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6702 (class 1259 OID 354095)
-- Name: ns_stats; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.ns_stats (
    id integer NOT NULL,
    ns_id integer NOT NULL,
    cnt bigint,
    type_id integer,
    class_id integer,
    property_id integer
);


ALTER TABLE nobel_prizes_schema.ns_stats OWNER TO postgres;

--
-- TOC entry 20965 (class 0 OID 0)
-- Dependencies: 6702
-- Name: COLUMN ns_stats.type_id; Type: COMMENT; Schema: nobel_prizes_schema; Owner: postgres
--

COMMENT ON COLUMN nobel_prizes_schema.ns_stats.type_id IS '1 - class, 2 - subject, 3 - object';


--
-- TOC entry 6703 (class 1259 OID 354098)
-- Name: ns_stats_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.ns_stats ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.ns_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6704 (class 1259 OID 354099)
-- Name: parameters; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.parameters (
    order_inx numeric DEFAULT 999 NOT NULL,
    name text NOT NULL,
    textvalue text,
    jsonvalue jsonb,
    comment text,
    id integer NOT NULL
);


ALTER TABLE nobel_prizes_schema.parameters OWNER TO postgres;

--
-- TOC entry 6705 (class 1259 OID 354105)
-- Name: parameters_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.parameters ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6706 (class 1259 OID 354106)
-- Name: pd_rels; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.pd_rels (
    id integer NOT NULL,
    property_id integer NOT NULL,
    datatype_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


ALTER TABLE nobel_prizes_schema.pd_rels OWNER TO postgres;

--
-- TOC entry 6707 (class 1259 OID 354111)
-- Name: pd_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.pd_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.pd_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6708 (class 1259 OID 354112)
-- Name: pp_rel_types; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.pp_rel_types (
    id integer NOT NULL,
    name text
);


ALTER TABLE nobel_prizes_schema.pp_rel_types OWNER TO postgres;

--
-- TOC entry 6709 (class 1259 OID 354117)
-- Name: pp_rel_types_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.pp_rel_types ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.pp_rel_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6710 (class 1259 OID 354118)
-- Name: pp_rels; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.pp_rels (
    id integer NOT NULL,
    property_1_id integer NOT NULL,
    property_2_id integer NOT NULL,
    type_id integer NOT NULL,
    cnt bigint,
    data jsonb,
    cnt_base bigint
);


ALTER TABLE nobel_prizes_schema.pp_rels OWNER TO postgres;

--
-- TOC entry 6711 (class 1259 OID 354123)
-- Name: pp_rels_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.pp_rels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.pp_rels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6712 (class 1259 OID 354124)
-- Name: properties_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.properties ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.properties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6713 (class 1259 OID 354125)
-- Name: property_annots; Type: TABLE; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE TABLE nobel_prizes_schema.property_annots (
    id integer NOT NULL,
    property_id integer NOT NULL,
    type_id integer NOT NULL,
    annotation text NOT NULL,
    language_code text DEFAULT 'en'::text
);


ALTER TABLE nobel_prizes_schema.property_annots OWNER TO postgres;

--
-- TOC entry 6714 (class 1259 OID 354131)
-- Name: property_annots_id_seq; Type: SEQUENCE; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE nobel_prizes_schema.property_annots ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME nobel_prizes_schema.property_annots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 6715 (class 1259 OID 354132)
-- Name: v_cc_rels; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_cc_rels AS
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
   FROM nobel_prizes_schema.cc_rels r,
    nobel_prizes_schema.classes c1,
    nobel_prizes_schema.classes c2
  WHERE ((r.class_1_id = c1.id) AND (r.class_2_id = c2.id));


ALTER TABLE nobel_prizes_schema.v_cc_rels OWNER TO postgres;

--
-- TOC entry 6716 (class 1259 OID 354136)
-- Name: v_classes_ns; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_classes_ns AS
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
    nobel_prizes_schema.tapprox(c.cnt) AS cnt_x,
    n.is_local,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (nobel_prizes_schema.classes c
     LEFT JOIN nobel_prizes_schema.ns n ON ((c.ns_id = n.id)));


ALTER TABLE nobel_prizes_schema.v_classes_ns OWNER TO postgres;

--
-- TOC entry 6717 (class 1259 OID 354141)
-- Name: v_classes_ns_main; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_classes_ns_main AS
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
   FROM nobel_prizes_schema.v_classes_ns v
  WHERE (NOT (EXISTS ( SELECT cc_rels.id
           FROM nobel_prizes_schema.cc_rels
          WHERE ((cc_rels.class_1_id = v.id) AND (cc_rels.type_id = 2)))));


ALTER TABLE nobel_prizes_schema.v_classes_ns_main OWNER TO postgres;

--
-- TOC entry 6718 (class 1259 OID 354146)
-- Name: v_classes_ns_plus; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_classes_ns_plus AS
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
    nobel_prizes_schema.tapprox(c.cnt) AS cnt_x,
    n.is_local,
        CASE
            WHEN (EXISTS ( SELECT cc_rels.class_1_id
               FROM nobel_prizes_schema.cc_rels
              WHERE (cc_rels.class_2_id = c.id))) THEN 1
            ELSE 0
        END AS has_subclasses,
    c.large_superclass_id,
    c.hide_in_main,
    c.principal_super_class_id,
    c.self_cp_rels,
    c.cp_ask_endpoint,
    c.in_cnt
   FROM (nobel_prizes_schema.classes c
     LEFT JOIN nobel_prizes_schema.ns n ON ((c.ns_id = n.id)));


ALTER TABLE nobel_prizes_schema.v_classes_ns_plus OWNER TO postgres;

--
-- TOC entry 6719 (class 1259 OID 354151)
-- Name: v_classes_ns_main_plus; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_classes_ns_main_plus AS
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
   FROM nobel_prizes_schema.v_classes_ns_plus v
  WHERE (NOT (EXISTS ( SELECT r.id,
            r.class_1_id,
            r.class_2_id,
            r.type_id,
            r.cnt,
            r.data
           FROM nobel_prizes_schema.cc_rels r
          WHERE ((r.class_1_id = v.id) AND (r.type_id = 2)))));


ALTER TABLE nobel_prizes_schema.v_classes_ns_main_plus OWNER TO postgres;

--
-- TOC entry 6720 (class 1259 OID 354156)
-- Name: v_classes_ns_main_v01; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_classes_ns_main_v01 AS
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
   FROM (nobel_prizes_schema.v_classes_ns v
     LEFT JOIN nobel_prizes_schema.cc_rels r ON (((r.class_1_id = v.id) AND (r.type_id = 2))))
  WHERE (r.class_2_id IS NULL);


ALTER TABLE nobel_prizes_schema.v_classes_ns_main_v01 OWNER TO postgres;

--
-- TOC entry 6721 (class 1259 OID 354161)
-- Name: v_cp_rels; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_cp_rels AS
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
    nobel_prizes_schema.tapprox((r.cnt)::integer) AS cnt_x,
    nobel_prizes_schema.tapprox(r.object_cnt) AS object_cnt_x,
    nobel_prizes_schema.tapprox(r.data_cnt_calc) AS data_cnt_x,
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
   FROM nobel_prizes_schema.cp_rels r,
    nobel_prizes_schema.classes c,
    nobel_prizes_schema.properties p
  WHERE ((r.class_id = c.id) AND (r.property_id = p.id));


ALTER TABLE nobel_prizes_schema.v_cp_rels OWNER TO postgres;

--
-- TOC entry 6722 (class 1259 OID 354166)
-- Name: v_cp_rels_card; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_cp_rels_card AS
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
   FROM nobel_prizes_schema.cp_rels r,
    nobel_prizes_schema.properties p
  WHERE (r.property_id = p.id);


ALTER TABLE nobel_prizes_schema.v_cp_rels_card OWNER TO postgres;

--
-- TOC entry 6723 (class 1259 OID 354171)
-- Name: v_properties_ns; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_properties_ns AS
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
    nobel_prizes_schema.tapprox(p.cnt) AS cnt_x,
    nobel_prizes_schema.tapprox(p.object_cnt) AS object_cnt_x,
    nobel_prizes_schema.tapprox(p.data_cnt_calc) AS data_cnt_x,
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
   FROM (nobel_prizes_schema.properties p
     LEFT JOIN nobel_prizes_schema.ns n ON ((p.ns_id = n.id)));


ALTER TABLE nobel_prizes_schema.v_properties_ns OWNER TO postgres;

--
-- TOC entry 6724 (class 1259 OID 354176)
-- Name: v_cp_sources_single; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_cp_sources_single AS
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
   FROM ((nobel_prizes_schema.v_cp_rels_card r
     JOIN nobel_prizes_schema.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN nobel_prizes_schema.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.domain_class_id) = c.id)))
  WHERE (r.type_id = 1);


ALTER TABLE nobel_prizes_schema.v_cp_sources_single OWNER TO postgres;

--
-- TOC entry 6725 (class 1259 OID 354181)
-- Name: v_cp_targets_single; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_cp_targets_single AS
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
   FROM ((nobel_prizes_schema.v_cp_rels_card r
     JOIN nobel_prizes_schema.v_properties_ns v ON ((r.property_id = v.id)))
     LEFT JOIN nobel_prizes_schema.v_classes_ns c ON ((COALESCE(r.principal_class_id, v.range_class_id) = c.id)))
  WHERE (r.type_id = 2);


ALTER TABLE nobel_prizes_schema.v_cp_targets_single OWNER TO postgres;

--
-- TOC entry 6726 (class 1259 OID 354186)
-- Name: v_pp_rels_names; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_pp_rels_names AS
 SELECT r.id,
    r.property_1_id,
    r.property_2_id,
    r.type_id,
    r.cnt,
    r.data,
    p1.iri AS iri1,
    p2.iri AS iri2,
    nobel_prizes_schema.tapprox((r.cnt)::integer) AS cnt_x
   FROM nobel_prizes_schema.pp_rels r,
    nobel_prizes_schema.properties p1,
    nobel_prizes_schema.properties p2
  WHERE ((r.property_1_id = p1.id) AND (r.property_2_id = p2.id));


ALTER TABLE nobel_prizes_schema.v_pp_rels_names OWNER TO postgres;

--
-- TOC entry 6727 (class 1259 OID 354190)
-- Name: v_properties_sources; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_properties_sources AS
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
   FROM (nobel_prizes_schema.v_properties_ns v
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
           FROM nobel_prizes_schema.cp_rels r,
            nobel_prizes_schema.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 2))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


ALTER TABLE nobel_prizes_schema.v_properties_sources OWNER TO postgres;

--
-- TOC entry 6728 (class 1259 OID 354195)
-- Name: v_properties_sources_single; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_properties_sources_single AS
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
   FROM (nobel_prizes_schema.v_properties_ns v
     LEFT JOIN nobel_prizes_schema.v_classes_ns c ON ((v.domain_class_id = c.id)));


ALTER TABLE nobel_prizes_schema.v_properties_sources_single OWNER TO postgres;

--
-- TOC entry 6729 (class 1259 OID 354200)
-- Name: v_properties_targets; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_properties_targets AS
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
   FROM (nobel_prizes_schema.v_properties_ns v
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
           FROM nobel_prizes_schema.cp_rels r,
            nobel_prizes_schema.v_classes_ns c_1
          WHERE ((r.class_id = c_1.id) AND (r.type_id = 1))) c ON (((v.id = c.property_id) AND (c.cover_set_index > 0) AND (v.target_cover_complete = true))));


ALTER TABLE nobel_prizes_schema.v_properties_targets OWNER TO postgres;

--
-- TOC entry 6730 (class 1259 OID 354205)
-- Name: v_properties_targets_single; Type: VIEW; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE VIEW nobel_prizes_schema.v_properties_targets_single AS
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
   FROM (nobel_prizes_schema.v_properties_ns v
     LEFT JOIN nobel_prizes_schema.v_classes_ns c ON ((v.range_class_id = c.id)));


ALTER TABLE nobel_prizes_schema.v_properties_targets_single OWNER TO postgres;

--
-- TOC entry 20916 (class 0 OID 353982)
-- Dependencies: 6675
-- Data for Name: _h_classes; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema._h_classes (a, b) FROM stdin;
\.


--
-- TOC entry 20917 (class 0 OID 353985)
-- Dependencies: 6676
-- Data for Name: annot_types; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.annot_types (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2000/01/rdf-schema#label	2	label
2	http://www.w3.org/2000/01/rdf-schema#comment	2	comment
3	http://www.w3.org/2004/02/skos/core#prefLabel	4	prefLabel
4	http://www.w3.org/2004/02/skos/core#altLabel	4	altLabel
5	http://purl.org/dc/terms/description	5	description
\.


--
-- TOC entry 20922 (class 0 OID 354034)
-- Dependencies: 6682
-- Data for Name: cc_rel_types; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.cc_rel_types (id, name) FROM stdin;
1	sub_class_of
2	equivalent_class
3	intersecting_class
\.


--
-- TOC entry 20924 (class 0 OID 354040)
-- Dependencies: 6684
-- Data for Name: cc_rels; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.cc_rels (id, class_1_id, class_2_id, type_id, cnt, data) FROM stdin;
1	2	8	1	\N	\N
2	2	8	3	\N	\N
3	3	9	3	\N	\N
4	3	4	3	\N	\N
5	4	3	1	\N	\N
6	4	3	3	\N	\N
7	6	22	1	\N	\N
8	6	22	3	\N	\N
9	8	12	3	\N	\N
10	8	19	3	\N	\N
11	8	2	3	\N	\N
12	9	3	1	\N	\N
13	9	3	3	\N	\N
14	10	14	3	\N	\N
15	10	15	3	\N	\N
16	12	8	1	\N	\N
17	12	8	3	\N	\N
18	13	17	3	\N	\N
19	13	20	3	\N	\N
20	14	10	1	\N	\N
21	14	10	3	\N	\N
22	15	10	1	\N	\N
23	15	10	3	\N	\N
24	17	13	1	\N	\N
25	17	13	3	\N	\N
26	19	8	1	\N	\N
27	19	8	3	\N	\N
28	20	13	1	\N	\N
29	20	13	3	\N	\N
30	22	6	3	\N	\N
\.


--
-- TOC entry 20926 (class 0 OID 354046)
-- Dependencies: 6686
-- Data for Name: class_annots; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.class_annots (id, class_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- TOC entry 20919 (class 0 OID 353991)
-- Dependencies: 6678
-- Data for Name: classes; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.classes (id, iri, cnt, data, props_in_schema, ns_id, local_name, display_name, classification_property_id, classification_property, classification_adornment, is_literal, datatype_id, instance_name_pattern, indirect_members, is_unique, large_superclass_id, hide_in_main, principal_super_class_id, self_cp_rels, cp_ask_endpoint, in_cnt) FROM stdin;
1	http://schema.vq.app/Annotation	5	\N	t	69	Annotation	Annotation	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
2	http://schema.vq.app/CommonSubject	54	\N	t	69	CommonSubject	CommonSubject	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
3	http://schema.vq.app/Classifier	30	\N	t	69	Classifier	Classifier	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	514
4	http://schema.vq.app/LiteralClassifier	2	\N	t	69	LiteralClassifier	LiteralClassifier	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	6
5	http://schema.vq.app/ClassProperty_Datatype	53	\N	t	69	ClassProperty_Datatype	ClassProperty_Datatype	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
6	http://schema.vq.app/Path	52	\N	t	69	Path	Path	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1849
7	http://schema.vq.app/Property_Datatype	24	\N	t	69	Property_Datatype	Property_Datatype	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
8	http://schema.vq.app/PropertyPropertyRel	826	\N	t	69	PropertyPropertyRel	PropertyPropertyRel	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
9	http://schema.vq.app/ResourceClassifier	28	\N	t	69	ResourceClassifier	ResourceClassifier	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	508
10	http://schema.vq.app/ClassPropertyPair	143	\N	t	69	ClassPropertyPair	ClassPropertyPair	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	159
11	http://schema.vq.app/Datatype	5	\N	t	69	Datatype	Datatype	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	79
12	http://schema.vq.app/PPFollows	106	\N	t	69	PPFollows	PPFollows	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
13	http://schema.vq.app/ClassClassRel	54	\N	t	69	ClassClassRel	ClassClassRel	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
14	http://schema.vq.app/ClassToProperty	117	\N	t	69	ClassToProperty	ClassToProperty	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	106
15	http://schema.vq.app/PropertyToClass	26	\N	t	69	PropertyToClass	PropertyToClass	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	53
16	http://schema.vq.app/Namespace	45	\N	t	69	Namespace	Namespace	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	90
17	http://schema.vq.app/SubClass	18	\N	t	69	SubClass	SubClass	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
18	http://schema.vq.app/ClassProperty_Class_Rel	106	\N	t	69	ClassProperty_Class_Rel	ClassProperty_Class_Rel	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
19	http://schema.vq.app/CommonObject	666	\N	t	69	CommonObject	CommonObject	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
20	http://schema.vq.app/IntersectingClasses	36	\N	t	69	IntersectingClasses	IntersectingClasses	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
21	http://schema.vq.app/Parameters	20	\N	t	69	Parameters	Parameters	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	\N
22	http://schema.vq.app/Property	52	\N	t	69	Property	Property	23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	\N	f	\N	\N	f	f	\N	f	\N	t	f	1849
\.


--
-- TOC entry 20929 (class 0 OID 354054)
-- Dependencies: 6689
-- Data for Name: cp_rel_types; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.cp_rel_types (id, name) FROM stdin;
1	incoming
2	outgoing
3	type_constraint
4	value_type_constraint
\.


--
-- TOC entry 20920 (class 0 OID 354003)
-- Dependencies: 6679
-- Data for Name: cp_rels; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.cp_rels (id, class_id, property_id, type_id, cnt, data, object_cnt, max_cardinality, min_cardinality, cover_set_index, add_link_slots, details_level, sub_cover_complete, data_cnt, principal_class_id, cnt_base) FROM stdin;
1	6	1	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
2	3	1	2	30	\N	0	1	1	2	1	2	t	30	\N	\N
3	22	1	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
4	9	1	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
5	4	1	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
6	3	2	2	30	\N	0	1	1	1	1	2	t	30	\N	\N
7	9	2	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
8	4	2	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
9	3	3	2	30	\N	0	1	1	1	1	2	t	30	\N	\N
10	9	3	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
11	4	3	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
12	16	4	2	45	\N	0	1	1	1	1	2	t	45	\N	\N
13	13	5	2	54	\N	54	1	1	1	1	2	t	0	3	\N
14	20	5	2	36	\N	36	1	1	0	1	2	t	0	3	\N
15	17	5	2	18	\N	18	1	1	0	1	2	t	0	3	\N
16	3	5	1	54	\N	54	-1	0	1	1	2	t	\N	13	\N
17	9	5	1	48	\N	48	-1	0	0	1	2	t	\N	13	\N
18	4	5	1	6	\N	6	-1	1	0	1	2	t	\N	13	\N
19	21	6	2	7	\N	0	1	0	1	1	2	t	7	\N	\N
20	3	7	2	36	\N	36	-1	0	1	1	2	t	0	9	\N
21	9	7	2	32	\N	32	-1	0	0	1	2	t	0	9	\N
22	4	7	2	4	\N	4	-1	1	0	1	2	t	0	9	\N
23	9	7	1	36	\N	36	-1	0	1	1	2	t	\N	3	\N
24	3	7	1	36	\N	36	-1	0	0	1	2	t	\N	3	\N
25	10	8	2	143	\N	0	1	1	1	1	2	t	143	\N	\N
26	14	8	2	117	\N	0	1	1	0	1	2	t	117	\N	\N
27	15	8	2	26	\N	0	1	1	0	1	2	t	26	\N	\N
28	8	9	2	826	\N	0	1	1	1	1	2	t	826	\N	\N
29	19	9	2	666	\N	0	1	1	0	1	2	t	666	\N	\N
30	12	9	2	106	\N	0	1	1	0	1	2	t	106	\N	\N
31	2	9	2	54	\N	0	1	1	0	1	2	t	54	\N	\N
32	6	10	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
33	3	10	2	30	\N	0	1	1	2	1	2	t	30	\N	\N
34	1	10	2	5	\N	0	1	1	3	1	2	t	5	\N	\N
35	11	10	2	5	\N	0	1	1	4	1	2	t	5	\N	\N
36	22	10	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
37	9	10	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
38	4	10	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
39	13	11	2	54	\N	54	1	1	1	1	2	t	0	9	\N
40	20	11	2	36	\N	36	1	1	0	1	2	t	0	9	\N
41	17	11	2	18	\N	18	1	1	0	1	2	t	0	9	\N
42	9	11	1	54	\N	54	-1	0	1	1	2	t	\N	13	\N
43	3	11	1	54	\N	54	-1	0	0	1	2	t	\N	13	\N
44	6	12	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
45	22	12	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
46	5	13	2	53	\N	53	1	1	1	1	2	t	0	11	\N
47	7	13	2	24	\N	24	1	1	2	1	2	t	0	11	\N
48	4	13	2	2	\N	2	1	1	3	1	2	t	0	11	\N
49	3	13	2	2	\N	2	1	0	0	1	2	t	0	11	\N
50	11	13	1	79	\N	79	-1	1	1	1	2	t	\N	\N	\N
51	18	14	2	106	\N	106	1	1	1	1	2	t	0	10	\N
52	5	14	2	53	\N	53	1	1	2	1	2	t	0	14	\N
53	10	14	1	159	\N	159	-1	0	1	1	2	t	\N	\N	\N
54	14	14	1	106	\N	106	-1	0	0	1	2	t	\N	\N	\N
55	15	14	1	53	\N	53	-1	1	0	1	2	t	\N	18	\N
56	3	15	2	30	\N	0	1	1	1	1	2	t	30	\N	\N
57	9	15	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
58	4	15	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
59	3	16	2	30	\N	0	1	1	1	1	2	t	30	\N	\N
60	9	16	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
61	4	16	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
62	16	17	2	45	\N	0	1	1	1	1	2	t	45	\N	\N
63	6	18	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
64	22	18	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
65	10	19	2	143	\N	0	1	1	1	1	2	t	143	\N	\N
66	14	19	2	117	\N	0	1	1	0	1	2	t	117	\N	\N
67	15	19	2	26	\N	0	1	1	0	1	2	t	26	\N	\N
68	6	20	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
69	22	20	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
70	21	21	2	20	\N	0	1	1	1	1	2	t	20	\N	\N
71	10	22	2	143	\N	143	1	1	1	1	2	t	0	6	\N
72	7	22	2	24	\N	24	1	1	2	1	2	t	0	6	\N
73	14	22	2	117	\N	117	1	1	0	1	2	t	0	22	\N
74	15	22	2	26	\N	26	1	1	0	1	2	t	0	22	\N
75	6	22	1	167	\N	167	-1	1	1	1	2	t	\N	\N	\N
76	22	22	1	167	\N	167	-1	1	0	1	2	t	\N	\N	\N
77	8	23	2	1652	\N	1652	-1	1	1	1	2	f	0	\N	\N
78	10	23	2	286	\N	286	-1	1	2	1	2	f	0	\N	\N
79	13	23	2	108	\N	108	-1	1	3	1	2	f	0	\N	\N
80	18	23	2	106	\N	106	1	1	4	1	2	f	0	\N	\N
81	6	23	2	104	\N	104	-1	1	5	1	2	f	0	\N	\N
82	3	23	2	60	\N	60	-1	1	6	1	2	f	0	\N	\N
83	5	23	2	53	\N	53	1	1	7	1	2	f	0	\N	\N
84	16	23	2	45	\N	45	1	1	8	1	2	f	0	\N	\N
85	7	23	2	24	\N	24	1	1	9	1	2	f	0	\N	\N
86	21	23	2	20	\N	20	1	1	10	1	2	f	0	\N	\N
87	1	23	2	5	\N	5	1	1	11	1	2	f	0	\N	\N
88	11	23	2	5	\N	5	1	1	12	1	2	f	0	\N	\N
89	19	23	2	1332	\N	1332	-1	1	0	1	2	f	0	\N	\N
90	14	23	2	234	\N	234	-1	1	0	1	2	f	0	\N	\N
91	12	23	2	212	\N	212	-1	1	0	1	2	f	0	\N	\N
92	2	23	2	108	\N	108	-1	1	0	1	2	f	0	\N	\N
93	22	23	2	104	\N	104	-1	1	0	1	2	f	0	\N	\N
94	20	23	2	72	\N	72	-1	1	0	1	2	f	0	\N	\N
95	9	23	2	56	\N	56	-1	1	0	1	2	f	0	\N	\N
96	15	23	2	52	\N	52	-1	1	0	1	2	f	0	\N	\N
97	17	23	2	36	\N	36	-1	1	0	1	2	f	0	\N	\N
98	4	23	2	4	\N	4	-1	1	0	1	2	f	0	\N	\N
99	6	24	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
100	22	24	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
101	6	25	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
102	22	25	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
103	8	26	2	826	\N	826	1	1	1	1	2	t	0	6	\N
104	19	26	2	666	\N	666	1	1	0	1	2	t	0	22	\N
105	12	26	2	106	\N	106	1	1	0	1	2	t	0	6	\N
106	2	26	2	54	\N	54	1	1	0	1	2	t	0	22	\N
107	6	26	1	826	\N	826	-1	1	1	1	2	t	\N	8	\N
108	22	26	1	826	\N	826	-1	1	0	1	2	t	\N	8	\N
109	8	27	2	826	\N	826	1	1	1	1	2	t	0	6	\N
110	19	27	2	666	\N	666	1	1	0	1	2	t	0	22	\N
111	12	27	2	106	\N	106	1	1	0	1	2	t	0	6	\N
112	2	27	2	54	\N	54	1	1	0	1	2	t	0	22	\N
113	6	27	1	826	\N	826	-1	1	1	1	2	t	\N	8	\N
114	22	27	1	826	\N	826	-1	1	0	1	2	t	\N	8	\N
115	6	28	2	12	\N	12	1	0	1	1	2	t	0	9	\N
116	22	28	2	12	\N	12	1	0	0	1	2	t	0	9	\N
117	9	28	1	12	\N	12	-1	0	1	1	2	t	\N	22	\N
118	3	28	1	12	\N	12	-1	0	0	1	2	t	\N	22	\N
119	3	29	2	30	\N	0	1	1	1	1	2	t	30	\N	\N
120	9	29	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
121	4	29	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
122	21	30	2	20	\N	0	1	1	1	1	2	t	20	\N	\N
123	3	31	2	18	\N	18	1	0	1	1	2	t	0	9	\N
124	9	31	2	16	\N	16	1	0	0	1	2	t	0	9	\N
125	4	31	2	2	\N	2	1	1	0	1	2	t	0	9	\N
126	9	31	1	18	\N	18	-1	0	1	1	2	t	\N	3	\N
127	3	31	1	18	\N	18	-1	0	0	1	2	t	\N	3	\N
128	6	32	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
129	22	32	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
130	13	33	2	54	\N	0	1	1	1	1	2	t	54	\N	\N
131	20	33	2	36	\N	0	1	1	0	1	2	t	36	\N	\N
132	17	33	2	18	\N	0	1	1	0	1	2	t	18	\N	\N
133	6	34	2	52	\N	52	1	1	1	1	2	f	\N	\N	\N
134	16	34	2	45	\N	\N	1	1	2	1	2	t	45	\N	\N
135	9	34	2	28	\N	28	1	1	3	1	2	f	\N	\N	\N
136	1	34	2	5	\N	5	1	1	4	1	2	f	\N	\N	\N
137	11	34	2	5	\N	5	1	1	5	1	2	f	\N	\N	\N
138	22	34	2	52	\N	52	1	1	0	1	2	f	\N	\N	\N
139	3	34	2	28	\N	28	1	0	0	1	2	f	\N	\N	\N
140	10	35	2	143	\N	143	1	1	1	1	2	t	0	9	\N
141	14	35	2	117	\N	117	1	1	0	1	2	t	0	9	\N
142	15	35	2	26	\N	26	1	1	0	1	2	t	0	9	\N
143	9	35	1	143	\N	143	-1	0	1	1	2	t	\N	10	\N
144	3	35	1	143	\N	143	-1	0	0	1	2	t	\N	10	\N
145	10	36	2	143	\N	0	1	1	1	1	2	t	143	\N	\N
146	14	36	2	117	\N	0	1	1	0	1	2	t	117	\N	\N
147	15	36	2	26	\N	0	1	1	0	1	2	t	26	\N	\N
148	8	37	2	826	\N	0	1	1	1	1	2	t	826	\N	\N
149	10	37	2	143	\N	0	1	1	2	1	2	t	143	\N	\N
150	18	37	2	106	\N	0	1	1	3	1	2	t	106	\N	\N
151	5	37	2	53	\N	0	1	1	4	1	2	t	53	\N	\N
152	6	37	2	52	\N	0	1	1	5	1	2	t	52	\N	\N
153	7	37	2	24	\N	0	1	1	6	1	2	t	24	\N	\N
154	19	37	2	666	\N	0	1	1	0	1	2	t	666	\N	\N
155	14	37	2	117	\N	0	1	1	0	1	2	t	117	\N	\N
156	12	37	2	106	\N	0	1	1	0	1	2	t	106	\N	\N
157	2	37	2	54	\N	0	1	1	0	1	2	t	54	\N	\N
158	22	37	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
159	15	37	2	26	\N	0	1	1	0	1	2	t	26	\N	\N
160	10	38	2	143	\N	0	1	1	1	1	2	t	143	\N	\N
161	18	38	2	106	\N	0	1	1	2	1	2	t	106	\N	\N
162	14	38	2	117	\N	0	1	1	0	1	2	t	117	\N	\N
163	15	38	2	26	\N	0	1	1	0	1	2	t	26	\N	\N
164	21	39	2	19	\N	0	1	0	1	1	2	t	19	\N	\N
165	6	40	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
166	22	40	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
167	3	41	2	30	\N	30	1	1	1	1	2	t	0	22	\N
168	9	41	2	28	\N	28	1	1	0	1	2	t	0	22	\N
169	4	41	2	2	\N	2	1	1	0	1	2	t	0	6	\N
170	6	41	1	30	\N	30	-1	0	1	1	2	t	\N	3	\N
171	22	41	1	30	\N	30	-1	0	0	1	2	t	\N	3	\N
172	18	42	2	106	\N	106	1	1	1	1	2	t	0	9	\N
173	9	42	1	106	\N	106	-1	0	1	1	2	t	\N	18	\N
174	3	42	1	106	\N	106	-1	0	0	1	2	t	\N	18	\N
175	10	43	2	143	\N	0	1	1	1	1	2	t	143	\N	\N
176	14	43	2	117	\N	0	1	1	0	1	2	t	117	\N	\N
177	15	43	2	26	\N	0	1	1	0	1	2	t	26	\N	\N
178	4	44	2	2	\N	0	1	1	1	1	2	t	2	\N	\N
179	3	44	2	2	\N	0	1	0	0	1	2	t	2	\N	\N
180	6	45	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
181	22	45	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
182	6	46	2	52	\N	52	1	1	1	1	2	t	0	16	\N
183	9	46	2	28	\N	28	1	1	2	1	2	t	0	16	\N
184	1	46	2	5	\N	5	1	1	3	1	2	t	0	16	\N
185	11	46	2	5	\N	5	1	1	4	1	2	t	0	16	\N
186	22	46	2	52	\N	52	1	1	0	1	2	t	0	16	\N
187	3	46	2	28	\N	28	1	0	0	1	2	t	0	16	\N
188	16	46	1	90	\N	90	-1	0	1	1	2	t	\N	\N	\N
189	6	47	2	45	\N	45	1	0	1	1	2	t	0	9	\N
190	22	47	2	45	\N	45	1	0	0	1	2	t	0	9	\N
191	9	47	1	45	\N	45	-1	0	1	1	2	t	\N	22	\N
192	3	47	1	45	\N	45	-1	0	0	1	2	t	\N	22	\N
193	21	48	2	3	\N	0	1	0	1	1	2	t	3	\N	\N
194	6	49	2	52	\N	0	1	1	1	1	2	t	52	\N	\N
195	22	49	2	52	\N	0	1	1	0	1	2	t	52	\N	\N
196	3	50	2	30	\N	0	1	1	1	1	2	t	30	\N	\N
197	9	50	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
198	4	50	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
199	3	51	2	14	\N	0	1	0	1	1	2	t	14	\N	\N
200	9	51	2	12	\N	0	1	0	0	1	2	t	12	\N	\N
201	4	51	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
202	6	52	2	30	\N	0	1	0	1	1	2	t	30	\N	\N
203	22	52	2	30	\N	0	1	0	0	1	2	t	30	\N	\N
204	3	53	2	30	\N	0	1	1	1	1	2	t	30	\N	\N
205	9	53	2	28	\N	0	1	1	0	1	2	t	28	\N	\N
206	4	53	2	2	\N	0	1	1	0	1	2	t	2	\N	\N
207	10	54	2	46	\N	46	1	0	1	1	2	t	0	9	\N
208	15	54	2	25	\N	25	1	0	0	1	2	t	0	9	\N
209	14	54	2	21	\N	21	1	0	0	1	2	t	0	9	\N
210	9	54	1	46	\N	46	-1	0	1	1	2	t	\N	10	\N
211	3	54	1	46	\N	46	-1	0	0	1	2	t	\N	10	\N
\.


--
-- TOC entry 20932 (class 0 OID 354061)
-- Dependencies: 6692
-- Data for Name: cpc_rels; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.cpc_rels (id, cp_rel_id, other_class_id, cnt, data, cover_set_index, cnt_base) FROM stdin;
1	13	9	48	\N	0	\N
2	13	3	54	\N	1	\N
3	13	4	6	\N	0	\N
4	14	9	32	\N	0	\N
5	14	4	4	\N	0	\N
6	14	3	36	\N	1	\N
7	15	3	18	\N	1	\N
8	15	4	2	\N	0	\N
9	15	9	16	\N	0	\N
10	16	13	54	\N	1	\N
11	16	17	18	\N	0	\N
12	16	20	36	\N	0	\N
13	17	13	48	\N	1	\N
14	17	20	32	\N	0	\N
15	17	17	16	\N	0	\N
16	18	17	2	\N	0	\N
17	18	20	4	\N	0	\N
18	18	13	6	\N	1	\N
19	20	3	36	\N	0	\N
20	20	9	36	\N	1	\N
21	21	3	32	\N	0	\N
22	21	9	32	\N	1	\N
23	22	3	4	\N	0	\N
24	22	9	4	\N	1	\N
25	23	3	36	\N	1	\N
26	23	4	4	\N	0	\N
27	23	9	32	\N	0	\N
28	24	9	32	\N	0	\N
29	24	3	36	\N	1	\N
30	24	4	4	\N	0	\N
31	39	9	54	\N	1	\N
32	39	3	54	\N	0	\N
33	40	9	36	\N	1	\N
34	40	3	36	\N	0	\N
35	41	3	18	\N	0	\N
36	41	9	18	\N	1	\N
37	42	13	54	\N	1	\N
38	42	20	36	\N	0	\N
39	42	17	18	\N	0	\N
40	43	13	54	\N	1	\N
41	43	17	18	\N	0	\N
42	43	20	36	\N	0	\N
43	46	11	53	\N	1	\N
44	47	11	24	\N	1	\N
45	48	11	2	\N	1	\N
46	49	11	2	\N	1	\N
47	50	7	24	\N	2	\N
48	50	3	2	\N	0	\N
49	50	4	2	\N	3	\N
50	50	5	53	\N	1	\N
51	51	10	106	\N	1	\N
52	51	14	53	\N	0	\N
53	51	15	53	\N	0	\N
54	52	14	53	\N	1	\N
55	52	10	53	\N	0	\N
56	53	18	106	\N	1	\N
57	53	5	53	\N	2	\N
58	54	18	53	\N	2	\N
59	54	5	53	\N	1	\N
60	55	18	53	\N	1	\N
61	71	6	143	\N	1	\N
62	71	22	143	\N	0	\N
63	72	6	24	\N	1	\N
64	72	22	24	\N	0	\N
65	73	22	117	\N	1	\N
66	73	6	117	\N	0	\N
67	74	22	26	\N	1	\N
68	74	6	26	\N	0	\N
69	75	7	24	\N	2	\N
70	75	10	143	\N	1	\N
71	75	15	26	\N	0	\N
72	75	14	117	\N	0	\N
73	76	14	117	\N	0	\N
74	76	15	26	\N	0	\N
75	76	7	24	\N	2	\N
76	76	10	143	\N	1	\N
77	103	6	826	\N	1	\N
78	103	22	826	\N	0	\N
79	104	22	666	\N	1	\N
80	104	6	666	\N	0	\N
81	105	6	106	\N	1	\N
82	105	22	106	\N	0	\N
83	106	22	54	\N	1	\N
84	106	6	54	\N	0	\N
85	107	8	826	\N	1	\N
86	107	19	666	\N	0	\N
87	107	12	106	\N	0	\N
88	107	2	54	\N	0	\N
89	108	19	666	\N	0	\N
90	108	2	54	\N	0	\N
91	108	8	826	\N	1	\N
92	108	12	106	\N	0	\N
93	109	6	826	\N	1	\N
94	109	22	826	\N	0	\N
95	110	22	666	\N	1	\N
96	110	6	666	\N	0	\N
97	111	6	106	\N	1	\N
98	111	22	106	\N	0	\N
99	112	22	54	\N	1	\N
100	112	6	54	\N	0	\N
101	113	8	826	\N	1	\N
102	113	19	666	\N	0	\N
103	113	12	106	\N	0	\N
104	113	2	54	\N	0	\N
105	114	19	666	\N	0	\N
106	114	2	54	\N	0	\N
107	114	8	826	\N	1	\N
108	114	12	106	\N	0	\N
109	115	9	12	\N	1	\N
110	115	3	12	\N	0	\N
111	116	3	12	\N	0	\N
112	116	9	12	\N	1	\N
113	117	22	12	\N	1	\N
114	117	6	12	\N	0	\N
115	118	22	12	\N	1	\N
116	118	6	12	\N	0	\N
117	123	3	18	\N	0	\N
118	123	9	18	\N	1	\N
119	124	3	16	\N	0	\N
120	124	9	16	\N	1	\N
121	125	3	2	\N	0	\N
122	125	9	2	\N	1	\N
123	126	3	18	\N	1	\N
124	126	4	2	\N	0	\N
125	126	9	16	\N	0	\N
126	127	9	16	\N	0	\N
127	127	3	18	\N	1	\N
128	127	4	2	\N	0	\N
129	140	3	143	\N	0	\N
130	140	9	143	\N	1	\N
131	141	9	117	\N	1	\N
132	141	3	117	\N	0	\N
133	142	3	26	\N	0	\N
134	142	9	26	\N	1	\N
135	143	14	117	\N	0	\N
136	143	15	26	\N	0	\N
137	143	10	143	\N	1	\N
138	144	10	143	\N	1	\N
139	144	15	26	\N	0	\N
140	144	14	117	\N	0	\N
141	167	22	30	\N	1	\N
142	167	6	30	\N	0	\N
143	168	22	28	\N	1	\N
144	168	6	28	\N	0	\N
145	169	6	2	\N	1	\N
146	169	22	2	\N	0	\N
147	170	9	28	\N	0	\N
148	170	4	2	\N	0	\N
149	170	3	30	\N	1	\N
150	171	9	28	\N	0	\N
151	171	3	30	\N	1	\N
152	171	4	2	\N	0	\N
153	172	3	106	\N	0	\N
154	172	9	106	\N	1	\N
155	173	18	106	\N	1	\N
156	174	18	106	\N	1	\N
157	182	16	52	\N	1	\N
158	183	16	28	\N	1	\N
159	184	16	5	\N	1	\N
160	185	16	5	\N	1	\N
161	186	16	52	\N	1	\N
162	187	16	28	\N	1	\N
163	188	1	5	\N	3	\N
164	188	3	28	\N	0	\N
165	188	22	52	\N	1	\N
166	188	11	5	\N	4	\N
167	188	6	52	\N	0	\N
168	188	9	28	\N	2	\N
169	189	9	45	\N	1	\N
170	189	3	45	\N	0	\N
171	190	3	45	\N	0	\N
172	190	9	45	\N	1	\N
173	191	22	45	\N	1	\N
174	191	6	45	\N	0	\N
175	192	22	45	\N	1	\N
176	192	6	45	\N	0	\N
177	207	3	46	\N	0	\N
178	207	9	46	\N	1	\N
179	208	3	25	\N	0	\N
180	208	9	25	\N	1	\N
181	209	9	21	\N	1	\N
182	209	3	21	\N	0	\N
183	210	14	21	\N	0	\N
184	210	15	25	\N	0	\N
185	210	10	46	\N	1	\N
186	211	10	46	\N	1	\N
187	211	15	25	\N	0	\N
188	211	14	21	\N	0	\N
\.


--
-- TOC entry 20934 (class 0 OID 354067)
-- Dependencies: 6694
-- Data for Name: cpd_rels; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.cpd_rels (id, cp_rel_id, datatype_id, cnt, data, cnt_base) FROM stdin;
1	1	1	52	\N	\N
2	2	1	30	\N	\N
3	3	1	52	\N	\N
4	4	1	28	\N	\N
5	5	1	2	\N	\N
6	6	2	30	\N	\N
7	7	2	28	\N	\N
8	8	2	2	\N	\N
9	9	3	30	\N	\N
10	10	3	28	\N	\N
11	11	3	2	\N	\N
12	12	1	45	\N	\N
13	19	1	7	\N	\N
14	25	3	143	\N	\N
15	26	3	117	\N	\N
16	27	3	26	\N	\N
17	28	3	826	\N	\N
18	29	3	666	\N	\N
19	30	3	106	\N	\N
20	31	3	54	\N	\N
21	32	1	52	\N	\N
22	33	1	30	\N	\N
23	34	1	5	\N	\N
24	35	1	5	\N	\N
25	36	1	52	\N	\N
26	37	1	28	\N	\N
27	38	1	2	\N	\N
28	44	2	52	\N	\N
29	45	2	52	\N	\N
30	56	2	30	\N	\N
31	57	2	28	\N	\N
32	58	2	2	\N	\N
33	59	1	30	\N	\N
34	60	1	28	\N	\N
35	61	1	2	\N	\N
36	62	2	45	\N	\N
37	63	2	52	\N	\N
38	64	2	52	\N	\N
39	65	3	143	\N	\N
40	66	3	117	\N	\N
41	67	3	26	\N	\N
42	68	3	52	\N	\N
43	69	3	52	\N	\N
44	70	3	20	\N	\N
45	99	2	52	\N	\N
46	100	2	52	\N	\N
47	101	2	52	\N	\N
48	102	2	52	\N	\N
49	119	2	30	\N	\N
50	120	2	28	\N	\N
51	121	2	2	\N	\N
52	122	1	20	\N	\N
53	128	2	52	\N	\N
54	129	2	52	\N	\N
55	130	3	54	\N	\N
56	131	3	36	\N	\N
57	132	3	18	\N	\N
58	134	1	45	\N	\N
59	145	3	143	\N	\N
60	146	3	117	\N	\N
61	147	3	26	\N	\N
62	148	3	826	\N	\N
63	149	3	143	\N	\N
64	150	3	106	\N	\N
65	151	3	53	\N	\N
66	152	3	52	\N	\N
67	153	3	24	\N	\N
68	154	3	666	\N	\N
69	155	3	117	\N	\N
70	156	3	106	\N	\N
71	157	3	54	\N	\N
72	158	3	52	\N	\N
73	159	3	26	\N	\N
74	160	3	143	\N	\N
75	161	3	106	\N	\N
76	162	3	117	\N	\N
77	163	3	26	\N	\N
78	164	1	19	\N	\N
79	165	2	52	\N	\N
80	166	2	52	\N	\N
81	175	3	143	\N	\N
82	176	3	117	\N	\N
83	177	3	26	\N	\N
84	178	1	2	\N	\N
85	179	1	2	\N	\N
86	180	2	52	\N	\N
87	181	2	52	\N	\N
88	193	1	3	\N	\N
89	194	3	52	\N	\N
90	195	3	52	\N	\N
91	196	2	30	\N	\N
92	197	2	28	\N	\N
93	198	2	2	\N	\N
94	199	1	14	\N	\N
95	200	1	12	\N	\N
96	201	1	2	\N	\N
97	202	3	30	\N	\N
98	203	3	30	\N	\N
99	204	2	30	\N	\N
100	205	2	28	\N	\N
101	206	2	2	\N	\N
\.


--
-- TOC entry 20936 (class 0 OID 354073)
-- Dependencies: 6696
-- Data for Name: datatypes; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.datatypes (id, iri, ns_id, local_name) FROM stdin;
1	http://www.w3.org/2001/XMLSchema#string	3	string
2	http://www.w3.org/2001/XMLSchema#boolean	3	boolean
3	http://www.w3.org/2001/XMLSchema#integer	3	integer
\.


--
-- TOC entry 20938 (class 0 OID 354079)
-- Dependencies: 6698
-- Data for Name: instances; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.instances (id, iri, ns_id, local_name, local_name_lowercase, class_id, class_iri) FROM stdin;
\.


--
-- TOC entry 20940 (class 0 OID 354086)
-- Dependencies: 6700
-- Data for Name: ns; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.ns (id, name, value, priority, is_local, basic_order_level) FROM stdin;
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
69		http://schema.vq.app/	0	t	0
\.


--
-- TOC entry 20942 (class 0 OID 354095)
-- Dependencies: 6702
-- Data for Name: ns_stats; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.ns_stats (id, ns_id, cnt, type_id, class_id, property_id) FROM stdin;
\.


--
-- TOC entry 20944 (class 0 OID 354099)
-- Dependencies: 6704
-- Data for Name: parameters; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.parameters (order_inx, name, textvalue, jsonvalue, comment, id) FROM stdin;
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
10	display_name_default	nobel_prizes_schema	\N	Recommended display name to be used in schema registry.	20
90	db_schema_name	nobel_prizes_schema	\N	Name of the schema by which it is to be known in the visual query environment (must be unique).	1
30	endpoint_url	http://85.254.199.72:8890/sparql	\N	Default endpoint URL for visual environment projects using this schema (can be overridden in induvidual project settings).	3
40	named_graph	http://nobel_prizes.vq.app	\N	Default named graph for visual environment projects using this schema.	4
200	schema_kind	default	\N	One of: default, dbpedia, wikidata, ... .	13
50	endpoint_type	generic	\N	Type of the endpoint (GENERIC, VIRTUOSO, JENA, BLAZEGRAPH), associated by default with the schema (can be overridden in a project).	12
500	schema_extraction_details	\N	{"graphName": "http://nobel_prizes.vq.app", "endpointUrl": "http://85.254.199.72:8890/sparql", "correlationId": "5792081097554022001", "enableLogging": true, "includedLabels": [{"languages": [], "labelPropertyFullOrPrefix": "rdfs:label"}, {"languages": [], "labelPropertyFullOrPrefix": "skos:prefLabel"}], "includedClasses": [], "calculateDataTypes": "propertyLevelAndClassContext", "excludedNamespaces": [], "includedProperties": [], "addIntersectionClasses": "yes", "calculateCardinalities": "propertyLevelAndClassContext", "exactCountCalculations": "no", "calculateClosedClassSets": true, "minimalAnalyzedClassSize": 1, "calculateDomainsAndRanges": true, "calculateImportanceIndexes": "regular", "calculateSubClassRelations": true, "calculateInstanceNamespaces": "no", "calculateSourceAndTargetPairs": true, "simpleClassificationProperties": [], "principalClassificationProperties": ["http://www.w3.org/1999/02/22-rdf-syntax-ns#type"], "calculatePropertyPropertyRelations": true, "calculateMultipleInheritanceSuperclasses": true, "classificationPropertiesWithConnectionsOnly": [], "sampleLimitForInstanceNamespacesCalculation": 1000}	JSON with parameters used in schema extraction.	17
510	schema_import_datetime	\N	"2024-11-25T10:59:55.769Z"	Date and time when the schema has been imported from extracted JSON data.	18
999	schema_importer_version	2024-10-23	\N	\N	31
240	use_pp_rels	\N	true	Use the property-property relationships from the data schema in the query auto-completion (the property-property relationships must be retrieved from the data and stored in the pp_rels table).	9
\.


--
-- TOC entry 20946 (class 0 OID 354106)
-- Dependencies: 6706
-- Data for Name: pd_rels; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.pd_rels (id, property_id, datatype_id, cnt, data, cnt_base) FROM stdin;
1	1	1	82	\N	\N
2	2	2	30	\N	\N
3	3	3	30	\N	\N
4	4	1	45	\N	\N
5	6	1	7	\N	\N
6	8	3	143	\N	\N
7	9	3	826	\N	\N
8	10	1	92	\N	\N
9	12	2	52	\N	\N
10	15	2	30	\N	\N
11	16	1	30	\N	\N
12	17	2	45	\N	\N
13	18	2	52	\N	\N
14	19	3	143	\N	\N
15	20	3	52	\N	\N
16	21	3	20	\N	\N
17	24	2	52	\N	\N
18	25	2	52	\N	\N
19	29	2	30	\N	\N
20	30	1	20	\N	\N
21	32	2	52	\N	\N
22	33	3	54	\N	\N
23	34	1	45	\N	\N
24	36	3	143	\N	\N
25	37	3	1204	\N	\N
26	38	3	249	\N	\N
27	39	1	19	\N	\N
28	40	2	52	\N	\N
29	43	3	143	\N	\N
30	44	1	2	\N	\N
31	45	2	52	\N	\N
32	48	1	3	\N	\N
33	49	3	52	\N	\N
34	50	2	30	\N	\N
35	51	1	14	\N	\N
36	52	3	30	\N	\N
37	53	2	30	\N	\N
\.


--
-- TOC entry 20948 (class 0 OID 354112)
-- Dependencies: 6708
-- Data for Name: pp_rel_types; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.pp_rel_types (id, name) FROM stdin;
1	followed_by
2	common_subject
3	common_object
4	sub_property_of
\.


--
-- TOC entry 20950 (class 0 OID 354118)
-- Dependencies: 6710
-- Data for Name: pp_rels; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.pp_rels (id, property_1_id, property_2_id, type_id, cnt, data, cnt_base) FROM stdin;
1	1	23	2	164	\N	\N
2	1	1	2	82	\N	\N
3	1	10	2	82	\N	\N
4	1	34	2	80	\N	\N
5	1	46	2	80	\N	\N
6	1	32	2	52	\N	\N
7	1	40	2	52	\N	\N
8	1	20	2	52	\N	\N
9	1	49	2	52	\N	\N
10	1	45	2	52	\N	\N
11	1	24	2	52	\N	\N
12	1	25	2	52	\N	\N
13	1	12	2	52	\N	\N
14	1	18	2	52	\N	\N
15	1	37	2	52	\N	\N
16	1	47	2	45	\N	\N
17	1	7	2	36	\N	\N
18	1	41	2	30	\N	\N
19	1	2	2	30	\N	\N
20	1	15	2	30	\N	\N
21	1	3	2	30	\N	\N
22	1	52	2	30	\N	\N
23	1	50	2	30	\N	\N
24	1	16	2	30	\N	\N
25	1	53	2	30	\N	\N
26	1	29	2	30	\N	\N
27	1	31	2	18	\N	\N
28	1	51	2	14	\N	\N
29	1	28	2	12	\N	\N
30	1	13	2	2	\N	\N
31	1	44	2	2	\N	\N
32	2	23	2	60	\N	\N
33	2	7	2	36	\N	\N
34	2	41	2	30	\N	\N
35	2	2	2	30	\N	\N
36	2	1	2	30	\N	\N
37	2	15	2	30	\N	\N
38	2	3	2	30	\N	\N
39	2	50	2	30	\N	\N
40	2	10	2	30	\N	\N
41	2	16	2	30	\N	\N
42	2	53	2	30	\N	\N
43	2	29	2	30	\N	\N
44	2	34	2	28	\N	\N
45	2	46	2	28	\N	\N
46	2	31	2	18	\N	\N
47	2	51	2	14	\N	\N
48	2	13	2	2	\N	\N
49	2	44	2	2	\N	\N
50	3	23	2	60	\N	\N
51	3	7	2	36	\N	\N
52	3	41	2	30	\N	\N
53	3	2	2	30	\N	\N
54	3	1	2	30	\N	\N
55	3	15	2	30	\N	\N
56	3	3	2	30	\N	\N
57	3	50	2	30	\N	\N
58	3	10	2	30	\N	\N
59	3	16	2	30	\N	\N
60	3	53	2	30	\N	\N
61	3	29	2	30	\N	\N
62	3	34	2	28	\N	\N
63	3	46	2	28	\N	\N
64	3	31	2	18	\N	\N
65	3	51	2	14	\N	\N
66	3	13	2	2	\N	\N
67	3	44	2	2	\N	\N
68	4	34	2	45	\N	\N
69	4	17	2	45	\N	\N
70	4	4	2	45	\N	\N
71	4	23	2	45	\N	\N
72	5	23	1	40	\N	\N
73	5	7	1	36	\N	\N
74	5	41	1	20	\N	\N
75	5	2	1	20	\N	\N
76	5	1	1	20	\N	\N
77	5	15	1	20	\N	\N
78	5	3	1	20	\N	\N
79	5	50	1	20	\N	\N
80	5	10	1	20	\N	\N
81	5	16	1	20	\N	\N
82	5	53	1	20	\N	\N
83	5	29	1	20	\N	\N
84	5	34	1	18	\N	\N
85	5	46	1	18	\N	\N
86	5	31	1	18	\N	\N
87	5	51	1	14	\N	\N
88	5	13	1	2	\N	\N
89	5	44	1	2	\N	\N
90	5	35	3	83	\N	\N
91	5	42	3	74	\N	\N
92	5	5	3	54	\N	\N
93	5	11	3	54	\N	\N
94	5	7	3	36	\N	\N
95	5	54	3	28	\N	\N
96	5	47	3	24	\N	\N
97	5	31	3	18	\N	\N
98	5	28	3	3	\N	\N
99	5	23	2	108	\N	\N
100	5	5	2	54	\N	\N
101	5	33	2	54	\N	\N
102	5	11	2	54	\N	\N
103	6	30	2	7	\N	\N
104	6	21	2	7	\N	\N
105	6	6	2	7	\N	\N
106	6	23	2	7	\N	\N
107	6	39	2	6	\N	\N
108	7	23	1	12	\N	\N
109	7	7	1	8	\N	\N
110	7	34	1	6	\N	\N
111	7	41	1	6	\N	\N
112	7	2	1	6	\N	\N
113	7	1	1	6	\N	\N
114	7	15	1	6	\N	\N
115	7	3	1	6	\N	\N
116	7	50	1	6	\N	\N
117	7	10	1	6	\N	\N
118	7	46	1	6	\N	\N
119	7	16	1	6	\N	\N
120	7	53	1	6	\N	\N
121	7	29	1	6	\N	\N
122	7	31	1	4	\N	\N
123	7	35	3	83	\N	\N
124	7	42	3	74	\N	\N
125	7	11	3	54	\N	\N
126	7	7	3	36	\N	\N
127	7	54	3	28	\N	\N
128	7	47	3	24	\N	\N
129	7	31	3	18	\N	\N
130	7	5	3	12	\N	\N
131	7	28	3	3	\N	\N
132	7	23	2	40	\N	\N
133	7	7	2	36	\N	\N
134	7	41	2	20	\N	\N
135	7	2	2	20	\N	\N
136	7	1	2	20	\N	\N
137	7	15	2	20	\N	\N
138	7	3	2	20	\N	\N
139	7	50	2	20	\N	\N
140	7	10	2	20	\N	\N
141	7	16	2	20	\N	\N
142	7	53	2	20	\N	\N
143	7	29	2	20	\N	\N
144	7	34	2	18	\N	\N
145	7	46	2	18	\N	\N
146	7	31	2	18	\N	\N
147	7	51	2	14	\N	\N
148	7	13	2	2	\N	\N
149	7	44	2	2	\N	\N
150	8	23	2	286	\N	\N
151	8	35	2	143	\N	\N
152	8	43	2	143	\N	\N
153	8	19	2	143	\N	\N
154	8	38	2	143	\N	\N
155	8	8	2	143	\N	\N
156	8	36	2	143	\N	\N
157	8	22	2	143	\N	\N
158	8	37	2	143	\N	\N
159	8	54	2	46	\N	\N
160	9	23	2	1652	\N	\N
161	9	9	2	826	\N	\N
162	9	27	2	826	\N	\N
163	9	26	2	826	\N	\N
164	9	37	2	826	\N	\N
165	10	23	2	174	\N	\N
166	10	10	2	92	\N	\N
167	10	34	2	90	\N	\N
168	10	46	2	90	\N	\N
169	10	1	2	82	\N	\N
170	10	32	2	52	\N	\N
171	10	40	2	52	\N	\N
172	10	20	2	52	\N	\N
173	10	49	2	52	\N	\N
174	10	45	2	52	\N	\N
175	10	24	2	52	\N	\N
176	10	25	2	52	\N	\N
177	10	12	2	52	\N	\N
178	10	18	2	52	\N	\N
179	10	37	2	52	\N	\N
180	10	47	2	45	\N	\N
181	10	7	2	36	\N	\N
182	10	41	2	30	\N	\N
183	10	2	2	30	\N	\N
184	10	15	2	30	\N	\N
185	10	3	2	30	\N	\N
186	10	52	2	30	\N	\N
187	10	50	2	30	\N	\N
188	10	16	2	30	\N	\N
189	10	53	2	30	\N	\N
190	10	29	2	30	\N	\N
191	10	31	2	18	\N	\N
192	10	51	2	14	\N	\N
193	10	28	2	12	\N	\N
194	10	13	2	2	\N	\N
195	10	44	2	2	\N	\N
196	11	23	1	12	\N	\N
197	11	7	1	8	\N	\N
198	11	34	1	6	\N	\N
199	11	41	1	6	\N	\N
200	11	2	1	6	\N	\N
201	11	1	1	6	\N	\N
202	11	15	1	6	\N	\N
203	11	3	1	6	\N	\N
204	11	50	1	6	\N	\N
205	11	10	1	6	\N	\N
206	11	46	1	6	\N	\N
207	11	16	1	6	\N	\N
208	11	53	1	6	\N	\N
209	11	29	1	6	\N	\N
210	11	31	1	4	\N	\N
211	11	35	3	83	\N	\N
212	11	42	3	74	\N	\N
213	11	11	3	54	\N	\N
214	11	7	3	36	\N	\N
215	11	54	3	28	\N	\N
216	11	47	3	24	\N	\N
217	11	31	3	18	\N	\N
218	11	5	3	12	\N	\N
219	11	28	3	3	\N	\N
220	11	23	2	108	\N	\N
221	11	5	2	54	\N	\N
222	11	33	2	54	\N	\N
223	11	11	2	54	\N	\N
224	12	23	2	104	\N	\N
225	12	34	2	52	\N	\N
226	12	32	2	52	\N	\N
227	12	1	2	52	\N	\N
228	12	40	2	52	\N	\N
229	12	10	2	52	\N	\N
230	12	20	2	52	\N	\N
231	12	46	2	52	\N	\N
232	12	49	2	52	\N	\N
233	12	45	2	52	\N	\N
234	12	24	2	52	\N	\N
235	12	25	2	52	\N	\N
236	12	12	2	52	\N	\N
237	12	18	2	52	\N	\N
238	12	37	2	52	\N	\N
239	12	47	2	45	\N	\N
240	12	52	2	30	\N	\N
241	12	28	2	12	\N	\N
242	13	34	1	5	\N	\N
243	13	10	1	5	\N	\N
244	13	46	1	5	\N	\N
245	13	23	1	5	\N	\N
246	13	13	3	79	\N	\N
247	13	23	2	81	\N	\N
248	13	13	2	79	\N	\N
249	13	37	2	77	\N	\N
250	13	14	2	53	\N	\N
251	13	22	2	24	\N	\N
252	13	7	2	4	\N	\N
253	13	41	2	2	\N	\N
254	13	51	2	2	\N	\N
255	13	2	2	2	\N	\N
256	13	1	2	2	\N	\N
257	13	15	2	2	\N	\N
258	13	3	2	2	\N	\N
259	13	50	2	2	\N	\N
260	13	10	2	2	\N	\N
261	13	16	2	2	\N	\N
262	13	53	2	2	\N	\N
263	13	29	2	2	\N	\N
264	13	31	2	2	\N	\N
265	13	44	2	2	\N	\N
266	14	23	1	218	\N	\N
267	14	35	1	109	\N	\N
268	14	43	1	109	\N	\N
269	14	19	1	109	\N	\N
270	14	38	1	109	\N	\N
271	14	8	1	109	\N	\N
272	14	36	1	109	\N	\N
273	14	22	1	109	\N	\N
274	14	37	1	109	\N	\N
275	14	54	1	46	\N	\N
276	14	14	3	159	\N	\N
277	14	14	2	159	\N	\N
278	14	37	2	159	\N	\N
279	14	23	2	159	\N	\N
280	14	38	2	106	\N	\N
281	14	42	2	106	\N	\N
282	14	13	2	53	\N	\N
283	15	23	2	60	\N	\N
284	15	7	2	36	\N	\N
285	15	41	2	30	\N	\N
286	15	2	2	30	\N	\N
287	15	1	2	30	\N	\N
288	15	15	2	30	\N	\N
289	15	3	2	30	\N	\N
290	15	50	2	30	\N	\N
291	15	10	2	30	\N	\N
292	15	16	2	30	\N	\N
293	15	53	2	30	\N	\N
294	15	29	2	30	\N	\N
295	15	34	2	28	\N	\N
296	15	46	2	28	\N	\N
297	15	31	2	18	\N	\N
298	15	51	2	14	\N	\N
299	15	13	2	2	\N	\N
300	15	44	2	2	\N	\N
301	16	23	2	60	\N	\N
302	16	7	2	36	\N	\N
303	16	41	2	30	\N	\N
304	16	2	2	30	\N	\N
305	16	1	2	30	\N	\N
306	16	15	2	30	\N	\N
307	16	3	2	30	\N	\N
308	16	50	2	30	\N	\N
309	16	10	2	30	\N	\N
310	16	16	2	30	\N	\N
311	16	53	2	30	\N	\N
312	16	29	2	30	\N	\N
313	16	34	2	28	\N	\N
314	16	46	2	28	\N	\N
315	16	31	2	18	\N	\N
316	16	51	2	14	\N	\N
317	16	13	2	2	\N	\N
318	16	44	2	2	\N	\N
319	17	34	2	45	\N	\N
320	17	17	2	45	\N	\N
321	17	4	2	45	\N	\N
322	17	23	2	45	\N	\N
323	18	23	2	104	\N	\N
324	18	34	2	52	\N	\N
325	18	32	2	52	\N	\N
326	18	1	2	52	\N	\N
327	18	40	2	52	\N	\N
328	18	10	2	52	\N	\N
329	18	20	2	52	\N	\N
330	18	46	2	52	\N	\N
331	18	49	2	52	\N	\N
332	18	45	2	52	\N	\N
333	18	24	2	52	\N	\N
334	18	25	2	52	\N	\N
335	18	12	2	52	\N	\N
336	18	18	2	52	\N	\N
337	18	37	2	52	\N	\N
338	18	47	2	45	\N	\N
339	18	52	2	30	\N	\N
340	18	28	2	12	\N	\N
341	19	23	2	286	\N	\N
342	19	35	2	143	\N	\N
343	19	43	2	143	\N	\N
344	19	19	2	143	\N	\N
345	19	38	2	143	\N	\N
346	19	8	2	143	\N	\N
347	19	36	2	143	\N	\N
348	19	22	2	143	\N	\N
349	19	37	2	143	\N	\N
350	19	54	2	46	\N	\N
351	20	23	2	104	\N	\N
352	20	34	2	52	\N	\N
353	20	32	2	52	\N	\N
354	20	1	2	52	\N	\N
355	20	40	2	52	\N	\N
356	20	10	2	52	\N	\N
357	20	20	2	52	\N	\N
358	20	46	2	52	\N	\N
359	20	49	2	52	\N	\N
360	20	45	2	52	\N	\N
361	20	24	2	52	\N	\N
362	20	25	2	52	\N	\N
363	20	12	2	52	\N	\N
364	20	18	2	52	\N	\N
365	20	37	2	52	\N	\N
366	20	47	2	45	\N	\N
367	20	52	2	30	\N	\N
368	20	28	2	12	\N	\N
369	21	30	2	20	\N	\N
370	21	21	2	20	\N	\N
371	21	23	2	20	\N	\N
372	21	39	2	19	\N	\N
373	21	6	2	7	\N	\N
374	21	48	2	3	\N	\N
375	22	23	1	104	\N	\N
376	22	34	1	52	\N	\N
377	22	32	1	52	\N	\N
378	22	1	1	52	\N	\N
379	22	40	1	52	\N	\N
380	22	10	1	52	\N	\N
381	22	20	1	52	\N	\N
382	22	46	1	52	\N	\N
383	22	49	1	52	\N	\N
384	22	45	1	52	\N	\N
385	22	24	1	52	\N	\N
386	22	25	1	52	\N	\N
387	22	12	1	52	\N	\N
388	22	18	1	52	\N	\N
389	22	37	1	52	\N	\N
390	22	47	1	45	\N	\N
391	22	52	1	30	\N	\N
392	22	28	1	12	\N	\N
393	22	27	3	826	\N	\N
394	22	26	3	826	\N	\N
395	22	22	3	167	\N	\N
396	22	41	3	30	\N	\N
397	22	23	2	310	\N	\N
398	22	22	2	167	\N	\N
399	22	37	2	167	\N	\N
400	22	35	2	143	\N	\N
401	22	43	2	143	\N	\N
402	22	19	2	143	\N	\N
403	22	38	2	143	\N	\N
404	22	8	2	143	\N	\N
405	22	36	2	143	\N	\N
406	22	54	2	46	\N	\N
407	22	13	2	24	\N	\N
408	23	23	3	2468	\N	\N
409	23	23	2	2468	\N	\N
410	23	37	2	1202	\N	\N
411	23	9	2	824	\N	\N
412	23	27	2	824	\N	\N
413	23	26	2	824	\N	\N
414	23	38	2	249	\N	\N
415	23	22	2	167	\N	\N
416	23	14	2	159	\N	\N
417	23	35	2	143	\N	\N
418	23	19	2	143	\N	\N
419	23	8	2	143	\N	\N
420	23	36	2	143	\N	\N
421	23	43	2	141	\N	\N
422	23	34	2	135	\N	\N
423	23	42	2	106	\N	\N
424	23	10	2	92	\N	\N
425	23	46	2	90	\N	\N
426	23	1	2	82	\N	\N
427	23	13	2	79	\N	\N
428	23	5	2	54	\N	\N
429	23	33	2	54	\N	\N
430	23	32	2	52	\N	\N
431	23	40	2	52	\N	\N
432	23	20	2	52	\N	\N
433	23	49	2	52	\N	\N
434	23	45	2	52	\N	\N
435	23	24	2	52	\N	\N
436	23	25	2	52	\N	\N
437	23	12	2	52	\N	\N
438	23	11	2	52	\N	\N
439	23	18	2	52	\N	\N
440	23	54	2	46	\N	\N
441	23	47	2	45	\N	\N
442	23	17	2	45	\N	\N
443	23	4	2	45	\N	\N
444	23	7	2	36	\N	\N
445	23	41	2	30	\N	\N
446	23	2	2	30	\N	\N
447	23	15	2	30	\N	\N
448	23	3	2	30	\N	\N
449	23	52	2	30	\N	\N
450	23	50	2	30	\N	\N
451	23	16	2	30	\N	\N
452	23	53	2	30	\N	\N
453	23	29	2	30	\N	\N
454	23	30	2	20	\N	\N
455	23	21	2	20	\N	\N
456	23	39	2	19	\N	\N
457	23	31	2	18	\N	\N
458	23	51	2	14	\N	\N
459	23	28	2	12	\N	\N
460	23	6	2	7	\N	\N
461	23	48	2	3	\N	\N
462	23	44	2	2	\N	\N
463	24	23	2	104	\N	\N
464	24	34	2	52	\N	\N
465	24	32	2	52	\N	\N
466	24	1	2	52	\N	\N
467	24	40	2	52	\N	\N
468	24	10	2	52	\N	\N
469	24	20	2	52	\N	\N
470	24	46	2	52	\N	\N
471	24	49	2	52	\N	\N
472	24	45	2	52	\N	\N
473	24	24	2	52	\N	\N
474	24	25	2	52	\N	\N
475	24	12	2	52	\N	\N
476	24	18	2	52	\N	\N
477	24	37	2	52	\N	\N
478	24	47	2	45	\N	\N
479	24	52	2	30	\N	\N
480	24	28	2	12	\N	\N
481	25	23	2	104	\N	\N
482	25	34	2	52	\N	\N
483	25	32	2	52	\N	\N
484	25	1	2	52	\N	\N
485	25	40	2	52	\N	\N
486	25	10	2	52	\N	\N
487	25	20	2	52	\N	\N
488	25	46	2	52	\N	\N
489	25	49	2	52	\N	\N
490	25	45	2	52	\N	\N
491	25	24	2	52	\N	\N
492	25	25	2	52	\N	\N
493	25	12	2	52	\N	\N
494	25	18	2	52	\N	\N
495	25	37	2	52	\N	\N
496	25	47	2	45	\N	\N
497	25	52	2	30	\N	\N
498	25	28	2	12	\N	\N
499	26	23	1	104	\N	\N
500	26	34	1	52	\N	\N
501	26	32	1	52	\N	\N
502	26	1	1	52	\N	\N
503	26	40	1	52	\N	\N
504	26	10	1	52	\N	\N
505	26	20	1	52	\N	\N
506	26	46	1	52	\N	\N
507	26	49	1	52	\N	\N
508	26	45	1	52	\N	\N
509	26	24	1	52	\N	\N
510	26	25	1	52	\N	\N
511	26	12	1	52	\N	\N
512	26	18	1	52	\N	\N
513	26	37	1	52	\N	\N
514	26	47	1	45	\N	\N
515	26	52	1	30	\N	\N
516	26	28	1	12	\N	\N
517	26	27	3	826	\N	\N
518	26	26	3	826	\N	\N
519	26	22	3	167	\N	\N
520	26	41	3	30	\N	\N
521	26	23	2	1652	\N	\N
522	26	9	2	826	\N	\N
523	26	27	2	826	\N	\N
524	26	26	2	826	\N	\N
525	26	37	2	826	\N	\N
526	27	23	1	104	\N	\N
527	27	34	1	52	\N	\N
528	27	32	1	52	\N	\N
529	27	1	1	52	\N	\N
530	27	40	1	52	\N	\N
531	27	10	1	52	\N	\N
532	27	20	1	52	\N	\N
533	27	46	1	52	\N	\N
534	27	49	1	52	\N	\N
535	27	45	1	52	\N	\N
536	27	24	1	52	\N	\N
537	27	25	1	52	\N	\N
538	27	12	1	52	\N	\N
539	27	18	1	52	\N	\N
540	27	37	1	52	\N	\N
541	27	47	1	45	\N	\N
542	27	52	1	30	\N	\N
543	27	28	1	12	\N	\N
544	27	27	3	826	\N	\N
545	27	26	3	826	\N	\N
546	27	22	3	167	\N	\N
547	27	41	3	30	\N	\N
548	27	23	2	1652	\N	\N
549	27	9	2	826	\N	\N
550	27	27	2	826	\N	\N
551	27	26	2	826	\N	\N
552	27	37	2	826	\N	\N
553	28	23	1	20	\N	\N
554	28	34	1	10	\N	\N
555	28	41	1	10	\N	\N
556	28	2	1	10	\N	\N
557	28	1	1	10	\N	\N
558	28	15	1	10	\N	\N
559	28	3	1	10	\N	\N
560	28	50	1	10	\N	\N
561	28	10	1	10	\N	\N
562	28	46	1	10	\N	\N
563	28	16	1	10	\N	\N
564	28	53	1	10	\N	\N
565	28	29	1	10	\N	\N
566	28	7	1	3	\N	\N
567	28	31	1	1	\N	\N
568	28	35	3	84	\N	\N
569	28	42	3	55	\N	\N
570	28	54	3	32	\N	\N
571	28	47	3	25	\N	\N
572	28	11	3	19	\N	\N
573	28	28	3	12	\N	\N
574	28	7	3	11	\N	\N
575	28	31	3	8	\N	\N
576	28	5	3	4	\N	\N
577	28	23	2	24	\N	\N
578	28	34	2	12	\N	\N
579	28	32	2	12	\N	\N
580	28	1	2	12	\N	\N
581	28	52	2	12	\N	\N
582	28	40	2	12	\N	\N
583	28	10	2	12	\N	\N
584	28	20	2	12	\N	\N
585	28	46	2	12	\N	\N
586	28	49	2	12	\N	\N
587	28	45	2	12	\N	\N
588	28	24	2	12	\N	\N
589	28	25	2	12	\N	\N
590	28	28	2	12	\N	\N
591	28	12	2	12	\N	\N
592	28	18	2	12	\N	\N
593	28	37	2	12	\N	\N
594	28	47	2	11	\N	\N
595	29	23	2	60	\N	\N
596	29	7	2	36	\N	\N
597	29	41	2	30	\N	\N
598	29	2	2	30	\N	\N
599	29	1	2	30	\N	\N
600	29	15	2	30	\N	\N
601	29	3	2	30	\N	\N
602	29	50	2	30	\N	\N
603	29	10	2	30	\N	\N
604	29	16	2	30	\N	\N
605	29	53	2	30	\N	\N
606	29	29	2	30	\N	\N
607	29	34	2	28	\N	\N
608	29	46	2	28	\N	\N
609	29	31	2	18	\N	\N
610	29	51	2	14	\N	\N
611	29	13	2	2	\N	\N
612	29	44	2	2	\N	\N
613	30	30	2	20	\N	\N
614	30	21	2	20	\N	\N
615	30	23	2	20	\N	\N
616	30	39	2	19	\N	\N
617	30	6	2	7	\N	\N
618	30	48	2	3	\N	\N
619	31	23	1	10	\N	\N
620	31	7	1	7	\N	\N
621	31	34	1	5	\N	\N
622	31	41	1	5	\N	\N
623	31	2	1	5	\N	\N
624	31	1	1	5	\N	\N
625	31	15	1	5	\N	\N
626	31	3	1	5	\N	\N
627	31	50	1	5	\N	\N
628	31	10	1	5	\N	\N
629	31	46	1	5	\N	\N
630	31	16	1	5	\N	\N
631	31	53	1	5	\N	\N
632	31	29	1	5	\N	\N
633	31	31	1	3	\N	\N
634	31	35	3	73	\N	\N
635	31	42	3	65	\N	\N
636	31	11	3	53	\N	\N
637	31	7	3	35	\N	\N
638	31	54	3	26	\N	\N
639	31	47	3	21	\N	\N
640	31	31	3	18	\N	\N
641	31	5	3	10	\N	\N
642	31	28	3	3	\N	\N
643	31	23	2	36	\N	\N
644	31	7	2	32	\N	\N
645	31	41	2	18	\N	\N
646	31	2	2	18	\N	\N
647	31	1	2	18	\N	\N
648	31	15	2	18	\N	\N
649	31	3	2	18	\N	\N
650	31	50	2	18	\N	\N
651	31	10	2	18	\N	\N
652	31	16	2	18	\N	\N
653	31	53	2	18	\N	\N
654	31	29	2	18	\N	\N
655	31	31	2	18	\N	\N
656	31	34	2	16	\N	\N
657	31	46	2	16	\N	\N
658	31	51	2	14	\N	\N
659	31	13	2	2	\N	\N
660	31	44	2	2	\N	\N
661	32	23	2	104	\N	\N
662	32	34	2	52	\N	\N
663	32	32	2	52	\N	\N
664	32	1	2	52	\N	\N
665	32	40	2	52	\N	\N
666	32	10	2	52	\N	\N
667	32	20	2	52	\N	\N
668	32	46	2	52	\N	\N
669	32	49	2	52	\N	\N
670	32	45	2	52	\N	\N
671	32	24	2	52	\N	\N
672	32	25	2	52	\N	\N
673	32	12	2	52	\N	\N
674	32	18	2	52	\N	\N
675	32	37	2	52	\N	\N
676	32	47	2	45	\N	\N
677	32	52	2	30	\N	\N
678	32	28	2	12	\N	\N
679	33	23	2	108	\N	\N
680	33	5	2	54	\N	\N
681	33	33	2	54	\N	\N
682	33	11	2	54	\N	\N
683	34	34	3	90	\N	\N
684	34	23	2	215	\N	\N
685	34	34	2	135	\N	\N
686	34	10	2	90	\N	\N
687	34	46	2	90	\N	\N
688	34	1	2	80	\N	\N
689	34	32	2	52	\N	\N
690	34	40	2	52	\N	\N
691	34	20	2	52	\N	\N
692	34	49	2	52	\N	\N
693	34	45	2	52	\N	\N
694	34	24	2	52	\N	\N
695	34	25	2	52	\N	\N
696	34	12	2	52	\N	\N
697	34	18	2	52	\N	\N
698	34	37	2	52	\N	\N
699	34	47	2	45	\N	\N
700	34	17	2	45	\N	\N
701	34	4	2	45	\N	\N
702	34	7	2	32	\N	\N
703	34	52	2	30	\N	\N
704	34	41	2	28	\N	\N
705	34	2	2	28	\N	\N
706	34	15	2	28	\N	\N
707	34	3	2	28	\N	\N
708	34	50	2	28	\N	\N
709	34	16	2	28	\N	\N
710	34	53	2	28	\N	\N
711	34	29	2	28	\N	\N
712	34	31	2	16	\N	\N
713	34	51	2	12	\N	\N
714	34	28	2	12	\N	\N
715	35	23	1	32	\N	\N
716	35	34	1	16	\N	\N
717	35	41	1	16	\N	\N
718	35	2	1	16	\N	\N
719	35	1	1	16	\N	\N
720	35	15	1	16	\N	\N
721	35	3	1	16	\N	\N
722	35	50	1	16	\N	\N
723	35	10	1	16	\N	\N
724	35	46	1	16	\N	\N
725	35	16	1	16	\N	\N
726	35	53	1	16	\N	\N
727	35	29	1	16	\N	\N
728	35	7	1	8	\N	\N
729	35	31	1	4	\N	\N
730	35	35	3	143	\N	\N
731	35	42	3	106	\N	\N
732	35	11	3	54	\N	\N
733	35	54	3	46	\N	\N
734	35	47	3	45	\N	\N
735	35	7	3	36	\N	\N
736	35	31	3	18	\N	\N
737	35	5	3	12	\N	\N
738	35	28	3	12	\N	\N
739	35	23	2	286	\N	\N
740	35	35	2	143	\N	\N
741	35	43	2	143	\N	\N
742	35	19	2	143	\N	\N
743	35	38	2	143	\N	\N
744	35	8	2	143	\N	\N
745	35	36	2	143	\N	\N
746	35	22	2	143	\N	\N
747	35	37	2	143	\N	\N
748	35	54	2	46	\N	\N
749	36	23	2	286	\N	\N
750	36	35	2	143	\N	\N
751	36	43	2	143	\N	\N
752	36	19	2	143	\N	\N
753	36	38	2	143	\N	\N
754	36	8	2	143	\N	\N
755	36	36	2	143	\N	\N
756	36	22	2	143	\N	\N
757	36	37	2	143	\N	\N
758	36	54	2	46	\N	\N
759	37	23	2	2225	\N	\N
760	37	37	2	1202	\N	\N
761	37	9	2	824	\N	\N
762	37	27	2	824	\N	\N
763	37	26	2	824	\N	\N
764	37	38	2	249	\N	\N
765	37	22	2	167	\N	\N
766	37	14	2	159	\N	\N
767	37	35	2	143	\N	\N
768	37	19	2	143	\N	\N
769	37	8	2	143	\N	\N
770	37	36	2	143	\N	\N
771	37	43	2	141	\N	\N
772	37	42	2	106	\N	\N
773	37	13	2	77	\N	\N
774	37	34	2	52	\N	\N
775	37	32	2	52	\N	\N
776	37	1	2	52	\N	\N
777	37	40	2	52	\N	\N
778	37	10	2	52	\N	\N
779	37	20	2	52	\N	\N
780	37	46	2	52	\N	\N
781	37	49	2	52	\N	\N
782	37	45	2	52	\N	\N
783	37	24	2	52	\N	\N
784	37	25	2	52	\N	\N
785	37	12	2	52	\N	\N
786	37	18	2	52	\N	\N
787	37	54	2	46	\N	\N
788	37	47	2	45	\N	\N
789	37	52	2	30	\N	\N
790	37	28	2	12	\N	\N
791	38	23	2	392	\N	\N
792	38	38	2	249	\N	\N
793	38	37	2	249	\N	\N
794	38	35	2	143	\N	\N
795	38	43	2	143	\N	\N
796	38	19	2	143	\N	\N
797	38	8	2	143	\N	\N
798	38	36	2	143	\N	\N
799	38	22	2	143	\N	\N
800	38	14	2	106	\N	\N
801	38	42	2	106	\N	\N
802	38	54	2	46	\N	\N
803	39	39	2	19	\N	\N
804	39	30	2	19	\N	\N
805	39	21	2	19	\N	\N
806	39	23	2	19	\N	\N
807	39	6	2	6	\N	\N
808	39	48	2	3	\N	\N
809	40	23	2	104	\N	\N
810	40	34	2	52	\N	\N
811	40	32	2	52	\N	\N
812	40	1	2	52	\N	\N
813	40	40	2	52	\N	\N
814	40	10	2	52	\N	\N
815	40	20	2	52	\N	\N
816	40	46	2	52	\N	\N
817	40	49	2	52	\N	\N
818	40	45	2	52	\N	\N
819	40	24	2	52	\N	\N
820	40	25	2	52	\N	\N
821	40	12	2	52	\N	\N
822	40	18	2	52	\N	\N
823	40	37	2	52	\N	\N
824	40	47	2	45	\N	\N
825	40	52	2	30	\N	\N
826	40	28	2	12	\N	\N
827	41	23	1	6	\N	\N
828	41	34	1	3	\N	\N
829	41	32	1	3	\N	\N
830	41	1	1	3	\N	\N
831	41	40	1	3	\N	\N
832	41	10	1	3	\N	\N
833	41	20	1	3	\N	\N
834	41	46	1	3	\N	\N
835	41	49	1	3	\N	\N
836	41	45	1	3	\N	\N
837	41	24	1	3	\N	\N
838	41	25	1	3	\N	\N
839	41	12	1	3	\N	\N
840	41	18	1	3	\N	\N
841	41	37	1	3	\N	\N
842	41	47	1	2	\N	\N
843	41	52	1	2	\N	\N
844	41	26	3	103	\N	\N
845	41	27	3	81	\N	\N
846	41	41	3	30	\N	\N
847	41	22	3	22	\N	\N
848	41	23	2	60	\N	\N
849	41	7	2	36	\N	\N
850	41	41	2	30	\N	\N
851	41	2	2	30	\N	\N
852	41	1	2	30	\N	\N
853	41	15	2	30	\N	\N
854	41	3	2	30	\N	\N
855	41	50	2	30	\N	\N
856	41	10	2	30	\N	\N
857	41	16	2	30	\N	\N
858	41	53	2	30	\N	\N
859	41	29	2	30	\N	\N
860	41	34	2	28	\N	\N
861	41	46	2	28	\N	\N
862	41	31	2	18	\N	\N
863	41	51	2	14	\N	\N
864	41	13	2	2	\N	\N
865	41	44	2	2	\N	\N
866	42	23	1	30	\N	\N
867	42	34	1	15	\N	\N
868	42	41	1	15	\N	\N
869	42	2	1	15	\N	\N
870	42	1	1	15	\N	\N
871	42	15	1	15	\N	\N
872	42	3	1	15	\N	\N
873	42	50	1	15	\N	\N
874	42	10	1	15	\N	\N
875	42	46	1	15	\N	\N
876	42	16	1	15	\N	\N
877	42	53	1	15	\N	\N
878	42	29	1	15	\N	\N
879	42	7	1	8	\N	\N
880	42	31	1	4	\N	\N
881	42	35	3	141	\N	\N
882	42	42	3	106	\N	\N
883	42	11	3	54	\N	\N
884	42	54	3	46	\N	\N
885	42	47	3	44	\N	\N
886	42	7	3	36	\N	\N
887	42	31	3	18	\N	\N
888	42	5	3	12	\N	\N
889	42	28	3	12	\N	\N
890	42	14	2	106	\N	\N
891	42	38	2	106	\N	\N
892	42	42	2	106	\N	\N
893	42	37	2	106	\N	\N
894	42	23	2	106	\N	\N
895	43	23	2	286	\N	\N
896	43	35	2	143	\N	\N
897	43	43	2	143	\N	\N
898	43	19	2	143	\N	\N
899	43	38	2	143	\N	\N
900	43	8	2	143	\N	\N
901	43	36	2	143	\N	\N
902	43	22	2	143	\N	\N
903	43	37	2	143	\N	\N
904	43	54	2	46	\N	\N
905	44	7	2	4	\N	\N
906	44	23	2	4	\N	\N
907	44	41	2	2	\N	\N
908	44	51	2	2	\N	\N
909	44	2	2	2	\N	\N
910	44	13	2	2	\N	\N
911	44	1	2	2	\N	\N
912	44	15	2	2	\N	\N
913	44	3	2	2	\N	\N
914	44	50	2	2	\N	\N
915	44	10	2	2	\N	\N
916	44	16	2	2	\N	\N
917	44	53	2	2	\N	\N
918	44	29	2	2	\N	\N
919	44	31	2	2	\N	\N
920	44	44	2	2	\N	\N
921	45	23	2	104	\N	\N
922	45	34	2	52	\N	\N
923	45	32	2	52	\N	\N
924	45	1	2	52	\N	\N
925	45	40	2	52	\N	\N
926	45	10	2	52	\N	\N
927	45	20	2	52	\N	\N
928	45	46	2	52	\N	\N
929	45	49	2	52	\N	\N
930	45	45	2	52	\N	\N
931	45	24	2	52	\N	\N
932	45	25	2	52	\N	\N
933	45	12	2	52	\N	\N
934	45	18	2	52	\N	\N
935	45	37	2	52	\N	\N
936	45	47	2	45	\N	\N
937	45	52	2	30	\N	\N
938	45	28	2	12	\N	\N
939	46	34	1	16	\N	\N
940	46	17	1	16	\N	\N
941	46	4	1	16	\N	\N
942	46	23	1	16	\N	\N
943	46	46	3	90	\N	\N
944	46	23	2	170	\N	\N
945	46	34	2	90	\N	\N
946	46	10	2	90	\N	\N
947	46	46	2	90	\N	\N
948	46	1	2	80	\N	\N
949	46	32	2	52	\N	\N
950	46	40	2	52	\N	\N
951	46	20	2	52	\N	\N
952	46	49	2	52	\N	\N
953	46	45	2	52	\N	\N
954	46	24	2	52	\N	\N
955	46	25	2	52	\N	\N
956	46	12	2	52	\N	\N
957	46	18	2	52	\N	\N
958	46	37	2	52	\N	\N
959	46	47	2	45	\N	\N
960	46	7	2	32	\N	\N
961	46	52	2	30	\N	\N
962	46	41	2	28	\N	\N
963	46	2	2	28	\N	\N
964	46	15	2	28	\N	\N
965	46	3	2	28	\N	\N
966	46	50	2	28	\N	\N
967	46	16	2	28	\N	\N
968	46	53	2	28	\N	\N
969	46	29	2	28	\N	\N
970	46	31	2	16	\N	\N
971	46	51	2	12	\N	\N
972	46	28	2	12	\N	\N
973	47	23	1	24	\N	\N
974	47	34	1	12	\N	\N
975	47	41	1	12	\N	\N
976	47	2	1	12	\N	\N
977	47	1	1	12	\N	\N
978	47	15	1	12	\N	\N
979	47	3	1	12	\N	\N
980	47	50	1	12	\N	\N
981	47	10	1	12	\N	\N
982	47	46	1	12	\N	\N
983	47	16	1	12	\N	\N
984	47	53	1	12	\N	\N
985	47	29	1	12	\N	\N
986	47	7	1	8	\N	\N
987	47	31	1	4	\N	\N
988	47	35	3	123	\N	\N
989	47	42	3	89	\N	\N
990	47	11	3	54	\N	\N
991	47	47	3	45	\N	\N
992	47	54	3	41	\N	\N
993	47	7	3	36	\N	\N
994	47	31	3	18	\N	\N
995	47	5	3	12	\N	\N
996	47	28	3	8	\N	\N
997	47	23	2	90	\N	\N
998	47	34	2	45	\N	\N
999	47	32	2	45	\N	\N
1000	47	1	2	45	\N	\N
1001	47	47	2	45	\N	\N
1002	47	40	2	45	\N	\N
1003	47	10	2	45	\N	\N
1004	47	20	2	45	\N	\N
1005	47	46	2	45	\N	\N
1006	47	49	2	45	\N	\N
1007	47	45	2	45	\N	\N
1008	47	24	2	45	\N	\N
1009	47	25	2	45	\N	\N
1010	47	12	2	45	\N	\N
1011	47	18	2	45	\N	\N
1012	47	37	2	45	\N	\N
1013	47	52	2	27	\N	\N
1014	47	28	2	11	\N	\N
1015	48	39	2	3	\N	\N
1016	48	48	2	3	\N	\N
1017	48	30	2	3	\N	\N
1018	48	21	2	3	\N	\N
1019	48	23	2	3	\N	\N
1020	49	23	2	104	\N	\N
1021	49	34	2	52	\N	\N
1022	49	32	2	52	\N	\N
1023	49	1	2	52	\N	\N
1024	49	40	2	52	\N	\N
1025	49	10	2	52	\N	\N
1026	49	20	2	52	\N	\N
1027	49	46	2	52	\N	\N
1028	49	49	2	52	\N	\N
1029	49	45	2	52	\N	\N
1030	49	24	2	52	\N	\N
1031	49	25	2	52	\N	\N
1032	49	12	2	52	\N	\N
1033	49	18	2	52	\N	\N
1034	49	37	2	52	\N	\N
1035	49	47	2	45	\N	\N
1036	49	52	2	30	\N	\N
1037	49	28	2	12	\N	\N
1038	50	23	2	60	\N	\N
1039	50	7	2	36	\N	\N
1040	50	41	2	30	\N	\N
1041	50	2	2	30	\N	\N
1042	50	1	2	30	\N	\N
1043	50	15	2	30	\N	\N
1044	50	3	2	30	\N	\N
1045	50	50	2	30	\N	\N
1046	50	10	2	30	\N	\N
1047	50	16	2	30	\N	\N
1048	50	53	2	30	\N	\N
1049	50	29	2	30	\N	\N
1050	50	34	2	28	\N	\N
1051	50	46	2	28	\N	\N
1052	50	31	2	18	\N	\N
1053	50	51	2	14	\N	\N
1054	50	13	2	2	\N	\N
1055	50	44	2	2	\N	\N
1056	51	7	2	28	\N	\N
1057	51	23	2	28	\N	\N
1058	51	41	2	14	\N	\N
1059	51	51	2	14	\N	\N
1060	51	2	2	14	\N	\N
1061	51	1	2	14	\N	\N
1062	51	15	2	14	\N	\N
1063	51	3	2	14	\N	\N
1064	51	50	2	14	\N	\N
1065	51	10	2	14	\N	\N
1066	51	16	2	14	\N	\N
1067	51	53	2	14	\N	\N
1068	51	29	2	14	\N	\N
1069	51	31	2	14	\N	\N
1070	51	34	2	12	\N	\N
1071	51	46	2	12	\N	\N
1072	51	13	2	2	\N	\N
1073	51	44	2	2	\N	\N
1074	52	23	2	60	\N	\N
1075	52	34	2	30	\N	\N
1076	52	32	2	30	\N	\N
1077	52	1	2	30	\N	\N
1078	52	52	2	30	\N	\N
1079	52	40	2	30	\N	\N
1080	52	10	2	30	\N	\N
1081	52	20	2	30	\N	\N
1082	52	46	2	30	\N	\N
1083	52	49	2	30	\N	\N
1084	52	45	2	30	\N	\N
1085	52	24	2	30	\N	\N
1086	52	25	2	30	\N	\N
1087	52	12	2	30	\N	\N
1088	52	18	2	30	\N	\N
1089	52	37	2	30	\N	\N
1090	52	47	2	27	\N	\N
1091	52	28	2	12	\N	\N
1092	53	23	2	60	\N	\N
1093	53	7	2	36	\N	\N
1094	53	41	2	30	\N	\N
1095	53	2	2	30	\N	\N
1096	53	1	2	30	\N	\N
1097	53	15	2	30	\N	\N
1098	53	3	2	30	\N	\N
1099	53	50	2	30	\N	\N
1100	53	10	2	30	\N	\N
1101	53	16	2	30	\N	\N
1102	53	53	2	30	\N	\N
1103	53	29	2	30	\N	\N
1104	53	34	2	28	\N	\N
1105	53	46	2	28	\N	\N
1106	53	31	2	18	\N	\N
1107	53	51	2	14	\N	\N
1108	53	13	2	2	\N	\N
1109	53	44	2	2	\N	\N
1110	54	23	1	30	\N	\N
1111	54	34	1	15	\N	\N
1112	54	41	1	15	\N	\N
1113	54	2	1	15	\N	\N
1114	54	1	1	15	\N	\N
1115	54	15	1	15	\N	\N
1116	54	3	1	15	\N	\N
1117	54	50	1	15	\N	\N
1118	54	10	1	15	\N	\N
1119	54	46	1	15	\N	\N
1120	54	16	1	15	\N	\N
1121	54	53	1	15	\N	\N
1122	54	29	1	15	\N	\N
1123	54	7	1	8	\N	\N
1124	54	31	1	4	\N	\N
1125	54	35	3	141	\N	\N
1126	54	42	3	106	\N	\N
1127	54	11	3	54	\N	\N
1128	54	54	3	46	\N	\N
1129	54	47	3	44	\N	\N
1130	54	7	3	36	\N	\N
1131	54	31	3	18	\N	\N
1132	54	5	3	12	\N	\N
1133	54	28	3	12	\N	\N
1134	54	23	2	92	\N	\N
1135	54	35	2	46	\N	\N
1136	54	43	2	46	\N	\N
1137	54	19	2	46	\N	\N
1138	54	38	2	46	\N	\N
1139	54	8	2	46	\N	\N
1140	54	36	2	46	\N	\N
1141	54	54	2	46	\N	\N
1142	54	22	2	46	\N	\N
1143	54	37	2	46	\N	\N
\.


--
-- TOC entry 20921 (class 0 OID 354012)
-- Dependencies: 6680
-- Data for Name: properties; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.properties (id, iri, cnt, data, ns_id, display_name, local_name, is_unique, object_cnt, max_cardinality, inverse_max_cardinality, source_cover_complete, target_cover_complete, domain_class_id, range_class_id, data_cnt, classes_in_schema, is_classifier, use_in_class, classif_prefix, values_have_cp, props_in_schema, pp_ask_endpoint, pc_ask_endpoint, has_followers_ok, has_outgoing_props_ok, has_incoming_props_ok) FROM stdin;
1	http://schema.vq.app/displayName	82	\N	69	displayName	displayName	f	0	1	\N	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
2	http://schema.vq.app/cp_ask_endpoint	30	\N	69	cp_ask_endpoint	cp_ask_endpoint	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
3	http://schema.vq.app/instanceCount	30	\N	69	instanceCount	instanceCount	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
4	http://schema.vq.app/prefix	45	\N	69	prefix	prefix	f	0	1	\N	t	f	16	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
5	http://schema.vq.app/base	54	\N	69	base	base	f	54	1	-1	t	t	13	3	\N	t	f	\N	\N	\N	t	f	f	t	t	t
6	http://schema.vq.app/textValue	7	\N	69	textValue	textValue	f	0	1	\N	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
24	http://schema.vq.app/pp_ask_endpoint	52	\N	69	pp_ask_endpoint	pp_ask_endpoint	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
7	http://schema.vq.app/intersects	36	\N	69	intersects	intersects	f	36	-1	-1	t	t	3	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
8	http://schema.vq.app/maxCardinalityInContext	143	\N	69	maxCardinalityInContext	maxCardinalityInContext	f	0	1	\N	t	f	10	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
9	http://schema.vq.app/pprel_type	826	\N	69	pprel_type	pprel_type	f	0	1	\N	t	f	8	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
10	http://schema.vq.app/local_name	92	\N	69	local_name	local_name	f	0	1	\N	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
11	http://schema.vq.app/target	54	\N	69	target	target	f	54	1	-1	t	t	13	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
12	http://schema.vq.app/sourceCoverComplete	52	\N	69	sourceCoverComplete	sourceCoverComplete	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
13	http://schema.vq.app/datatype	79	\N	69	datatype	datatype	f	79	1	-1	t	t	\N	11	\N	t	f	\N	\N	\N	t	f	f	t	t	t
14	http://schema.vq.app/basePair	159	\N	69	basePair	basePair	f	159	1	-1	t	t	\N	10	\N	t	f	\N	\N	\N	t	f	f	t	t	t
15	http://schema.vq.app/hide_in_main	30	\N	69	hide_in_main	hide_in_main	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
16	http://schema.vq.app/namestring	30	\N	69	namestring	namestring	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
17	http://schema.vq.app/isDefault	45	\N	69	isDefault	isDefault	f	0	1	\N	t	f	16	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
18	http://schema.vq.app/targetCoverComplete	52	\N	69	targetCoverComplete	targetCoverComplete	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
19	http://schema.vq.app/detailsLevel	143	\N	69	detailsLevel	detailsLevel	f	0	1	\N	t	f	10	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
20	http://schema.vq.app/maxCardinality	52	\N	69	maxCardinality	maxCardinality	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
21	http://schema.vq.app/order_inx	20	\N	69	order_inx	order_inx	f	0	1	\N	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
22	http://schema.vq.app/property	167	\N	69	property	property	f	167	1	-1	t	t	\N	6	\N	t	f	\N	\N	\N	t	f	f	t	t	t
25	http://schema.vq.app/props_in_schema	52	\N	69	props_in_schema	props_in_schema	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
26	http://schema.vq.app/property_2	826	\N	69	property_2	property_2	f	826	1	-1	t	t	8	6	\N	t	f	\N	\N	\N	t	f	f	t	t	t
33	http://schema.vq.app/cc_rel_type	54	\N	69	cc_rel_type	cc_rel_type	f	0	1	\N	t	f	13	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
27	http://schema.vq.app/property_1	826	\N	69	property_1	property_1	f	826	1	-1	t	t	8	6	\N	t	f	\N	\N	\N	t	f	f	t	t	t
34	http://schema.vq.app/URI	135	\N	69	URI	URI	f	90	1	-1	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
28	http://schema.vq.app/rangeClass	12	\N	69	rangeClass	rangeClass	f	12	1	-1	t	t	6	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
29	http://schema.vq.app/self_cp_rels	30	\N	69	self_cp_rels	self_cp_rels	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
30	http://schema.vq.app/name	20	\N	69	name	name	f	0	1	\N	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
31	http://schema.vq.app/subClassOf	18	\N	69	subClassOf	subClassOf	f	18	1	-1	t	t	3	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
32	http://schema.vq.app/classes_in_schema	52	\N	69	classes_in_schema	classes_in_schema	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
40	http://schema.vq.app/is_classifier	52	\N	69	is_classifier	is_classifier	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
35	http://schema.vq.app/class	143	\N	69	class	class	f	143	1	-1	t	t	10	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
36	http://schema.vq.app/minCardinalityInContext	143	\N	69	minCardinalityInContext	minCardinalityInContext	f	0	1	\N	t	f	10	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
37	http://schema.vq.app/tripleCount	1204	\N	69	tripleCount	tripleCount	f	0	1	\N	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
38	http://schema.vq.app/importanceIndex	249	\N	69	importanceIndex	importanceIndex	f	0	1	\N	t	f	\N	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
39	http://schema.vq.app/comment	19	\N	69	comment	comment	f	0	1	\N	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
43	http://schema.vq.app/cprel_type	143	\N	69	cprel_type	cprel_type	f	0	1	\N	t	f	10	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
41	http://schema.vq.app/classifIcationProperty	30	\N	69	classifIcationProperty	classifIcationProperty	f	30	1	-1	t	t	3	6	\N	t	f	\N	\N	\N	t	f	f	t	t	t
42	http://schema.vq.app/linkedClass	106	\N	69	linkedClass	linkedClass	f	106	1	-1	t	t	18	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
44	http://schema.vq.app/text	2	\N	69	text	text	f	0	1	\N	t	f	4	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
45	http://schema.vq.app/pc_ask_endpoint	52	\N	69	pc_ask_endpoint	pc_ask_endpoint	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
46	http://schema.vq.app/namespace	90	\N	69	namespace	namespace	f	90	1	-1	t	t	\N	16	\N	t	f	\N	\N	\N	t	f	f	t	t	t
48	http://schema.vq.app/jsonValue	3	\N	69	jsonValue	jsonValue	f	0	1	\N	t	f	21	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
47	http://schema.vq.app/domainClass	45	\N	69	domainClass	domainClass	f	45	1	-1	t	t	6	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
23	http://www.w3.org/1999/02/22-rdf-syntax-ns#type	2468	\N	1	type	type	f	2468	-1	-1	t	f	\N	\N	\N	t	t	t	\N	t	t	f	f	t	t	t
49	http://schema.vq.app/objectTripleCount	52	\N	69	objectTripleCount	objectTripleCount	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
50	http://schema.vq.app/isLiteral	30	\N	69	isLiteral	isLiteral	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
51	http://schema.vq.app/classif_adornment	14	\N	69	classif_adornment	classif_adornment	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
52	http://schema.vq.app/invMaxCardinality	30	\N	69	invMaxCardinality	invMaxCardinality	f	0	1	\N	t	f	6	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
53	http://schema.vq.app/propsInSchema	30	\N	69	propsInSchema	propsInSchema	f	0	1	\N	t	f	3	\N	\N	t	f	\N	\N	\N	t	f	f	t	t	t
54	http://schema.vq.app/principalEnd	46	\N	69	principalEnd	principalEnd	f	46	1	-1	t	t	10	9	\N	t	f	\N	\N	\N	t	f	f	t	t	t
\.


--
-- TOC entry 20953 (class 0 OID 354125)
-- Dependencies: 6713
-- Data for Name: property_annots; Type: TABLE DATA; Schema: nobel_prizes_schema; Owner: postgres
--

COPY nobel_prizes_schema.property_annots (id, property_id, type_id, annotation, language_code) FROM stdin;
\.


--
-- TOC entry 20966 (class 0 OID 0)
-- Dependencies: 6677
-- Name: annot_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.annot_types_id_seq', 7, true);


--
-- TOC entry 20967 (class 0 OID 0)
-- Dependencies: 6683
-- Name: cc_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.cc_rel_types_id_seq', 3, true);


--
-- TOC entry 20968 (class 0 OID 0)
-- Dependencies: 6685
-- Name: cc_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.cc_rels_id_seq', 30, true);


--
-- TOC entry 20969 (class 0 OID 0)
-- Dependencies: 6687
-- Name: class_annots_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.class_annots_id_seq', 1, false);


--
-- TOC entry 20970 (class 0 OID 0)
-- Dependencies: 6688
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.classes_id_seq', 22, true);


--
-- TOC entry 20971 (class 0 OID 0)
-- Dependencies: 6690
-- Name: cp_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.cp_rel_types_id_seq', 4, true);


--
-- TOC entry 20972 (class 0 OID 0)
-- Dependencies: 6691
-- Name: cp_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.cp_rels_id_seq', 211, true);


--
-- TOC entry 20973 (class 0 OID 0)
-- Dependencies: 6693
-- Name: cpc_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.cpc_rels_id_seq', 188, true);


--
-- TOC entry 20974 (class 0 OID 0)
-- Dependencies: 6695
-- Name: cpd_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.cpd_rels_id_seq', 101, true);


--
-- TOC entry 20975 (class 0 OID 0)
-- Dependencies: 6697
-- Name: datatypes_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.datatypes_id_seq', 3, true);


--
-- TOC entry 20976 (class 0 OID 0)
-- Dependencies: 6699
-- Name: instances_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.instances_id_seq', 1, false);


--
-- TOC entry 20977 (class 0 OID 0)
-- Dependencies: 6701
-- Name: ns_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.ns_id_seq', 69, true);


--
-- TOC entry 20978 (class 0 OID 0)
-- Dependencies: 6703
-- Name: ns_stats_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.ns_stats_id_seq', 1, false);


--
-- TOC entry 20979 (class 0 OID 0)
-- Dependencies: 6705
-- Name: parameters_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.parameters_id_seq', 32, true);


--
-- TOC entry 20980 (class 0 OID 0)
-- Dependencies: 6707
-- Name: pd_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.pd_rels_id_seq', 37, true);


--
-- TOC entry 20981 (class 0 OID 0)
-- Dependencies: 6709
-- Name: pp_rel_types_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.pp_rel_types_id_seq', 4, true);


--
-- TOC entry 20982 (class 0 OID 0)
-- Dependencies: 6711
-- Name: pp_rels_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.pp_rels_id_seq', 1143, true);


--
-- TOC entry 20983 (class 0 OID 0)
-- Dependencies: 6712
-- Name: properties_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.properties_id_seq', 54, true);


--
-- TOC entry 20984 (class 0 OID 0)
-- Dependencies: 6714
-- Name: property_annots_id_seq; Type: SEQUENCE SET; Schema: nobel_prizes_schema; Owner: postgres
--

SELECT pg_catalog.setval('nobel_prizes_schema.property_annots_id_seq', 1, false);


--
-- TOC entry 18620 (class 2606 OID 354211)
-- Name: _h_classes _h_classes_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema._h_classes
    ADD CONSTRAINT _h_classes_pkey PRIMARY KEY (a, b);


--
-- TOC entry 18622 (class 2606 OID 354213)
-- Name: annot_types annot_types_iri_uq; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.annot_types
    ADD CONSTRAINT annot_types_iri_uq UNIQUE (iri);


--
-- TOC entry 18624 (class 2606 OID 354215)
-- Name: annot_types annot_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.annot_types
    ADD CONSTRAINT annot_types_pkey PRIMARY KEY (id);


--
-- TOC entry 18658 (class 2606 OID 354217)
-- Name: cc_rel_types cc_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cc_rel_types
    ADD CONSTRAINT cc_rel_types_pkey PRIMARY KEY (id);


--
-- TOC entry 18660 (class 2606 OID 354219)
-- Name: cc_rels cc_rels_class_1_id_class_2_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cc_rels
    ADD CONSTRAINT cc_rels_class_1_id_class_2_id_type_id_key UNIQUE (class_1_id, class_2_id, type_id);


--
-- TOC entry 18662 (class 2606 OID 354221)
-- Name: cc_rels cc_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cc_rels
    ADD CONSTRAINT cc_rels_pkey PRIMARY KEY (id);


--
-- TOC entry 18668 (class 2606 OID 354223)
-- Name: class_annots class_annots_c_t_l_uq; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.class_annots
    ADD CONSTRAINT class_annots_c_t_l_uq UNIQUE (class_id, type_id, language_code);


--
-- TOC entry 18670 (class 2606 OID 354225)
-- Name: class_annots class_annots_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.class_annots
    ADD CONSTRAINT class_annots_pkey PRIMARY KEY (id);


--
-- TOC entry 18627 (class 2606 OID 354227)
-- Name: classes classes_iri_cl_prop_id_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.classes
    ADD CONSTRAINT classes_iri_cl_prop_id_key UNIQUE (iri, classification_property_id);


--
-- TOC entry 18629 (class 2606 OID 354229)
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- TOC entry 18673 (class 2606 OID 354231)
-- Name: cp_rel_types cp_rel_types_name_unique; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cp_rel_types
    ADD CONSTRAINT cp_rel_types_name_unique UNIQUE (name);


--
-- TOC entry 18675 (class 2606 OID 354233)
-- Name: cp_rel_types cp_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cp_rel_types
    ADD CONSTRAINT cp_rel_types_pkey PRIMARY KEY (id);


--
-- TOC entry 18637 (class 2606 OID 354235)
-- Name: cp_rels cp_rels_class_id_property_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cp_rels
    ADD CONSTRAINT cp_rels_class_id_property_id_type_id_key UNIQUE (class_id, property_id, type_id);


--
-- TOC entry 18639 (class 2606 OID 354237)
-- Name: cp_rels cp_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cp_rels
    ADD CONSTRAINT cp_rels_pkey PRIMARY KEY (id);


--
-- TOC entry 18677 (class 2606 OID 354239)
-- Name: cpc_rels cpc_rels_cp_rel_id_other_class_id_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_id_other_class_id_key UNIQUE (cp_rel_id, other_class_id);


--
-- TOC entry 18679 (class 2606 OID 354241)
-- Name: cpc_rels cpc_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpc_rels
    ADD CONSTRAINT cpc_rels_pkey PRIMARY KEY (id);


--
-- TOC entry 18681 (class 2606 OID 354243)
-- Name: cpd_rels cpd_rels_cp_rel_id_datatype_id_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_id_datatype_id_key UNIQUE (cp_rel_id, datatype_id);


--
-- TOC entry 18683 (class 2606 OID 354245)
-- Name: cpd_rels cpd_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpd_rels
    ADD CONSTRAINT cpd_rels_pkey PRIMARY KEY (id);


--
-- TOC entry 18685 (class 2606 OID 354247)
-- Name: datatypes datatypes_iri_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.datatypes
    ADD CONSTRAINT datatypes_iri_key UNIQUE (iri);


--
-- TOC entry 18687 (class 2606 OID 354249)
-- Name: datatypes datatypes_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.datatypes
    ADD CONSTRAINT datatypes_pkey PRIMARY KEY (id);


--
-- TOC entry 18692 (class 2606 OID 354251)
-- Name: instances instances_iri_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.instances
    ADD CONSTRAINT instances_iri_key UNIQUE (iri);


--
-- TOC entry 18694 (class 2606 OID 354253)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 18696 (class 2606 OID 354255)
-- Name: ns ns_name_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.ns
    ADD CONSTRAINT ns_name_key UNIQUE (name);


--
-- TOC entry 18698 (class 2606 OID 354257)
-- Name: ns ns_name_unique; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.ns
    ADD CONSTRAINT ns_name_unique UNIQUE (name);


--
-- TOC entry 18700 (class 2606 OID 354259)
-- Name: ns ns_value_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.ns
    ADD CONSTRAINT ns_value_key UNIQUE (value);


--
-- TOC entry 18706 (class 2606 OID 354261)
-- Name: parameters parameters_name_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.parameters
    ADD CONSTRAINT parameters_name_key UNIQUE (name);


--
-- TOC entry 18708 (class 2606 OID 354263)
-- Name: parameters parameters_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.parameters
    ADD CONSTRAINT parameters_pkey PRIMARY KEY (id);


--
-- TOC entry 18710 (class 2606 OID 354265)
-- Name: pd_rels pd_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pd_rels
    ADD CONSTRAINT pd_rels_pkey PRIMARY KEY (id);


--
-- TOC entry 18712 (class 2606 OID 354267)
-- Name: pd_rels pd_rels_property_id_datatype_id_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pd_rels
    ADD CONSTRAINT pd_rels_property_id_datatype_id_key UNIQUE (property_id, datatype_id);


--
-- TOC entry 18714 (class 2606 OID 354269)
-- Name: pp_rel_types pp_rel_types_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pp_rel_types
    ADD CONSTRAINT pp_rel_types_pkey PRIMARY KEY (id);


--
-- TOC entry 18726 (class 2606 OID 354271)
-- Name: pp_rels pp_rels_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pp_rels
    ADD CONSTRAINT pp_rels_pkey PRIMARY KEY (id);


--
-- TOC entry 18728 (class 2606 OID 354273)
-- Name: pp_rels pp_rels_property_1_id_property_2_id_type_id_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pp_rels
    ADD CONSTRAINT pp_rels_property_1_id_property_2_id_type_id_key UNIQUE (property_1_id, property_2_id, type_id);


--
-- TOC entry 18702 (class 2606 OID 354275)
-- Name: ns prefixes_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.ns
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (id);


--
-- TOC entry 18654 (class 2606 OID 354277)
-- Name: properties properties_iri_key; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.properties
    ADD CONSTRAINT properties_iri_key UNIQUE (iri);


--
-- TOC entry 18656 (class 2606 OID 354279)
-- Name: properties properties_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.properties
    ADD CONSTRAINT properties_pkey PRIMARY KEY (id);


--
-- TOC entry 18731 (class 2606 OID 354281)
-- Name: property_annots property_annots_p_t_l_uq; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.property_annots
    ADD CONSTRAINT property_annots_p_t_l_uq UNIQUE (property_id, type_id, language_code);


--
-- TOC entry 18733 (class 2606 OID 354283)
-- Name: property_annots property_annots_pkey; Type: CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.property_annots
    ADD CONSTRAINT property_annots_pkey PRIMARY KEY (id);


--
-- TOC entry 18625 (class 1259 OID 354284)
-- Name: fki_annot_types_ns_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_annot_types_ns_fk ON nobel_prizes_schema.annot_types USING btree (ns_id);


--
-- TOC entry 18663 (class 1259 OID 354285)
-- Name: fki_cc_rels_class_1_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cc_rels_class_1_fk ON nobel_prizes_schema.cc_rels USING btree (class_1_id);


--
-- TOC entry 18664 (class 1259 OID 354286)
-- Name: fki_cc_rels_class_2_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cc_rels_class_2_fk ON nobel_prizes_schema.cc_rels USING btree (class_2_id);


--
-- TOC entry 18665 (class 1259 OID 354287)
-- Name: fki_cc_rels_type_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cc_rels_type_fk ON nobel_prizes_schema.cc_rels USING btree (type_id);


--
-- TOC entry 18671 (class 1259 OID 354288)
-- Name: fki_class_annots_class_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_class_annots_class_fk ON nobel_prizes_schema.class_annots USING btree (class_id);


--
-- TOC entry 18630 (class 1259 OID 354289)
-- Name: fki_classes_ns_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_classes_ns_fk ON nobel_prizes_schema.classes USING btree (ns_id);


--
-- TOC entry 18631 (class 1259 OID 354290)
-- Name: fki_classes_superclass_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_classes_superclass_fk ON nobel_prizes_schema.classes USING btree (principal_super_class_id);


--
-- TOC entry 18640 (class 1259 OID 354291)
-- Name: fki_cp_rels_class_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cp_rels_class_fk ON nobel_prizes_schema.cp_rels USING btree (class_id);


--
-- TOC entry 18647 (class 1259 OID 354292)
-- Name: fki_cp_rels_domain_classes_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cp_rels_domain_classes_fk ON nobel_prizes_schema.properties USING btree (domain_class_id);


--
-- TOC entry 18641 (class 1259 OID 354293)
-- Name: fki_cp_rels_property_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cp_rels_property_fk ON nobel_prizes_schema.cp_rels USING btree (property_id);


--
-- TOC entry 18648 (class 1259 OID 354294)
-- Name: fki_cp_rels_range_classes_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cp_rels_range_classes_fk ON nobel_prizes_schema.properties USING btree (range_class_id);


--
-- TOC entry 18642 (class 1259 OID 354295)
-- Name: fki_cp_rels_type_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_cp_rels_type_fk ON nobel_prizes_schema.cp_rels USING btree (type_id);


--
-- TOC entry 18688 (class 1259 OID 354296)
-- Name: fki_datatypes_ns_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_datatypes_ns_fk ON nobel_prizes_schema.datatypes USING btree (ns_id);


--
-- TOC entry 18703 (class 1259 OID 354297)
-- Name: fki_ns_stats_class_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_ns_stats_class_fk ON nobel_prizes_schema.ns_stats USING btree (class_id);


--
-- TOC entry 18704 (class 1259 OID 354298)
-- Name: fki_ns_stats_property_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_ns_stats_property_fk ON nobel_prizes_schema.ns_stats USING btree (property_id);


--
-- TOC entry 18715 (class 1259 OID 354299)
-- Name: fki_pp_rels_property_1_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_pp_rels_property_1_fk ON nobel_prizes_schema.pp_rels USING btree (property_1_id);


--
-- TOC entry 18716 (class 1259 OID 354300)
-- Name: fki_pp_rels_property_2_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_pp_rels_property_2_fk ON nobel_prizes_schema.pp_rels USING btree (property_2_id);


--
-- TOC entry 18717 (class 1259 OID 354301)
-- Name: fki_pp_rels_type_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_pp_rels_type_fk ON nobel_prizes_schema.pp_rels USING btree (type_id);


--
-- TOC entry 18649 (class 1259 OID 354302)
-- Name: fki_properties_ns_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_properties_ns_fk ON nobel_prizes_schema.properties USING btree (ns_id);


--
-- TOC entry 18729 (class 1259 OID 354303)
-- Name: fki_property_annots_class_fk; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX fki_property_annots_class_fk ON nobel_prizes_schema.property_annots USING btree (property_id);


--
-- TOC entry 18666 (class 1259 OID 354304)
-- Name: idx_cc_rels_data; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_cc_rels_data ON nobel_prizes_schema.cc_rels USING gin (data);


--
-- TOC entry 18632 (class 1259 OID 354305)
-- Name: idx_classes_cnt; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_classes_cnt ON nobel_prizes_schema.classes USING btree (cnt);


--
-- TOC entry 18633 (class 1259 OID 354306)
-- Name: idx_classes_data; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_classes_data ON nobel_prizes_schema.classes USING gin (data);


--
-- TOC entry 18634 (class 1259 OID 354307)
-- Name: idx_classes_iri; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_classes_iri ON nobel_prizes_schema.classes USING btree (iri);


--
-- TOC entry 18635 (class 1259 OID 354308)
-- Name: idx_classes_large_superclass_id; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_classes_large_superclass_id ON nobel_prizes_schema.classes USING btree (large_superclass_id) INCLUDE (id);


--
-- TOC entry 18643 (class 1259 OID 354309)
-- Name: idx_cp_rels_class_prop_data; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_cp_rels_class_prop_data ON nobel_prizes_schema.cp_rels USING btree (class_id, type_id, data_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- TOC entry 18644 (class 1259 OID 354310)
-- Name: idx_cp_rels_class_prop_object; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_cp_rels_class_prop_object ON nobel_prizes_schema.cp_rels USING btree (class_id, type_id, object_cnt DESC NULLS LAST) INCLUDE (property_id);


--
-- TOC entry 18645 (class 1259 OID 354311)
-- Name: idx_cp_rels_data; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_cp_rels_data ON nobel_prizes_schema.cp_rels USING gin (data);


--
-- TOC entry 18646 (class 1259 OID 354312)
-- Name: idx_cp_rels_prop_class; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_cp_rels_prop_class ON nobel_prizes_schema.cp_rels USING btree (property_id, type_id, cnt DESC NULLS LAST) INCLUDE (class_id);


--
-- TOC entry 18689 (class 1259 OID 354313)
-- Name: idx_instances_local_name; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_instances_local_name ON nobel_prizes_schema.instances USING btree (local_name text_pattern_ops);


--
-- TOC entry 18690 (class 1259 OID 354314)
-- Name: idx_instances_test; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_instances_test ON nobel_prizes_schema.instances USING gin (test);


--
-- TOC entry 18718 (class 1259 OID 354315)
-- Name: idx_pp_rels_data; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_pp_rels_data ON nobel_prizes_schema.pp_rels USING gin (data);


--
-- TOC entry 18719 (class 1259 OID 354316)
-- Name: idx_pp_rels_p1_t_p2; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_pp_rels_p1_t_p2 ON nobel_prizes_schema.pp_rels USING btree (property_1_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_2_id);


--
-- TOC entry 18720 (class 1259 OID 354317)
-- Name: idx_pp_rels_p2_t_p1; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_pp_rels_p2_t_p1 ON nobel_prizes_schema.pp_rels USING btree (property_2_id, type_id, cnt DESC NULLS LAST) INCLUDE (property_1_id);


--
-- TOC entry 18721 (class 1259 OID 354318)
-- Name: idx_pp_rels_property_1_type; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_pp_rels_property_1_type ON nobel_prizes_schema.pp_rels USING btree (property_1_id) INCLUDE (type_id);


--
-- TOC entry 18722 (class 1259 OID 354319)
-- Name: idx_pp_rels_property_1_type_; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_pp_rels_property_1_type_ ON nobel_prizes_schema.pp_rels USING btree (property_1_id, type_id);


--
-- TOC entry 18723 (class 1259 OID 354320)
-- Name: idx_pp_rels_property_2_type; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_pp_rels_property_2_type ON nobel_prizes_schema.pp_rels USING btree (property_2_id) INCLUDE (type_id);


--
-- TOC entry 18724 (class 1259 OID 354321)
-- Name: idx_pp_rels_property_2_type_; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_pp_rels_property_2_type_ ON nobel_prizes_schema.pp_rels USING btree (property_2_id, type_id);


--
-- TOC entry 18650 (class 1259 OID 354322)
-- Name: idx_properties_cnt; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_properties_cnt ON nobel_prizes_schema.properties USING btree (cnt);


--
-- TOC entry 18651 (class 1259 OID 354323)
-- Name: idx_properties_data; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_properties_data ON nobel_prizes_schema.properties USING gin (data);


--
-- TOC entry 18652 (class 1259 OID 354324)
-- Name: idx_properties_iri; Type: INDEX; Schema: nobel_prizes_schema; Owner: postgres
--

CREATE INDEX idx_properties_iri ON nobel_prizes_schema.properties USING btree (iri);


--
-- TOC entry 18734 (class 2606 OID 354325)
-- Name: annot_types annot_types_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.annot_types
    ADD CONSTRAINT annot_types_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes_schema.ns(id) ON DELETE SET NULL;


--
-- TOC entry 18744 (class 2606 OID 354330)
-- Name: cc_rels cc_rels_class_1_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cc_rels
    ADD CONSTRAINT cc_rels_class_1_fk FOREIGN KEY (class_1_id) REFERENCES nobel_prizes_schema.classes(id) ON DELETE CASCADE;


--
-- TOC entry 18745 (class 2606 OID 354335)
-- Name: cc_rels cc_rels_class_2_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cc_rels
    ADD CONSTRAINT cc_rels_class_2_fk FOREIGN KEY (class_2_id) REFERENCES nobel_prizes_schema.classes(id) ON DELETE CASCADE;


--
-- TOC entry 18746 (class 2606 OID 354340)
-- Name: cc_rels cc_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cc_rels
    ADD CONSTRAINT cc_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes_schema.cc_rel_types(id) ON DELETE CASCADE;


--
-- TOC entry 18747 (class 2606 OID 354345)
-- Name: class_annots class_annots_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.class_annots
    ADD CONSTRAINT class_annots_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes_schema.classes(id) ON DELETE CASCADE;


--
-- TOC entry 18748 (class 2606 OID 354350)
-- Name: class_annots class_annots_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.class_annots
    ADD CONSTRAINT class_annots_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes_schema.annot_types(id) ON DELETE CASCADE;


--
-- TOC entry 18735 (class 2606 OID 354355)
-- Name: classes classes_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.classes
    ADD CONSTRAINT classes_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes_schema.datatypes(id) ON DELETE SET NULL;


--
-- TOC entry 18736 (class 2606 OID 354360)
-- Name: classes classes_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.classes
    ADD CONSTRAINT classes_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes_schema.ns(id) ON DELETE SET NULL;


--
-- TOC entry 18737 (class 2606 OID 354365)
-- Name: classes classes_superclass_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.classes
    ADD CONSTRAINT classes_superclass_fk FOREIGN KEY (principal_super_class_id) REFERENCES nobel_prizes_schema.classes(id) ON UPDATE CASCADE ON DELETE SET NULL NOT VALID;


--
-- TOC entry 18738 (class 2606 OID 354370)
-- Name: cp_rels cp_rels_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cp_rels
    ADD CONSTRAINT cp_rels_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes_schema.classes(id) ON DELETE CASCADE;


--
-- TOC entry 18739 (class 2606 OID 354375)
-- Name: cp_rels cp_rels_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cp_rels
    ADD CONSTRAINT cp_rels_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes_schema.properties(id) ON DELETE CASCADE;


--
-- TOC entry 18740 (class 2606 OID 354380)
-- Name: cp_rels cp_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cp_rels
    ADD CONSTRAINT cp_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes_schema.cp_rel_types(id);


--
-- TOC entry 18749 (class 2606 OID 354385)
-- Name: cpc_rels cpc_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpc_rels
    ADD CONSTRAINT cpc_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES nobel_prizes_schema.cp_rels(id) ON DELETE CASCADE;


--
-- TOC entry 18750 (class 2606 OID 354390)
-- Name: cpc_rels cpc_rels_other_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpc_rels
    ADD CONSTRAINT cpc_rels_other_class_fk FOREIGN KEY (other_class_id) REFERENCES nobel_prizes_schema.classes(id) ON DELETE CASCADE;


--
-- TOC entry 18751 (class 2606 OID 354395)
-- Name: cpd_rels cpd_rels_cp_rel_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpd_rels
    ADD CONSTRAINT cpd_rels_cp_rel_fk FOREIGN KEY (cp_rel_id) REFERENCES nobel_prizes_schema.cp_rels(id) ON DELETE CASCADE;


--
-- TOC entry 18752 (class 2606 OID 354400)
-- Name: cpd_rels cpd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.cpd_rels
    ADD CONSTRAINT cpd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes_schema.datatypes(id) ON DELETE CASCADE;


--
-- TOC entry 18753 (class 2606 OID 354405)
-- Name: datatypes datatypes_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.datatypes
    ADD CONSTRAINT datatypes_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes_schema.ns(id) ON DELETE SET NULL;


--
-- TOC entry 18754 (class 2606 OID 354410)
-- Name: instances instances_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.instances
    ADD CONSTRAINT instances_class_id_fkey FOREIGN KEY (class_id) REFERENCES nobel_prizes_schema.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 18755 (class 2606 OID 354415)
-- Name: instances instances_ns_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.instances
    ADD CONSTRAINT instances_ns_id_fkey FOREIGN KEY (ns_id) REFERENCES nobel_prizes_schema.ns(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 18756 (class 2606 OID 354420)
-- Name: ns_stats ns_stats_class_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.ns_stats
    ADD CONSTRAINT ns_stats_class_fk FOREIGN KEY (class_id) REFERENCES nobel_prizes_schema.classes(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 18757 (class 2606 OID 354425)
-- Name: ns_stats ns_stats_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.ns_stats
    ADD CONSTRAINT ns_stats_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes_schema.ns(id) ON DELETE CASCADE;


--
-- TOC entry 18758 (class 2606 OID 354430)
-- Name: ns_stats ns_stats_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.ns_stats
    ADD CONSTRAINT ns_stats_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes_schema.properties(id);


--
-- TOC entry 18759 (class 2606 OID 354435)
-- Name: pd_rels pd_rels_datatype_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pd_rels
    ADD CONSTRAINT pd_rels_datatype_fk FOREIGN KEY (datatype_id) REFERENCES nobel_prizes_schema.datatypes(id) ON DELETE CASCADE;


--
-- TOC entry 18760 (class 2606 OID 354440)
-- Name: pd_rels pd_rels_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pd_rels
    ADD CONSTRAINT pd_rels_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes_schema.properties(id) ON DELETE CASCADE;


--
-- TOC entry 18761 (class 2606 OID 354445)
-- Name: pp_rels pp_rels_property_1_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pp_rels
    ADD CONSTRAINT pp_rels_property_1_fk FOREIGN KEY (property_1_id) REFERENCES nobel_prizes_schema.properties(id) ON DELETE CASCADE;


--
-- TOC entry 18762 (class 2606 OID 354450)
-- Name: pp_rels pp_rels_property_2_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pp_rels
    ADD CONSTRAINT pp_rels_property_2_fk FOREIGN KEY (property_2_id) REFERENCES nobel_prizes_schema.properties(id) ON DELETE CASCADE;


--
-- TOC entry 18763 (class 2606 OID 354455)
-- Name: pp_rels pp_rels_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.pp_rels
    ADD CONSTRAINT pp_rels_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes_schema.pp_rel_types(id);


--
-- TOC entry 18741 (class 2606 OID 354460)
-- Name: properties properties_domain_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.properties
    ADD CONSTRAINT properties_domain_class_id_fkey FOREIGN KEY (domain_class_id) REFERENCES nobel_prizes_schema.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 18742 (class 2606 OID 354465)
-- Name: properties properties_ns_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.properties
    ADD CONSTRAINT properties_ns_fk FOREIGN KEY (ns_id) REFERENCES nobel_prizes_schema.ns(id) ON DELETE SET NULL;


--
-- TOC entry 18743 (class 2606 OID 354470)
-- Name: properties properties_range_class_id_fkey; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.properties
    ADD CONSTRAINT properties_range_class_id_fkey FOREIGN KEY (range_class_id) REFERENCES nobel_prizes_schema.classes(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 18764 (class 2606 OID 354475)
-- Name: property_annots property_annots_property_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.property_annots
    ADD CONSTRAINT property_annots_property_fk FOREIGN KEY (property_id) REFERENCES nobel_prizes_schema.properties(id) ON DELETE CASCADE;


--
-- TOC entry 18765 (class 2606 OID 354480)
-- Name: property_annots property_annots_type_fk; Type: FK CONSTRAINT; Schema: nobel_prizes_schema; Owner: postgres
--

ALTER TABLE ONLY nobel_prizes_schema.property_annots
    ADD CONSTRAINT property_annots_type_fk FOREIGN KEY (type_id) REFERENCES nobel_prizes_schema.annot_types(id) ON DELETE CASCADE;


--
-- TOC entry 20961 (class 0 OID 0)
-- Dependencies: 7018
-- Name: FUNCTION tapprox(integer); Type: ACL; Schema: nobel_prizes_schema; Owner: postgres
--

REVOKE ALL ON FUNCTION nobel_prizes_schema.tapprox(integer) FROM postgres;
GRANT ALL ON FUNCTION nobel_prizes_schema.tapprox(integer) TO postgres WITH GRANT OPTION;


--
-- TOC entry 20962 (class 0 OID 0)
-- Dependencies: 7017
-- Name: FUNCTION tapprox(bigint); Type: ACL; Schema: nobel_prizes_schema; Owner: postgres
--

REVOKE ALL ON FUNCTION nobel_prizes_schema.tapprox(bigint) FROM postgres;
GRANT ALL ON FUNCTION nobel_prizes_schema.tapprox(bigint) TO postgres WITH GRANT OPTION;


-- Completed on 2024-11-25 23:51:40

--
-- PostgreSQL database dump complete
--

