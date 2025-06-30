-- Set the database context
SHOW DATABASES;
USE hr;

-- REGIONS: table parent of COUNTRIES
CREATE TABLE REGIONS (
    REGION_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Primary key of regions table.',
    REGION_NAME VARCHAR(25) NOT NULL COMMENT 'Name of the region.'
) COMMENT 'Table containing region IDs and names of various countries. Primary key table to the COUNTRIES table.';

-- COUNTRIES: table parent of LOCATIONS
CREATE TABLE COUNTRIES (
    COUNTRY_ID CHAR(2) NOT NULL PRIMARY KEY COMMENT 'Primary key of countries table.',
    COUNTRY_NAME VARCHAR(40) NOT NULL COMMENT 'Name of the country.',
    REGION_ID INT NOT NULL COMMENT 'Region ID for the country.',
    FOREIGN KEY (REGION_ID) REFERENCES REGIONS(REGION_ID)
) COMMENT 'Table containing country IDs, names, and region IDs. Primary key table to the LOCATIONS table.';

-- LOCATIONS: table parent of DEPARTMENTS
CREATE TABLE LOCATIONS (
    LOCATION_ID SMALLINT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of locations table.',
    STREET_ADDRESS VARCHAR(40) COMMENT 'Street address of an office, warehouse, or production site.',
    POSTAL_CODE VARCHAR(12) COMMENT 'Postal code of the location.',
    CITY VARCHAR(30) NOT NULL COMMENT 'City where the location is based.',
    STATE_PROVINCE VARCHAR(25) COMMENT 'State or province of the location.',
    COUNTRY_ID CHAR(2) NOT NULL COMMENT 'Country ID for the location.',
    FOREIGN KEY (COUNTRY_ID) REFERENCES COUNTRIES(COUNTRY_ID)
) COMMENT 'Table containing location information for departments. Primary key table to the DEPARTMENTS table.';

-- JOBS: table parent of EMPLOYEES and JOB_HISTORY
CREATE TABLE JOBS (
    JOB_ID VARCHAR(10) NOT NULL PRIMARY KEY COMMENT 'Primary key of jobs table.',
    JOB_TITLE VARCHAR(35) NOT NULL COMMENT 'Job title, e.g., AD_VP, FI_ACCOUNTANT.',
    MIN_SALARY INT COMMENT 'Minimum salary for the job title.',
    MAX_SALARY INT COMMENT 'Maximum salary for the job title.'
) COMMENT 'Table containing job titles and salary ranges. Primary key table to EMPLOYEES and JOB_HISTORY.';

-- DEPARTMENTS: table parent of EMPLOYEES and JOB_HISTORY
CREATE TABLE DEPARTMENTS (
    DEPARTMENT_ID SMALLINT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of departments table.',
    DEPARTMENT_NAME VARCHAR(30) NOT NULL COMMENT 'Name of the department, e.g., Administration, Marketing.',
    MANAGER_ID INT COMMENT 'Manager ID of the department.',
    LOCATION_ID SMALLINT NOT NULL COMMENT 'Location ID where the department is located.',
    FOREIGN KEY (LOCATION_ID) REFERENCES LOCATIONS(LOCATION_ID)
) COMMENT 'Table containing department information. Primary key table to the EMPLOYEES and JOB_HISTORY tables.';

-- EMPLOYEES table
CREATE TABLE EMPLOYEES (
    EMPLOYEE_ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of employees table.',
    FIRST_NAME VARCHAR(20) COMMENT 'First name of the employee.',
    LAST_NAME VARCHAR(25) NOT NULL COMMENT 'Last name of the employee.',
    EMAIL VARCHAR(25) NOT NULL UNIQUE COMMENT 'Email ID of the employee.',
    PHONE_NUMBER VARCHAR(20) COMMENT 'Phone number of the employee, including country and area code.',
    HIRE_DATE DATETIME NOT NULL COMMENT 'Date when the employee started this job.',
    JOB_ID VARCHAR(10) NOT NULL COMMENT 'Current job of the employee.',
    SALARY DECIMAL(8, 2) COMMENT 'Monthly salary of the employee.',
    COMMISSION_PCT DECIMAL(2, 2) COMMENT 'Commission percentage; only for Sales employees.',
    MANAGER_ID INT COMMENT 'Manager ID of the employee (self-referencing).',
    DEPARTMENT_ID SMALLINT NOT NULL COMMENT 'Department ID where the employee works.',
    FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID),
    FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID),
    CHECK (SALARY > 0)
) COMMENT 'Table containing employee information. Child of DEPARTMENTS and JOBS tables.';

-- Add foreign key for DEPARTMENTS.MANAGER_ID
ALTER TABLE DEPARTMENTS
ADD CONSTRAINT FK_DEPT_MANAGER FOREIGN KEY (MANAGER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID);

