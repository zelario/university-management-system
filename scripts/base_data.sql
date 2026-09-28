DELETE FROM public.attendance;
DELETE FROM public.student_activity;
DELETE FROM public.student_class;
DELETE FROM public.edition_student;
DELETE FROM public.instructor_edition;
DELETE FROM public.degree_course;
DELETE FROM public.course_course;
DELETE FROM public.bill;
DELETE FROM public.grade;
DELETE FROM public.enrollment;
DELETE FROM public.class;
DELETE FROM public.edition;
DELETE FROM public.student;
DELETE FROM public.staff;
DELETE FROM public.instructor;
DELETE FROM public.activity;
DELETE FROM public.course;
DELETE FROM public.classroom;
DELETE FROM public.degree;
DELETE FROM public.users;

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

-- Started on 2025-04-26 17:08:38

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

--
-- TOC entry 4951 (class 0 OID 16510)
-- Dependencies: 230
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.activity VALUES ('Football', 25, 'Sport');
INSERT INTO public.activity VALUES ('Basketball', 25, 'Sport');
INSERT INTO public.activity VALUES ('Tennis', 20, 'Sport');
INSERT INTO public.activity VALUES ('Workshop', 50, 'Workshop');
INSERT INTO public.activity VALUES ('Hackathon', 10, 'Competition');


--
-- TOC entry 4942 (class 0 OID 16452)
-- Dependencies: 221
-- Data for Name: classroom; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.classroom VALUES (9, 50, 'E', 'DEI');
INSERT INTO public.classroom VALUES (1, 50, 'C', 'DEI');
INSERT INTO public.classroom VALUES (2, 60, 'B', 'DEI');
INSERT INTO public.classroom VALUES (3, 70, 'C', 'DEI');
INSERT INTO public.classroom VALUES (4, 40, 'D', 'DEI');
INSERT INTO public.classroom VALUES (5, 80, 'E', 'DEI');
INSERT INTO public.classroom VALUES (6, 50, 'A', 'EC');
INSERT INTO public.classroom VALUES (7, 60, 'B', 'EC');
INSERT INTO public.classroom VALUES (8, 70, 'C', 'EC');
INSERT INTO public.classroom VALUES (10, 60, 'E', 'EC');
INSERT INTO public.classroom VALUES (11, 40, 'A', 'DEI');
INSERT INTO public.classroom VALUES (12, 50, 'B', 'DEI');
INSERT INTO public.classroom VALUES (13, 60, 'C', 'DEI');
INSERT INTO public.classroom VALUES (14, 70, 'D', 'DEI');
INSERT INTO public.classroom VALUES (15, 80, 'E', 'DEI');


--
-- TOC entry 4938 (class 0 OID 16424)
-- Dependencies: 217
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.course VALUES ('DB', 'Databases');
INSERT INTO public.course VALUES ('CS', 'Computer Science');
INSERT INTO public.course VALUES ('DS', 'Data Structures');
INSERT INTO public.course VALUES ('OS', 'Operating Systems');
INSERT INTO public.course VALUES ('SD', 'Software Development');
INSERT INTO public.course VALUES ('AI', 'Artificial Intelligence');
INSERT INTO public.course VALUES ('ML', 'Machine Learning');
INSERT INTO public.course VALUES ('CN', 'Computer Networks');
INSERT INTO public.course VALUES ('SE', 'Software Engineering');
INSERT INTO public.course VALUES ('WT', 'Web Technologies');


--
-- TOC entry 4948 (class 0 OID 16489)
-- Dependencies: 227
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES ('Afonso', 'afonso@gmail.com', 'd6d6170dc82ad8cf3ea91cf87485232e00909222eeee308202718528f890bb8a');
INSERT INTO public.users VALUES ('Capinha', 'capinha@gmail.com', 'd39f1ae6dfafc75fd7b2951aafe8cdc94591166ee9e050b386b288b670279c43');
INSERT INTO public.users VALUES ('Ricardo', 'ricardo@gmail.com', '9ed28ffcc0b316567fbc971b758ba541c6d9a6b869d4a99598e25841cabae5b8');
INSERT INTO public.users VALUES ('Zelas', 'zelas@gmail.com', '781279ccf3ee25bc33f3878ee809b3b83380d323ad4fb971cd9df68daed80b55');
INSERT INTO public.users VALUES ('Guijo', 'guijo@gmail.com', '457f796fde2c988c328c0e25a41aa5b61d2623969e78b6eed55938194a65392d');
INSERT INTO public.users VALUES ('Joana', 'joana@gmail.com', '832dfcaa11ea73f1440ad19535906e6b18a8b3c9505b57c7152645eb0b5477a4');
INSERT INTO public.users VALUES ('Amaro', 'amaro@gmail.com', '6e00cd562cc2d88e238dfb81d9439de7ec843ee9d0c9879d549cb1436786f975');


