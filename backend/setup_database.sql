-- Nexora AI - Database Setup Script
-- Run this in MySQL to create the database and user

-- Create the database
CREATE DATABASE IF NOT EXISTS nexora_db 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Create the user (IMPORTANT: Use '%' for Docker compatibility!)
-- '%' allows connections from any host, including Docker containers
-- For production, replace '%' with specific IP addresses
CREATE USER IF NOT EXISTS 'nexora_user'@'%' IDENTIFIED BY 'your_secure_password';

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON nexora_db.* TO 'nexora_user'@'%';

-- Apply the changes
FLUSH PRIVILEGES;

-- Verify the setup
USE nexora_db;
SHOW TABLES;

-- Success message
SELECT 'Database setup complete! ✓' AS Status;
SELECT 'Database: nexora_db' AS Info;
SELECT 'User: nexora_user@% (allows Docker connections)' AS Info;
SELECT 'Now update your backend/.env file with these credentials' AS NextStep;
SELECT 'IMPORTANT: Change your_secure_password to a real password!' AS Warning;
