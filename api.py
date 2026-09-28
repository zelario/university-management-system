import flask
import logging
import psycopg2
import hashlib
import jwt
import os
from functools import wraps
from dotenv import load_dotenv

###########################################################
## GLOBALS
###########################################################

load_dotenv()
app = flask.Flask(__name__)
app.config['JWT_SECRET_KEY'] = str(os.getenv('SECRET_KEY'))

StatusCodes = {
    'success': 200,
    'api_error': 400,
    'internal_error': 500,
    'unauthorized': 401
}

##########################################################
## DATABASE ACCESS
##########################################################

def db_connection():
    db = psycopg2.connect(
        user=os.getenv('USER'),
        password=os.getenv('PASSWORD'),
        host=os.getenv('HOST'),
        port=os.getenv('PORT'),
        database=os.getenv('DATABASE')
    )
    return db

##########################################################
## AUTHENTICATION HELPERS
##########################################################

def get_username():

    token = flask.request.headers.get('Authorization')

    try:
        decoded_token = jwt.decode(token.split(" ")[1], app.config['JWT_SECRET_KEY'], algorithms=['HS256'])
        username = decoded_token['username']
        return username

    except Exception as error:
        logger.warning('No user authenticated')
        return None

def token_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):

        token = flask.request.headers.get('Authorization')
        logger.debug(f'token: {token}')
        
        try:
            decoded_token = jwt.decode(token.split(" ")[1], app.config['JWT_SECRET_KEY'], algorithms=['HS256'])

        except Exception as error:
            logger.warning('No user authenticated')
            return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': 'No user authenticated',})

        return f(*args, **kwargs)
    return decorated

def role_required(required_role):
    def wrapper(f):
        @wraps(f)
        def decorated(*args, **kwargs):

            username = get_username()

            try:
                with db_connection() as conn:
                    with conn.cursor() as cur:

                        # Check user role
                        cur.execute(
                            '''
                            SELECT 
                                CASE 
                                    WHEN (SELECT users_username FROM Student WHERE users_username = %s) IS NOT NULL THEN 'student'
                                    WHEN (SELECT users_username FROM Staff WHERE users_username = %s) IS NOT NULL THEN 'staff'
                                    ELSE 'instructor'
                                END AS role
                            ''', 
                            (username, username)
                        )
                        role = cur.fetchone()[0]

            except Exception as error:
                logger.error(f'user_role - error: {error}')
                return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error)})

            if role not in required_role:
                logger.warning(f'User {username} does not have the required role: {required_role}')
                return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': f'User does not have the required role: {required_role}'})

            return f(*args, **kwargs)
        return decorated
    return wrapper

##########################################################      
## FUNCTIONS
##########################################################

##
## Register user
##
## Default function to register a user
##
def register_user(username, email, password, role, district=None, balance=None):

    if not username or not email or not password:
        logger.warning('POST /dbproj/register - username, email, and password are required')
        return {'status': StatusCodes['api_error'], 'errors': 'Username, email, and password are required', 'results': None}
    
    # Hash the password using SHA-256
    hashed_password = hashlib.sha256(password.encode('utf-8')).hexdigest()

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the username already exists
                cur.execute('SELECT * FROM Users WHERE username = %s FOR UPDATE', (username,))
                if cur.fetchone() is not None:
                    logger.warning('POST /dbproj/register - username already exists')
                    return {'status': StatusCodes['unauthorized'], 'errors': 'Username already exists', 'results': None}

                # Check if the email already exists
                cur.execute('SELECT * FROM Users WHERE email = %s FOR UPDATE', (email,))
                if cur.fetchone() is not None:
                    logger.warning('POST /dbproj/register - email already exists')
                    return {'status': StatusCodes['unauthorized'], 'errors': 'Email already exists', 'results': None}

                # Insert the user 
                cur.execute('INSERT INTO Users (username, email, password) VALUES (%s, %s, %s)', (username, email, hashed_password))
                if role == 'Student':
                    cur.execute('INSERT INTO Student (users_username, district, balance) VALUES (%s, %s, %s)', (username, district, balance))
                else:
                    cur.execute(f'INSERT INTO {role} (users_username) VALUES (%s)', (username,))

                conn.commit()

    except Exception as error:
        logger.error(f'POST /dbproj/register - error: {error}')
        conn.rollback()
        return {'status': StatusCodes['internal_error'], 'errors': str(error), 'results': None}

    logger.info(f'POST /dbproj/register - {role} {username} registered')
    return {'status': StatusCodes['success'], 'errors': None, 'results': username}