--
-- TOC entry 4940 (class 0 OID 16438)
-- Dependencies: 219
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.instructor VALUES ('Ricardo');


--
-- TOC entry 4939 (class 0 OID 16431)
-- Dependencies: 218
-- Data for Name: edition; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.edition VALUES ('DB2025', 'Databases 2025', 2025, 50, 'Ricardo', 'DB');
INSERT INTO public.edition VALUES ('CS2025', 'Computer Science 2025', 2025, 50, 'Ricardo', 'CS');
INSERT INTO public.edition VALUES ('CS2026', 'Computer Science 2026', 2026, 50, 'Ricardo', 'CS');
INSERT INTO public.edition VALUES ('DS2025', 'Data Structures 2025', 2025, 50, 'Ricardo', 'DS');
INSERT INTO public.edition VALUES ('DS2026', 'Data Structures 2026', 2026, 50, 'Ricardo', 'DS');
INSERT INTO public.edition VALUES ('OS2025', 'Operating Systems 2025', 2025, 50, 'Ricardo', 'OS');
INSERT INTO public.edition VALUES ('OS2026', 'Operating Systems 2026', 2026, 50, 'Ricardo', 'OS');
INSERT INTO public.edition VALUES ('SD2025', 'Software Development 2025', 2025, 50, 'Ricardo', 'SD');
INSERT INTO public.edition VALUES ('SD2026', 'Software Development 2026', 2026, 50, 'Ricardo', 'SD');
INSERT INTO public.edition VALUES ('DB2026', 'Database Systems 2026', 2026, 50, 'Ricardo', 'DB');
INSERT INTO public.edition VALUES ('AI2025', 'Artificial Intelligence 2025', 2025, 50, 'Ricardo', 'AI');
INSERT INTO public.edition VALUES ('AI2026', 'Artificial Intelligence 2026', 2026, 50, 'Ricardo', 'AI');
INSERT INTO public.edition VALUES ('ML2025', 'Machine Learning 2025', 2025, 50, 'Ricardo', 'ML');
INSERT INTO public.edition VALUES ('ML2026', 'Machine Learning 2026', 2026, 50, 'Ricardo', 'ML');
INSERT INTO public.edition VALUES ('CN2025', 'Computer Networks 2025', 2025, 50, 'Ricardo', 'CN');
INSERT INTO public.edition VALUES ('CN2026', 'Computer Networks 2026', 2026, 50, 'Ricardo', 'CN');
INSERT INTO public.edition VALUES ('SE2025', 'Software Engineering 2025', 2025, 50, 'Ricardo', 'SE');
INSERT INTO public.edition VALUES ('SE2026', 'Software Engineering 2026', 2026, 50, 'Ricardo', 'SE');
INSERT INTO public.edition VALUES ('WT2025', 'Web Technologies 2025', 2025, 50, 'Ricardo', 'WT');
INSERT INTO public.edition VALUES ('WT2026', 'Web Technologies 2026', 2026, 50, 'Ricardo', 'WT');


