# 🔐 Google Cloud Service Account Setup for Nexora AI

## Step-by-Step Guide

You've already created a service account - great! Now let's configure it properly.

---

## 📋 Part 1: Required APIs to Enable

### 1. Enable Required APIs

Go to **APIs & Services → Library** and enable these APIs:

#### ✅ **Vertex AI API** (CRITICAL)
- Search for: "Vertex AI API"
- Click **Enable**
- **Why:** This is the main API for Google Gemini models used by Nexora

#### ✅ **Generative Language API** (CRITICAL)
- Search for: "Generative Language API" or "Gemini API"
- Click **Enable**
- **Why:** Required for the Gemini 2.5 Flash model used in agents

#### ⚠️ **Cloud Resource Manager API** (Recommended)
- Search for: "Cloud Resource Manager API"
- Click **Enable**
- **Why:** For better project management and permissions

#### ⚠️ **Service Usage API** (Recommended)
- Might already be enabled
- **Why:** For monitoring API usage

---

## 🔑 Part 2: Service Account Permissions (IAM Roles)

### Go to IAM & Admin → Service Accounts

Find your service account and configure permissions:

### **Required Role:**

#### 1. **Vertex AI User**
- **Role name:** `roles/aiplatform.user`
- **What it does:** Allows using Vertex AI models (Gemini)
- **Required permissions include:**
  - `aiplatform.endpoints.predict`
  - `aiplatform.models.predict`
  - `aiplatform.publishers.predict`

### **How to Add:**

**Method A: Via Service Account Page**
1. Go to **IAM & Admin → Service Accounts**
2. Click on your service account
3. Go to **Permissions** tab
4. Click **Grant Access**
5. Add role: **Vertex AI User**

**Method B: Via IAM Page** (Recommended)
1. Go to **IAM & Admin → IAM**
2. Click **Grant Access**
3. In "New principals", enter your service account email
   (e.g., `nexora-sa@your-project.iam.gserviceaccount.com`)
4. Select role: **Vertex AI User**
5. Click **Save**

---

## 🎯 Part 3: Additional Recommended Roles (Optional but Useful)

If you want more comprehensive access for development/debugging:

### **Option 1: Minimal Setup (Recommended for Production)**
- ✅ Vertex AI User **(required)**

### **Option 2: Development Setup (More permissions for testing)**
- ✅ Vertex AI User
- ✅ **Logs Writer** (`roles/logging.logWriter`) - For Cloud Logging
- ✅ **Monitoring Metric Writer** (`roles/monitoring.metricWriter`) - For monitoring

### **Option 3: Full Setup (Maximum flexibility)**
- ✅ Vertex AI User
- ✅ Vertex AI Service Agent
- ✅ Storage Object Viewer (if you plan to use Cloud Storage)
- ✅ Logs Writer
- ✅ Monitoring Metric Writer

**For Nexora AI, Option 1 (Minimal Setup) is sufficient!**

---

## 📥 Part 4: Download Service Account Key

### If you haven't downloaded the JSON key yet:

1. Go to **IAM & Admin → Service Accounts**
2. Click on your service account
3. Go to **Keys** tab
4. Click **Add Key → Create new key**
5. Choose **JSON** format
6. Click **Create**
7. The JSON file will download automatically

### Save the file:
- Rename it to something memorable: `google-credentials.json` or `nexora-service-account.json`
- Move it to: `d:\Projects\Nexora\backend\`
- **IMPORTANT:** Never commit this file to Git!

---

## 💰 Part 5: Enable Billing

**CRITICAL:** Vertex AI requires billing to be enabled (even for free tier)

1. Go to **Billing** in Google Cloud Console
2. Link a billing account to your project
3. **Don't worry:** You get:
   - $300 free credits for new users
   - Generous free tier for Gemini API
   - You won't be charged unless you exceed free tier

### Gemini API Free Tier (as of Nov 2025):
- **Gemini 2.5 Flash:** 
  - 15 requests per minute (RPM)
  - 1 million tokens per minute (TPM)
  - 1,500 requests per day (RPD)
- **This is MORE than enough for development and testing!**

---

## ✅ Part 6: Verify Setup

### Check 1: APIs are Enabled
```
Google Cloud Console → APIs & Services → Enabled APIs
```
You should see:
- ✅ Vertex AI API
- ✅ Generative Language API

### Check 2: Service Account has Correct Role
```
IAM & Admin → IAM
```
Find your service account email and verify it has:
- ✅ Vertex AI User role

### Check 3: Key Downloaded
- ✅ JSON file is in `d:\Projects\Nexora\backend\`
- ✅ File has content (not empty)

---

## 🔧 Part 7: Configure Nexora to Use the Credentials

### Option A: Environment Variable (Recommended for Windows)

**In PowerShell:**
```powershell
# Set for current session
$env:GOOGLE_APPLICATION_CREDENTIALS="d:\Projects\Nexora\backend\google-credentials.json"

