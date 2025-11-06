# Google Cloud Quick Checklist for Nexora AI

## ✅ Follow this exact order:

### Step 1: Enable APIs (5 minutes)
```
Google Cloud Console → APIs & Services → Library
```

Search and Enable:
- [ ] **Vertex AI API** ⭐ REQUIRED
- [ ] **Generative Language API** ⭐ REQUIRED
- [ ] Cloud Resource Manager API (optional)

---

### Step 2: Add IAM Role to Service Account (3 minutes)
```
Google Cloud Console → IAM & Admin → IAM
```

- [ ] Click **"Grant Access"**
- [ ] New principals: `your-service-account@project.iam.gserviceaccount.com`
- [ ] Select role: **"Vertex AI User"** ⭐ REQUIRED
- [ ] Click **"Save"**

**That's the only role you need!**

---

### Step 3: Enable Billing (2 minutes)
```
Google Cloud Console → Billing
```

- [ ] Link billing account to your project
- [ ] Don't worry: $300 free credits + generous free tier
- [ ] **Note:** Billing is required even for free tier

---

### Step 4: Download Key (if not done yet) (2 minutes)
```
Google Cloud Console → IAM & Admin → Service Accounts
```

- [ ] Click your service account
- [ ] Go to **"Keys"** tab
- [ ] Click **"Add Key"** → **"Create new key"**
- [ ] Choose **"JSON"**
- [ ] Save as: `d:\Projects\Nexora\backend\google-credentials.json`

---

### Step 5: Configure Nexora (2 minutes)

**In PowerShell:**
```powershell
# Set environment variable permanently
[System.Environment]::SetEnvironmentVariable('GOOGLE_APPLICATION_CREDENTIALS', 'd:\Projects\Nexora\backend\google-credentials.json', 'User')

# Verify
echo $env:GOOGLE_APPLICATION_CREDENTIALS
```

**OR add to backend\.env:**
```env
GOOGLE_APPLICATION_CREDENTIALS=d:\Projects\Nexora\backend\google-credentials.json
```

---

## 🧪 Test It!

```powershell
cd backend
.\venv\Scripts\activate
python -c "from google.auth import default; creds, project = default(); print(f'✓ Success! Project: {project}')"
```

If you see "✓ Success!" - you're done! 🎉

---

## ❓ Quick FAQ

**Q: Which role exactly?**
A: **Vertex AI User** (`roles/aiplatform.user`)

**Q: Do I need Owner or Editor role?**
A: No! Just "Vertex AI User" is enough.

**Q: Will I be charged?**
A: Not if you stay within free tier (more than enough for dev)

**Q: Where do I find my service account email?**
A: IAM & Admin → Service Accounts → it looks like `name@project.iam.gserviceaccount.com`

---

## 🚨 If Something Goes Wrong

1. **Wait 5-10 minutes** after making changes (propagation time)
2. **Check error message** in backend terminal
3. **Verify APIs are enabled**: APIs & Services → Enabled APIs
4. **Verify role is assigned**: IAM & Admin → IAM → find your service account
5. **Check billing is enabled**: Billing → Overview

---

**That's it! You're now ready to run Nexora AI.** 🚀
