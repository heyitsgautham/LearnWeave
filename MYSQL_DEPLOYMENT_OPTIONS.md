# 🗄️ MySQL Database Setup - All Deployment Options

## Overview

You have **3 options** for MySQL when deploying Nexora AI. Choose based on your needs.

---

## Option 1: MySQL on Windows (Recommended for Development) ⭐

### Pros:
- ✅ Easy to manage with existing MySQL installation
- ✅ Data persists outside containers
- ✅ Can use MySQL Workbench directly
- ✅ Faster for development

### Cons:
- ⚠️ Need to configure Docker to access host MySQL
- ⚠️ Windows MySQL must allow external connections

### Setup:

#### 1. Install MySQL on Windows (if not installed)
Download from: https://dev.mysql.com/downloads/mysql/

#### 2. Create Database and User
```sql
-- Run in MySQL as root
CREATE DATABASE nexora_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nexora_user'@'%' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON nexora_db.* TO 'nexora_user'@'%';
FLUSH PRIVILEGES;
```

**Note:** Use `'nexora_user'@'%'` (not `@'localhost'`) to allow Docker connections!

#### 3. Configure MySQL to Accept External Connections

Edit MySQL config file (`my.ini` on Windows, usually in `C:\ProgramData\MySQL\MySQL Server 8.0\`):

```ini
[mysqld]
bind-address = 0.0.0.0
# Or comment out: # bind-address = 127.0.0.1
```

Restart MySQL service:
```powershell
Restart-Service MySQL80
```

#### 4. Update `.env` File

```env
DB_USER=nexora_user
DB_PASSWORD=your_secure_password
DB_HOST=host.docker.internal
DB_PORT=3306
DB_NAME=nexora_db
```

**Key:** `DB_HOST=host.docker.internal` - This is a special DNS name that Docker provides to access the Windows host!

#### 5. Test Connection from Docker

```powershell
# Start a temporary MySQL client container
docker run -it --rm mysql:8.0 mysql -h host.docker.internal -u nexora_user -p

# Enter your password when prompted
# If successful, you'll see: mysql>
```

---

## Option 2: MySQL in Docker (Recommended for Production) 🐳

### Pros:
- ✅ Everything containerized
- ✅ Easy to deploy anywhere
- ✅ Consistent environment
- ✅ Automatic startup with backend

### Cons:
- ⚠️ Data in Docker volume (need to backup properly)
- ⚠️ Slightly more complex setup

### Setup:

#### 1. Update `docker-compose.yml`

I'll create an updated version below with MySQL included.

#### 2. Update `.env` File

```env
DB_USER=nexora_user
DB_PASSWORD=your_secure_password
DB_HOST=mysql
DB_PORT=3306
DB_NAME=nexora_db
```

**Key:** `DB_HOST=mysql` - This matches the MySQL service name in docker-compose.yml!

#### 3. Start Everything

```powershell
cd backend
docker-compose up -d
```

Docker Compose will:
- Start MySQL container
- Wait for MySQL to be ready
- Start backend container
- Automatically create the database

---

## Option 3: Cloud Database (Best for Production) ☁️

### Pros:
- ✅ Managed service (no maintenance)
- ✅ Automatic backups
- ✅ High availability
- ✅ Scalable

### Cons:
- 💰 Costs money (but often has free tier)

### Providers:

#### AWS RDS
- Free tier: 750 hours/month for 12 months
- https://aws.amazon.com/rds/free/

#### Google Cloud SQL
- Free tier: db-f1-micro instance
- https://cloud.google.com/sql

#### Azure Database for MySQL
- Free tier available
- https://azure.microsoft.com/en-us/products/mysql

#### PlanetScale (MySQL-compatible)
- Free tier: 5GB storage
- https://planetscale.com/

### Setup:

1. Create database instance in your cloud provider
2. Get connection details (host, port, user, password)
3. Update `.env`:

```env
DB_USER=your_cloud_db_user
DB_PASSWORD=your_cloud_db_password
DB_HOST=your-db-instance.mysql.database.azure.com  # Example for Azure
DB_PORT=3306
DB_NAME=nexora_db
```

---

## 🔧 Updated docker-compose.yml (Option 2)

Here's a complete docker-compose.yml with MySQL included:

```yaml
version: '3.8'

services:
  # MySQL Database
  mysql:
    container_name: nexora-mysql
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root_password_change_me
      MYSQL_DATABASE: nexora_db
      MYSQL_USER: nexora_user
      MYSQL_PASSWORD: your_secure_password
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
    restart: always
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      timeout: 20s
      retries: 10

  # Backend Application
  app:
    container_name: nexora
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      - WORKERS=1
      - GOOGLE_APPLICATION_CREDENTIALS=/home/app/web/google-credentials.json
    volumes:
      - ./google-credentials.json:/home/app/web/google-credentials.json:ro
    ports:
      - "8127:8000"
    env_file:
      - ./.env
    depends_on:
      mysql:
        condition: service_healthy
    restart: always
    labels:
      - "com.centurylinklabs.watchtower.enable=true"

  # ChromaDB Vector Database
  chromadb:
    container_name: nexora-chromadb
    image: chromadb/chroma:latest
    environment:
      - CHROMA_SERVER_HOST=0.0.0.0
      - CHROMA_SERVER_HTTP_PORT=8000
      - PERSIST_DIRECTORY=/chroma/chroma
      - CHROMA_SERVER_ALLOW_RESET=true
      - CHROMA_SERVER_CORS_ALLOW_ORIGINS=["*"]
    volumes:
      - chroma-data:/chroma/chroma
    ports:
      - "8001:8000"
    restart: always

volumes:
  mysql-data:
    driver: local
  chroma-data:
    driver: local
```

---

## 🎯 Which Option Should You Choose?

### For Local Development:
→ **Option 1** (MySQL on Windows)
- Easier to manage
- Use your existing MySQL
- Can use MySQL Workbench

### For Testing/Staging:
→ **Option 2** (MySQL in Docker)
- Everything isolated
- Easy to tear down and rebuild
- Matches production setup

### For Production:
→ **Option 3** (Cloud Database)
- Professional setup
- Automatic backups
- High availability
- Scalable

---

## 🔄 Migration Between Options

### From Option 1 to Option 2:

```powershell
# 1. Backup your data
mysqldump -u nexora_user -p nexora_db > backup.sql

# 2. Update docker-compose.yml (add MySQL service)
# 3. Update .env (DB_HOST=mysql)
# 4. Start containers
docker-compose up -d

# 5. Import data
docker exec -i nexora-mysql mysql -u nexora_user -p nexora_db < backup.sql
```

### From Option 2 to Option 3:

```powershell
# 1. Backup from Docker
docker exec nexora-mysql mysqldump -u nexora_user -p nexora_db > backup.sql

# 2. Create cloud database
# 3. Import data to cloud
mysql -h your-cloud-host -u your-cloud-user -p nexora_db < backup.sql

# 4. Update .env with cloud credentials
# 5. Restart backend
```

---

## 🧪 Test Your Database Connection

### Test from Local Python:
```powershell
cd backend
.\venv\Scripts\activate
python -c "from src.db.database import engine; print('✓ Connected!' if engine.connect() else '✗ Failed')"
```

### Test from Docker:
```powershell
# Test connection from backend container
docker exec -it nexora python -c "from app.database import engine; print('✓ Connected!' if engine.connect() else '✗ Failed')"
```

### Test with MySQL Client:
```powershell
# Test from Windows (Option 1)
mysql -h localhost -u nexora_user -p nexora_db

# Test Docker MySQL (Option 2)
docker exec -it nexora-mysql mysql -u nexora_user -p nexora_db

# Test from Docker container to Windows MySQL (Option 1)
docker run -it --rm mysql:8.0 mysql -h host.docker.internal -u nexora_user -p
```

---

## 🐛 Troubleshooting

### Issue: "Can't connect to MySQL server on 'host.docker.internal'"

**Solution for Option 1:**
1. Check MySQL is running: `Get-Service MySQL*`
2. Check bind-address in my.ini (should be 0.0.0.0)
3. Check firewall allows port 3306
4. Create user with '%' instead of 'localhost':
   ```sql
   CREATE USER 'nexora_user'@'%' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON nexora_db.* TO 'nexora_user'@'%';
   ```

### Issue: "Access denied for user"

**Solution:**
1. Check password in .env matches MySQL user
2. Check user has correct permissions:
   ```sql
   SHOW GRANTS FOR 'nexora_user'@'%';
   ```
3. Try connecting manually first

### Issue: Container starts but backend crashes

**Check logs:**
```powershell
docker logs nexora
```

Look for database connection errors and verify DB_HOST in .env.

### Issue: "Unknown database 'nexora_db'"

**For Option 1:**
```sql
CREATE DATABASE nexora_db;
```

**For Option 2:**
The database should be created automatically. If not:
```powershell
docker exec -it nexora-mysql mysql -u root -p
# Then: CREATE DATABASE nexora_db;
```

---

## 📊 Comparison Table

| Feature | Option 1 (Windows) | Option 2 (Docker) | Option 3 (Cloud) |
|---------|-------------------|-------------------|------------------|
| **Setup Time** | 10 min | 5 min | 20 min |
| **Cost** | Free | Free | Free tier available |
| **Performance** | Fast | Fast | Depends on plan |
| **Backup** | Manual | Manual (volumes) | Automatic |
| **Portability** | Low | High | High |
| **Best For** | Development | Testing/Staging | Production |

---

## ✅ Recommended Setup

### For You (Development):

**Use Option 1** (MySQL on Windows) while developing locally, then switch to **Option 2** (MySQL in Docker) when ready to deploy.

**Current Configuration:**
```env
DB_HOST=host.docker.internal  # Already set for you!
```

This works for Docker talking to Windows MySQL! ✅

---

## 📝 Summary

**Your current setup:**
- ✅ `.env` configured with `DB_HOST=host.docker.internal`
- ✅ This allows Docker to connect to MySQL on Windows
- ✅ Just create the database and user with `@'%'` (not `@'localhost'`)

**Next steps:**
1. Run the MySQL setup script (with `@'%'`)
2. Update .env with your actual password
3. Start Docker: `docker-compose up -d`
4. Backend will connect to your Windows MySQL! 🎉

Need help setting up any of these options? Let me know!
