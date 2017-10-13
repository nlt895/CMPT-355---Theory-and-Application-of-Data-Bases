/* Kristine Trinh
 * nlt895
 * 11190412
 * A1 Part 2
*/

/*1)  Return the university name, department name, course code, course name, course description, 
and credit units of the courses offered at the University of Saskatchewan. /5 */

SELECT 
   universities.name AS university,
   departments.name AS department, 
   courses.name AS course,
   course_desc, 
   credit_units
FROM (universities INNER JOIN departments ON universities.id=university_id)
INNER JOIN courses ON courses.department_id=departments.id
WHERE universities.name='University of Saskatchewan';

/*2)  We want to check to see if the number of students enrolled in the enrollments table 
matches the number of students in sections.num_enrolled. Write a query to return a count 
of the number of sections that have a matching number of enrollments.  /5 (HINT: you’ll 
want to use a subquery in the WHERE clause to aggregate data.) */

SELECT COUNT(sections.id)
FROM sections LEFT JOIN 
	(SELECT COUNT(enrollments.id) count_fact,section_id 
	FROM enrollments
	GROUP BY section_id) res ON res.section_id=sections.id
WHERE coalesce(count_fact,0)=num_enrolled;

/*3)  Display all the sections of the CMPT courses. Include the course code, course name, lecture 
type, maximum enrollment, number currently enrolled, remaining number of available 
enrollments, the name of the instructor of the section, the start and end date of the term, 
and the start and end time of the section.  Write this query twice – once using implicit joins 
and again using explicit joins. /10 (5 each) */

--implicit join

SELECT 
   courses.code AS course_code,
   courses.name AS course_name,
   lec_type,
   max_enrollment,
   num_enrolled,
   max_enrollment-num_enrolled AS remaining_available,
   first_name,
   last_name,
   sections.start_time AS section_Start, 
   sections.end_time AS section_End, 
   terms.start_date AS term_Start, 
   terms.end_date AS term_End
FROM courses,sections,terms,instructors
WHERE (courses.department_id IN (SELECT id
		  FROM departments
		  WHERE code='CMPT'))
		  AND (courses.id=course_id) AND (term_id=terms.id) AND (instructor_id=instructors.id);

--explicit join

SELECT 
   courses.code AS course_code,
   courses.name AS course_name,
   lec_type,
   max_enrollment,
   num_enrolled,
   max_enrollment-num_enrolled AS remaining_available,
   first_name,
   last_name,
   sections.start_time AS section_Start, 
   sections.end_time AS section_End, 
   terms.start_date AS term_Start, 
   terms.end_date AS term_End
FROM ((courses INNER JOIN sections ON courses.id=course_id)
	       INNER JOIN terms ON term_id=terms.id)
	       INNER JOIN instructors ON instructor_id=instructors.id
WHERE courses.department_id IN (SELECT id
                                FROM departments
	                        WHERE code='CMPT');

/*4)  With the help of an inline view, return the number of sections for each lecture type of each 
course. You should return the following information: course code, course name, lecture 
type, number of sections. Sort your query first by the course code, and then by the number 
of sections.  /10 (HINT: try writing the inline view to aggregate the section information first 
and then create the rest of the query. See the inline view example in slide set 5 for an 
example.) */

SELECT 
   courses.code AS course_code,
   courses.name AS course_name,
   lec_type,
   number_section
FROM courses INNER JOIN
        (SELECT COUNT(id) number_section,lec_type,course_id
         FROM sections
	 GROUP BY lec_type,course_id) CS ON CS.course_id=id
ORDER BY courses.code,number_section;


/*5)  We want to report a section status for each section in our database. Based on how many 
students are enrolled in the section, the section status can be one of three values: room 
available, section full, or section over-filled. With the help of a case statement, write a 
query to return the course code, course name, section code, lecture type, and section 
status.  /10  */

SELECT 
   courses.code AS course_code,
   courses.name AS course_name,
   section_code,
   lec_type,
CASE WHEN num_enrolled=max_enrollment THEN 'section full'
     WHEN num_enrolled<max_enrollment THEN 'room available'
     ELSE 'over-filled' 
END section_status
FROM courses INNER JOIN sections ON courses.id=course_id;
		