##########################################################
## ENDPOINTS
##########################################################

##
## Login user                                             
## 
## Authenticate user and return a JWT token
##
@app.route('/dbproj/user', methods=['PUT'])
def login_user():

    data = flask.request.get_json()
    username = data.get('username')
    password = data.get('password')

    logger.debug(f'PUT /dbproj/user - username: {username}')

    if not username or not password:
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Username and password are required', 'results': None})

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the user exists
                cur.execute('SELECT username, password FROM Users WHERE username = %s', (username,))
                user = cur.fetchone()
                if user is None:
                    logger.warning('PUT /dbproj/user - invalid username')
                    return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': 'Invalid username or password', 'results': None})

                db_username, db_password = user
                
                hashed_password = hashlib.sha256(password.encode('utf-8')).hexdigest()

                # Check if the password is correct
                if hashed_password != db_password:
                    logger.warning('PUT /dbproj/user - wrong password')
                    return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': 'Invalid username or password', 'results': None})

                token = jwt.encode({"username": db_username}, app.config['JWT_SECRET_KEY'], algorithm='HS256')

    except Exception as error:
        logger.error(f'PUT /dbproj/user - error: {error}')
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error), 'results': None})

    logger.info(f'PUT /dbproj/user - user {username} logged')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None, 'results': token})

##
## Register student                                                 
##
## Register a new student
##
@app.route('/dbproj/register/student', methods=['POST'])
@token_required
@role_required('staff')
def register_student():

    data = flask.request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')
    district = data.get('district')
    balance = data.get('balance')

    logger.debug(f'POST /dbproj/register/student - username: {username}, email: {email}, district: {district}, balance: {balance}')

    try:
        balance = float(balance)
        if balance < 0:
            raise ValueError("Balance cannot be negative")
    except (ValueError, TypeError):
        logger.warning('POST /dbproj/register/student - invalid balance')
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Invalid balance'})

    return flask.jsonify(register_user(username, email, password, 'Student', district, balance))

##
## Register staff                                        
##
## Register a new staff member
##
@app.route('/dbproj/register/staff', methods=['POST'])
@token_required
@role_required('staff')
def register_staff():

    data = flask.request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    logger.debug(f'POST /dbproj/register/staff - username: {username}, email: {email}')

    return flask.jsonify(register_user(username, email, password, 'Staff'))

##
## Register instructor                               
##
## Register a new instructor
##
@app.route('/dbproj/register/instructor', methods=['POST'])
@token_required
@role_required('staff')
def register_instructor():

    data = flask.request.get_json()
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')

    logger.debug(f'POST /dbproj/register/instructor - username: {username}, email: {email}')

    return flask.jsonify(register_user(username, email, password, 'Instructor'))

