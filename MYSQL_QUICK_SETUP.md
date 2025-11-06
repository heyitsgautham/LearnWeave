# 🚀 Quick MySQL Setup for Docker Deployment

## TL;DR

Your `.env` is already configured correctly! ✅

```env
DB_HOST=host.docker.internal  # ← This allows Docker to reach Windows MySQL
```

## What You Need to Do

### Step 1: Create MySQL Database & User

**Run this in MySQL:**

```sql
CREATE DATABASE nexora_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'nexora_user'@'%' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON nexora_db.* TO 'nexora_user'@'%';
FLUSH PRIVILEGES;
```

**⚠️ Key Point:** Use `@'%'` not `@'localhost'` - this allows Docker containers to connect!

**Or use the provided script:**
```powershell
mysql -u root -p < backend\setup_database.sql
```

### Step 2: Update .env Password

Edit `backend\.env`:
```env
DB_PASSWORD=your_actual_password_here  # ← Change this!
```

### Step 3: Configure MySQL for External Connections

Edit `C:\ProgramData\MySQL\MySQL Server 8.0\my.ini`:

```ini
[mysqld]
bind-address = 0.0.0.0
```

Then restart MySQL:
```powershell
Restart-Service MySQL80
```

### Step 4: Test It

```powershell
# Test from Docker
docker run -it --rm mysql:8.0 mysql -h host.docker.internal -u nexora_user -p

# Enter your password
# If successful: You'll see mysql> prompt
```

### Step 5: Deploy

```powershell
cd backend
docker-compose up --build -d
```

---

## ✅ That's It!

Your backend Docker container will now connect to MySQL on your Windows machine!

---

## 🔄 Alternative: Use MySQL in Docker

If you prefer everything in Docker:

1. **Uncomment MySQL section in docker-compose.yml**
2. **Update .env:**
   ```env
   DB_HOST=mysql  # ← Change from host.docker.internal to mysql
   ```
3. **Start:**
   ```powershell
   cd backend
   docker-compose up --build -d
   ```

No need to install MySQL on Windows! 🎉

---

## 📚 Full Details

See `MYSQL_DEPLOYMENT_OPTIONS.md` for complete guide with all options.

---

## 🐛 Quick Troubleshooting

**"Can't connect to MySQL"**
→ Check MySQL is running: `Get-Service MySQL*`
→ Check user created with `@'%'` not `@'localhost'`
→ Check bind-address is 0.0.0.0 in my.ini

**"Access denied"**
→ Check password in .env matches MySQL
→ Test: `mysql -u nexora_user -p`

**"Unknown database"**
→ Create it: `CREATE DATABASE nexora_db;`

---

**You're ready to deploy!** 🚀
