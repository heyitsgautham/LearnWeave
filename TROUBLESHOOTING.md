# 🔧 Nexora AI - Troubleshooting Guide

Common issues and their solutions when running Nexora AI locally.

---

## 🚨 Critical Issues

### 1. Google Cloud Authentication Error

**Error messages:**
- `Could not automatically determine credentials`
- `google.auth.exceptions.DefaultCredentialsError`
- `Application Default Credentials not found`

**Solutions:**

✅ **Option A: Set environment variable (Recommended for Windows)**
```powershell
# Add to your PowerShell profile or run before starting the app
$env:GOOGLE_APPLICATION_CREDENTIALS="d:\Projects\Nexora\backend\google-credentials.json"

# Or set it permanently:
[System.Environment]::SetEnvironmentVariable('GOOGLE_APPLICATION_CREDENTIALS', 'd:\Projects\Nexora\backend\google-credentials.json', 'User')
```

✅ **Option B: Add to .env file**
```env
GOOGLE_APPLICATION_CREDENTIALS=d:\Projects\Nexora\backend\google-credentials.json
```

✅ **Option C: Verify your service account has correct permissions**
1. Go to Google Cloud Console
2. IAM & Admin → Service Accounts
3. Make sure your service account has "Vertex AI User" role
4. Make sure Vertex AI API is enabled

---

### 2. MySQL Connection Error

**Error messages:**
- `Can't connect to MySQL server`
- `Access denied for user`
- `Unknown database 'nexora_db'`

**Solutions:**

✅ **Check MySQL is running:**
```powershell
# Check if MySQL service is running
Get-Service MySQL* | Select-Object Name, Status

# If not running, start it
Start-Service MySQL80  # or your MySQL service name
```

✅ **Verify database exists:**
```powershell
mysql -u root -p
```
```sql
SHOW DATABASES;
USE nexora_db;
```

✅ **Check credentials in .env:**
```env
DB_USER=nexora_user
DB_PASSWORD=your_password  # Make sure this matches what you set
DB_HOST=localhost
DB_PORT=3306
DB_NAME=nexora_db
```

✅ **Recreate database and user:**
```sql
DROP DATABASE IF EXISTS nexora_db;
DROP USER IF EXISTS 'nexora_user'@'localhost';

CREATE DATABASE nexora_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nexora_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON nexora_db.* TO 'nexora_user'@'localhost';
FLUSH PRIVILEGES;
```

---

### 3. ChromaDB Connection Error

**Error messages:**
- `Connection refused at localhost:8001`
- `Failed to connect to Chroma server`

**Solutions:**

✅ **Start ChromaDB container:**
```powershell
cd backend\chroma_db
docker-compose up -d

# Check if it's running
docker ps
```

✅ **Check ChromaDB health:**
```powershell
curl http://localhost:8001/api/v1/heartbeat
```

✅ **Check if port 8001 is available:**
```powershell
netstat -ano | findstr :8001
```

✅ **If port is in use, kill the process or change port in .env:**
```env
CHROMA_PORT=8002  # Use a different port
CHROMA_DB_URL=http://localhost:8002
```

---

## ⚠️ Backend Issues

### 4. ModuleNotFoundError: No module named 'X'

**Error:** Missing Python packages

**Solutions:**

✅ **Make sure virtual environment is activated:**
```powershell
cd backend
.\venv\Scripts\activate
# You should see (venv) in your prompt
```

✅ **Reinstall dependencies:**
```powershell
pip install -r requirements.txt --force-reinstall
```

✅ **If specific package fails (e.g., mysqlclient):**
```powershell
# For Windows, some packages need Microsoft C++ Build Tools
# Download from: https://visualstudio.microsoft.com/visual-cpp-build-tools/
```

---

### 5. Port 8000 Already in Use

**Error:** `Address already in use`

**Solutions:**

✅ **Find and kill the process:**
```powershell
# Find process using port 8000
netstat -ano | findstr :8000

# Kill the process (replace PID with actual process ID)
taskkill /PID <PID> /F
```

✅ **Use a different port:**
```powershell
uvicorn src.main:app --reload --port 8080
```

---

### 6. CORS Errors

**Error:** `Access to XMLHttpRequest blocked by CORS policy`

**Solutions:**

✅ **Check FRONTEND_BASE_URL in .env:**
```env
FRONTEND_BASE_URL=http://localhost:5173
```

✅ **Make sure backend CORS settings allow your frontend:**
Check `backend/src/main.py` for CORS configuration.

---

## 🎨 Frontend Issues

### 7. Frontend Won't Start

**Error messages:**
- `Cannot find module`
- `ENOENT: no such file or directory`

**Solutions:**

✅ **Delete and reinstall node_modules:**
```powershell
cd frontend
Remove-Item -Recurse -Force node_modules
Remove-Item -Force package-lock.json
npm install
```

✅ **Clear npm cache:**
```powershell
npm cache clean --force
npm install
```

---

### 8. Frontend Can't Connect to Backend

**Error:** `Network Error` or `ERR_CONNECTION_REFUSED`

**Solutions:**