##
## Enroll degree                                           
##
## Enroll a student in a degree program
##
@app.route('/dbproj/enroll_degree/<degree_id>', methods=['POST'])
@token_required
@role_required('staff')
def enroll_degree(degree_id):

    data = flask.request.get_json()
    student_number = data.get('student_id')
    enrollment_date = data.get('date')

    logger.debug(f'POST /dbproj/enroll_degree/ - degree: {degree_id}, student_number: {student_number}, enrollment_date: {enrollment_date}')

    if not student_number or not enrollment_date:
        logger.warning('POST /dbproj/enroll_degree - missing parameters')
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student id and enrollment date are required', 'results': None})

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the student exists
                cur.execute('SELECT users_username FROM student WHERE number = %s', (student_number,))
                result = cur.fetchone()
                if result is None:
                    logger.warning('POST /dbproj/enroll_degree - student not found')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student not found'})
                else:
                    student_username = result

                ## Check if the degree exists
                cur.execute('SELECT code FROM degree WHERE code = %s', (degree_id,))
                if cur.fetchone() is None:
                    logger.warning('POST /dbproj/enroll_degree - degree not found')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Degree not found'})

                # Check if the student is already enrolled in a degree
                cur.execute('SELECT * FROM enrollment WHERE student_users_username = %s FOR UPDATE', (student_username,))
                if cur.fetchone() is not None:
                    logger.warning('POST /dbproj/enroll_degree - student already enrolled in a degree')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student is already enrolled a degree'})

                cur.execute(
                    '''
                    INSERT INTO enrollment (enrollment_date, average, approved_count, status, student_users_username, degree_code)
                    VALUES (%s, NULL, NULL, 'active', %s, %s)
                    ''',
                    (enrollment_date, student_username, degree_id)
                )
                conn.commit()

    except Exception as error:
        logger.error(f'POST /dbproj/enroll_degree - error: {error}')
        conn.rollback()
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error)})

    logger.info(f'POST /dbproj/enroll_degree - student {student_username} enrolled in degree {degree_id}')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None})

##
## Enroll activity                               
##
## Enroll a student in an activity
##
@app.route('/dbproj/enroll_activity/<activity_id>', methods=['POST'])
@token_required
@role_required('student')
def enroll_activity(activity_id):

    logger.debug(f'POST /dbproj/enroll_activity/{activity_id} - activity_id: {activity_id}')

    student_username = get_username()

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                #Check if activity exists
                cur.execute('SELECT name FROM activity WHERE name = %s', (activity_id,))
                if cur.fetchone() is None:
                    logger.warning(f'POST /dbproj/enroll_activity/{activity_id} - activity not found')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Activity not found'})

                # Check if the student is already enrolled in the activity
                cur.execute('SELECT * FROM student_activity WHERE student_users_username = %s AND activity_name = %s FOR UPDATE', (student_username, activity_id))
                if cur.fetchone() is not None:
                    logger.warning(f'POST /dbproj/enroll_activity/{activity_id} - student already enrolled in activity')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student is already enrolled in this activity'})

                # Enroll the student in the activity
                cur.execute('INSERT INTO student_activity (student_users_username, activity_name) VALUES (%s, %s)', (student_username, activity_id))
                conn.commit()

    except Exception as error:
        logger.error(f'POST /dbproj/enroll_activity/{activity_id} - error: {error}')
        conn.rollback()
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error)})

    logger.info(f'POST /dbproj/enroll_activity/{activity_id} - student {student_username} enrolled in activity {activity_id}')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None})

