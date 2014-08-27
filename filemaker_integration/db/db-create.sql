create database academyclass_courses;
create user 'academyclass'@'localhost' identified by '9xN3,oad4';

\r academyclass_courses

CREATE TABLE course_seats (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  location VARCHAR(100) NOT NULL,
  start_date DATETIME NOT NULL,
  total_seats INTEGER NOT NULL,
  seats_sold INTEGER NOT NULL
) ENGINE=INNODB;

CREATE TABLE course_logs (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  name VARCHAR(255),
  location VARCHAR(100),
  start_date DATETIME,
  total_seats INTEGER,
  seats_sold INTEGER,
  success BIT,
  message VARCHAR(255)
) ENGINE=INNODB;

grant select on academyclass_courses.course_seats to 'academyclass' identified by '9xN3,oad4';
grant insert on academyclass_courses.course_seats to 'academyclass' identified by '9xN3,oad4';
grant delete on academyclass_courses.course_seats to 'academyclass' identified by '9xN3,oad4';
grant insert on academyclass_courses.course_logs to 'academyclass' identified by '9xN3,oad4';