-- Create JOB_GRADES table
CREATE TABLE JOB_GRADES (
    GRADE_LEVEL CHAR(1) NOT NULL PRIMARY KEY COMMENT 'Job grade level (A, B, C, D).',
    LOWEST_SAL DECIMAL(8, 2) NOT NULL COMMENT 'Minimum salary for the grade.',
    HIGHEST_SAL DECIMAL(8, 2) NOT NULL COMMENT 'Maximum salary for the grade.',
    CHECK (LOWEST_SAL < HIGHEST_SAL),
    CHECK (LOWEST_SAL > 0 AND HIGHEST_SAL > 0)
) COMMENT 'Table identifying salary ranges per job grade. Ranges do not overlap.';

-- Create JOB_HISTORY table
CREATE TABLE JOB_HISTORY (
    EMPLOYEE_ID INT NOT NULL COMMENT 'Foreign key to EMPLOYEES.',
    START_DATE DATETIME NOT NULL COMMENT 'Start date of the historical job.',
    END_DATE DATETIME NOT NULL COMMENT 'End date of the historical job.',
    JOB_ID VARCHAR(10) NOT NULL COMMENT 'Job role previously held.',
    DEPARTMENT_ID SMALLINT NOT NULL COMMENT 'Department previously assigned.',
    PRIMARY KEY (EMPLOYEE_ID, START_DATE),
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID),
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID),
    CHECK (END_DATE > START_DATE)
) COMMENT 'Table storing job history of employees. Tracks job and department changes.';

-- Create indexes
CREATE INDEX LOC_CITY_IX ON LOCATIONS (CITY);
CREATE INDEX LOC_STATE_PROVINCE_IX ON LOCATIONS (STATE_PROVINCE);
CREATE INDEX LOC_COUNTRY_IX ON LOCATIONS (COUNTRY_ID);
CREATE INDEX DEPT_LOCATION_IX ON DEPARTMENTS (LOCATION_ID);
CREATE INDEX EMP_DEPARTMENT_IX ON EMPLOYEES (DEPARTMENT_ID);
CREATE INDEX EMP_JOB_IX ON EMPLOYEES (JOB_ID);
CREATE INDEX EMP_MANAGER_IX ON EMPLOYEES (MANAGER_ID);
CREATE INDEX EMP_NAME_IX ON EMPLOYEES (LAST_NAME, FIRST_NAME);
CREATE INDEX JHIST_JOB_IX ON JOB_HISTORY (JOB_ID);
CREATE INDEX JHIST_EMPLOYEE_IX ON JOB_HISTORY (EMPLOYEE_ID);
CREATE INDEX JHIST_DEPARTMENT_IX ON JOB_HISTORY (DEPARTMENT_ID);


-- PERFORMANCE_REVIEWS: Linked to EMPLOYEES (employee reviewed and reviewer)
CREATE TABLE PERFORMANCE_REVIEWS (
    REVIEW_ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of performance reviews table.',
    EMPLOYEE_ID INT NOT NULL COMMENT 'Employee being reviewed. Foreign key to EMPLOYEES.',
    REVIEW_DATE DATETIME NOT NULL COMMENT 'Date of the performance review.',
    RATING DECIMAL(3, 1) NOT NULL COMMENT 'Performance rating (e.g., 1.0 to 5.0).',
    COMMENTS TEXT COMMENT 'Reviewer comments or feedback.',
    REVIEWER_ID INT COMMENT 'Reviewer (e.g., manager). Foreign key to EMPLOYEES.',
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    FOREIGN KEY (REVIEWER_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    CHECK (RATING >= 1.0 AND RATING <= 5.0)
) COMMENT 'Table storing employee performance reviews, linked to EMPLOYEES by both EMPLOYEE_ID and REVIEWER_ID.';


-- TRAINING_COURSES: Standalone; can optionally be linked via a junction table to EMPLOYEES
CREATE TABLE TRAINING_COURSES (
    COURSE_ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of training courses table.',
    COURSE_NAME VARCHAR(50) NOT NULL COMMENT 'Name of the training course or certification.',
    COURSE_TYPE VARCHAR(20) COMMENT 'Type of course (e.g., Technical, Leadership, Compliance).',
    DURATION_HOURS INT COMMENT 'Duration of the course in hours.',
    START_DATE DATETIME COMMENT 'Start date of the course.',
    END_DATE DATETIME COMMENT 'End date of the course.',
    CHECK (END_DATE > START_DATE OR END_DATE IS NULL)
) COMMENT 'Table storing course details. Can be linked to EMPLOYEES via a junction table like EMPLOYEE_TRAINING.';

-- EMPLOYEE_SKILLS: Linked to EMPLOYEES (many-to-one relationship)
CREATE TABLE EMPLOYEE_SKILLS (
    EMPLOYEE_ID INT NOT NULL COMMENT 'Employee possessing the skill. Foreign key to EMPLOYEES.',
    SKILL_NAME VARCHAR(50) NOT NULL COMMENT 'Skill name (e.g., SQL, Leadership).',
    PROFICIENCY_LEVEL VARCHAR(20) COMMENT 'Proficiency level (e.g., Beginner, Expert).',
    ACQUIRED_DATE DATE COMMENT 'Date the skill was acquired.',
    PRIMARY KEY (EMPLOYEE_ID, SKILL_NAME),
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID)
) COMMENT 'Table storing skills linked to EMPLOYEES. Supports many skills per employee.';