##
## Enroll course edition                               
##
## Enroll a student in a course edition
##
@app.route('/dbproj/enroll_course_edition/<course_edition_id>', methods=['POST'])
@token_required
@role_required('student')
def enroll_course_edition(course_edition_id):

    logger.debug(f'POST /dbproj/enroll_course_edition/{course_edition_id} - course_edition_id: {course_edition_id}')
    
    data = flask.request.get_json()
    classes = data.get('classes', [])

    if not classes:
        logger.warning('POST /dbproj/enroll_course_edition - classes not found')
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'No classes found', 'results': None})

    student_username = get_username()

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the course edition exists
                cur.execute('SELECT course_code FROM edition WHERE code = %s', (course_edition_id,))
                edition = cur.fetchone()
                if edition is None:
                    logger.warning('POST /dbproj/enroll_course_edition - course edition not found')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Course edition not found'})
                course_code = edition

                # Check if the course is part of a degree the student is enrolled in
                cur.execute(
                    '''
                    SELECT degree_code 
                    FROM degree_course 
                    WHERE course_code = %s AND degree_code IN (
                        SELECT degree_code 
                        FROM enrollment 
                        WHERE student_users_username = %s AND status = 'active'
                    )
                    ''',
                    (course_code, student_username)
                )
                if cur.fetchone() is None:
                    logger.warning('POST /dbproj/enroll_course_edition - course edition not part of the degree the student is enrolled in')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Course edition is not part of a degree the student is enrolled in'})
                
                # Check if the course edition is already full
                cur.execute('LOCK TABLE edition_student IN EXCLUSIVE MODE')
                cur.execute('SELECT COUNT(*) FROM edition_student WHERE edition_code = %s', (course_edition_id,))
                enrolled_count = cur.fetchone()
                
                cur.execute('SELECT capacity FROM edition WHERE code = %s', (course_edition_id,))
                capacity = cur.fetchone()
                if(enrolled_count==capacity):
                    logger.warning('POST /dbproj/enroll_course_edition - course edition is already full')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Course edition is already full'})
                
                #Check if the student has the required prerequisites
                cur.execute('SELECT course_code1 FROM course_course WHERE course_code = %s', (course_code,))
                prerequisites = cur.fetchall()
                for prerequisite in prerequisites:
                    prerequisite_code = prerequisite[0]
                    
                    cur.execute(
                        '''
                        SELECT grade.score
                        FROM grade
                        JOIN edition ON grade.edition_code = edition.code
                        WHERE edition.course_code = %s AND grade.student_users_username = %s AND grade.score >= 10
                        ''',
                        (prerequisite_code, student_username)
                    )
                    if cur.fetchone() is None:
                        logger.warning('POST /dbproj/enroll_course_edition - student does not meet the prerequisite')
                        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': f'Student does not meet the prerequisite: {prerequisite_code}'})

                # Check if the student is already enrolled in the course edition
                cur.execute('SELECT * FROM edition_student WHERE edition_code = %s AND student_users_username = %s', (course_edition_id, student_username))
                if cur.fetchone() is not None:
                    logger.warning('POST /dbproj/enroll_course_edition - student already enrolled in course edition')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student is already enrolled in this course edition'})

                # Validate the provided classes
                for class_code in classes:
                    cur.execute('SELECT code FROM class WHERE code = %s AND edition_code = %s', (class_code, course_edition_id))
                    if cur.fetchone() is None:
                        logger.warning('POST /dbproj/enroll_course_edition - class does not belong to the course edition')
                        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': f'Class {class_code} does not belong to the course edition'})

                # Enroll the student in the course edition
                cur.execute('INSERT INTO edition_student (edition_code, student_users_username) VALUES (%s, %s)', (course_edition_id, student_username))

                # Enroll the student in the selected classes
                for class_code in classes:
                    cur.execute('INSERT INTO student_class (student_users_username, class_code) VALUES (%s, %s)', (student_username, class_code))

                conn.commit()

    except Exception as error:
        logger.error(f'POST /dbproj/enroll_course_edition - error: {error}')
        conn.rollback()
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error)})

    logger.info(f'POST /dbproj/enroll_course_edition - student {student_username} enrolled in course edition {course_edition_id}')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None})

