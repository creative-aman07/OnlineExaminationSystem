USE examdb;
INSERT IGNORE INTO roles (role_id, role_name) VALUES (1, 'admin'), (2, 'student');
INSERT IGNORE INTO questions (question_id, subject, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES
(1, 'Java', 'Which keyword is used to create an object in Java?', 'new', 'class', 'this', 'void', 'A', 1),
(2, 'Java', 'Which of these is NOT a Java primitive type?', 'int', 'boolean', 'String', 'double', 'C', 1),
(3, 'Java', 'Which collection preserves insertion order?', 'HashSet', 'ArrayList', 'HashMap', 'TreeSet', 'B', 1),
(4, 'Java', 'What does JVM stand for?', 'Java Virtual Machine', 'Java Verified Module', 'Joint Virtual Machine', 'Java Variable Method', 'A', 1),
(5, 'Java', 'Which keyword prevents a method from being overridden?', 'static', 'const', 'super', 'final', 'D', 1);
INSERT IGNORE INTO tests (test_id, test_name, subject, duration_minutes, total_questions) VALUES
(1, 'Java Fundamentals', 'Java', 15, 5);
INSERT IGNORE INTO test_questions (test_id, question_id) VALUES
(1,1),(1,2),(1,3),(1,4),(1,5);
