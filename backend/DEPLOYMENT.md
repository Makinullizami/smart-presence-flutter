# Smart Presence Backend Deployment Guide

## Prerequisites

- Docker & Docker Compose
- Git
- PHP 8.1+
- Composer
- Node.js & npm
- MySQL 8.0+

## Quick Deployment (Docker)

### 1. Clone and Setup
```bash
git clone <repository-url>
cd smart_presence/backend
```

### 2. Configure Environment
```bash
# Copy production environment
cp .env.production .env

# Edit .env with your settings
nano .env
```

### 3. Deploy with Docker
```bash
# Make deploy script executable (Linux/Mac)
chmod +x deploy.sh

# Run deployment
./deploy.sh production
```

### 4. Manual Docker Commands
```bash
# Build and start services
docker-compose up -d --build

# Run migrations
docker-compose exec app php artisan migrate --force

# Create storage link
docker-compose exec app php artisan storage:link

# Clear and cache config
docker-compose exec app php artisan config:cache
docker-compose exec app php artisan route:cache
```

## Traditional Deployment (VPS/Server)

### 1. Server Requirements
- Ubuntu 20.04+ / CentOS 8+
- Nginx or Apache
- PHP 8.1+ with extensions
- MySQL 8.0+
- Redis (optional)
- SSL certificate

### 2. Install Dependencies
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install PHP and extensions
sudo apt install php8.1 php8.1-cli php8.1-fpm php8.1-mysql php8.1-xml php8.1-mbstring php8.1-curl php8.1-zip php8.1-gd -y

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install MySQL
sudo apt install mysql-server -y
sudo mysql_secure_installation
```

### 3. Configure Database
```sql
CREATE DATABASE smart_presence_prod;
CREATE USER 'smart_presence_user'@'localhost' IDENTIFIED BY 'secure_password_2024';
GRANT ALL PRIVILEGES ON smart_presence_prod.* TO 'smart_presence_user'@'localhost';
FLUSH PRIVILEGES;
```

### 4. Deploy Application
```bash
# Clone repository
git clone <repository-url> /var/www/smart_presence
cd /var/www/smart_presence

# Install dependencies
composer install --optimize-autoloader --no-dev
npm install && npm run build

# Configure environment
cp .env.production .env
# Edit .env with your database credentials

# Generate app key
php artisan key:generate

# Run migrations
php artisan migrate --force

# Create storage link
php artisan storage:link

# Set permissions
sudo chown -R www-data:www-data /var/www/smart_presence
sudo chmod -R 755 /var/www/smart_presence/storage
sudo chmod -R 755 /var/www/smart_presence/bootstrap/cache
```

### 5. Configure Nginx
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/smart_presence/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

### 6. Configure SSL (Let's Encrypt)
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your-domain.com
```

### 7. Start Services
```bash
# Enable and start services
sudo systemctl enable nginx php8.1-fpm mysql redis-server
sudo systemctl start nginx php8.1-fpm mysql redis-server

# Start queue worker (if using queues)
php artisan queue:work --daemon
```

## Environment Configuration

### Required Environment Variables
```env
APP_NAME=SmartPresence
APP_ENV=production
APP_KEY=base64:your-generated-key
APP_DEBUG=false
APP_URL=https://your-domain.com

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=smart_presence_prod
DB_USERNAME=smart_presence_user
DB_PASSWORD=your_secure_password

MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls

# Firebase/Push Notifications
FCM_SERVER_KEY=your-fcm-server-key

# File Storage (AWS S3)
AWS_ACCESS_KEY_ID=your-aws-key
AWS_SECRET_ACCESS_KEY=your-aws-secret
AWS_DEFAULT_REGION=us-east-1
AWS_BUCKET=your-s3-bucket
```

## Monitoring & Maintenance

### Health Checks
```bash
# Application health
curl https://your-domain.com/api/health

# Queue status
php artisan queue:status
```

### Backup Strategy
```bash
# Database backup
mysqldump -u smart_presence_user -p smart_presence_prod > backup_$(date +%Y%m%d).sql

# File backup
tar -czf storage_backup_$(date +%Y%m%d).tar.gz storage/
```

### Log Monitoring
```bash
# Laravel logs
tail -f storage/logs/laravel.log

# Nginx logs
tail -f /var/log/nginx/access.log
tail -f /var/log/nginx/error.log
```

## Troubleshooting

### Common Issues

1. **Permission Issues**
```bash
sudo chown -R www-data:www-data /var/www/smart_presence
sudo chmod -R 755 /var/www/smart_presence/storage
```

2. **Database Connection**
```bash
# Test connection
php artisan tinker
DB::connection()->getPdo();
```

3. **Queue Not Working**
```bash
# Restart queue worker
php artisan queue:restart

# Check queue status
php artisan queue:status
```

4. **File Upload Issues**
```bash
# Check storage permissions
ls -la storage/
sudo chmod -R 775 storage/
```

## Performance Optimization

### Caching
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Database Optimization
```bash
# Add indexes to frequently queried columns
php artisan tinker
# Add indexes as needed
```

### CDN Setup (Optional)
- Use AWS CloudFront or similar for static assets
- Configure CORS headers properly

## Security Checklist

- [ ] SSL certificate installed
- [ ] Database credentials secured
- [ ] File permissions correct
- [ ] .env file not in version control
- [ ] Debug mode disabled
- [ ] CSRF protection enabled
- [ ] Rate limiting configured
- [ ] Backup strategy in place

## Support

For deployment issues, check:
1. Laravel logs: `storage/logs/laravel.log`
2. Nginx logs: `/var/log/nginx/`
3. Application health: `/api/health`
4. Database connectivity