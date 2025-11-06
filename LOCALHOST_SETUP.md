# 🚀 Nexora AI - Local Setup Guide

This guide will help you run Nexora AI on your localhost.

## 📋 Prerequisites Checklist

Before starting, make sure you have:

- [ ] **Python 3.12+** installed ([Download](https://www.python.org/downloads/))
- [ ] **Node.js (LTS)** installed ([Download](https://nodejs.org/))
- [ ] **MySQL Server** running ([Download](https://dev.mysql.com/downloads/mysql/))
- [ ] **Docker Desktop** (optional, for easy ChromaDB setup) ([Download](https://www.docker.com/products/docker-desktop/))
- [ ] **Google Cloud Account** with billing enabled (for AI features)

---

## 🔑 Part 1: Get Your API Keys

### 1. Google Cloud / Vertex AI (CRITICAL - Required for AI features)

**Why needed?** The entire AI agent system uses Google Gemini models.

**Steps:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (e.g., "nexora-local")
3. Enable billing for the project
4. Enable these APIs:
   - Vertex AI API
   - Generative Language API (Gemini)
5. Create a Service Account:
   - Go to "IAM & Admin" → "Service Accounts"
   - Click "Create Service Account"
   - Name: `nexora-service-account`
   - Grant role: "Vertex AI User"
   - Click "Done"
6. Create a key:
   - Click on the service account you just created
   - Go to "Keys" tab
   - Click "Add Key" → "Create new key"
   - Choose "JSON"
   - Save the file as `google-credentials.json` in the `backend/` folder

**Cost:** Google Cloud offers $300 free credits for new users. Gemini API has a generous free tier.

### 2. Unsplash API (Optional - for image search)

**Why needed?** For searching and adding images to courses.

**Steps:**
1. Go to [Unsplash Developers](https://unsplash.com/developers)
2. Sign up / Log in
3. Click "New Application"
4. Accept terms and create app
5. Copy your "Access Key" and "Secret Key"

**Free tier:** 50 requests/hour

### 3. OAuth Providers (Optional - for social login)

**Why needed?** Allows users to log in with Google/GitHub/Discord.

#### Google OAuth:
1. Go to [Google Cloud Credentials](https://console.cloud.google.com/apis/credentials)
2. Click "Create Credentials" → "OAuth 2.0 Client ID"
3. Application type: "Web application"
4. Authorized redirect URIs: `http://localhost:8000/api/google/callback`
5. Copy Client ID and Client Secret

#### GitHub OAuth:
1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Click "New OAuth App"
3. Homepage URL: `http://localhost:5173`
4. Authorization callback URL: `http://localhost:8000/api/github/callback`
5. Copy Client ID and generate Client Secret

#### Discord OAuth:
1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Click "New Application"
3. Go to "OAuth2" section
4. Add redirect: `http://localhost:8000/api/discord/callback`
5. Copy Client ID and Client Secret

---

## 🗄️ Part 2: Set Up MySQL Database

### Option A: Using Command Line

```powershell
# Log into MySQL as root
mysql -u root -p

# Create database and user
CREATE DATABASE nexora_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nexora_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON nexora_db.* TO 'nexora_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Option B: Using MySQL Workbench

1. Open MySQL Workbench
2. Connect to your MySQL server
3. Run the SQL commands from Option A

**Note:** Remember your database name, username, and password for the `.env` file!

---

## ⚙️ Part 3: Configure Backend

### Step 1: Create .env file

```powershell
cd backend
copy .env.example .env
```

### Step 2: Edit .env file

Open `backend\.env` in your text editor and fill in:

**Required (Minimum to run):**
```env
# Security
SECRET_KEY=your-secret-key-here
SESSION_SECRET_KEY=your-session-secret-key-here
SECURE_COOKIE=false

# Database
DB_USER=nexora_user
DB_PASSWORD=your_secure_password
DB_HOST=localhost
DB_PORT=3306
DB_NAME=nexora_db

# Frontend
FRONTEND_BASE_URL=http://localhost:5173

# ChromaDB
CHROMA_HOST=localhost
CHROMA_PORT=8001
```

**Optional (but recommended):**
```env
# Unsplash
UNSPLASH_ACCESS_KEY=your-unsplash-access-key
UNSPLASH_SECRET_KEY=your-unsplash-secret-key

# Google OAuth
GOOGLE_CLIENT_ID=your-google-oauth-client-id
GOOGLE_CLIENT_SECRET=your-google-oauth-client-secret
```

### Step 3: Set Google Credentials

**Option A (Recommended for local dev):**
Set environment variable in PowerShell:
```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS="d:\Projects\Nexora\backend\google-credentials.json"
```

**Option B:** Add to `.env` file:
```env
GOOGLE_APPLICATION_CREDENTIALS=d:\Projects\Nexora\backend\google-credentials.json
```

### Step 4: Generate Secret Keys

```powershell
# Run in PowerShell
python -c "import secrets; print('SECRET_KEY=' + secrets.token_urlsafe(32))"
python -c "import secrets; print('SESSION_SECRET_KEY=' + secrets.token_urlsafe(32))"
```

Copy these values into your `.env` file.

### Step 5: Install Python Dependencies

```powershell
cd backend

# Create virtual environment
python -m venv venv

# Activate virtual environment
.\venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

---

## 🔮 Part 4: Set Up ChromaDB (Vector Database)

### Option A: Using Docker (Easiest)

```powershell
cd backend\chroma_db
docker-compose up -d
```

This will start ChromaDB on `localhost:8001`

### Option B: Manual Installation

```powershell
pip install chromadb
```

Then update `.env`:
```env
CHROMA_CLIENT_TYPE=persistent
```

---

## 🎨 Part 5: Configure Frontend

```powershell
cd frontend

# Install dependencies
npm install
```

**Optional:** Create `frontend\.env` if you need custom API endpoint:
```env
VITE_API_URL=http://localhost:8000
```

---

## 🚀 Part 6: Run the Application

### Start Backend

**Terminal 1 - Backend:**
```powershell
cd backend
.\venv\Scripts\activate
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000
```

**OR using the provided script:**
```powershell
cd backend
python run_dev.py
```

✅ Backend should be running at: `http://localhost:8000`
✅ API docs at: `http://localhost:8000/docs`

### Start Frontend

**Terminal 2 - Frontend:**
```powershell
cd frontend
npm run dev
```

✅ Frontend should be running at: `http://localhost:5173`

---

## 👤 Part 7: Create Admin User

After backend is running, create an admin account:

```powershell
cd backend
python create_admin.py
```

Follow the prompts to create your admin user.

---

## ✅ Verification Checklist

- [ ] Backend running at `http://localhost:8000`
- [ ] Frontend running at `http://localhost:5173`
- [ ] Can access API docs at `http://localhost:8000/docs`
- [ ] ChromaDB running (check with: `curl http://localhost:8001/api/v1/heartbeat`)
- [ ] MySQL database created and accessible
- [ ] Admin user created successfully
- [ ] Can log in to the frontend

---

## 🐛 Common Issues & Solutions

### Issue: "ModuleNotFoundError: No module named 'google.genai'"
**Solution:** Make sure you installed all requirements and activated the virtual environment:
```powershell
.\venv\Scripts\activate
pip install -r requirements.txt
```

### Issue: "Can't connect to MySQL server"
**Solution:** 
1. Make sure MySQL is running
2. Check your DB_HOST, DB_PORT, DB_USER, DB_PASSWORD in `.env`
3. Test connection: `mysql -u nexora_user -p`

### Issue: "Google Cloud authentication failed"
**Solution:**
1. Make sure you downloaded the service account JSON file
2. Set GOOGLE_APPLICATION_CREDENTIALS environment variable
3. Enable Vertex AI API in Google Cloud Console
4. Check that billing is enabled

### Issue: "ChromaDB connection refused"
**Solution:**
```powershell
# If using Docker
cd backend\chroma_db
docker-compose up -d

# Check if it's running
docker ps
curl http://localhost:8001/api/v1/heartbeat
```

### Issue: Frontend can't connect to backend
**Solution:**
1. Check backend is running on port 8000
2. Check CORS settings in backend
3. Make sure FRONTEND_BASE_URL in `.env` is correct

---

## 📊 Quick Start Summary

**Minimum Required API Keys to Run:**
1. ✅ Google Cloud Service Account (for AI features) - **REQUIRED**
2. ✅ MySQL Database credentials - **REQUIRED**
3. ⚠️ Unsplash API (optional, for images)
4. ⚠️ OAuth providers (optional, for social login)

**Estimated Setup Time:** 30-60 minutes (mostly waiting for downloads and Google Cloud setup)

**Costs:**
- Google Cloud: $0 (free tier + $300 free credits)
- Unsplash: $0 (free tier)
- Everything else: Free

---

## 🎉 Next Steps

Once everything is running:

1. Open `http://localhost:5173` in your browser
2. Register a new account or log in with admin credentials
3. Start creating your first course!
4. Explore the AI features:
   - Course generation from documents
   - AI chat per chapter
   - Quiz generation
   - Flashcards

---

## 📚 Additional Resources

- [Google Cloud Free Tier](https://cloud.google.com/free)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [React Documentation](https://react.dev/)
- [ChromaDB Documentation](https://docs.trychroma.com/)

---

## 🆘 Need Help?

If you encounter issues:
1. Check the troubleshooting section above
2. Review backend logs in the terminal
3. Check browser console for frontend errors
4. Open an issue on GitHub: https://github.com/M4RKUS28/Nexora/issues

Good luck! 🚀
