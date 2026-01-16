# Automated Quiz Generation & Assessment System

A full-stack intelligent assessment platform that leverages Generative AI (RAG + Phi-3) to automate quiz creation from lecture notes. Designed for educational institutions to streamline the workflow between Admins, Teachers, and Students.

![Project Banner](replace_this_with_your_banner_link)

## 🚀 Key Features

### 🎓 For Teachers
- **AI Quiz Generation**: Upload PDF lecture notes and generate tailored MCQs automatically using local LLM (Phi-3).
- **RAG Powered**: Questions are context-aware, extracted directly from specific chunks of your documents.
- **Question Bank**: Manage a library of generated questions; edit, approve, or reject them.
- **Manual & AI Mix**: Create quizzes by mixing AI-generated questions with manual entries.
- **Course Management**: Organize materials and quizzes by course.

### 📚 For Students
- **Smart Assessment**: Take quizzes within a timed, secure environment.
- **Instant Results**: Get immediate feedback and grading upon submission.
- **Progress Tracking**: View history of attempted quizzes and performance trends.

### 🛡️ For Admins
- **User Management**: Register and manage Teacher and Student accounts.
- **Course Allocation**: Assign courses to teachers and enroll students.

---

## 🛠️ Tech Stack

- **Backend**: Python (FastAPI), SQLAlchemy (MySQL), pypdf
- **AI Engine**: Microsoft Phi-3 (GGUF Quantized) + RAG (Vector Embeddings)
- **Frontend**: Flutter (Dart) - Desktop/Web
- **Database**: MySQL

---

## ⚙️ Setup Instructions

### 1. Database Setup
1. Install MySQL Server.
2. Create a new database named `QuizGenerationAssessment`.
3. Import the schema file `QuizGenerationAssessment Schema.sql` located in the root directory.

### 2. Backend Setup
The backend requires a local LLM model to function.

1. Navigate to `quiz_backend_rag/`.
2. Create a virtual environment and install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. **Download the Model**:
   - Download `Phi-3-mini-128k-instruct.Q4_K_M.gguf` (approx 2.4GB).
   - Place it in: `quiz_backend_rag/ml_model/`.
4. Run the server:
   ```bash
   uvicorn api.main:app --reload
   ```

### 3. Frontend Setup
1. Navigate to `quiz_frontend/`.
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```
├── quiz_backend_rag/      # FastAPI Server & AI Logic
│   ├── api/               # API Routers, Models, Services
│   ├── ml_model/          # Place your .gguf model here
│   └── ...
├── quiz_frontend/         # Flutter Application
│   ├── lib/
│   │   ├── screens/       # UI Screens (Admin, Teacher, Student)
│   │   └── ...
│   └── ...
└── QuizGenerationAssessment Schema.sql  # Database Script
```

## 🤝 Contributing
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/NewFeature`).
3. Commit your changes.
4. Push to the branch.
5. Open a Pull Request.

## 📄 License
[MIT License](LICENSE)