-- ATTENDANCE: Linked to EMPLOYEES
CREATE TABLE ATTENDANCE (
    ATTENDANCE_ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of attendance table.',
    EMPLOYEE_ID INT NOT NULL COMMENT 'Employee associated with the attendance record. Foreign key to EMPLOYEES.',
    ATTENDANCE_DATE DATE NOT NULL COMMENT 'Date of the attendance record.',
    STATUS VARCHAR(20) NOT NULL COMMENT 'Status (e.g., Present, Absent, Leave, Sick).',
    HOURS_WORKED DECIMAL(4,2) COMMENT 'Hours worked on the date.',
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    CHECK (HOURS_WORKED >= 0 AND HOURS_WORKED <= 24 OR HOURS_WORKED IS NULL)
) COMMENT 'Tracks daily attendance linked to EMPLOYEES.';

-- PAYROLL: Linked to EMPLOYEES
CREATE TABLE PAYROLL (
    PAYROLL_ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of payroll table.',
    EMPLOYEE_ID INT NOT NULL COMMENT 'Employee paid in this record. Foreign key to EMPLOYEES.',
    PAY_PERIOD_START DATE NOT NULL COMMENT 'Start of pay period.',
    PAY_PERIOD_END DATE NOT NULL COMMENT 'End of pay period.',
    BASE_SALARY DECIMAL(8,2) NOT NULL COMMENT 'Base salary for the period.',
    BONUS DECIMAL(8,2) COMMENT 'Bonus earned.',
    DEDUCTIONS DECIMAL(8,2) COMMENT 'Deductions (e.g., tax).',
    NET_PAY DECIMAL(8,2) NOT NULL COMMENT 'Final pay.',
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    CHECK (PAY_PERIOD_END > PAY_PERIOD_START),
    CHECK (BASE_SALARY >= 0),
    CHECK (BONUS >= 0 OR BONUS IS NULL),
    CHECK (DEDUCTIONS >= 0 OR DEDUCTIONS IS NULL),
    CHECK (NET_PAY >= 0)
) COMMENT 'Payroll data linked to EMPLOYEES. Includes salary, bonus, deductions.';

-- RECRUITMENT: Linked to JOBS and DEPARTMENTS
CREATE TABLE RECRUITMENT (
    APPLICATION_ID INT AUTO_INCREMENT NOT NULL PRIMARY KEY COMMENT 'Primary key of recruitment table.',
    JOB_ID VARCHAR(10) NOT NULL COMMENT 'Job applied for. Foreign key to JOBS.',
    APPLICANT_NAME VARCHAR(50) NOT NULL COMMENT 'Name of the applicant.',
    APPLICATION_DATE DATE NOT NULL COMMENT 'Date of application.',
    STATUS VARCHAR(20) NOT NULL COMMENT 'Status (e.g., Applied, Hired).',
    HIRE_DATE DATE COMMENT 'Hire date (if hired).',
    DEPARTMENT_ID SMALLINT COMMENT 'Department applied to. Foreign key to DEPARTMENTS.',
    FOREIGN KEY (JOB_ID) REFERENCES JOBS(JOB_ID),
    FOREIGN KEY (DEPARTMENT_ID) REFERENCES DEPARTMENTS(DEPARTMENT_ID),
    CHECK (HIRE_DATE >= APPLICATION_DATE OR HIRE_DATE IS NULL)
) COMMENT 'Recruitment data linked to JOBS and DEPARTMENTS. Stores application and hiring info.';

-- This would enable queries like “Which employees completed leadership training?
CREATE TABLE EMPLOYEE_TRAINING (
    EMPLOYEE_ID NUMBER(6) NOT NULL,
    COURSE_ID NUMBER(6) NOT NULL,
    COMPLETION_DATE DATE,
    PRIMARY KEY (EMPLOYEE_ID, COURSE_ID),
    FOREIGN KEY (EMPLOYEE_ID) REFERENCES EMPLOYEES(EMPLOYEE_ID),
    FOREIGN KEY (COURSE_ID) REFERENCES TRAINING_COURSES(COURSE_ID)
) COMMENT 'Junction table linking EMPLOYEES to TRAINING_COURSES.'
;


