--
-- Data for Name: enrollment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO enrollment (student_users_username, degree_code, enrollment_date, status, average, approved_count)
VALUES 
    ('Afonso', 'CS', '2024-05-19', 'active', NULL, NULL),
    ('Zelas', 'DS', '2024-05-19', 'active', NULL, NULL),
    ('Guijo', 'OS', '2024-05-19', 'active', NULL, NULL),
    ('Joana', 'CS', '2024-05-19', 'active', NULL, NULL),
    ('Amaro', 'DS', '2024-05-19', 'active', NULL, NULL);

--
-- Data for Name: edition_student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO edition_student (edition_code, student_users_username)
VALUES 
    ('CS2025', 'Afonso'),
    ('DS2025', 'Afonso'),
    ('OS2025', 'Afonso'),
    ('SD2025', 'Afonso'),
    ('AI2025', 'Afonso'),
    ('DS2025', 'Zelas'),
    ('SD2025', 'Zelas'),
    ('AI2025', 'Zelas'),
    ('CN2025', 'Zelas'),
    ('WT2025', 'Zelas'),
    ('OS2025', 'Guijo'),
    ('SD2025', 'Guijo'),
    ('CN2025', 'Guijo'),
    ('SE2025', 'Guijo'),
    ('WT2025', 'Guijo'),
    ('CS2025', 'Joana'),
    ('DS2025', 'Joana'),
    ('OS2025', 'Joana'),
    ('SD2025', 'Joana'),
    ('AI2025', 'Joana'),
    ('DS2025', 'Amaro'),
    ('SD2025', 'Amaro'),
    ('AI2025', 'Amaro'),
    ('CN2025', 'Amaro'),
    ('WT2025', 'Amaro');

--
-- Data for Name: grade; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grade (student_users_username, edition_code, evaluation_period, score, grade_date)
VALUES 
    ('Afonso', 'CS2025', 'Normal', 19, '2025-01-15'),
    ('Afonso', 'CS2025', 'Recourse', 20, '2024-06-20'),
    ('Afonso', 'DS2025', 'Normal', 18, '2025-01-15'),
    ('Afonso', 'DS2025', 'Recourse', 19, '2024-07-15'),
    ('Afonso', 'OS2025', 'Normal', 17, '2025-01-15'),
    ('Afonso', 'OS2025', 'Recourse', 18, '2024-08-10'),
    ('Afonso', 'SD2025', 'Normal', 16, '2025-01-15'),
    ('Afonso', 'SD2025', 'Recourse', 17, '2024-09-20'),
    ('Afonso', 'AI2025', 'Normal', 18, '2025-01-15'),
    ('Afonso', 'AI2025', 'Recourse', 19, '2024-10-15'),
    ('Zelas', 'DS2025', 'Normal', 15, '2025-01-15'),
    ('Zelas', 'DS2025', 'Recourse', 17, '2024-06-25'),
    ('Zelas', 'SD2025', 'Normal', 12, '2025-01-15'),
    ('Zelas', 'SD2025', 'Recourse', 14, '2024-07-20'),
    ('Zelas', 'AI2025', 'Normal', 16, '2025-01-15'),
    ('Zelas', 'AI2025', 'Recourse', 18, '2024-08-15'),
    ('Zelas', 'CN2025', 'Normal', 13, '2025-01-15'),
    ('Zelas', 'CN2025', 'Recourse', 15, '2024-09-25'),
    ('Zelas', 'WT2025', 'Normal', 14, '2025-01-15'),
    ('Zelas', 'WT2025', 'Recourse', 16, '2024-10-20'),
    ('Guijo', 'OS2025', 'Normal', 20, '2025-01-15'),
    ('Guijo', 'OS2025', 'Recourse', 20, '2024-06-15'),
    ('Guijo', 'SD2025', 'Normal', 19, '2025-01-15'),
    ('Guijo', 'SD2025', 'Recourse', 20, '2024-07-25'),
    ('Guijo', 'CN2025', 'Normal', 18, '2025-01-15'),
    ('Guijo', 'CN2025', 'Recourse', 19, '2024-08-20'),
    ('Guijo', 'SE2025', 'Normal', 20, '2025-01-15'),
    ('Guijo', 'SE2025', 'Recourse', 20, '2024-09-15'),
    ('Guijo', 'WT2025', 'Normal', 19, '2025-01-15'),
    ('Guijo', 'WT2025', 'Recourse', 20, '2024-10-25'),
    ('Joana', 'CS2025', 'Normal', 8, '2025-01-15'),
    ('Joana', 'CS2025', 'Recourse', 10, '2024-06-10'),
    ('Joana', 'DS2025', 'Normal', 7, '2025-01-15'),
    ('Joana', 'DS2025', 'Recourse', 9, '2024-07-15'),
    ('Joana', 'OS2025', 'Normal', 6, '2025-01-15'),
    ('Joana', 'OS2025', 'Recourse', 8, '2024-08-20'),
    ('Joana', 'SD2025', 'Normal', 5, '2025-01-15'),
    ('Joana', 'SD2025', 'Recourse', 7, '2024-09-25'),
    ('Joana', 'AI2025', 'Normal', 8, '2025-01-15'),
    ('Joana', 'AI2025', 'Recourse', 10, '2024-10-30'),
    ('Amaro', 'DS2025', 'Normal', 13, '2025-01-15'),
    ('Amaro', 'DS2025', 'Recourse', 15, '2024-06-20'),
    ('Amaro', 'SD2025', 'Normal', 14, '2025-01-15'),
    ('Amaro', 'SD2025', 'Recourse', 16, '2024-07-25'),
    ('Amaro', 'AI2025', 'Normal', 12, '2025-01-15'),
    ('Amaro', 'AI2025', 'Recourse', 14, '2024-08-30'),
    ('Amaro', 'CN2025', 'Normal', 13, '2025-01-15'),
    ('Amaro', 'CN2025', 'Recourse', 15, '2024-09-20'),
    ('Amaro', 'WT2025', 'Normal', 14, '2025-01-15'),
    ('Amaro', 'WT2025', 'Recourse', 16, '2024-10-25');

--
-- Data for Name: student_class; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO student_class (student_users_username, class_code)
SELECT es.student_users_username, c.code
FROM edition_student es
JOIN class c ON c.edition_code = es.edition_code
WHERE c.type = 'T';

--
-- Data for Name: student_activity; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO student_activity (student_users_username, activity_name)
VALUES 
    ('Afonso', 'Football'),
    ('Afonso', 'Workshop'),
    ('Zelas', 'Basketball'),
    ('Zelas', 'Hackathon'),
    ('Guijo', 'Tennis'),
    ('Guijo', 'Workshop'),
    ('Joana', 'Football'),
    ('Joana', 'Hackathon'),
    ('Amaro', 'Basketball'),
    ('Amaro', 'Workshop'); 