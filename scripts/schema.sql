CREATE TABLE course (
	code VARCHAR(512),
	name VARCHAR(512) NOT NULL,
	PRIMARY KEY(code)
);

CREATE TABLE edition (
	code			 VARCHAR(512),
	name			 VARCHAR(512) NOT NULL,
	edition_year		 BIGINT NOT NULL,
	capacity			 BIGINT NOT NULL,
	instructor_users_username VARCHAR(512) NOT NULL,
	course_code		 VARCHAR(512) NOT NULL,
	PRIMARY KEY(code)
);

CREATE TABLE instructor (
	users_username VARCHAR(512),
	PRIMARY KEY(users_username)
);

CREATE TABLE class (
	code		 VARCHAR(512),
	type		 VARCHAR(512) NOT NULL,
	schedule	 VARCHAR(512) NOT NULL,
	edition_code	 VARCHAR(512) NOT NULL,
	classroom_number BIGINT NOT NULL,
	PRIMARY KEY(code)
);

CREATE TABLE classroom (
	number		 BIGINT,
	capacity	 BIGINT NOT NULL,
	location	 VARCHAR(512) NOT NULL,
	campus_building VARCHAR(512) NOT NULL,
	PRIMARY KEY(number)
);

CREATE TABLE degree (
	code VARCHAR(512),
	name VARCHAR(512) NOT NULL,
	fee	 DOUBLE PRECISION NOT NULL,
	PRIMARY KEY(code)
);

CREATE TABLE student (
	number	 BIGSERIAL NOT NULL,
	district	 VARCHAR(512) NOT NULL,
	balance	 DOUBLE PRECISION NOT NULL,
	users_username VARCHAR(512),
	PRIMARY KEY(users_username)
);

CREATE TABLE staff (
	users_username VARCHAR(512),
	PRIMARY KEY(users_username)
);

CREATE TABLE grade (
	evaluation_period	 VARCHAR(512) NOT NULL,
	score			 BIGINT NOT NULL,
	grade_date		 DATE NOT NULL,
	student_users_username VARCHAR(512),
	edition_code		 VARCHAR(512),
	PRIMARY KEY(evaluation_period,student_users_username,edition_code)
);

CREATE TABLE users (
	username VARCHAR(512),
	email	 VARCHAR(512) NOT NULL,
	password VARCHAR(512) NOT NULL,
	PRIMARY KEY(username)
);

CREATE TABLE bill (
	number		 BIGSERIAL,
	amount		 DOUBLE PRECISION NOT NULL,
	subject		 VARCHAR(512) NOT NULL,
	transaction_date	 DATE NOT NULL,
	student_users_username VARCHAR(512),
	PRIMARY KEY(number,student_users_username)
);

CREATE TABLE enrollment (
	enrollment_date	 VARCHAR(512) NOT NULL,
	average		 DOUBLE PRECISION,
	approved_count	 BIGINT,
	status		 VARCHAR(512) NOT NULL,
	student_users_username VARCHAR(512),
	degree_code		 VARCHAR(512),
	PRIMARY KEY(student_users_username,degree_code)
);

CREATE TABLE activity (
	name VARCHAR(512),
	fee	 DOUBLE PRECISION NOT NULL,
	type VARCHAR(512) NOT NULL,
	PRIMARY KEY(name)
);

CREATE TABLE attendance (
	lesson_number		 BIGINT NOT NULL,
	student_users_username VARCHAR(512),
	class_code		 VARCHAR(512),
	PRIMARY KEY(lesson_number,student_users_username,class_code)
);

CREATE TABLE student_activity (
	student_users_username VARCHAR(512),
	activity_name		 VARCHAR(512),
	PRIMARY KEY(student_users_username,activity_name)
);

CREATE TABLE student_class (
	student_users_username VARCHAR(512),
	class_code		 VARCHAR(512),
	PRIMARY KEY(student_users_username,class_code)
);

CREATE TABLE edition_student (
	edition_code		 VARCHAR(512),
	student_users_username VARCHAR(512),
	PRIMARY KEY(edition_code,student_users_username)
);

CREATE TABLE instructor_edition (
	instructor_users_username VARCHAR(512),
	edition_code		 VARCHAR(512),
	PRIMARY KEY(instructor_users_username,edition_code)
);

CREATE TABLE degree_course (
	degree_code VARCHAR(512),
	course_code VARCHAR(512),
	PRIMARY KEY(degree_code,course_code)
);

