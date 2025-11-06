# 🚀 Production Deployment Guide - Tomorrow Ready!

## ✅ Your Setup is PRODUCTION-READY!

Everything is configured for **cloud deployment** and can be **tested locally today**.

---

## 📦 What's Configured (Production-Ready)

### ✅ Complete Docker Stack
- **MySQL 8.0** in Docker (with health checks)
- **Backend** (FastAPI + Nexora AI)
- **ChromaDB** (Vector database)
- **All connected via Docker network**
- **Data persistence** (MySQL & ChromaDB volumes)

### ✅ Security
- Secret keys generated
- Google Cloud credentials configured
- Read-only credential mounting
- Database passwords in .env (change them!)

### ✅ Cloud-Ready
- Environment variable based configuration
- Easy to switch to cloud database
- Scalable architecture
- Production docker-compose

---

## 🧪 Test Locally TODAY (10 minutes)

### Step 1: Start Everything
```powershell
cd backend
docker-compose up -d
```

This starts:
- ✅ MySQL database
- ✅ Backend API
- ✅ ChromaDB

### Step 2: Check Status
```powershell
docker ps
```

You should see 3 containers running:
- `nexora` (backend)
- `nexora-mysql` (database)
- `nexora-chromadb` (vector DB)

### Step 3: Watch Logs
```powershell
docker-compose logs -f
```

Wait until you see:
- ✅ "Application startup complete"
- ✅ MySQL ready for connections
- ✅ No errors

### Step 4: Test the API
Open browser: http://localhost:8127/docs

You should see FastAPI Swagger documentation! 🎉

### Step 5: Create Admin User
```powershell
docker exec -it nexora python create_admin.py
```

### Step 6: Test with Frontend (Optional)
```powershell
# New terminal
cd frontend
npm install
npm run dev
```

Open: http://localhost:5173

---

## 🌍 Deploy to Production TOMORROW

### Option A: Deploy to VM/VPS (DigitalOcean, AWS EC2, Azure VM, etc.)

#### 1. Choose Your Server
- **DigitalOcean Droplet**: $6/month (2GB RAM)
- **AWS EC2**: t3.small ($15/month)
- **Azure VM**: B2s ($30/month)
- **Google Cloud VM**: e2-small ($13/month)

**Recommended:** DigitalOcean Droplet (easiest setup)

#### 2. Server Setup (Ubuntu 22.04)
```bash
# SSH into your server
ssh root@your-server-ip

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install docker-compose-plugin -y

# Install Git
apt install git -y
```

#### 3. Deploy Your Application
```bash
# Clone your repository
git clone https://github.com/M4RKUS28/Nexora.git
cd Nexora/backend

# Copy your .env file (upload via SCP or create manually)
nano .env
# Paste your .env content, update passwords!

# Copy your Google credentials
# Upload google-credentials.json via SCP

# Update .env for production
nano .env
# Update these:
# SECURE_COOKIE=true
# FRONTEND_BASE_URL=https://yourdomain.com
# Update OAuth redirect URIs

# Start the application
docker-compose up -d

# Check logs
docker-compose logs -f
```

#### 4. Set Up Domain & SSL
```bash
# Install Nginx and Certbot
apt install nginx certbot python3-certbot-nginx -y

# Configure Nginx (see nginx config below)
nano /etc/nginx/sites-available/nexora

# Enable site
ln -s /etc/nginx/sites-available/nexora /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx

# Get SSL certificate
certbot --nginx -d yourdomain.com -d www.yourdomain.com
```

**Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:8127;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### 5. Deploy Frontend
```bash
# On your local machine, build frontend
cd frontend
npm run build

# Upload dist folder to server
scp -r dist root@your-server-ip:/var/www/nexora

# Update Nginx to serve frontend
nano /etc/nginx/sites-available/nexora
# Add root /var/www/nexora/dist;
```

---

### Option B: Use Cloud Database (Recommended for Production)

Instead of MySQL in Docker, use managed database:

#### AWS RDS MySQL
1. Create RDS MySQL instance
2. Get connection details
3. Update .env:
```env
DB_HOST=your-rds-endpoint.rds.amazonaws.com
DB_USER=admin
DB_PASSWORD=your-rds-password
DB_NAME=nexora_db
```

#### Google Cloud SQL
1. Create Cloud SQL MySQL instance
2. Download SSL certificates
3. Update .env with connection string

#### Azure Database for MySQL
1. Create Azure MySQL Flexible Server
2. Get connection string
3. Update .env

#### 4. Comment Out MySQL in docker-compose.yml
```yaml
# Remove or comment the mysql service section
# Update app service to remove depends_on mysql
```

---

### Option C: Deploy to Cloud Platforms

#### **Docker Hub + DigitalOcean App Platform**

1. **Build and Push Image**
```powershell
cd backend
docker build -t yourusername/nexora:latest .
docker push yourusername/nexora:latest
```

2. **Create App on DigitalOcean**
- Go to App Platform
- Connect your Docker Hub
- Select your image
- Add environment variables from .env
- Add MySQL database (managed)
- Deploy!

#### **Google Cloud Run**
```bash
# Build and deploy
gcloud builds submit --tag gcr.io/your-project/nexora
gcloud run deploy nexora --image gcr.io/your-project/nexora --platform managed
```