--
-- TOC entry 4941 (class 0 OID 16445)
-- Dependencies: 220
-- Data for Name: class; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.class VALUES ('CS2025T', 'T', 'Monday 10:00-12:00', 'CS2025', 1);
INSERT INTO public.class VALUES ('CS2025TP', 'TP', 'Wednesday 10:00-12:00', 'CS2025', 2);
INSERT INTO public.class VALUES ('CS2025PL1', 'PL', 'Tuesday 14:00-16:00', 'CS2025', 3);
INSERT INTO public.class VALUES ('CS2025PL2', 'PL', 'Thursday 14:00-16:00', 'CS2025', 4);
INSERT INTO public.class VALUES ('CS2025PL3', 'PL', 'Friday 14:00-16:00', 'CS2025', 5);
INSERT INTO public.class VALUES ('DS2025T', 'T', 'Monday 10:00-12:00', 'DS2025', 6);
INSERT INTO public.class VALUES ('DS2025TP', 'TP', 'Wednesday 10:00-12:00', 'DS2025', 7);
INSERT INTO public.class VALUES ('DS2025PL1', 'PL', 'Tuesday 14:00-16:00', 'DS2025', 8);
INSERT INTO public.class VALUES ('DS2025PL2', 'PL', 'Thursday 14:00-16:00', 'DS2025', 9);
INSERT INTO public.class VALUES ('DS2025PL3', 'PL', 'Friday 14:00-16:00', 'DS2025', 10);
INSERT INTO public.class VALUES ('OS2025T', 'T', 'Monday 10:00-12:00', 'OS2025', 11);
INSERT INTO public.class VALUES ('OS2025TP', 'TP', 'Wednesday 10:00-12:00', 'OS2025', 12);
INSERT INTO public.class VALUES ('OS2025PL1', 'PL', 'Tuesday 14:00-16:00', 'OS2025', 13);
INSERT INTO public.class VALUES ('OS2025PL2', 'PL', 'Thursday 14:00-16:00', 'OS2025', 14);
INSERT INTO public.class VALUES ('OS2025PL3', 'PL', 'Friday 14:00-16:00', 'OS2025', 15);
INSERT INTO public.class VALUES ('SD2025T', 'T', 'Monday 10:00-12:00', 'SD2025', 1);
INSERT INTO public.class VALUES ('SD2025TP', 'TP', 'Wednesday 10:00-12:00', 'SD2025', 2);
INSERT INTO public.class VALUES ('SD2025PL1', 'PL', 'Tuesday 14:00-16:00', 'SD2025', 3);
INSERT INTO public.class VALUES ('SD2025PL2', 'PL', 'Thursday 14:00-16:00', 'SD2025', 4);
INSERT INTO public.class VALUES ('SD2025PL3', 'PL', 'Friday 14:00-16:00', 'SD2025', 5);
INSERT INTO public.class VALUES ('DB2025T', 'T', 'Monday 10:00-12:00', 'DB2025', 6);
INSERT INTO public.class VALUES ('DB2025TP', 'TP', 'Wednesday 10:00-12:00', 'DB2025', 7);
INSERT INTO public.class VALUES ('DB2025PL1', 'PL', 'Tuesday 14:00-16:00', 'DB2025', 8);
INSERT INTO public.class VALUES ('DB2025PL2', 'PL', 'Thursday 14:00-16:00', 'DB2025', 9);
INSERT INTO public.class VALUES ('DB2025PL3', 'PL', 'Friday 14:00-16:00', 'DB2025', 10);
INSERT INTO public.class VALUES ('AI2025T', 'T', 'Monday 10:00-12:00', 'AI2025', 11);
INSERT INTO public.class VALUES ('AI2025TP', 'TP', 'Wednesday 10:00-12:00', 'AI2025', 12);
INSERT INTO public.class VALUES ('AI2025PL1', 'PL', 'Tuesday 14:00-16:00', 'AI2025', 13);
INSERT INTO public.class VALUES ('AI2025PL2', 'PL', 'Thursday 14:00-16:00', 'AI2025', 14);
INSERT INTO public.class VALUES ('AI2025PL3', 'PL', 'Friday 14:00-16:00', 'AI2025', 15);
INSERT INTO public.class VALUES ('ML2025T', 'T', 'Monday 10:00-12:00', 'ML2025', 1);
INSERT INTO public.class VALUES ('ML2025TP', 'TP', 'Wednesday 10:00-12:00', 'ML2025', 2);
INSERT INTO public.class VALUES ('ML2025PL1', 'PL', 'Tuesday 14:00-16:00', 'ML2025', 3);
INSERT INTO public.class VALUES ('ML2025PL2', 'PL', 'Thursday 14:00-16:00', 'ML2025', 4);
INSERT INTO public.class VALUES ('ML2025PL3', 'PL', 'Friday 14:00-16:00', 'ML2025', 5);
INSERT INTO public.class VALUES ('CN2025T', 'T', 'Monday 10:00-12:00', 'CN2025', 6);
INSERT INTO public.class VALUES ('CN2025TP', 'TP', 'Wednesday 10:00-12:00', 'CN2025', 7);
INSERT INTO public.class VALUES ('CN2025PL1', 'PL', 'Tuesday 14:00-16:00', 'CN2025', 8);
INSERT INTO public.class VALUES ('CN2025PL2', 'PL', 'Thursday 14:00-16:00', 'CN2025', 9);
INSERT INTO public.class VALUES ('CN2025PL3', 'PL', 'Friday 14:00-16:00', 'CN2025', 10);
INSERT INTO public.class VALUES ('SE2025T', 'T', 'Monday 10:00-12:00', 'SE2025', 11);
INSERT INTO public.class VALUES ('SE2025TP', 'TP', 'Wednesday 10:00-12:00', 'SE2025', 12);
INSERT INTO public.class VALUES ('SE2025PL1', 'PL', 'Tuesday 14:00-16:00', 'SE2025', 13);
INSERT INTO public.class VALUES ('SE2025PL2', 'PL', 'Thursday 14:00-16:00', 'SE2025', 14);
INSERT INTO public.class VALUES ('SE2025PL3', 'PL', 'Friday 14:00-16:00', 'SE2025', 15);
INSERT INTO public.class VALUES ('WT2025T', 'T', 'Monday 10:00-12:00', 'WT2025', 1);
INSERT INTO public.class VALUES ('WT2025TP', 'TP', 'Wednesday 10:00-12:00', 'WT2025', 2);
INSERT INTO public.class VALUES ('WT2025PL1', 'PL', 'Tuesday 14:00-16:00', 'WT2025', 3);
INSERT INTO public.class VALUES ('WT2025PL2', 'PL', 'Thursday 14:00-16:00', 'WT2025', 4);
INSERT INTO public.class VALUES ('WT2025PL3', 'PL', 'Friday 14:00-16:00', 'WT2025', 5);


