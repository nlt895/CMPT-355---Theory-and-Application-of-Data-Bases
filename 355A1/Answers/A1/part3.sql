/* Kristine Trinh
 * nlt895
 * 11190412
 * A1 Part 3
*/

/*
1)Fill blank space: 
 1. enrollment_id INT, foreign key
 2. assesment_id INT, foreign key
 3. points NUMERIC
 4. total_points NUMERIC
 5. weight NUMERIC
 6. due_date DATE
 7. section_id INT, foreign key
*/

/*2)  Write and apply the DDL statements required to add these tables to the database. 
Remember to include constraints (such as primary and foreign keys) where appropriate*/

CREATE TABLE assessments(
  id INT,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(10) NOT NULL,
  total_points NUMERIC NOT NULL,
  weight NUMERIC NOT NULL,
  due_date DATE,
  section_id INT NOT NULL REFERENCES sections,  
  PRIMARY KEY (id));

CREATE TABLE enrollment_assessments(
  id INT,
  enrollment_id INT NOT NULL REFERENCES enrollments,
  assesment_id INT NOT NULL REFERENCES assessments,
  points NUMERIC NOT NULL,
  PRIMARY KEY (id));


/*3)  Using INSERT statements, add records for our five assignments, one midterm, and one final 
into the assessments table for the CMPT 355 lecture section. Remember that each 
assignment is worth 10%, the midterm is worth 20%, and the final is worth 30%. You can 
assume that all assessments have a total_points value of 100, and you can make up your 
own due date. /5 
a)  Can you do this using only one insert statement with a SELECT clause? If you can, you 
only have to use this one query to get full marks on the whole question. /3 */

INSERT INTO assessments (id,name,type,total_points,weight,due_date,section_id)
VALUES (1,'Assignment 1','ASS',10,0.1,  TO_DATE('10/01/2017','MM/DD/YYYY'),(SELECT sections.id 
					FROM sections INNER JOIN courses ON course_id=courses.id
					WHERE (lec_type='LEC') AND (code='CMPT355')));
INSERT INTO assessments (id,name,type,total_points,weight,due_date,section_id) VALUES			
(2,'Assignment 2','ASS',10,0.1,  TO_DATE('10/15/2017','MM/DD/YYYY'),(SELECT sections.id 
					FROM sections INNER JOIN courses ON course_id=courses.id
					WHERE (lec_type='LEC') AND (code='CMPT355')));
INSERT INTO assessments (id,name,type,total_points,weight,due_date,section_id) VALUES			
(3,'Assignment 3','ASS',10,0.1,  TO_DATE('11/01/2017','MM/DD/YYYY'),(SELECT sections.id 
					FROM sections INNER JOIN courses ON course_id=courses.id
					WHERE (lec_type='LEC') AND (code='CMPT355')));
INSERT INTO assessments (id,name,type,total_points,weight,due_date,section_id) VALUES(4,'Assignment 4','ASS',10,0.1,  TO_DATE('11/15/2017','MM/DD/YYYY'),(SELECT sections.id 
					FROM sections INNER JOIN courses ON course_id=courses.id
					WHERE (lec_type='LEC') AND (code='CMPT355')));
INSERT INTO assessments (id,name,type,total_points,weight,due_date,section_id) VALUES(5,'Assignment 5','ASS',10,0.1,  TO_DATE('12/01/2017','MM/DD/YYYY'),(SELECT sections.id 
					FROM sections INNER JOIN courses ON course_id=courses.id
					WHERE (lec_type='LEC') AND (code='CMPT355')));
INSERT INTO assessments (id,name,type,total_points,weight,due_date,section_id) VALUES(6,'Midterm','MT',10,0.2,  TO_DATE('12/01/2017','MM/DD/YYYY'),(SELECT sections.id 
					FROM sections INNER JOIN courses ON course_id=courses.id
					WHERE (lec_type='LEC') AND (code='CMPT355')));
INSERT INTO assessments (id,name,type,total_points,weight,due_date,section_id) VALUES(7,'Final','FIN',100,0.3,  TO_DATE('12/10/2017','MM/DD/YYYY'),(SELECT sections.id 
					FROM sections INNER JOIN courses ON course_id=courses.id
					WHERE (lec_type='LEC') AND (code='CMPT355')));



/*4)  Let’s say that the instructor for lectures of CMPT 355 has suddenly quit. Using the 
appropriate DML statements, remove the current instructor record from the database 
completely and assign me (Ellen) to teach the class. Feel free to make up whatever data you 
need to make my instructor record*/

-- insert new instructor:
DO $$
DECLARE 
  L_INSTRUCTOR_ID INT;
  L_INSTRUCTOR_NEW_ID INT;
  L_SECTION_ID INT;
BEGIN
SELECT MAX(id)+1 INTO L_INSTRUCTOR_NEW_ID
FROM instructors;

INSERT INTO instructors(
    id, employee_number, first_name, last_name, 
    seniority_date, email_address
  ) 
  VALUES 
    (L_INSTRUCTOR_NEW_ID, 1007, 'Elen', 'Dow', TO_DATE('01/01/2016','MM/DD/YYYY'), 'dowElen@usask.ca');
-- store id of current instructor:
SELECT instructor_id INTO L_INSTRUCTOR_ID, sections.id INTO L_SECTION_ID
FROM sections INNER JOIN courses ON course_id=courses.id
WHERE (lec_type='LEC') AND (code='CMPT355');

UPDATE sections SET instructor_id =L_INSTRUCTOR_NEW_ID
WHERE id=L_SECTION_ID;

DELETE instructors WHERE id=L_INSTRUCTOR_ID;

END; $$