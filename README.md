# 🌿 OhMyGut!

OhMyGut! adalah aplikasi mobile personal tracker yang membantu pengguna menemukan hubungan antara **pola makan, kebiasaan harian, dan gejala tubuh** seperti jerawat, rambut rontok, kembung, hingga mood.

> “Cari tahu apa yang tubuhmu coba bilang.”

---

## 🚀 Features

### 🍽 Daily Tracking
- Food log (quick tap, tanpa ribet)
- Symptom log (berdasarkan keluhan user)
- Habit log (tidur, stres, olahraga, dll)

### 📊 Weekly Report
- Ringkasan kondisi tubuh mingguan
- Trend gejala
- Insight minggu ini
- Actionable tips

## 🧠 AI Features

### 1. Data Analysis (Correlation Engine)
- Menganalisis hubungan antara:
  - Makanan (susu, gorengan, fast food, dll)
  - Kebiasaan (tidur, stres, olahraga, air minum)
  - Gejala tubuh (jerawat, rambut rontok, mood, dll)
- Menggunakan **Pearson Correlation**
- Mendukung **time lag 1–3 hari** untuk menangkap efek tertunda

### 2. Pattern Detection
- Menyaring korelasi yang signifikan
- Mengurutkan berdasarkan kekuatan hubungan
- Memilih top pattern paling relevan untuk user

### 3. AI Insight Generation (Gemini)
- Mengubah hasil statistik menjadi bahasa natural
- Menyajikan:
  - Insight yang mudah dipahami
  - Confidence level (rendah/sedang/tinggi)
  - Penjelasan singkat
  - Rekomendasi aksi yang bisa dilakukan

---

## 🧩 Tech Stack

- **Frontend**: Flutter
- **Backend & Database**: Firebase
- **AI Engine**: FastAPI + LLM integration
- **Respone Generation**: Gemini AI
- **Statistics** :custom Pearson implementation

---

## 🔗 AI Model Repostory

👉 AI Service: `ohmygut-ai` 🔗[View Repository](https://github.com/nowwie/OhMyGutAI.git)

---

## 🧠 Concept

OhMyGut! bekerja seperti **health detective**:
1. User mencatat makanan & kondisi tubuh
2. Data dikumpulkan selama beberapa hari
3. AI menemukan pola tersembunyi
4. User dapat insight personal

---

## ⚠️ Disclaimer

Aplikasi ini **bukan alat diagnosis medis**.  
Insight yang diberikan hanya berupa pola dan kemungkinan.

---

