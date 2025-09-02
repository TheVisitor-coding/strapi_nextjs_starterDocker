#!/bin/bash

# =============================================================================
# STRAPI + NEXTJS DOCKER STARTER - SETUP SCRIPT
# =============================================================================

set -e

echo "🚀 Setting up Strapi + Next.js Docker Starter..."

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

# Safely escape replacement values for sed (handles /, \ and &)
escape_sed_replacement() {
    printf '%s' "$1" | sed -e 's/[\\/&]/\\&/g'
}

# Set or update an env var in .env (portable for macOS/BSD sed)
set_env_var() {
    var_name="$1"
    var_value="$2"
    escaped_value="$(escape_sed_replacement "$var_value")"

    if grep -q "^${var_name}=" .env; then
        sed -i.bak "s/^${var_name}=.*/${var_name}=${escaped_value}/" .env
    else
        printf '%s=%s\n' "$var_name" "$var_value" >> .env
    fi
}

# Check if Docker is installed
check_docker() {
    print_status "Checking Docker installation..."
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    print_success "Docker and Docker Compose are installed"
}

# Check if .env file exists
setup_env() {
    print_status "Setting up environment configuration..."
    
    if [ ! -f .env ]; then
        if [ -f .env.template ]; then
            cp .env.template .env
            print_success "Created .env file from template"
            print_warning "Please edit .env file with your configuration"
        else
            print_error ".env.template not found"
            exit 1
        fi
    else
        print_warning ".env file already exists"
    fi
}

# Generate secure secrets
generate_secrets() {
    print_status "Generating secure secrets..."
    
    # Generate random secrets
    ADMIN_JWT_SECRET=$(openssl rand -base64 32)
    JWT_SECRET=$(openssl rand -base64 32)
    API_TOKEN_SALT=$(openssl rand -base64 32)
    APP_KEYS=$(openssl rand -base64 32),$(openssl rand -base64 32)
    TRANSFER_TOKEN_SALT=$(openssl rand -base64 32)
    
    # Update .env file with generated secrets (safe for macOS/BSD sed)
    if [ -f .env ]; then
        set_env_var "STRAPI_ADMIN_JWT_SECRET" "$ADMIN_JWT_SECRET"
        set_env_var "STRAPI_JWT_SECRET" "$JWT_SECRET"
        set_env_var "STRAPI_API_TOKEN_SALT" "$API_TOKEN_SALT"
        set_env_var "STRAPI_APP_KEYS" "$APP_KEYS"
        set_env_var "STRAPI_TRANSFER_TOKEN_SALT" "$TRANSFER_TOKEN_SALT"

        # Clean up backup file if created by sed
        rm -f .env.bak

        print_success "Generated and updated secure secrets in .env"
    fi
}

# Create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    
    mkdir -p apps/api
    mkdir -p apps/web
    mkdir -p docker/nginx/ssl
    mkdir -p docker/backup
    mkdir -p docker/monitoring/grafana/provisioning/datasources
    mkdir -p docker/monitoring/grafana/provisioning/dashboards
    
    print_success "Created directory structure"
}

# Set proper permissions
set_permissions() {
    print_status "Setting proper permissions..."
    
    # Make scripts executable
    chmod +x scripts/*.sh
    
    # Set ownership for development (use correct primary group on macOS/Linux)
    # If running with sudo, prefer the original invoking user
    if [ "$EUID" -eq 0 ] && [ -n "$SUDO_USER" ]; then
        OWNER_USER="$SUDO_USER"
        OWNER_GROUP="$(id -gn "$SUDO_USER")"
    else
        OWNER_USER="$(id -un)"
        OWNER_GROUP="$(id -gn)"
    fi

    if command -v sudo >/dev/null 2>&1 && [ "$EUID" -ne 0 ]; then
        sudo chown -R "$OWNER_USER":"$OWNER_GROUP" .
    else
        chown -R "$OWNER_USER":"$OWNER_GROUP" .
    fi
    
    print_success "Set proper permissions"
}

# Check if applications exist
check_applications() {
    print_status "Checking application directories..."
    
    if [ ! -f "apps/api/package.json" ]; then
        print_warning "Strapi application not found in apps/api/"
        print_status "You can create a new Strapi app with:"
        echo "  npx create-strapi-app@latest apps/api --quickstart --no-run"
    fi
    
    if [ ! -f "apps/web/package.json" ]; then
        print_warning "Next.js application not found in apps/web/"
        print_status "You can create a new Next.js app with:"
        echo "  npx create-next-app@latest apps/web --typescript --tailwind --eslint"
    fi
}

# Main setup function
main() {
    echo "=============================================================================="
    echo "🚀 STRAPI + NEXTJS DOCKER STARTER SETUP"
    echo "=============================================================================="
    
    check_docker
    setup_env
    generate_secrets
    create_directories
    set_permissions
    check_applications
    
    echo ""
    echo "=============================================================================="
    print_success "Setup completed successfully!"
    echo "=============================================================================="
    echo ""
    echo "Next steps:"
    echo "1. Edit .env file with your project configuration"
    echo "2. Create your Strapi application in apps/api/"
    echo "3. Create your Next.js application in apps/web/"
    echo "4. Run: docker-compose up -d"
    echo ""
    echo "For more information, see README.md"
    echo ""
}

# Run main function
main "$@" 