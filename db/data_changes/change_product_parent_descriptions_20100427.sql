UPDATE product_parents SET description= concat('h3. ', name, ' Authorised Training Courses', substr(description, 23))
WHERE name IN ('Adobe', 'Apple', 'Autodesk', 'Quark')

UPDATE product_parents SET description=concat('h3. ', name, ' Training courses by Academy Class deliver Results!', substr(description, 23))
