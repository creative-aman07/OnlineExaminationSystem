USE examdb;

INSERT IGNORE INTO roles (role_id, role_name) VALUES (1, 'admin'), (2, 'student');

INSERT IGNORE INTO questions (question_id, subject, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES
(1, 'Java', 'Which keyword is used to create a new object instance in Java?', 'new', 'class', 'this', 'create', 'A', 1),
(2, 'Java', 'Which of the following is NOT a primitive data type in Java?', 'int', 'boolean', 'String', 'double', 'C', 1),
(3, 'Java', 'Which collection class preserves insertion order and allows duplicate elements?', 'HashSet', 'ArrayList', 'HashMap', 'TreeSet', 'B', 1),
(4, 'Java', 'What does JVM stand for?', 'Java Virtual Machine', 'Java Verified Module', 'Joint Virtual Machine', 'Java Variable Method', 'A', 1),
(5, 'Java', 'Which keyword prevents a class method from being overridden in subclasses?', 'static', 'abstract', 'final', 'synchronized', 'C', 1),
(6, 'Java', 'What is the default value of an uninitialized boolean instance variable in Java?', 'true', 'false', 'null', '0', 'B', 1),
(7, 'Web & Databases', 'Which HTTP status code signifies a successful request?', '200 OK', '404 Not Found', '500 Internal Error', '301 Moved', 'A', 1),
(8, 'Web & Databases', 'In SQL, which clause is used to filter records returned by a SELECT query?', 'ORDER BY', 'GROUP BY', 'WHERE', 'HAVING', 'C', 1),
(9, 'Web & Databases', 'Which method of HttpServlet processes incoming HTTP POST requests?', 'doGet', 'doPost', 'service', 'init', 'B', 1),
(10, 'Web & Databases', 'What does the ACID acronym stand for in database transactions?', 'Atomicity, Consistency, Isolation, Durability', 'Access, Control, Identity, Data', 'Auto, Concurrent, Indexed, Distributed', 'Array, Cache, Index, Directory', 'A', 1),
(11, 'Web & Databases', 'Which SQL constraint uniquely identifies each record in a database table?', 'Foreign Key', 'Primary Key', 'Check Constraint', 'Unique Index', 'B', 1),
(12, 'Aptitude', 'If a train traveling at 60 km/h crosses a 300-meter platform in 30 seconds, what is the length of the train?', '150 meters', '200 meters', '250 meters', '300 meters', 'B', 1),
(13, 'Aptitude', 'Find the next number in the sequence: 2, 6, 12, 20, 30, ?', '40', '42', '44', '46', 'B', 1),
(14, 'Aptitude', 'If 5 workers complete a project in 12 days, how many days will 6 workers take at the same pace?', '8 days', '10 days', '11 days', '14 days', 'B', 1),
(15, 'Aptitude', 'Which of the following items does NOT belong with the others?', 'Apple', 'Orange', 'Banana', 'Potato', 'D', 1),
(16, 'Aptitude', 'An item was sold for $240 at a 20% profit. What was its original cost price?', '$190', '$200', '$210', '$220', 'B', 1);

INSERT IGNORE INTO tests (test_id, test_name, subject, duration_minutes, total_questions, start_time, end_time) VALUES
(1, 'Java Full Stack & Core Programming', 'Java', 20, 6, NULL, NULL),
(2, 'Web Technologies & Database Systems', 'Web & Databases', 15, 5, NULL, NULL),
(3, 'General Aptitude & Logical Reasoning', 'Aptitude', 15, 5, NULL, NULL);

INSERT IGNORE INTO test_questions (test_id, question_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
(2, 7), (2, 8), (2, 9), (2, 10), (2, 11),
(3, 12), (3, 13), (3, 14), (3, 15), (3, 16);

-- Demo Candidate
INSERT IGNORE INTO candidates (candidate_id, full_name, roll_number, email) VALUES
(1, 'Demo Student', 'STUDENT001', 'student@exam.com');

-- Demo Users (BCrypt hash for 'password123' is $2a$12$K896X3Lff4uYyvN.d3x7I.jP9xS2hL.c7b8Cg8.Z1jY9uF2S3Wq1i)
INSERT IGNORE INTO users (user_id, email, password_hash, role_id, candidate_id) VALUES
(1, 'admin@exam.com', '$2a$12$4L1Jb3C8yR2iIqU2rWvTpe7B5i8t1g3l5n9p2q4r6s8t0u2v4w6x8', 1, NULL),
(2, 'student@exam.com', '$2a$12$4L1Jb3C8yR2iIqU2rWvTpe7B5i8t1g3l5n9p2q4r6s8t0u2v4w6x8', 2, 1);
