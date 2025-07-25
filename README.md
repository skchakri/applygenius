# ApplyGenius

> Automate your LinkedIn job applications with GPT-powered, personalized cover letters — in Ruby.

ApplyGenius is a complete Ruby application that logs into LinkedIn, finds relevant "Ruby on Rails" jobs, generates tailored cover letters using OpenAI GPT, uploads your resume and letter, applies via Easy Apply, emails the documents to you, and logs everything in both CSV and Google Sheets.

---

## ✨ Features

- 🔐 Secure LinkedIn login via environment variables
- 🔎 Job search for “Ruby on Rails” positions
- 🤖 GPT-4-powered custom cover letter generation (PDF + TXT)
- 📧 Emails cover letters to you using Gmail SMTP
- ✅ Automatically applies via Easy Apply
- 📊 Logs each application to `jobs_applied.csv`
- 📋 Syncs job data and GPT output to Google Sheets
- 🚫 Skips duplicates and irrelevant job titles
- 🧱 Modular structure, cron-friendly

---

## 🚀 Getting Started

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/ApplyGenius.git
cd ApplyGenius
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Add your config

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

### 4. Add your resume

Place your PDF resume at the root as `resume.pdf`.

### 5. Set up Google Sheets API

- Create a project in [Google Cloud Console](https://console.cloud.google.com/)
- Enable **Google Drive API**
- Create a **service account**, generate a JSON key
- Share your spreadsheet with the service account email
- Save key as `config.json` in the project root

---

## 🧪 Run it

```bash
ruby linkedin_apply.rb
```

---

## 🕒 Automate It

Set it to run daily at 10AM via cron:

```cron
0 10 * * * cd /full/path/to/ApplyGenius && /usr/bin/ruby linkedin_apply.rb >> log.txt 2>&1
```

---

## 📂 Folder Structure

```
ApplyGenius/
├── .env.example
├── config.json
├── resume.pdf
├── linkedin_apply.rb
├── cover_letters/
├── jobs_applied.csv
├── lib/
│   ├── linkedin_bot.rb
│   ├── openai_writer.rb
│   ├── email_sender.rb
│   ├── job_logger.rb
│   ├── google_sheets_logger.rb
│   └── utils.rb
```

---

## 🔐 .gitignore (recommended)

```gitignore
.env
config.json
*.pdf
*.txt
cover_letters/*
jobs_applied.csv
```

---

## 🧠 Tech Stack

- Ruby
- Selenium
- OpenAI API (GPT-4)
- Google Sheets API
- Gmail SMTP
- Prawn PDF generation

---

## 💡 Next Ideas

- Support multiple roles/keywords
- Browserless mode (headless)
- Telegram or Slack alerts
- Multi-step form automation
- Resume generation via GPT

---

## 🧑‍💻 Author

Built with ❤️ by [Your Name]  
Let AI help you get hired — faster.
