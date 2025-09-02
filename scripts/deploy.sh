#!/bin/bash

# =============================================================================
# STRAPI + NEXTJS DOCKER STARTER - DEPLOYMENT SCRIPT
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if .env file exists
check_env() {
    if [ ! -f .env ]; then
        print_error ".env file not found. Please run setup.sh first."
        exit 1
    fi
}

# Load environment variables
load_env() {
    print_status "Loading environment variables..."
    export $(cat .env | grep -v '^#' | xargs)
}

# Backup database before deployment
backup_database() {
    print_status "Creating database backup..."
    docker-compose run --rm backup
    print_success "Database backup completed"
}

# Build and deploy production images
deploy_production() {
    print_status "Deploying to production..."
    
    # Stop existing containers
    docker-compose -f docker-compose.prod.yml down
    
    # Build new images
    print_status "Building production images..."
    docker-compose -f docker-compose.prod.yml build --no-cache
    
    # Start production services
    print_status "Starting production services..."
    docker-compose -f docker-compose.prod.yml up -d
    
    # Wait for services to be healthy
    print_status "Waiting for services to be healthy..."
    sleep 30
    
    # Check service health
    check_health
}

# Check service health
check_health() {
    print_status "Checking service health..."
    
    services=("postgres" "backend" "frontend" "nginx")
    
    for service in "${services[@]}"; do
        if docker-compose -f docker-compose.prod.yml ps $service | grep -q "Up"; then
            print_success "$service is running"
        else
            print_error "$service is not running"
            exit 1
        fi
    done
}

# Show deployment status
show_status() {
    print_status "Deployment status:"
    docker-compose -f docker-compose.prod.yml ps
    
    echo ""
    print_status "Service URLs:"
    echo "  Frontend: http://localhost"
    echo "  Backend API: http://localhost/api"
    echo "  Strapi Admin: http://localhost/admin"
    echo "  Health Check: http://localhost/health"
}

# Main deployment function
main() {
    echo "=============================================================================="
    echo "🚀 STRAPI + NEXTJS DOCKER STARTER - PRODUCTION DEPLOYMENT"
    echo "=============================================================================="
    
    check_env
    load_env
    backup_database
    deploy_production
    show_status
    
    echo ""
    echo "=============================================================================="
    print_success "Production deployment completed successfully!"
    echo "=============================================================================="
    echo ""
    echo "Monitoring:"
    echo "  - View logs: docker-compose -f docker-compose.prod.yml logs -f"
    echo "  - Check health: docker-compose -f docker-compose.prod.yml ps"
    echo "  - Access Grafana: http://localhost:3001 (admin/admin)"
    echo ""
}

# Run main function
main "$@" 