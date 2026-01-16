CREATE DATABASE QuizGenerationAssessment;
USE QuizGenerationAssessment;

-- ============================
-- TEACHERS
-- ============================
CREATE TABLE teachers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(200) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL
);

-- ============================
-- STUDENTS
-- ============================
CREATE TABLE students (	
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(200) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  reg_no VARCHAR(100),
  semester VARCHAR(50)
);

-- ============================
-- COURSES
-- ============================
CREATE TABLE courses (
  id INT AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(50) UNIQUE,
  title VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================
-- TEACHES (Teacher ↔ Course)
-- ============================
CREATE TABLE teaches (
  teacher_id INT NOT NULL,
  course_id INT NOT NULL,

  PRIMARY KEY (teacher_id, course_id),
  FOREIGN KEY (teacher_id) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ============================
-- ENROLLMENTS (Student ↔ Course)
-- ============================
CREATE TABLE enrollments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  course_id INT NOT NULL,

  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
);

-- ============================
-- DOCUMENTS (Lecture Notes)
-- ============================
CREATE TABLE lecture_notes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  uploaded_by INT NOT NULL,
  file_path VARCHAR(500) NOT NULL,
  original_name VARCHAR(255),
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (uploaded_by, course_id) REFERENCES teaches(teacher_id, course_id)
    ON DELETE CASCADE
);

-- ============================
-- CHUNKS (Extracted Text + Embedding)
-- RAG-Critical Table
-- ============================
CREATE TABLE chunks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  lecture_notes_id INT NOT NULL,

  -- Order within document
  chunk_index INT DEFAULT 0,

  -- Actual chunk text
  text LONGTEXT NOT NULL,

  -- Keywords extracted via NLP
  keywords JSON DEFAULT NULL,

  -- Vector embedding stored in MySQL
  embedding LONGBLOB NULL,

  FOREIGN KEY (lecture_notes_id) REFERENCES lecture_notes(id) ON DELETE CASCADE
);

-- ============================
-- QUIZZES
-- ============================
CREATE TABLE quizzes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  course_id INT NOT NULL,
  created_by INT NOT NULL,
  lecture_notes_id INT DEFAULT NULL,

  title VARCHAR(255) NOT NULL,
  total_questions INT DEFAULT 0,
  avg_difficulty ENUM('Easy','Medium','Hard') DEFAULT NULL,
  total_time_mins INT DEFAULT 0,
  total_marks INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (lecture_notes_id) REFERENCES lecture_notes(id) ON DELETE SET NULL
);

-- ============================
-- QUIZ QUESTIONS (MCQs)
-- ============================
CREATE TABLE quiz_questions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quiz_id INT NOT NULL,
  q_order INT NOT NULL,

  question_text LONGTEXT NOT NULL,
  option_a TEXT NOT NULL,
  option_b TEXT NOT NULL,
  option_c TEXT NOT NULL,
  option_d TEXT NOT NULL,
  correct_option ENUM('A','B','C','D') NOT NULL,

  difficulty ENUM('Easy','Medium','Hard') DEFAULT NULL,
  time_secs INT DEFAULT 0,
  marks INT DEFAULT 1,

  FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
  UNIQUE (quiz_id, q_order)
);

-- ============================
-- ASSIGNMENTS
-- ============================
CREATE TABLE assignments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quiz_id INT NOT NULL,
  assigned_by INT NOT NULL,
  student_id INT DEFAULT NULL,

  due_at TIMESTAMP DEFAULT NULL,
  status ENUM('assigned','completed','expired') DEFAULT 'assigned',
  assigned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
  FOREIGN KEY (assigned_by) REFERENCES teachers(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- ============================
-- ATTEMPTS
-- ============================
CREATE TABLE attempts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  assignment_id INT NOT NULL,
  quiz_id INT NOT NULL,
  student_id INT NOT NULL,

  submitted_answers JSON NOT NULL,
  total_correct INT DEFAULT 0,
  percentage DECIMAL(5,2) DEFAULT NULL,
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (assignment_id) REFERENCES assignments(id) ON DELETE CASCADE,
  FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- ============================
-- RETRIEVAL RECORDS (Tracking which chunks were used)
-- ============================
CREATE TABLE retrieval_records (
  id INT AUTO_INCREMENT PRIMARY KEY,
  quiz_id INT NOT NULL,
  chunk_id INT NOT NULL,
  similarity_score DECIMAL(5,4) DEFAULT NULL,
  used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (quiz_id) REFERENCES quizzes(id) ON DELETE CASCADE,
  FOREIGN KEY (chunk_id) REFERENCES chunks(id) ON DELETE CASCADE
);



CREATE TABLE question_bank (
    id INT AUTO_INCREMENT PRIMARY KEY,

    -- The text of the chunk used to create this MCQ
    input_chunk LONGTEXT NOT NULL,

    -- Reference to the source chunk from lecture notes
    chunk_id INT NOT NULL,

    -- MCQ Content
    question LONGTEXT NOT NULL,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,

    -- Correct answer
    correct_option ENUM('A','B','C','D') NOT NULL,

    -- Metadata
    difficulty ENUM('Easy','Medium','Hard') DEFAULT NULL,
    time_secs INT DEFAULT 0,

    -- Foreign key linking back to RAG chunks
    FOREIGN KEY (chunk_id) REFERENCES chunks(id) ON DELETE CASCADE,

    -- Optimization
    INDEX (chunk_id)
);





CREATE TABLE processed_chunks (
    chunk_id INT PRIMARY KEY,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);





SELECT * FROM teachers;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM teaches;
SELECT * FROM enrollments;
SELECT * FROM lecture_notes;
SELECT * FROM chunks;
SELECT * FROM quizzes;
SELECT * FROM quiz_questions;
SELECT * FROM assignments;
SELECT * FROM attempts;
SELECT * FROM retrieval_records;
SELECT * FROM processed_chunks;
SELECT * FROM question_bank;

SELECT COUNT(*) FROM chunks WHERE id  = 1200;
SELECT COUNT(*) FROM chunks;
SELECT COUNT(*) FROM processed_chunks;


UPDATE chunks SET embedding = NULL WHERE lecture_notes_id = 1;
DELETE FROM chunks WHERE lecture_notes_id = 70;
DELETE FROM lecture_notes WHERE id = 86;

SELECT id, LENGTH(embedding) FROM chunks WHERE lecture_notes_id = 8;