##
## Submit grades                               
##
## Submit grades for a course edition if the user is an instructor
##
@app.route('/dbproj/submit_grades/<course_edition_id>', methods=['POST'])
@token_required
@role_required('instructor')
def submit_grades(course_edition_id):
    
    data = flask.request.get_json()
    period = data.get('period')
    grades = data.get('grades', [])

    logger.debug(f'POST /dbproj/submit_grades/{course_edition_id} - period: {period}, grades: {grades}')

    if not period or not grades:
        logger.warning('POST /dbproj/submit_grades - Evaluation period and grades are required')
        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Evaluation period and grades are required', 'results': None})

    instructor_username = get_username()

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the instructor is assigned to the course edition
                cur.execute('SELECT * FROM edition WHERE instructor_users_username = %s AND code = %s', (instructor_username, course_edition_id))
                if cur.fetchone() is None:
                    logger.warning('POST /dbproj/submit_grades - instructor not assigned to course edition')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Instructor is not assigned to this course edition'})

                # Validate and insert grades
                for grade in grades:
                    student_id, score, grade_date = grade

                    if not student_id or score is None or not grade_date:
                        logger.warning('POST /dbproj/submit_grades - Each grade must include student id, score, and date')
                        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Each grade must include student id, score, and date'})
                    
                    #Check if the student exists
                    cur.execute('SELECT users_username FROM student WHERE number = %s', (student_id,))
                    student_username = cur.fetchone()
                    if student_username is None:
                        logger.warning('POST /dbproj/submit_grades - student not found')
                        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student not found'})

                    # Check if the student is enrolled in the course edition
                    cur.execute('SELECT * FROM edition_student WHERE edition_code = %s AND student_users_username = %s', (course_edition_id, student_username))
                    if cur.fetchone() is None:
                        logger.warning('POST /dbproj/submit_grades - student not enrolled in course edition')
                        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student not enrolled in this course edition'})

                    # Check if grade is already submitted for the student
                    cur.execute('SELECT * FROM grade WHERE evaluation_period = %s AND student_users_username = %s AND edition_code = %s FOR UPDATE', (period, student_username, course_edition_id))
                    if cur.fetchone() is not None:
                        logger.warning('POST /dbproj/submit_grades - grade already submitted for student')
                        return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Grade already submitted for the student in this evaluation period'})

                    # Insert grade
                    cur.execute(
                        '''
                        INSERT INTO grade (evaluation_period, score, grade_date, student_users_username, edition_code)
                        VALUES (%s, %s, %s, %s, %s)
                        ''',
                        (period, score, grade_date, student_username, course_edition_id)
                    )

                conn.commit()

    except Exception as error:
        logger.error(f'POST /dbproj/submit_grades - error: {error}')
        conn.rollback()
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error)})

    logger.info(f'POST /dbproj/submit_grades - instructor {instructor_username} submitted grades for course edition {course_edition_id}')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None})

##
## Student details                               
##
## Get details of a student
##
@app.route('/dbproj/student_details/<student_id>', methods=['GET'])
@token_required
@role_required(['staff', 'student'])
def student_details(student_id):

    logger.debug(f'GET /dbproj/student_details/{student_id} - student_id: {student_id}')

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the student exists
                cur.execute('SELECT users_username FROM student WHERE number = %s', (student_id,))
                student_username = cur.fetchone()
                if student_username is None:
                    logger.warning('GET /dbproj/student_details - student not found')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student not found'})
                
                username = get_username()

                # Check if the user is the student or staff
                if username != student_username[0]:
                    # Check if the user is staff
                    cur.execute('SELECT * FROM staff WHERE users_username = %s', (username,))
                    if cur.fetchone() is None:
                        logger.warning('GET /dbproj/student_details - user not authorized')
                        return flask.jsonify({'status': StatusCodes['unauthorized'], 'errors': 'User not authorized'})

                # Get details of the student
                cur.execute(
                    '''
                    SELECT edition.code as course_edition_id , course.name as course_name, edition.edition_year as course_edition_year, MAX(grade.score) as grade
                    FROM edition_student
                    JOIN edition ON edition_student.edition_code = edition.code
                    JOIN course ON edition.course_code = course.code
                    JOIN grade ON edition_student.student_users_username = grade.student_users_username AND edition.code = grade.edition_code
                    WHERE edition_student.student_users_username = %s
                    GROUP BY edition.code, course.name, edition.edition_year
                    ORDER BY edition.edition_year
                    ''',
                    (student_username,)
                )
                details = cur.fetchall()
                
                # Format the results 
                results = [
                    {
                        "course_edition_id": row[0],
                        "course_name": row[1],
                        "course_edition_year": row[2],
                        "grade": row[3]
                    }
                    for row in details
                ]
    
    except Exception as error:
        logger.error(f'GET /dbproj/student_details - error: {error}')
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error), 'results': None})

    logger.info(f'GET /dbproj/student_details - student {student_username} details retrieved')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None, 'results': results})

