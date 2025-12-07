#!/bin/bash

# Smart Presence Backend Deployment Script
# Usage: ./deploy.sh [environment]

set -e

ENVIRONMENT=${1:-production}
PROJECT_NAME="smart_presence"
BACKUP_DIR="./backups/$(date +%Y%m%d_%H%M%S)"

echo "🚀 Starting Smart Presence Backend Deployment"
echo "Environment: $ENVIRONMENT"
echo "Project: $PROJECT_NAME"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Function to backup current deployment
backup_current() {
    echo "📦 Creating backup..."
    if [ -d "./storage" ]; then
        cp -r ./storage "$BACKUP_DIR/"
    fi
    if [ -f ".env" ]; then
        cp .env "$BACKUP_DIR/"
    fi
    echo "✅ Backup created at $BACKUP_DIR"
}

# Function to setup environment
setup_environment() {
    echo "🔧 Setting up environment..."

    # Copy environment file
    if [ "$ENVIRONMENT" = "production" ]; then
        if [ -f ".env.production" ]; then
            cp .env.production .env
            echo "✅ Production environment configured"
        else
            echo "❌ .env.production file not found"
            exit 1
        fi
    fi

    # Generate application key if not set
    if ! grep -q "APP_KEY=base64:" .env; then
        echo "🔑 Generating application key..."
        php artisan key:generate
    fi
}

# Function to install dependencies
install_dependencies() {
    echo "📦 Installing dependencies..."

    # Install PHP dependencies
    if [ "$ENVIRONMENT" = "production" ]; then
        composer install --optimize-autoloader --no-dev
    else
        composer install
    fi

    # Install Node.js dependencies
    npm install

    # Build assets
    npm run build

    echo "✅ Dependencies installed"
}

# Function to setup database
setup_database() {
    echo "🗄️ Setting up database..."

    # Run migrations
    php artisan migrate --force

    # Seed database if in development
    if [ "$ENVIRONMENT" = "local" ]; then
        php artisan db:seed
    fi

    echo "✅ Database setup complete"
}

# Function to setup storage
setup_storage() {
    echo "💾 Setting up storage..."

    # Create storage link
    php artisan storage:link

    # Set permissions
    chmod -R 755 storage
    chmod -R 755 bootstrap/cache

    echo "✅ Storage setup complete"
}

# Function to clear and cache config
clear_cache() {
    echo "🧹 Clearing cache..."

    php artisan config:clear
    php artisan cache:clear
    php artisan route:clear
    php artisan view:clear

    if [ "$ENVIRONMENT" = "production" ]; then
        php artisan config:cache
        php artisan route:cache
        php artisan view:cache
    fi

    echo "✅ Cache cleared and optimized"
}

# Function to start services
start_services() {
    echo "🏃 Starting services..."

    if [ -f "docker-compose.yml" ]; then
        echo "🐳 Using Docker Compose"
        docker-compose down
        docker-compose up -d --build
        docker-compose exec app php artisan migrate --force

        if [ "$ENVIRONMENT" = "production" ]; then
            docker-compose exec app php artisan queue:restart
        fi
    else
        echo "🌐 Using traditional deployment"
        # Add traditional deployment commands here
        echo "Please configure your web server manually"
    fi

    echo "✅ Services started"
}

# Function to run health checks
health_check() {
    echo "🏥 Running health checks..."

    # Wait for services to be ready
    sleep 10

    # Check if application is responding
    if curl -f http://localhost/api/health > /dev/null 2>&1; then
        echo "✅ Application is healthy"
    else
        echo "⚠️ Application health check failed"
    fi
}

# Function to show deployment summary
show_summary() {
    echo ""
    echo "🎉 Deployment Summary"
    echo "===================="
    echo "Environment: $ENVIRONMENT"
    echo "Backup Location: $BACKUP_DIR"
    echo "Application URL: http://localhost"
    echo "API Base URL: http://localhost/api"
    echo ""
    echo "Next Steps:"
    echo "1. Configure your domain DNS"
    echo "2. Set up SSL certificate"
    echo "3. Configure Firebase for push notifications"
    echo "4. Test all features thoroughly"
    echo ""
}

# Main deployment flow
main() {
    echo "🔍 Pre-deployment checks..."

    # Check if required tools are installed
    command -v php >/dev/null 2>&1 || { echo "❌ PHP is required but not installed."; exit 1; }
    command -v composer >/dev/null 2>&1 || { echo "❌ Composer is required but not installed."; exit 1; }
    command -v npm >/dev/null 2>&1 || { echo "❌ Node.js is required but not installed."; exit 1; }

    # Backup current deployment
    backup_current

    # Setup environment
    setup_environment

    # Install dependencies
    install_dependencies

    # Setup database
    setup_database

    # Setup storage
    setup_storage

    # Clear cache
    clear_cache

    # Start services
    start_services

    # Health check
    health_check

    # Show summary
    show_summary

    echo "🎊 Deployment completed successfully!"
}

# Run main function
main "$@"