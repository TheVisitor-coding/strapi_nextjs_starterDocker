# =============================================================================
# STRAPI BACKEND - DEVELOPMENT DOCKERFILE
# =============================================================================

# Use Node.js 18 Alpine for smaller image size
FROM node:18-alpine AS base

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    python3 \
    make \
    g++ \
    git \
    && rm -rf /var/cache/apk/*

# Development stage
FROM base AS development

# Create node_modules directory
RUN mkdir -p /app/node_modules

# Expose port
EXPOSE 1337

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node healthcheck.js || exit 1

# Start development server with hot reload
CMD ["sh", "-c", "if [ -f package.json ]; then npm install && npm run develop; else echo 'Waiting for application files...'; sleep 30; fi"] 