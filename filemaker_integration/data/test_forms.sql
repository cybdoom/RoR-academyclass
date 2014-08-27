INSERT INTO booking_form VALUES (
1, 'ABC123', 'XYZ', 'Joe Smith', 'joe@smith.com', '07438574385', 'Test Enterprises', '123 Somestreet Place', 'SE1 2BD', 'Sarah Patton', 0.2, 1, 'XYZ123');

INSERT INTO booking_delegate 
  (booking_form_id, name, course_name, course_location, start_date, end_date, platform_pc, price, booking_type)
VALUES (
  1, 'Joe Smith', 'Photoshop 101', 'London', '2011-12-25', '2011-12-28', 1, '1375.50', 'XYZ'
);
INSERT INTO booking_delegate 
  (booking_form_id, name, course_name, course_location, start_date, end_date, platform_pc, price, booking_type)
VALUES (
  1, 'Joe Smith', 'Photoshop 201', 'London', '2012-01-01', '2012-01-04', 1, '1430.50', 'XYZ'
);