# Set permanently (User level)
[System.Environment]::SetEnvironmentVariable('GOOGLE_APPLICATION_CREDENTIALS', 'd:\Projects\Nexora\backend\google-credentials.json', 'User')

# Verify it's set
echo $env:GOOGLE_APPLICATION_CREDENTIALS
```

### Option B: Add to .env File

Edit `backend\.env`:
```env
GOOGLE_APPLICATION_CREDENTIALS=d:\Projects\Nexora\backend\google-credentials.json
```

### Option C: For Docker (already configured)

The `docker-compose.yml` already mounts the credentials:
```yaml
volumes:
  - ./google-credentials.json:/home/app/web/google-credentials.json:ro
```

Just make sure your JSON file is named `google-credentials.json`

---

## 🧪 Part 8: Test the Setup

### Test 1: Verify Credentials File

```powershell
cd d:\Projects\Nexora\backend
python -c "import json; print('Valid JSON!' if json.load(open('google-credentials.json')) else 'Invalid')"
```

### Test 2: Test Authentication

```powershell
cd backend
.\venv\Scripts\activate

# Install google-auth if not already installed
pip install google-auth

# Test authentication
python -c "from google.auth import default; creds, project = default(); print(f'✓ Authenticated! Project: {project}')"
```

### Test 3: Test Gemini API (After backend is running)

Create a test file `backend/test_gemini.py`:
```python
import os
from google import genai

# Set credentials
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = 'google-credentials.json'

# Initialize client
client = genai.Client()

# Test Gemini
response = client.models.generate_content(
    model='gemini-2.0-flash',
    contents='Say hello to Nexora AI!'
)

print(f"✓ Success! Response: {response.text}")
```

Run it:
```powershell
python backend/test_gemini.py
```

---

## 📊 Part 9: Monitor Usage (Optional)

### Check API Usage:
1. Go to **APIs & Services → Dashboard**
2. Click on **Vertex AI API**
3. View traffic, errors, and usage

### Check Costs:
1. Go to **Billing → Reports**
2. Filter by Vertex AI service
3. Monitor your usage against free tier

---

## 🚨 Common Issues & Solutions

### Issue 1: "Permission denied" or "Insufficient permissions"

**Solution:**
- Make sure service account has **Vertex AI User** role
- Wait 5-10 minutes after adding roles (propagation time)
- Try refreshing credentials: restart your backend

### Issue 2: "Billing must be enabled"

**Solution:**
- Go to Billing in Google Cloud Console
- Link a valid payment method
- You won't be charged if staying within free tier

### Issue 3: "API not enabled"

**Solution:**
- Go to APIs & Services → Library
- Search for "Vertex AI API"
- Click **Enable**
- Wait a few minutes for it to activate

### Issue 4: "Could not load credentials"

**Solution:**
- Check file path is correct
- Check file has valid JSON content
- Verify `GOOGLE_APPLICATION_CREDENTIALS` environment variable is set

### Issue 5: "Quota exceeded"

**Solution:**
- Go to **APIs & Services → Quotas**
- Check your Vertex AI quota
- Request increase if needed (usually not needed for dev)

---

## ✅ Final Checklist

Before running Nexora, verify:

- [ ] Project created in Google Cloud Console
- [ ] Billing enabled (required even for free tier)
- [ ] **Vertex AI API** enabled
- [ ] **Generative Language API** enabled
- [ ] Service account created
- [ ] Service account has **Vertex AI User** role
- [ ] JSON key downloaded
- [ ] JSON key saved in `backend/` folder
- [ ] `GOOGLE_APPLICATION_CREDENTIALS` environment variable set
- [ ] Tested authentication (test script runs successfully)

---

## 🎯 Quick Summary for Nexora AI

**Minimum Required:**
1. ✅ Enable **Vertex AI API**
2. ✅ Enable **Generative Language API**
3. ✅ Service Account with **Vertex AI User** role
4. ✅ Enable **Billing**
5. ✅ Download JSON key
6. ✅ Set environment variable

**That's it!** These 6 steps are all you need for Nexora AI to work.

---

## 💡 Pro Tips

1. **Name your service account clearly:** e.g., "nexora-ai-service-account"
2. **Keep the JSON key secure:** Add to `.gitignore`, never share it
3. **Use environment variables:** Don't hardcode credentials
4. **Monitor usage:** Check dashboard regularly to stay within free tier
5. **Set up alerts:** Get notified if approaching quota limits

---

## 📞 Need Help?

If you're stuck:
1. Check the error message in backend logs
2. Verify all APIs are enabled
3. Wait 10 minutes after making changes (propagation)
4. Check Google Cloud Status: https://status.cloud.google.com/

---

## 🎉 You're Done!

Once you complete this setup:
1. Your service account will be able to call Gemini API
2. Nexora AI can generate courses, answer questions, and create content
3. You'll stay within free tier for development

**Next step:** Go back to `LOCALHOST_SETUP.md` and continue with the rest of the setup!

---

*Last updated: November 5, 2025*
*Optimized for Nexora AI project*
