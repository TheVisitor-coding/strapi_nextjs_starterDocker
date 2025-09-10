# 🚀 Strapi + Next.js Docker Starter

A production-ready Docker starter kit for building modern web applications with **Strapi** (Headless CMS) and **Next.js** (React Framework).

## 🏗️ Stack & Architecture

- **Frontend**: Next.js 14 (React)
- **Backend**: Strapi 5 (Headless CMS)
- **Database**: PostgreSQL 15
- **Reverse Proxy**: Nginx
- **Containerization**: Docker & Docker Compose
- **Monitoring**: Prometheus & Grafana (optional)

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Nginx Proxy   │    │   Next.js App   │    │   Strapi CMS    │
│   (Port 80)     │◄──►│   (Port 3000)   │◄──►│   (Port 1337)   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │   PostgreSQL    │
                    │   (Port 5432)   │
                    └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Git

### 1. Setup
```bash
git clone <your-repo-url>
cd strapi_nextjs_starterDocker
cp .env.template .env

# Generate secure secrets for Strapi
node scripts/generate-secrets.js

# Copy the generated secrets to your .env file
# Edit .env with your other settings
```

### 2. Start
```bash
# Basic setup
docker-compose up -d

# With monitoring
docker-compose --profile monitoring up -d
```

### 3. Access
- **Frontend**: http://localhost
- **Strapi Admin**: http://localhost/admin
- **API**: http://localhost/api
- **Database**: localhost:5432
- **Grafana**: http://localhost:3001 (admin/admin)
- **Prometheus**: http://localhost:9090

## 🛠️ Development

### Hot Reload
Both Next.js and Strapi support hot reloading. Code changes are automatically reflected.

### Useful Commands
```bash
# View logs
docker-compose logs -f

# Rebuild specific service
docker-compose build frontend
docker-compose build backend

# Restart specific service
docker-compose restart nginx

# Access database
docker-compose exec postgres psql -U strapi -d strapidb

# Stop all services
docker-compose down
```

### Environment Variables
Key variables to configure in `.env`:
```bash
PROJECT_SLUG=my-app
POSTGRES_PASSWORD=your_password

# Strapi Security - Generate with: node scripts/generate-secrets.js
ADMIN_JWT_SECRET=your_admin_jwt_secret
ENCRYPTION_KEY=your_encryption_key
API_TOKEN_SALT=your_api_token_salt
APP_KEYS=key1,key2,key3,key4
TRANSFER_TOKEN_SALT=your_transfer_token_salt
```

> ⚠️ **Important**: Never use the default placeholder values in production. Always generate your own secure secrets with the provided script.

## 📊 Monitoring

### Quick Start
```bash
# Start with monitoring
docker-compose --profile monitoring up -d

# Access Grafana
# URL: http://localhost:3001
# Login: admin
# Password: admin
```

### What you can monitor
- **Services Status**: Up/Down de chaque service
- **Performance**: Temps de réponse, requêtes par seconde
- **Errors**: Taux d'erreurs 4xx/5xx
- **Resources**: CPU, mémoire, disque

### Dashboard included
- **Stack Overview**: Vue d'ensemble automatique
- **Custom dashboards**: Créer selon vos besoins

📖 **Guide complet**: [MONITORING_GUIDE.md](MONITORING_GUIDE.md)

## 🚀 Production

### Deploy
```bash
# Use production compose
docker-compose -f docker-compose.prod.yml up -d

# With monitoring
docker-compose --profile monitoring -f docker-compose.prod.yml up -d
```

### SSL Setup
1. Add certificates to `docker/nginx/ssl/`
2. Uncomment HTTPS in `docker/nginx/default.conf`
3. Update environment variables

## 🔧 Troubleshooting

### Common Issues
```bash
# Strapi APP_KEYS error
# Error: Middleware "strapi::session": App keys are required
# Solution: Generate and set secure secrets
node scripts/generate-secrets.js
# Copy the output to your .env file

# Permission errors
sudo chown -R $USER:$USER ./apps/

# Port conflicts - change in .env
NEXTJS_PORT_EXTERNAL=3001
STRAPI_PORT_EXTERNAL=1338

# Rebuild after config changes
docker-compose build nginx && docker-compose restart nginx

# Reset everything
docker-compose down -v && docker-compose up -d
```

### Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs backend
docker-compose logs frontend
docker-compose logs nginx
```

## 📁 Project Structure
```
├── apps/
│   ├── api/          # Strapi application
│   └── web/          # Next.js application
├── docker/
│   ├── backend/      # Strapi Dockerfile
│   ├── frontend/     # Next.js Dockerfile
│   ├── nginx/        # Nginx config
│   └── monitoring/   # Prometheus & Grafana
├── docker-compose.yml
└── .env.template
```

## 🔧 Recent Fixes

- ✅ Fixed permission errors in development containers
- ✅ Added PostgreSQL driver to Strapi
- ✅ Optimized Nginx configuration for development
- ✅ Fixed 502 Bad Gateway errors
- ✅ Enhanced proxy settings and timeouts
- ✅ Added monitoring with Prometheus & Grafana

---

**Happy Coding! 🎉** 