# 🐳 Docker Deployment Guide - Nexora AI

## ✅ Setup Complete!

Your environment is now configured:
- ✅ `.env` file created with secure keys
- ✅ Google credentials path configured
- ✅ docker-compose.yml updated
- ✅ Environment variable set for local development

---

## 📦 What's Configured

### 1. Local Development (Windows)
```env
GOOGLE_APPLICATION_CREDENTIALS=d:\Projects\Nexora\backend\google-credentials.json
```
Environment variable set permanently for your user account.

### 2. Docker Deployment
```yaml
volumes:
  - ./google-credentials.json:/home/app/web/google-credentials.json:ro
environment:
  - GOOGLE_APPLICATION_CREDENTIALS=/home/app/web/google-credentials.json
```
The credentials file will be mounted into the container.

---

## 🚀 How to Deploy

### Option 1: Run Everything with Docker Compose (Recommended)

```powershell
# Navigate to backend folder
cd d:\Projects\Nexora\backend

# Build and start all services (backend + ChromaDB)
docker-compose up --build

# Or run in detached mode (background)
docker-compose up -d --build
```

This will:
- ✅ Build the Docker image with your code
- ✅ Mount your google-credentials.json into the container
- ✅ Start the backend on port 8127 (mapped to 8000 in container)
- ✅ Start ChromaDB on port 8001
- ✅ Load all environment variables from .env

### Option 2: Run Locally (Without Docker)

```powershell
# Terminal 1 - Start ChromaDB
cd backend\chroma_db
docker-compose up -d

# Terminal 2 - Start Backend
cd backend
.\venv\Scripts\activate
uvicorn src.main:app --reload --host 0.0.0.0 --port 8000

# Terminal 3 - Start Frontend
cd frontend
npm run dev
```

---

## 🌐 Access Your Application

After starting with Docker Compose:

- **Backend API:** http://localhost:8127
- **API Documentation:** http://localhost:8127/docs
- **ChromaDB:** http://localhost:8001

If running locally:
- **Backend API:** http://localhost:8000
- **Frontend:** http://localhost:5173
- **ChromaDB:** http://localhost:8001

---

## 🔍 Verify Everything Works

### 1. Check Containers are Running
```powershell
docker ps
```
You should see:
- `nexora` container (backend)
- `nexora-chromadb` container

### 2. Check Backend Logs
```powershell
docker logs nexora -f
```
Look for:
- ✅ "Application startup complete"
- ✅ No authentication errors
- ❌ Any error messages

### 3. Test API
```powershell
# Test health endpoint
curl http://localhost:8127/docs

# Should open API documentation in browser
```

### 4. Test Google Credentials
```powershell
# Check if credentials are accessible in container
docker exec nexora cat /home/app/web/google-credentials.json | Select-Object -First 3
```

---

## 🛠️ Common Docker Commands

### View Logs
```powershell
# All logs
docker-compose logs

# Follow logs (real-time)
docker-compose logs -f

# Specific service logs
docker-compose logs app
docker-compose logs chromadb
```

### Restart Services
```powershell
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart app
```

### Stop Services
```powershell
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

### Rebuild After Code Changes
```powershell
# Rebuild and restart
docker-compose up --build

# Force rebuild (no cache)
docker-compose build --no-cache
docker-compose up
```

### Access Container Shell
```powershell
# Access backend container
docker exec -it nexora bash

# Check environment variables
docker exec nexora env | Select-String GOOGLE
```

---

## 🔧 Update Your Code and Redeploy

When you make code changes:

```powershell
cd backend

# Stop current containers
docker-compose down

# Rebuild and start
docker-compose up --build -d

# Check logs
docker-compose logs -f app
```

---

## 📊 Environment Variables in Docker

The container uses environment variables from:

1. **`.env` file** (loaded via `env_file` in docker-compose.yml)
2. **`environment` section** in docker-compose.yml (overrides .env)
3. **Dockerfile ENV statements** (defaults)

Priority: environment > env_file > Dockerfile

---

## 🔒 Security Notes

### ✅ Already Configured
- Google credentials file is mounted as read-only (`:ro`)
- `.env` file is in `.gitignore` (not committed)
- Credentials file should be in `.gitignore`

### ⚠️ Before Pushing to Production
1. **Never commit** `.env` or `google-credentials.json`
2. **Use secrets management** (Docker secrets, Kubernetes secrets, or cloud provider secrets)
3. **Change SECRET_KEY and SESSION_SECRET_KEY** for production
4. **Enable HTTPS** and set `SECURE_COOKIE=true`
5. **Use proper database** (not localhost)
6. **Set appropriate CORS origins**

---

## 🐛 Troubleshooting

### Issue: Container can't find credentials

```powershell
# Check if file is mounted
docker exec nexora ls -la /home/app/web/google-credentials.json

# Check environment variable
docker exec nexora env | Select-String GOOGLE
```

### Issue: Permission denied on credentials file

```powershell
# Ensure file has correct permissions (Windows)
icacls "google-credentials.json"

# In container (if needed)
docker exec nexora ls -la /home/app/web/google-credentials.json
# Should show: -r--r--r-- (read-only)
```

### Issue: Changes not reflected

```powershell
# Rebuild without cache
docker-compose build --no-cache
docker-compose up
```

### Issue: Port already in use

```powershell
# Check what's using the port
netstat -ano | findstr :8127

# Change port in docker-compose.yml
# Change "8127:8000" to "8128:8000"
```

---

## 🚀 Production Deployment Checklist

When deploying to production:

- [ ] Set up proper domain and SSL certificate
- [ ] Update `FRONTEND_BASE_URL` in .env
- [ ] Update OAuth redirect URIs
- [ ] Set `SECURE_COOKIE=true`
- [ ] Use production database (not localhost)
- [ ] Set up proper logging and monitoring
- [ ] Use Docker secrets or cloud secrets manager
- [ ] Set up automated backups
- [ ] Configure proper CORS origins
- [ ] Set up rate limiting
- [ ] Enable security headers
- [ ] Use reverse proxy (nginx/traefik)

---

## 📚 Next Steps

1. **Start Frontend:**
   ```powershell
   cd frontend
   npm run dev
   ```

2. **Create Admin User:**
   ```powershell
   docker exec -it nexora python create_admin.py
   # Or locally:
   cd backend
   python create_admin.py
   ```

3. **Open Application:**
   - Frontend: http://localhost:5173
   - Backend: http://localhost:8127

4. **Test Features:**
   - Create a course
   - Test AI chat
   - Generate quizzes

---

## 🎉 You're Ready!

Your Docker deployment is configured and ready to run!

**Quick Start:**
```powershell
cd backend
docker-compose up --build
```

Then open http://localhost:8127/docs to see your API!

---

*For local development without Docker, see LOCALHOST_SETUP.md*
