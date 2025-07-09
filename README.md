# HR Database SQL Analysis 📊

## 🔍 Overview

This project is based on the official Oracle Database 19c: SQL Workshop (1Z0-071) and has been expanded into a comprehensive, real-world HR analytics schema with **15 interrelated tables**.

While the core tables originate from the Oracle SQL certification course, additional custom tables were added to reflect modern HR practices, such as `PERFORMANCE_REVIEWS`, `PAYROLL`, `TRAINING_COURSES`, `ATTENDANCE`, and `EMPLOYEE_SKILLS`. These extensions support deeper analysis, scenario based querying, and portfolio level demonstration.

## 🎯 Objectives
- Prepare for the Oracle SQL Associate Certification (1Z0-071)
- Demonstrate practical SQL and database design skills
- Apply analytical thinking to real-world HR data
- Build a data analyst portfolio project using SQL

## 👥 Ideal For
- Database Developers
- Data Analysts
- SQL Certification Candidates

## 🧠 What You Will Learn
By working with this database, you will practice how to:

- Retrieve data using `SELECT` statements
- Restrict and sort data
- Customize output using single-row functions
- Use conversion functions and conditional expressions
- Report aggregated data using group functions
- Display data from multiple tables using joins
- Manage tables using DML (`INSERT`, `UPDATE`, `DELETE`)
- Create schema objects like `SEQUENCES`, `SYNONYMS`, `INDEXES`, and `VIEWS`
- Work with subqueries and advanced queries
- Control user access and manage time zone-aware data

---

## 🧱 Schema Structure

- **Employee Information**: `EMPLOYEES`, `EMPLOYEE_SKILLS`, `PERFORMANCE_REVIEWS`, `ATTENDANCE`
- **Job & Recruitment**: `JOBS`, `RECRUITMENT`, `JOB_HISTORY`, `JOB_GRADES`
- **Organizational Structure**: `DEPARTMENTS`, `LOCATIONS`, `COUNTRIES`, `REGIONS`
- **Payroll & Compensation**: `PAYROLL`, `SALARY_AUDIT`
- **Learning & Development**: `TRAINING_COURSES`

---

## 🛠️ How to Use

1. Install Oracle 21c (see `Documentation/setup_guide_oracle21c.md`)
2. Run the SQL scripts in the `/Oracle_SQL_Scripts/` directory
3. Explore the pre-built queries or write your own

---

## 💡 Sample Questions Answered

- Which department has the highest average salary?
- Who has not completed any training this year?
- What are the most common employee skill sets?

---

## 📈 ER Diagram

![ERD](./ERD/HR_ER_Diagram.png)

---

## 🔗 Resources

- [Oracle 1Z0-071 Exam Guide](#)
- [MySQL Version of Schema](./MySQL_Scripts/)

---

**Schema Version**: Oracle 21c (compatible with 19c)  
**Language**: English  
**Original Base**: Oracle 19c: SQL Workshop – Official Course Material