##
## Degree details                             
##
## Get details of a degree program
##
@app.route('/dbproj/degree_details/<degree_id>', methods=['GET'])
@token_required
@role_required('staff')
def degree_details(degree_id):

    logger.debug(f'GET /dbproj/degree_details/{degree_id} - degree_id: {degree_id}')

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the degree exists
                cur.execute('SELECT code FROM degree WHERE code = %s', (degree_id,))
                degree = cur.fetchone()
                if degree is None:
                    logger.warning('GET /dbproj/degree_details - degree not found')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Degree not found'})
                
                cur.execute(
                    '''
                    SELECT 
                        course.code AS course_id, 
                        course.name AS course_name, 
                        edition.code AS course_edition_id,
                        edition.edition_year AS course_edition_year, 
                        edition.capacity,
                        COUNT(DISTINCT edition_student.student_users_username) AS enrolled_count,
                        COUNT(DISTINCT CASE WHEN grade.score > 9 THEN grade.student_users_username END) AS approved_count,
                        edition.instructor_users_username AS coordinator_id,
                        instructor_edition.instructor_users_username AS instructor_id
                    FROM degree
                    JOIN degree_course ON degree_course.degree_code = degree.code
                    JOIN course ON course.code = degree_course.course_code
                    JOIN edition ON edition.course_code = course.code
                    LEFT JOIN edition_student ON edition_student.edition_code = edition.code
                    LEFT JOIN grade ON grade.edition_code = edition.code AND grade.score > 9
                    LEFT JOIN instructor_edition ON instructor_edition.edition_code = edition.code
                    WHERE degree.code = %s
                    GROUP BY
                        course.code, 
                        course.name, 
                        edition.code, 
                        edition.edition_year, 
                        edition.capacity, 
                        edition.instructor_users_username, 
                        instructor_edition.instructor_users_username
                    ORDER BY edition.edition_year DESC, edition.code;
                    ''',
                    (degree_id,)
                )
                details = cur.fetchall()

                # Format the results 
                edition_dictionary = {}
                for row in details:
                    (course_id, course_name, course_edition_id, course_edition_year, capacity,
                     enrolled_count, approved_count, coordinator_id, instructor_id) = row

                    key = (course_id, course_name, course_edition_id, course_edition_year, capacity,
                           enrolled_count, approved_count, coordinator_id)

                    if key not in edition_dictionary:
                        edition_dictionary[key] = {
                            "course_id": course_id,
                            "course_name": course_name,
                            "course_edition_id": course_edition_id,
                            "course_edition_year": course_edition_year,
                            "capacity": capacity,
                            "enrolled_count": enrolled_count,
                            "approved_count": approved_count,
                            "coordinator_id": coordinator_id,
                            "instructors": []
                        }
                    if instructor_id and instructor_id not in edition_dictionary[key]["instructors"]:
                        edition_dictionary[key]["instructors"].append(instructor_id)

                results = list(edition_dictionary.values())

    except Exception as error:
        logger.error(f'GET /dbproj/degree_details - errors: {error}')
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error), 'results': None})

    logger.info(f'GET /dbproj/degree_details - degree {degree_id} details retrieved')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None, 'results': results})