✅ **Make sure backend is running:**
```powershell
curl http://localhost:8000/docs
```

✅ **Check API URL in frontend:**
If you have a `frontend/.env` file, check:
```env
VITE_API_URL=http://localhost:8000
```

✅ **Check browser console for actual error message**

---

## 🔐 Authentication Issues

### 9. Can't Login / Token Invalid

**Solutions:**

✅ **Check SECRET_KEY in .env is set and doesn't have spaces:**
```env
SECRET_KEY=your-secret-key-here-no-spaces
SESSION_SECRET_KEY=your-session-key-here-no-spaces
```

✅ **Generate new secret keys:**
```powershell
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

✅ **Clear browser cookies and local storage:**
- Open DevTools (F12)
- Application → Storage → Clear site data

---

### 10. Admin User Creation Fails

**Solutions:**

✅ **Make sure database is connected and tables are created:**
```powershell
cd backend
python -c "from src.db.database import engine; from src.db.models import Base; Base.metadata.create_all(bind=engine)"
```

✅ **Then create admin:**
```powershell
python create_admin.py
```

---

## 🐳 Docker Issues

### 11. Docker Compose Fails

**Solutions:**

✅ **Make sure Docker Desktop is running:**
```powershell
docker --version
docker ps
```

✅ **Check docker-compose.yml paths:**
Make sure the Google credentials path is correct:
```yaml
volumes:
  - ./google-credentials.json:/home/app/web/google-credentials.json:ro
```

✅ **Rebuild containers:**
```powershell
docker-compose down
docker-compose up --build
```

---

## 📦 Dependency Issues

### 12. Conflicting Python Versions

**Solutions:**

✅ **Use Python 3.12 specifically:**
```powershell
py -3.12 -m venv venv
```

✅ **Check your Python version:**
```powershell
python --version  # Should be 3.12+
```

---

### 13. npm Install Fails / Package Errors

**Solutions:**

✅ **Use compatible Node.js version (LTS):**
```powershell
node --version  # Should be 18.x or 20.x LTS
```

✅ **Try legacy peer deps:**
```powershell
npm install --legacy-peer-deps
```

✅ **Increase Node memory:**
```powershell
$env:NODE_OPTIONS="--max-old-space-size=4096"
npm install
```

---

## 🤖 AI Agent Issues

### 14. AI Responses Not Working

**Solutions:**

✅ **Check Google Cloud quota:**
1. Go to Google Cloud Console
2. Navigate to "Quotas"
3. Check Vertex AI API quota

✅ **Verify API is enabled:**
1. APIs & Services → Enabled APIs
2. Make sure "Vertex AI API" and "Generative Language API" are enabled

✅ **Check agent debug mode:**
```env
AGENT_DEBUG_MODE=true
```
Then check backend logs for detailed error messages.

---

### 15. Slow AI Responses

**Solutions:**

✅ **This is normal for first request** - Models need to warm up

✅ **Check your internet connection**

✅ **Consider using a different Google Cloud region** if you're far from the default region

---

## 🔍 Debugging Tips

### General Debugging Steps:

1. **Check backend logs:**
   - Look at the terminal where backend is running
   - Enable debug mode in .env

2. **Check frontend console:**
   - Open DevTools (F12)
   - Look for errors in Console tab
   - Check Network tab for failed requests

3. **Verify all services are running:**
   ```powershell
   # Backend
   curl http://localhost:8000/docs
   
   # Frontend
   curl http://localhost:5173
   
   # ChromaDB
   curl http://localhost:8001/api/v1/heartbeat
   ```

4. **Check all environment variables:**
   ```powershell
   cd backend
   .\venv\Scripts\activate
   python -c "from src.config import settings; print(f'DB: {settings.DB_NAME}, Host: {settings.DB_HOST}')"
   ```

---

## 📞 Still Having Issues?

### Check These Files:

1. `backend/.env` - All variables filled correctly?
2. `backend/google-credentials.json` - File exists and valid?
3. MySQL database - Created and accessible?
4. Chrome DevTools - Any JavaScript errors?
5. Backend terminal - Any Python errors?

### Get Help:

1. **Read detailed setup:** `LOCALHOST_SETUP.md`
2. **Check API keys:** `API_KEYS_REFERENCE.md`
3. **Open an issue:** https://github.com/M4RKUS28/Nexora/issues
4. **Include in your report:**
   - Error message (full text)
   - Operating system and versions
   - Steps to reproduce
   - Relevant logs

---

## ✅ Quick Health Check

Run these commands to verify everything is working:

```powershell
# 1. Check Python
python --version  # Should be 3.12+

# 2. Check Node
node --version  # Should be 18.x or 20.x

# 3. Check MySQL
mysql -u nexora_user -p -e "USE nexora_db; SHOW TABLES;"

# 4. Check Docker (if using)
docker ps

# 5. Check backend
curl http://localhost:8000/docs

# 6. Check ChromaDB
curl http://localhost:8001/api/v1/heartbeat

# 7. Check frontend
curl http://localhost:5173
```

If all these work, you're good to go! 🚀
