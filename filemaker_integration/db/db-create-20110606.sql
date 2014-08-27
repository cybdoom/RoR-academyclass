CREATE TABLE booking_form (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  filemaker_code VARCHAR(255) NOT NULL,
  booking_type VARCHAR(255) NOT NULL,
  contact_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  telephone VARCHAR(50) NULL,
  company VARCHAR(255) NULL,
  address VARCHAR(255) NULL,
  postcode VARCHAR(10) NULL,
  salesperson VARCHAR(255) NULL,
  vat_rate NUMERIC(2,2),
  allow_invoice BOOLEAN NULL,
  po_number VARCHAR(255) NULL
) ENGINE=INNODB;

CREATE TABLE booking_delegate (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  booking_form_id INTEGER NOT NULL,
  name VARCHAR(255) NOT NULL,
  booking_type VARCHAR(255) NOT NULL,
  course_name VARCHAR(255) NOT NULL,
  course_location VARCHAR(20) NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  platform_pc BOOLEAN,
  price NUMERIC(8,2)
) ENGINE=INNODB;

CREATE TABLE booking_logs (
  id INTEGER PRIMARY KEY AUTO_INCREMENT,
  created_at DATETIME NOT NULL,
  filemaker_code VARCHAR(255),
  success BIT, 
  message VARCHAR(255)
) ENGINE=INNODB;

grant select on academyclass_courses.booking_form to 'academyclass' identified by '9xN3,oad4';
grant insert on academyclass_courses.booking_form to 'academyclass' identified by '9xN3,oad4';
grant delete on academyclass_courses.booking_form to 'academyclass' identified by '9xN3,oad4';
grant select on academyclass_courses.booking_delegate to 'academyclass' identified by '9xN3,oad4';
grant insert on academyclass_courses.booking_delegate to 'academyclass' identified by '9xN3,oad4';
grant delete on academyclass_courses.booking_delegate to 'academyclass' identified by '9xN3,oad4';
grant insert on academyclass_courses.booking_logs to 'academyclass' identified by '9xN3,oad4';