CREATE TABLE course_course (
	course_code	 VARCHAR(512),
	course_code1 VARCHAR(512),
	PRIMARY KEY(course_code,course_code1)
);

ALTER TABLE course ADD UNIQUE (name);
ALTER TABLE edition ADD UNIQUE (name);
ALTER TABLE edition ADD CONSTRAINT edition_fk1 FOREIGN KEY (instructor_users_username) REFERENCES instructor(users_username);
ALTER TABLE edition ADD CONSTRAINT edition_fk2 FOREIGN KEY (course_code) REFERENCES course(code);
ALTER TABLE instructor ADD CONSTRAINT instructor_fk1 FOREIGN KEY (users_username) REFERENCES users(username);
ALTER TABLE class ADD CONSTRAINT class_fk1 FOREIGN KEY (edition_code) REFERENCES edition(code);
ALTER TABLE class ADD CONSTRAINT class_fk2 FOREIGN KEY (classroom_number) REFERENCES classroom(number);
ALTER TABLE degree ADD UNIQUE (name);
ALTER TABLE student ADD UNIQUE (number);
ALTER TABLE student ADD CONSTRAINT student_fk1 FOREIGN KEY (users_username) REFERENCES users(username);
ALTER TABLE staff ADD CONSTRAINT staff_fk1 FOREIGN KEY (users_username) REFERENCES users(username);
ALTER TABLE grade ADD CONSTRAINT grade_fk1 FOREIGN KEY (student_users_username) REFERENCES student(users_username);
ALTER TABLE grade ADD CONSTRAINT grade_fk2 FOREIGN KEY (edition_code) REFERENCES edition(code);
ALTER TABLE users ADD UNIQUE (email);
ALTER TABLE bill ADD CONSTRAINT bill_fk1 FOREIGN KEY (student_users_username) REFERENCES student(users_username);
ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk1 FOREIGN KEY (student_users_username) REFERENCES student(users_username);
ALTER TABLE enrollment ADD CONSTRAINT enrollment_fk2 FOREIGN KEY (degree_code) REFERENCES degree(code);
ALTER TABLE attendance ADD CONSTRAINT attendance_fk1 FOREIGN KEY (student_users_username) REFERENCES student(users_username);
ALTER TABLE attendance ADD CONSTRAINT attendance_fk2 FOREIGN KEY (class_code) REFERENCES class(code);
ALTER TABLE student_activity ADD CONSTRAINT student_activity_fk1 FOREIGN KEY (student_users_username) REFERENCES student(users_username);
ALTER TABLE student_activity ADD CONSTRAINT student_activity_fk2 FOREIGN KEY (activity_name) REFERENCES activity(name);
ALTER TABLE student_class ADD CONSTRAINT student_class_fk1 FOREIGN KEY (student_users_username) REFERENCES student(users_username);
ALTER TABLE student_class ADD CONSTRAINT student_class_fk2 FOREIGN KEY (class_code) REFERENCES class(code);
ALTER TABLE edition_student ADD CONSTRAINT edition_student_fk1 FOREIGN KEY (edition_code) REFERENCES edition(code);
ALTER TABLE edition_student ADD CONSTRAINT edition_student_fk2 FOREIGN KEY (student_users_username) REFERENCES student(users_username);
ALTER TABLE instructor_edition ADD CONSTRAINT instructor_edition_fk1 FOREIGN KEY (instructor_users_username) REFERENCES instructor(users_username);
ALTER TABLE instructor_edition ADD CONSTRAINT instructor_edition_fk2 FOREIGN KEY (edition_code) REFERENCES edition(code);
ALTER TABLE degree_course ADD CONSTRAINT degree_course_fk1 FOREIGN KEY (degree_code) REFERENCES degree(code);
ALTER TABLE degree_course ADD CONSTRAINT degree_course_fk2 FOREIGN KEY (course_code) REFERENCES course(code);
ALTER TABLE course_course ADD CONSTRAINT course_course_fk1 FOREIGN KEY (course_code) REFERENCES course(code);
ALTER TABLE course_course ADD CONSTRAINT course_course_fk2 FOREIGN KEY (course_code1) REFERENCES course(code);

INSERT INTO public.users VALUES ('staff', 'staff@gmail.com', '1562206543da764123c21bd524674f0a8aaf49c8a89744c97352fe677f7e4006');

