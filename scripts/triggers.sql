-- Bill generation trigger for degree enrollment
CREATE OR REPLACE FUNCTION degree_bill_generator() RETURNS TRIGGER
LANGUAGE plpgsql 
AS $$
BEGIN
    UPDATE student
    SET balance = balance - (SELECT fee FROM degree WHERE code = NEW.degree_code)
    WHERE users_username = NEW.student_users_username;

    INSERT INTO bill (amount, subject, transaction_date, student_users_username)
    VALUES ((SELECT fee FROM degree WHERE code = NEW.degree_code), NEW.degree_code, CURRENT_DATE, NEW.student_users_username);

    RETURN NEW;
END;
$$;

CREATE TRIGGER degree_enrollment_trigger
AFTER INSERT ON enrollment
FOR EACH ROW
EXECUTE PROCEDURE degree_bill_generator();

-- Bill generation trigger for activity enrollment
CREATE OR REPLACE FUNCTION activity_bill_generator() RETURNS TRIGGER
LANGUAGE plpgsql 
AS $$
BEGIN
    UPDATE student
    SET balance = balance - (SELECT fee FROM activity WHERE name = NEW.activity_name)
    WHERE users_username = NEW.student_users_username;

    INSERT INTO bill (amount, subject, transaction_date, student_users_username)
    VALUES ((SELECT fee FROM activity WHERE name = NEW.activity_name), NEW.activity_name, CURRENT_DATE, NEW.student_users_username);

    RETURN NEW;
END;
$$;

CREATE TRIGGER activity_enrollment_trigger
AFTER INSERT ON student_activity
FOR EACH ROW
EXECUTE PROCEDURE activity_bill_generator();

-- Update the average and approved_count for the active enrollment
CREATE OR REPLACE FUNCTION update_enrollment_on_grade() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE enrollment
    SET
        average = (
            SELECT AVG(best_score)
            FROM (
                SELECT MAX(score) AS best_score
                FROM grade
                WHERE student_users_username = NEW.student_users_username
                GROUP BY edition_code
            ) AS best_per_edition
        ),
        approved_count = (
            SELECT COUNT(*)
            FROM (
                SELECT MAX(score) AS best_score
                FROM grade
                WHERE student_users_username = NEW.student_users_username
                GROUP BY edition_code
            ) AS best_per_edition
            WHERE best_score >= 10
        )
    WHERE student_users_username = NEW.student_users_username
        AND status = 'active';

    RETURN NEW;
END;
$$;

CREATE TRIGGER grade_insert_update_enrollment
AFTER INSERT ON grade
FOR EACH ROW
EXECUTE PROCEDURE update_enrollment_on_grade();