--
-- TOC entry 4945 (class 0 OID 16467)
-- Dependencies: 224
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student VALUES (1, 'Coimbra', 3000, 'Afonso');
INSERT INTO public.student VALUES (2, 'Coimbra', 3000, 'Zelas');
INSERT INTO public.student VALUES (3, 'Lisboa', 3000, 'Guijo');
INSERT INTO public.student VALUES (4, 'Porto', 3000, 'Joana');
INSERT INTO public.student VALUES (5, 'Aveiro', 3000, 'Amaro');

--
-- TOC entry 4952 (class 0 OID 16517)
-- Dependencies: 231
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4949 (class 0 OID 16496)
-- Dependencies: 228
-- Data for Name: bill; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4958 (class 0 OID 16559)
-- Dependencies: 237
-- Data for Name: course_course; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4943 (class 0 OID 16459)
-- Dependencies: 222
-- Data for Name: degree; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.degree VALUES ('CS', 'Computer Science', 700);
INSERT INTO public.degree VALUES ('OS', 'Operating Systems', 600);
INSERT INTO public.degree VALUES ('DS', 'Data Science', 500);


--
-- TOC entry 4957 (class 0 OID 16552)
-- Dependencies: 236
-- Data for Name: degree_course; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.degree_course VALUES ('CS', 'CS');
INSERT INTO public.degree_course VALUES ('CS', 'DS');
INSERT INTO public.degree_course VALUES ('CS', 'OS');
INSERT INTO public.degree_course VALUES ('CS', 'SD');
INSERT INTO public.degree_course VALUES ('CS', 'AI');
INSERT INTO public.degree_course VALUES ('DS', 'DS');
INSERT INTO public.degree_course VALUES ('DS', 'SD');
INSERT INTO public.degree_course VALUES ('DS', 'AI');
INSERT INTO public.degree_course VALUES ('DS', 'CN');
INSERT INTO public.degree_course VALUES ('DS', 'WT');
INSERT INTO public.degree_course VALUES ('OS', 'OS');
INSERT INTO public.degree_course VALUES ('OS', 'SD');
INSERT INTO public.degree_course VALUES ('OS', 'CN');
INSERT INTO public.degree_course VALUES ('OS', 'SE');
INSERT INTO public.degree_course VALUES ('OS', 'WT');


--
-- TOC entry 4955 (class 0 OID 16538)
-- Dependencies: 234
-- Data for Name: edition_student; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4950 (class 0 OID 16503)
-- Dependencies: 229
-- Data for Name: enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4947 (class 0 OID 16482)
-- Dependencies: 226
-- Data for Name: grade; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4956 (class 0 OID 16545)
-- Dependencies: 235
-- Data for Name: instructor_edition; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4946 (class 0 OID 16475)
-- Dependencies: 225
-- Data for Name: staff; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.staff VALUES ('Capinha');


--
-- TOC entry 4953 (class 0 OID 16524)
-- Dependencies: 232
-- Data for Name: student_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4954 (class 0 OID 16531)
-- Dependencies: 233
-- Data for Name: student_class; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 223
-- Name: student_number_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--


-- Completed on 2025-04-26 17:08:39

--
-- PostgreSQL database dump complete
--

