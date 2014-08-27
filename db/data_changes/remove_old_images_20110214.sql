DELETE from images where id NOT IN (SELECT image_id FROM courses WHERE image_id IS NOT NULL) AND id NOT IN (SELECT image_id FROM events WHERE image_id IS NOT NULL) AND id NOT IN (SELECT image_id FROM families WHERE image_id IS NOT NULL) AND id NOT IN (SELECT image_id FROM product_parents WHERE image_id IS NOT NULL) AND id NOT IN (SELECT image_id FROM products WHERE image_id IS NOT NULL);

DELETE FROM instructors WHERE priority=18;
INSERT INTO instructors (name, image_name, content, priority, created_at, updated_at) VALUES ('Ozgur Gorgun', 'Instructor-Image-boy.gif', 'Originally from Turkey, Ozgur Gorgun moved to the UK in 2005 to continue his career. He studied Digital and Lens Media at the University of Hertfordshire, where he later received an MA degree in Film and TV Directing - which has been his primary occupation for the majority of his life. Ozgur has been working in the film industry both in the UK and abroad with roles varying from directing to producing and editing. So far, he\'s written and directed five short films, a feature drama, two documentaries, a number of music and commercial videos.

His credits include: Butterflies Never Die, Interference, The International, Hope Island, Road to the Front and Desaturated Dreams. Some of these titles have been very successful at the international film festivals.

*What do you specialise in?*
I specialise mostly in video related products, such as Premiere, After Effects and Final Cut Pro. I also train in Photoshop, Lightroom, Captivate, Acrobat and Digital Photography

*What did you do before this job?*
Before joining Academy Class, I worked as a director, editor, scriptwriter and cinematographer in productions varying from feature films to documentaries and shorts.  I also still run my own production company which is active both in the UK and Turkey, that\'s home. 

*What do you enjoy about training?*
The best thing about training is actually being able to share my knowledge with others, while learning new things from them - regardless of their experience.  The other cool thing is to get to meet new people from different backgrounds and industries.

*What kind of things do you enjoy outside of training?*
I have a never-ending passion for filmmaking. So when I\'m not training, I watch/write/make films. I also do photography, which excites me just as much as films. Other than that, I really enjoy trying out new things and visiting new places.

*Cats or dogs?*
Dogs. If possible, Golden Retrievers please.

*If you won &pound;10 million on the lottery tomorrow then what would you do?*
After having a classic car collection in my garage, I would probably set up a studio. There, I would have departments for music, design, photography and film - all under one roof. With the rest of the money, I would run the business and multiply the first &pound;10 million!', 18, now(), now());


SELECT 'courses', id FROM courses WHERE image_id=173 union
SELECT 'events', id FROM events WHERE image_id=173 union
SELECT 'families', id FROM families WHERE image_id=173 union
SELECT 'parents', id FROM product_parents WHERE image_id=173 union
SELECT 'products', id FROM products WHERE image_id=173;