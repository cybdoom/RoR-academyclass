UPDATE products SET description= concat(substr(description, 1, locate('for free within a year', description)-1), 'free of charge within 6 months', substr(description, locate('for free within a year', description)+22)) where locate('for free within a year', description) > 0