##
## Top 3 students                               
##
## Get the top 3 students based on average grade
##
@app.route('/dbproj/top3', methods=['GET'])
@token_required
@role_required('staff')
def top3_students():
    
    logger.debug('GET /dbproj/top3 - top 3 students')

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                '''
                WITH top_students AS (
                    SELECT 
                        student.users_username,
                        enrollment.average
                    FROM enrollment
                    JOIN student ON student.users_username = enrollment.student_users_username
                    WHERE enrollment.average IS NOT NULL
                    AND enrollment.status = 'active'
                    ORDER BY enrollment.average DESC
                    LIMIT 3
                )
                SELECT 
                    top_students.users_username,
                    top_students.average,
                    edition.code,
                    edition.name,
                    grade.score,
                    grade.grade_date,
                    activity.name
                FROM top_students
                JOIN edition_student ON top_students.users_username = edition_student.student_users_username
                JOIN edition ON edition_student.edition_code = edition.code
                JOIN grade ON edition_student.student_users_username = grade.student_users_username AND edition.code = grade.edition_code
                LEFT JOIN student_activity ON top_students.users_username = student_activity.student_users_username
                LEFT JOIN activity ON student_activity.activity_name = activity.name
                ORDER BY top_students.average DESC, top_students.users_username, grade.grade_date;
                '''
                )
                details = cur.fetchall()

                # Format the results 
                formatted_results = {}
                for row in details:
                    student_name = row[0]
                    if student_name not in formatted_results:
                        formatted_results[student_name] = {
                            "student_name": student_name,
                            "average_grade": row[1],
                            "grades": [],
                            "activities": set()
                        }
                    
                    grade = {
                        "course_edition_id": row[2],
                        "course_edition_name": row[3],
                        "grade": row[4],
                        "date": row[5].strftime('%Y-%m-%d')
                    }
                    if grade not in formatted_results[student_name]["grades"]:
                        formatted_results[student_name]["grades"].append(grade)

                    if row[6]:
                        formatted_results[student_name]["activities"].add(row[6])

                results = []
                for student in formatted_results.values():
                    student["activities"] = list(student["activities"])
                    results.append(student)

    except Exception as error:
        logger.error(f'GET /dbproj/top3 - error: {error}')
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error), 'results': None})

    logger.info('GET /dbproj/top3 - top 3 students retrieved')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None, 'results': results})

##
## Top by district                              
##
## Get the top students by district
##
@app.route('/dbproj/top_by_district', methods=['GET'])
@token_required
@role_required('staff')
def top_by_district():

    logger.debug('GET /dbproj/top_by_district - top students by district')

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                cur.execute(
                '''
                WITH district_best AS (
                    SELECT 
                        student.district,
                        MAX(enrollment.average) as max_average
                    FROM student
                    JOIN enrollment ON student.users_username = enrollment.student_users_username
                    WHERE enrollment.status = 'active'
                    GROUP BY student.district
                )
                SELECT 
                    student.number,
                    student.users_username,
                    student.district,
                    enrollment.average
                FROM student
                JOIN enrollment ON student.users_username = enrollment.student_users_username
                JOIN district_best ON student.district = district_best.district AND enrollment.average = district_best.max_average
                WHERE enrollment.status = 'active'
                ORDER BY student.district;
                '''
                )
                top_students = cur.fetchall()

                # Format the results
                results = [
                    {
                        "student_id": row[0],
                        "student_name": row[1],
                        "district": row[2],
                        "average_grade": row[3]
                    }
                    for row in top_students
                ]

    except Exception as error:
        logger.error(f'GET /dbproj/top_by_district - error: {error}')
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error), 'results': None})
    
    logger.info('GET /dbproj/top_by_district - top students by district retrieved')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None, 'results': results})