#### **AWS ECS/Fargate**
1. Push to ECR
2. Create ECS service
3. Use RDS for database
4. Configure load balancer

---

## 🔐 Production Security Checklist

Before deploying tomorrow:

### Update .env for Production
```env
# 1. Change ALL passwords!
SECRET_KEY=<generate-new-one>
SESSION_SECRET_KEY=<generate-new-one>
DB_PASSWORD=<strong-password>
MYSQL_ROOT_PASSWORD=<strong-password>

# 2. Enable secure cookies
SECURE_COOKIE=true

# 3. Update URLs
FRONTEND_BASE_URL=https://yourdomain.com
GOOGLE_REDIRECT_URI=https://yourdomain.com/api/google/callback
GITHUB_REDIRECT_URI=https://yourdomain.com/api/github/callback
DISCORD_REDIRECT_URI=https://yourdomain.com/api/discord/callback

# 4. Set proper CORS
# (Update in backend code if needed)
```

### OAuth Redirect URIs
Update in respective platforms:
- Google OAuth: https://console.cloud.google.com/apis/credentials
- GitHub OAuth: https://github.com/settings/developers
- Discord OAuth: https://discord.com/developers/applications

### Firewall Rules
```bash
# Allow only necessary ports
ufw allow 22    # SSH
ufw allow 80    # HTTP
ufw allow 443   # HTTPS
ufw enable
```

---

## 📊 Cost Estimate (Production)

### Cheap Setup (~$10/month):
- DigitalOcean Droplet: $6/month (2GB RAM)
- Domain Name: $12/year (~$1/month)
- Google Cloud: Free tier (Gemini API)
- Total: **~$7/month**

### Recommended Setup (~$30/month):
- DigitalOcean Droplet: $18/month (4GB RAM)
- Managed MySQL: $15/month
- Domain: $1/month
- Cloudflare CDN: Free
- Total: **~$34/month**

### Enterprise Setup (~$100/month):
- AWS EC2 t3.medium: $30/month
- RDS MySQL: $30/month
- Load Balancer: $20/month
- CloudFront CDN: $10/month
- Backup & Monitoring: $10/month
- Total: **~$100/month**

---

## 🚦 Deployment Checklist for Tomorrow

### Pre-Deployment (Today):
- [x] Docker compose ready
- [x] Environment variables configured
- [x] Google credentials obtained
- [ ] Test locally (run docker-compose up)
- [ ] Create admin user
- [ ] Test all features work
- [ ] Choose deployment platform
- [ ] Buy domain (if needed)
- [ ] Set up server/cloud account

### Deployment Day (Tomorrow):
- [ ] SSH into server
- [ ] Install Docker
- [ ] Clone repository
- [ ] Upload .env and credentials
- [ ] Update .env for production
- [ ] Start docker-compose
- [ ] Configure Nginx + SSL
- [ ] Update OAuth redirect URIs
- [ ] Deploy frontend
- [ ] Test live site
- [ ] Monitor logs
- [ ] Set up backups

### Post-Deployment:
- [ ] Monitor for 24 hours
- [ ] Set up monitoring (UptimeRobot, etc.)
- [ ] Configure automated backups
- [ ] Document any issues
- [ ] Scale if needed

---

## 🆘 Quick Commands for Tomorrow

### Deploy on Server:
```bash
# 1. Clone and setup
git clone https://github.com/M4RKUS28/Nexora.git
cd Nexora/backend
nano .env  # Update passwords and URLs!

# 2. Start everything
docker-compose up -d

# 3. Check logs
docker-compose logs -f

# 4. Create admin
docker exec -it nexora python create_admin.py

# 5. Backup database (important!)
docker exec nexora-mysql mysqldump -u root -p nexora_db > backup.sql
```

### Restart Services:
```bash
docker-compose restart
```

### Update Code:
```bash
git pull
docker-compose up -d --build
```

### View Logs:
```bash
docker-compose logs -f app
```

---

## 📱 Monitoring Setup (Optional but Recommended)

### UptimeRobot (Free)
- https://uptimerobot.com/
- Monitor your site every 5 minutes
- Get alerts if it goes down

### Grafana + Prometheus
```bash
# Add to docker-compose for monitoring
# See monitoring guide
```

---

## 🎯 TL;DR - Deploy Tomorrow in 30 Minutes

### Today (Test):
```powershell
cd backend
docker-compose up -d
# Open http://localhost:8127/docs
# Test everything works ✓
```

### Tomorrow (Deploy):
```bash
# On server:
curl -fsSL https://get.docker.com | sh
git clone https://github.com/M4RKUS28/Nexora.git
cd Nexora/backend
# Upload .env with production settings
docker-compose up -d
# Configure Nginx + SSL
# You're live! 🚀
```

---

## 📞 Support for Tomorrow

If you hit issues during deployment:
1. Check logs: `docker-compose logs -f`
2. Verify all containers running: `docker ps`
3. Test database: `docker exec -it nexora-mysql mysql -u root -p`
4. Check network: `docker network inspect nexora-network`

---

**You're ready for tomorrow! 🚀**

Test locally today, deploy with confidence tomorrow!
