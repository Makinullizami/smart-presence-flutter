# 🚀 Smart Presence - Complete Deployment Guide

## Overview

Smart Presence is a comprehensive attendance management system with face recognition, built using Flutter (mobile) and Laravel (backend). This guide covers the complete deployment process for both backend and mobile applications.

## 📋 Deployment Checklist

### Backend (Laravel) Deployment
- [ ] Server/VPS with Ubuntu 20.04+
- [ ] Domain and SSL certificate
- [ ] MySQL 8.0+ database
- [ ] PHP 8.1+ with required extensions
- [ ] Redis (optional, for caching/queues)
- [ ] File storage (local/AWS S3)

### Mobile App Deployment
- [ ] Android signing keystore
- [ ] iOS developer account
- [ ] Firebase project for notifications
- [ ] App store accounts (Google Play, App Store)
- [ ] CI/CD pipeline (optional)

### Services Configuration
- [ ] Firebase Cloud Messaging
- [ ] Email service (SMTP/Gmail)
- [ ] File storage service
- [ ] Push notification certificates

## 🏗️ Quick Start Deployment

### Option 1: Docker Deployment (Recommended)

#### Backend
```bash
cd backend
cp .env.production .env
# Edit .env with your settings
docker-compose up -d --build
```

#### Mobile App
```bash
# Android
flutter build apk --release

# iOS (macOS only)
flutter build ipa --release
```

### Option 2: Traditional Server Deployment

#### Backend Setup
```bash
# Install dependencies
sudo apt update
sudo apt install php8.1 php8.1-cli php8.1-fpm php8.1-mysql nginx mysql-server redis-server

# Clone and setup
git clone <repository> /var/www/smart_presence
cd /var/www/smart_presence
composer install --optimize-autoloader --no-dev
npm install && npm run build

# Configure environment
cp .env.production .env
# Edit database and other settings

# Run migrations
php artisan migrate --force
php artisan key:generate
php artisan storage:link

# Configure Nginx (see backend/DEPLOYMENT.md)
```

#### Mobile App Setup
```bash
# Configure Firebase
# Add google-services.json (Android) and GoogleService-Info.plist (iOS)

# Build release
./build_release.sh android production
./build_release.sh ios production
```

## 🔧 Detailed Configuration

### 1. Backend Configuration

#### Environment Variables (.env)
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
DB_PASSWORD=secure_password

MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password

FIREBASE_SERVER_KEY=your-fcm-server-key
```

#### Database Setup
```sql
CREATE DATABASE smart_presence_prod;
CREATE USER 'smart_presence_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON smart_presence_prod.* TO 'smart_presence_user'@'localhost';
FLUSH PRIVILEGES;
```

### 2. Mobile App Configuration

#### Android Setup
```gradle
// android/app/build.gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.smartpresence"
        minSdkVersion 21
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }
}
```

#### iOS Setup
```plist
<!-- ios/Runner/Info.plist -->
<key>CFBundleDisplayName</key>
<string>Smart Presence</string>
<key>CFBundleIdentifier</key>
<string>com.yourcompany.smartpresence</string>
```

#### Firebase Setup
1. Create Firebase project
2. Add Android app with package name
3. Add iOS app with bundle ID
4. Download config files
5. Enable Authentication, Firestore, Cloud Messaging

### 3. SSL Certificate Setup

#### Using Let's Encrypt
```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

## 📱 App Store Deployment

### Google Play Console
1. Create app
2. Upload AAB file
3. Configure store listing
4. Set pricing and distribution
5. Publish

### App Store Connect
1. Create app
2. Upload IPA via Transporter
3. Configure metadata
4. Submit for review
5. Release

## 🔍 Testing & Validation

### Backend Testing
```bash
# Health check
curl https://your-domain.com/api/health

# Test authentication
curl -X POST https://your-domain.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'
```

### Mobile App Testing
- Test on physical devices
- Verify all features work
- Test offline functionality
- Validate push notifications
- Check face recognition accuracy

## 📊 Monitoring & Maintenance

### Application Monitoring
- Set up error tracking (Sentry/Bugsnag)
- Configure analytics (Firebase Analytics)
- Monitor server resources
- Set up uptime monitoring

### Database Maintenance
```bash
# Regular backups
mysqldump -u smart_presence_user -p smart_presence_prod > backup_$(date +%Y%m%d).sql

# Optimize tables
php artisan db:monitor
```

### Performance Optimization
```bash
# Laravel optimization
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Database optimization
php artisan db:monitor
```

## 🚨 Troubleshooting

### Common Issues

#### Backend Issues
```bash
# Check Laravel logs
tail -f storage/logs/laravel.log

# Clear cache
php artisan config:clear
php artisan cache:clear

# Check permissions
sudo chown -R www-data:www-data /var/www/smart_presence
```

#### Mobile App Issues
```bash
# Clean build
flutter clean
flutter pub get

# Check device logs
flutter logs

# Rebuild with clean
flutter build apk --release --clean
```

#### Database Issues
```bash
# Test connection
php artisan tinker
DB::connection()->getPdo();

# Reset migrations
php artisan migrate:reset
php artisan migrate
```

## 🔒 Security Checklist

- [ ] SSL certificate installed and valid
- [ ] Database credentials secured
- [ ] API keys properly configured
- [ ] File permissions correct
- [ ] Debug mode disabled in production
- [ ] CSRF protection enabled
- [ ] Rate limiting configured
- [ ] Input validation implemented
- [ ] SQL injection prevention
- [ ] XSS protection enabled

## 📞 Support & Documentation

### Documentation Files
- `docs/features.md` - Complete feature documentation
- `backend/DEPLOYMENT.md` - Backend deployment guide
- `DEPLOYMENT_MOBILE.md` - Mobile app deployment guide
- `README.md` - Project overview

### Support Channels
- GitHub Issues for bug reports
- Documentation wiki for guides
- Email support for urgent issues

## 🎯 Post-Deployment Tasks

1. **Monitor Application**
   - Check error logs regularly
   - Monitor user feedback
   - Track performance metrics

2. **User Onboarding**
   - Create user guides
   - Set up help documentation
   - Prepare training materials

3. **Updates & Maintenance**
   - Plan regular updates
   - Monitor app store reviews
   - Address user feedback

4. **Scaling**
   - Monitor resource usage
   - Plan for increased load
   - Consider CDN for assets

## 🏆 Success Metrics

- App successfully installed on devices
- Users can login and perform attendance
- Face recognition works accurately
- Notifications are received
- Reports generate correctly
- System performs well under load

---

**🎉 Congratulations! Your Smart Presence system is now deployed and ready for users.**

For additional help, refer to the detailed documentation in each component's DEPLOYMENT.md file.