##
## Report                               
##
## Generate a monthly report of course editions
##
@app.route('/dbproj/report', methods=['GET'])
@token_required
@role_required('staff')
def monthly_report():

    logger.debug('GET /dbproj/report - monthly report')

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                cur.execute(
                '''
                SELECT DISTINCT ON (TO_CHAR(grade.grade_date, 'YYYY-MM')) TO_CHAR(grade.grade_date, 'YYYY-MM'), edition.code, edition.name,
                COUNT(CASE WHEN grade.score >= 10 THEN 1 END),
                COUNT(DISTINCT grade.student_users_username)
                FROM grade
                JOIN edition ON grade.edition_code = edition.code
                WHERE grade.grade_date >= (CURRENT_DATE - INTERVAL '12 months')
                GROUP BY TO_CHAR(grade.grade_date, 'YYYY-MM'), edition.code, edition.name
                ORDER BY TO_CHAR(grade.grade_date, 'YYYY-MM'), COUNT(CASE WHEN grade.score >= 10 THEN 1 END) DESC;
                '''
                )

                report = cur.fetchall()

                # Format the results
                results = [
                    {
                        "month": row[0],
                        "course_edition_id": row[1],
                        "course_edition_name": row[2],
                        "approved": row[3],
                        "evaluated": row[4]
                    }
                    for row in report
                ]
    
    except Exception as error:
        logger.error(f'GET /dbproj/report - error: {error}')
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error), 'results': None})

    logger.info('GET /dbproj/report - monthly report generated')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None, 'results': results})

##
## Delete student                              
##
## Delete a student
##
@app.route('/dbproj/delete_details/<student_id>', methods=['DELETE'])
@token_required
@role_required('staff')
def delete_student(student_id):
    logger.debug(f'DELETE /dbproj/delete_details/{student_id} - student_id: {student_id}')

    try:
        with db_connection() as conn:
            with conn.cursor() as cur:

                # Check if the student exists
                cur.execute('SELECT users_username FROM student WHERE number = %s FOR UPDATE', (student_id,))
                student_username = cur.fetchone()
                if student_username is None:
                    logger.warning('DELETE /dbproj/delete_details - student not found')
                    return flask.jsonify({'status': StatusCodes['api_error'], 'errors': 'Student not found'})

                # Delete the student
                cur.execute('DELETE FROM attendance WHERE student_users_username = %s', (student_username,))
                cur.execute('DELETE FROM student_activity WHERE student_users_username = %s', (student_username,))
                cur.execute('DELETE FROM student_class WHERE student_users_username = %s', (student_username,))
                cur.execute('DELETE FROM edition_student WHERE student_users_username = %s', (student_username,))
                cur.execute('DELETE FROM grade WHERE student_users_username = %s', (student_username,))
                cur.execute('DELETE FROM bill WHERE student_users_username = %s', (student_username,))
                cur.execute('DELETE FROM enrollment WHERE student_users_username = %s', (student_username,))
                cur.execute('DELETE FROM student WHERE users_username = %s', (student_username,))
                cur.execute('DELETE FROM users WHERE username = %s', (student_username,))
                conn.commit()

    except Exception as error:
        logger.error(f'DELETE /dbproj/delete_details - error: {error}')
        conn.rollback()
        return flask.jsonify({'status': StatusCodes['internal_error'], 'errors': str(error)})

    logger.info(f'DELETE /dbproj/delete_details - student {student_username} deleted')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None})

##
## Logout user                              
##
## Logout user and clear the token
##
@app.route('/dbproj/logout', methods=['PUT'])
@token_required
def logout_user():
    logger.info('PUT /dbproj/logout - user logged out')
    return flask.jsonify({'status': StatusCodes['success'], 'errors': None})

##########################################################
## MAIN
##########################################################

if __name__ == '__main__':
    # set up logging
    logging.basicConfig(filename='Final/log_file.log')
    logger = logging.getLogger('logger')
    logger.setLevel(logging.DEBUG)  
    ch = logging.StreamHandler()
    ch.setLevel(logging.DEBUG)

    # create formatter
    formatter = logging.Formatter('%(asctime)s [%(levelname)s]:  %(message)s', '%H:%M:%S')
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    host = '127.0.0.1'
    port = 8080

    logging.getLogger('werkzeug').setLevel(logging.CRITICAL)
    logger.info(f'API stubs online: http://{host}:{port}')

    app.run(host=host, debug=True, threaded=True, port=port)

