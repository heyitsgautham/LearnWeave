# 🔑 Nexora AI - API Keys Quick Reference

## Required API Keys (Must Have)

### 1. ✅ Google Cloud Service Account (CRITICAL)
**What:** Google Gemini AI for course generation and AI features  
**Where to get:** https://console.cloud.google.com/  
**Cost:** FREE ($300 credits + generous free tier)  
**Setup time:** 15-20 minutes  

**Quick Steps:**
1. Create Google Cloud project
2. Enable "Vertex AI API" and "Generative Language API"
3. Create Service Account with "Vertex AI User" role
4. Download JSON key → Save as `backend/google-credentials.json`
5. Set in `.env`: `GOOGLE_APPLICATION_CREDENTIALS=path/to/json`

**Without this:** ❌ App won't work (AI features are core functionality)

---

### 2. ✅ MySQL Database Credentials
**What:** Main database for users, courses, and content  
**Where to get:** Local MySQL installation  
**Cost:** FREE  
**Setup time:** 10 minutes  

**Quick Steps:**
```sql
CREATE DATABASE nexora_db;
CREATE USER 'nexora_user'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON nexora_db.* TO 'nexora_user'@'localhost';
```

**Add to .env:**
```env
DB_USER=nexora_user
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=3306
DB_NAME=nexora_db
```

**Without this:** ❌ App won't start

---

## Optional API Keys (Recommended)

### 3. ⚠️ Unsplash API
**What:** Image search for course content  
**Where to get:** https://unsplash.com/developers  
**Cost:** FREE (50 requests/hour)  
**Setup time:** 5 minutes  

**Quick Steps:**
1. Sign up at Unsplash
2. Create new application
3. Copy Access Key and Secret Key

**Add to .env:**
```env
UNSPLASH_ACCESS_KEY=your-access-key
UNSPLASH_SECRET_KEY=your-secret-key
```

**Without this:** ⚠️ Image search won't work (but app runs fine)

---

### 4. ⚠️ Google OAuth (Social Login)
**What:** "Login with Google" button  
**Where to get:** https://console.cloud.google.com/apis/credentials  
**Cost:** FREE  
**Setup time:** 5 minutes  

**Quick Steps:**
1. Go to Google Cloud Console → Credentials
2. Create OAuth 2.0 Client ID
3. Add redirect: `http://localhost:8000/api/google/callback`
4. Copy Client ID and Secret

**Add to .env:**
```env
GOOGLE_CLIENT_ID=your-client-id
GOOGLE_CLIENT_SECRET=your-client-secret
GOOGLE_REDIRECT_URI=http://localhost:8000/api/google/callback
```

**Without this:** ⚠️ Google login won't work (but normal login works)

---

### 5. ⚠️ GitHub OAuth (Social Login)
**What:** "Login with GitHub" button  
**Where to get:** https://github.com/settings/developers  
**Cost:** FREE  
**Setup time:** 5 minutes  

**Quick Steps:**
1. Go to GitHub Settings → Developer settings → OAuth Apps
2. Create new OAuth App
3. Callback URL: `http://localhost:8000/api/github/callback`
4. Copy Client ID and generate Secret

**Add to .env:**
```env
GITHUB_CLIENT_ID=your-client-id
GITHUB_CLIENT_SECRET=your-client-secret
GITHUB_REDIRECT_URI=http://localhost:8000/api/github/callback
```

**Without this:** ⚠️ GitHub login won't work (but normal login works)

---

### 6. ⚠️ Discord OAuth (Social Login)
**What:** "Login with Discord" button  
**Where to get:** https://discord.com/developers/applications  
**Cost:** FREE  
**Setup time:** 5 minutes  

**Quick Steps:**
1. Create new Discord Application
2. Go to OAuth2 settings
3. Add redirect: `http://localhost:8000/api/discord/callback`
4. Copy Client ID and Secret

**Add to .env:**
```env
DISCORD_CLIENT_ID=your-client-id
DISCORD_CLIENT_SECRET=your-client-secret
DISCORD_REDIRECT_URI=http://localhost:8000/api/discord/callback
```

**Without this:** ⚠️ Discord login won't work (but normal login works)

---

## Security Keys (Auto-generated)

### 7. ✅ JWT Secret Keys
**What:** For secure token signing  
**Generate with:**
```powershell
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

**Add to .env:**
```env
SECRET_KEY=<generated-key-1>
SESSION_SECRET_KEY=<generated-key-2>
```

**Without this:** ❌ Authentication won't work

---

## Summary Priority List

### To Run Locally (Minimum):
1. ✅ **Google Cloud Service Account** (MUST HAVE)
2. ✅ **MySQL Database** (MUST HAVE)
3. ✅ **Secret Keys** (auto-generate)

**Estimated setup time:** 30 minutes  
**Cost:** $0 (all free tiers)

### For Full Features:
4. ⚠️ Unsplash API (nice to have)
5. ⚠️ OAuth Providers (nice to have)

**Estimated setup time:** +15 minutes  
**Cost:** $0

---

## Quick Setup Checklist

- [ ] Install Python 3.12+
- [ ] Install Node.js LTS
- [ ] Install MySQL Server
- [ ] Get Google Cloud credentials (**REQUIRED**)
- [ ] Create MySQL database
- [ ] Generate secret keys
- [ ] Copy `.env.example` to `.env`
- [ ] Fill in all keys in `.env`
- [ ] (Optional) Get Unsplash API keys
- [ ] (Optional) Set up OAuth providers
- [ ] Install Python dependencies
- [ ] Install Node.js dependencies
- [ ] Start ChromaDB
- [ ] Run backend
- [ ] Run frontend
- [ ] Create admin user

---

## Cost Breakdown

| Service | Free Tier | Paid | Notes |
|---------|-----------|------|-------|
| Google Cloud (Gemini) | $300 credits + generous free tier | Pay-as-you-go | Required |
| MySQL | FREE | - | Local install |
| ChromaDB | FREE | - | Local/Docker |
| Unsplash | 50 req/hour | $0 | Optional |
| OAuth Providers | FREE | - | Optional |
| **TOTAL** | **$0** | - | With free tiers |

---

## Help & Resources

- **Setup Guide:** See `LOCALHOST_SETUP.md`
- **Issues:** https://github.com/M4RKUS28/Nexora/issues
- **Google Cloud Free:** https://cloud.google.com/free
- **Unsplash Developers:** https://unsplash.com/developers

---

## TL;DR - Just Get Me Running!

**Absolute minimum to run the app:**

1. Get Google Cloud credentials (15 min)
2. Install MySQL and create database (10 min)
3. Run setup script: `.\setup.ps1` (5 min)
4. Edit `.env` with your keys (5 min)
5. Start app (2 min)

**Total: ~40 minutes** 🚀
