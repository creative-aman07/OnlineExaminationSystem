
CREATE TABLE IF NOT EXISTS candidates (
    candidate_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    roll_number VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS questions (
    question_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject VARCHAR(150) NOT NULL,
    question_text TEXT NOT NULL,
    option_a VARCHAR(500) NOT NULL,
    option_b VARCHAR(500) NOT NULL,
    option_c VARCHAR(500) NOT NULL,
    option_d VARCHAR(500) NOT NULL,
    correct_answer VARCHAR(2) NOT NULL,
    marks INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS tests (
    test_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    test_name VARCHAR(255) NOT NULL,
    subject VARCHAR(150) NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 30,
    total_questions INT NOT NULL DEFAULT 0,
    start_time DATETIME NULL,
    end_time DATETIME NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS test_questions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    test_id BIGINT NOT NULL,
    question_id BIGINT NOT NULL,
    FOREIGN KEY (test_id) REFERENCES tests(test_id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
    UNIQUE KEY uk_test_question (test_id, question_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS results (
    result_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    candidate_id BIGINT NOT NULL,
    test_id BIGINT NOT NULL,
    test_name VARCHAR(255) NOT NULL,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL DEFAULT 0,
    wrong_answers INT NOT NULL DEFAULT 0,
    score INT NOT NULL DEFAULT 0,
    percentage DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    passed BOOLEAN NOT NULL DEFAULT FALSE,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES tests(test_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS exam_attempts (
    attempt_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    candidate_id BIGINT NOT NULL,
    test_id BIGINT NOT NULL,
    started_at DATETIME NOT NULL,
    deadline DATETIME NOT NULL,
    submitted BOOLEAN NOT NULL DEFAULT FALSE,
    UNIQUE KEY uk_attempt (candidate_id, test_id),
    FOREIGN KEY (candidate_id) REFERENCES candidates(candidate_id) ON DELETE CASCADE,
    FOREIGN KEY (test_id) REFERENCES tests(test_id) ON DELETE CASCADE
) ENGINE=InnoDB;

INSERT IGNORE INTO questions (question_id, subject, question_text, option_a, option_b, option_c, option_d, correct_answer, marks) VALUES
(1, 'Java', 'Which keyword is used to create an object in Java?', 'new', 'class', 'this', 'void', 'A', 1),
(2, 'Java', 'Which of these is NOT a Java primitive type?', 'int', 'boolean', 'String', 'double', 'C', 1),
(3, 'Java', 'Which collection preserves insertion order?', 'HashSet', 'ArrayList', 'HashMap', 'TreeSet', 'B', 1),
(4, 'Java', 'What does JVM stand for?', 'Java Virtual Machine', 'Java Verified Module', 'Joint Virtual Machine', 'Java Variable Method', 'A', 1),
(5, 'Java', 'Which keyword prevents a method from being overridden?', 'static', 'const', 'super', 'final', 'D', 1);

INSERT IGNORE INTO tests (test_id, test_name, subject, duration_minutes, total_questions, start_time, end_time) VALUES
(1, 'Java Fundamentals', 'Java', 15, 5, NULL, NULL);

INSERT IGNORE INTO test_questions (test_id, question_id) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5);
