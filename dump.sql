--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0 (Debian 17.0-1+b1)
-- Dumped by pg_dump version 17.0 (Debian 17.0-1+b1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: citizen; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citizen (
    id integer NOT NULL,
    email text,
    phone text,
    password_hash text NOT NULL,
    full_name text,
    gender text,
    age integer,
    location text,
    is_verified boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT citizen_gender_check CHECK ((gender = ANY (ARRAY['male'::text, 'female'::text, 'other'::text])))
);


ALTER TABLE public.citizen OWNER TO postgres;

--
-- Name: citizen_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.citizen_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.citizen_id_seq OWNER TO postgres;

--
-- Name: citizen_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.citizen_id_seq OWNED BY public.citizen.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post_id uuid,
    citizen_id integer,
    comment text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.comments OWNER TO postgres;

--
-- Name: leader; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leader (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    designation character varying(100),
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    profile_image_url text
);


ALTER TABLE public.leader OWNER TO postgres;

--
-- Name: leader_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leader_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leader_id_seq OWNER TO postgres;

--
-- Name: leader_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leader_id_seq OWNED BY public.leader.id;


--
-- Name: post_likes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_likes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post_id uuid,
    citizen_id integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.post_likes OWNER TO postgres;

--
-- Name: post_media; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_media (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post_id uuid,
    media_url text NOT NULL,
    media_type text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT post_media_media_type_check CHECK ((media_type = ANY (ARRAY['image'::text, 'video'::text, 'document'::text])))
);


ALTER TABLE public.post_media OWNER TO postgres;

--
-- Name: post_shares; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post_shares (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    post_id uuid,
    citizen_id integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.post_shares OWNER TO postgres;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.posts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    leader_id integer,
    body text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.posts OWNER TO postgres;

--
-- Name: citizen id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citizen ALTER COLUMN id SET DEFAULT nextval('public.citizen_id_seq'::regclass);


--
-- Name: leader id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leader ALTER COLUMN id SET DEFAULT nextval('public.leader_id_seq'::regclass);


--
-- Data for Name: citizen; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citizen (id, email, phone, password_hash, full_name, gender, age, location, is_verified, created_at) FROM stdin;
\.


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comments (id, post_id, citizen_id, comment, created_at) FROM stdin;
\.


--
-- Data for Name: leader; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leader (id, name, email, designation, password_hash, created_at, profile_image_url) FROM stdin;
1	Salim Mussa	ulrikjosephat@gmail.com	Ward Leader	$2b$10$yVXQoWReJ3Y138iK3AgoMeGmGt5XU3YkgJE2SKJfKhAKlngqsPAjm	2025-11-18 20:35:48.193979	\N
\.


--
-- Data for Name: post_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_likes (id, post_id, citizen_id, created_at) FROM stdin;
\.


--
-- Data for Name: post_media; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_media (id, post_id, media_url, media_type, created_at) FROM stdin;
69f1873f-c8c0-47d8-b3a5-eb383cbf5636	fe70df72-edef-4407-99a3-866609cddce0	https://res.cloudinary.com/db5isiex3/image/upload/v1763636378/ccp_post/isaw31bf7dxqvtfvtjn4.jpg	image	2025-11-20 13:59:39.345386+03
\.


--
-- Data for Name: post_shares; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post_shares (id, post_id, citizen_id, created_at) FROM stdin;
\.


--
-- Data for Name: posts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.posts (id, leader_id, body, created_at) FROM stdin;
14f99614-5d2f-4cce-b470-19f4fc149ba6	1	Test Message	2025-11-19 20:42:17.053942+03
739b2d6b-5da6-4afb-9bb3-753f61e667b9	1	Ujitoleaji wenu kusafisha mitaa yetu leo umeleta mabadiliko makubwa na ya kuonekana kwa kila mmoja. Nawashukuru wote mliojitokeza, hasa vikundi vya vijana wetu wenye juhudi. Pamoja tunajenga jamii safi na yenye afya zaidi kwa vizazi vijavyo.	2025-11-20 13:57:50.372291+03
fe70df72-edef-4407-99a3-866609cddce0	1	Tumeanza kukarabati barabara ya Sankara–KWALE - FINYA baada ya wiki za uharibifu. Hatua ya kwanza ni kuboresha mifereji ya maji na kusawazisha barabara ili kupunguza mafuriko wakati wa mvua. Asanteni kwa uvumilivu wenu tunapoboresha usafiri na usalama kwa wote.	2025-11-20 13:59:39.338374+03
\.


--
-- Name: citizen_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citizen_id_seq', 1, false);


--
-- Name: leader_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leader_id_seq', 1, true);


--
-- Name: citizen citizen_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citizen
    ADD CONSTRAINT citizen_email_key UNIQUE (email);


--
-- Name: citizen citizen_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citizen
    ADD CONSTRAINT citizen_phone_key UNIQUE (phone);


--
-- Name: citizen citizen_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citizen
    ADD CONSTRAINT citizen_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: leader leader_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leader
    ADD CONSTRAINT leader_email_key UNIQUE (email);


--
-- Name: leader leader_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leader
    ADD CONSTRAINT leader_pkey PRIMARY KEY (id);


--
-- Name: post_likes post_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_pkey PRIMARY KEY (id);


--
-- Name: post_likes post_likes_post_id_citizen_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_post_id_citizen_id_key UNIQUE (post_id, citizen_id);


--
-- Name: post_media post_media_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_media
    ADD CONSTRAINT post_media_pkey PRIMARY KEY (id);


--
-- Name: post_shares post_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_shares
    ADD CONSTRAINT post_shares_pkey PRIMARY KEY (id);


--
-- Name: post_shares post_shares_post_id_citizen_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_shares
    ADD CONSTRAINT post_shares_post_id_citizen_id_key UNIQUE (post_id, citizen_id);


--
-- Name: posts posts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: comments comments_citizen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_citizen_id_fkey FOREIGN KEY (citizen_id) REFERENCES public.citizen(id) ON DELETE SET NULL;


--
-- Name: comments comments_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_citizen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_citizen_id_fkey FOREIGN KEY (citizen_id) REFERENCES public.citizen(id) ON DELETE CASCADE;


--
-- Name: post_likes post_likes_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_likes
    ADD CONSTRAINT post_likes_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: post_media post_media_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_media
    ADD CONSTRAINT post_media_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: post_shares post_shares_citizen_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_shares
    ADD CONSTRAINT post_shares_citizen_id_fkey FOREIGN KEY (citizen_id) REFERENCES public.citizen(id) ON DELETE CASCADE;


--
-- Name: post_shares post_shares_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post_shares
    ADD CONSTRAINT post_shares_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.posts(id) ON DELETE CASCADE;


--
-- Name: posts posts_leader_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT posts_leader_id_fkey FOREIGN KEY (leader_id) REFERENCES public.leader(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO ccp_user;


--
-- Name: TABLE citizen; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.citizen TO ccp_user;


--
-- Name: SEQUENCE citizen_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.citizen_id_seq TO ccp_user;


--
-- Name: TABLE comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.comments TO ccp_user;


--
-- Name: TABLE leader; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.leader TO ccp_user;


--
-- Name: SEQUENCE leader_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.leader_id_seq TO ccp_user;


--
-- Name: TABLE post_likes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.post_likes TO ccp_user;


--
-- Name: TABLE post_media; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.post_media TO ccp_user;


--
-- Name: TABLE post_shares; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.post_shares TO ccp_user;


--
-- Name: TABLE posts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.posts TO ccp_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO ccp_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO ccp_user;


--
-- PostgreSQL database dump complete
--

