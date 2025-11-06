# ============================================
# Nexora AI - Cloud Run Deployment Guide
# ============================================

## Prerequisites
1. ✅ Google Cloud account with billing enabled
2. ✅ Supabase account (free tier works)
3. ✅ Google Cloud SDK installed: https://cloud.google.com/sdk/docs/install

## Step 1: Set Up Supabase Database (5 minutes)

### 1.1 Create Supabase Project
1. Go to: https://supabase.com/dashboard
2. Click **"New Project"**
3. Fill in:
   - Name: `nexora-db`
   - Database Password: **Save this securely!**
   - Region: Choose closest to your users
4. Wait 2 minutes for project to provision

### 1.2 Get Database Connection Details
1. Go to **Project Settings** → **Database**
2. Find **Connection Pooling** section
3. Copy the connection string (Mode: Session):
   ```
   postgres://postgres.[project-ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres
   ```
4. Extract these values:
   - `DB_USER`: `postgres.xxxxx` (before the `:`)
   - `DB_PASSWORD`: Your database password
   - `DB_HOST`: `aws-0-[region].pooler.supabase.com`
   - `DB_PORT`: `6543`
   - `DB_NAME`: `postgres`

### 1.3 Update .env File
```bash
DB_USER=postgres.your-project-ref
DB_PASSWORD=your-supabase-password
DB_HOST=aws-0-us-east-1.pooler.supabase.com
DB_PORT=6543
DB_NAME=postgres
```

## Step 2: Prepare for Cloud Run Deployment

### 2.1 Update Google OAuth Redirect URI
1. Go to: https://console.cloud.google.com/apis/credentials
2. Click your OAuth client ID
3. Add redirect URI:
   ```
   https://nexora-[random].run.app/api/google/callback
   ```
   (You'll update this after deployment with actual URL)

### 2.2 Enable Required APIs
```powershell
gcloud services enable run.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable secretmanager.googleapis.com
```

## Step 3: Deploy to Cloud Run (10 minutes)

### 3.1 Set Your Project ID
```powershell
gcloud config set project YOUR_PROJECT_ID
$PROJECT_ID = gcloud config get-value project
```

### 3.2 Create Secret for Google Credentials
```powershell
cd d:\Projects\Nexora
gcloud secrets create google-credentials --data-file=backend\google-credentials.json
```

### 3.3 Build and Deploy
```powershell
# Build the container image
gcloud builds submit --tag gcr.io/$PROJECT_ID/nexora-app -f Dockerfile.cloudrun .

# Deploy to Cloud Run
gcloud run deploy nexora-app `
  --image gcr.io/$PROJECT_ID/nexora-app `
  --platform managed `
  --region us-central1 `
  --allow-unauthenticated `
  --port 8080 `
  --memory 2Gi `
  --cpu 2 `
  --timeout 300 `
  --set-env-vars "DB_USER=postgres.your-ref,DB_HOST=aws-0-us-east-1.pooler.supabase.com,DB_PORT=6543,DB_NAME=postgres,CHROMA_HOST=localhost,CHROMA_PORT=8000,SECURE_COOKIE=true" `
  --set-secrets "DB_PASSWORD=supabase-password:latest,SECRET_KEY=jwt-secret:latest,GOOGLE_APPLICATION_CREDENTIALS=/secrets/google-credentials.json=google-credentials:latest"
```

### 3.4 Get Your App URL
```powershell
gcloud run services describe nexora-app --platform managed --region us-central1 --format 'value(status.url)'
```

## Step 4: Post-Deployment Setup

### 4.1 Update Google OAuth Redirect URI
1. Copy your Cloud Run URL: `https://nexora-xxxxx.run.app`
2. Go to: https://console.cloud.google.com/apis/credentials
3. Update redirect URI to:
   ```
   https://nexora-xxxxx.run.app/api/google/callback
   ```

### 4.2 Create Admin User
```powershell
# Get a Cloud Run shell
gcloud run services describe nexora-app --format 'value(status.url)'

# SSH into Cloud Run (if needed) or use Cloud Shell
gcloud run services proxy nexora-app --region us-central1

# Create admin via API endpoint
curl -X POST https://your-app.run.app/api/admin/create `
  -H "Content-Type: application/json" `
  -d '{"username":"admin","email":"admin@example.com","password":"YourStrongPassword123!"}'
```

## Step 5: ChromaDB Consideration

⚠️ **Important**: ChromaDB runs in-memory in Cloud Run. For production:

**Option A: External ChromaDB** (Recommended)
- Deploy ChromaDB separately on Cloud Run or VM
- Update `CHROMA_DB_URL` to external URL

**Option B: Use Pinecone/Weaviate**
- Replace ChromaDB with managed vector DB
- Update vector service code

## Cost Estimate

- **Cloud Run**: $0-15/month (with free tier)
- **Supabase**: Free (up to 500MB database)
- **Total**: ~$0-15/month for small projects

## Monitoring & Logs

```powershell
# View logs
gcloud run services logs read nexora-app --region us-central1 --limit 50

# Monitor performance
gcloud run services describe nexora-app --region us-central1
```

## Scaling Configuration

Cloud Run auto-scales! Configure limits:
```powershell
gcloud run services update nexora-app `
  --min-instances 0 `
  --max-instances 10 `
  --concurrency 80
```

## Troubleshooting

### Database Connection Issues
- Verify Supabase IP whitelist (should allow all by default)
- Check `DB_PASSWORD` secret is correct
- Ensure connection pooler is used (port 6543, not 5432)

### Google Auth Issues
- Verify redirect URI matches exactly
- Check `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`
- Ensure `GOOGLE_APPLICATION_CREDENTIALS` secret is mounted

### Build Failures
- Check `Dockerfile.cloudrun` exists
- Verify `frontend/dist` is in `.dockerignore` (it's built during Docker build)
- Ensure `google-credentials.json` exists in `backend/` folder

## Quick Commands Reference

```powershell
# Redeploy after code changes
gcloud builds submit --tag gcr.io/$PROJECT_ID/nexora-app -f Dockerfile.cloudrun .
gcloud run deploy nexora-app --image gcr.io/$PROJECT_ID/nexora-app --region us-central1

# Update environment variables
gcloud run services update nexora-app --set-env-vars KEY=value --region us-central1

# View service details
gcloud run services describe nexora-app --region us-central1

# Delete service
gcloud run services delete nexora-app --region us-central1
```

## Next Steps

1. ✅ Test your app: `https://your-app.run.app/docs`
2. ✅ Set up custom domain (optional)
3. ✅ Configure CDN (optional)
4. ✅ Set up monitoring alerts
5. ✅ Regular backups of Supabase

Your app is now live! 🚀
