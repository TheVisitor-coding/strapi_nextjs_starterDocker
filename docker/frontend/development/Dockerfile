# =============================================================================
# NEXTJS FRONTEND - DEVELOPMENT DOCKERFILE
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

# Create node_modules and .next directories
RUN mkdir -p /app/node_modules /app/.next

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/api/health || exit 1

# Start development server with hot reload
CMD ["sh", "-c", "if [ -f package.json ]; then npm install && npm run dev; else echo 'Waiting for application files...'; sleep 30; fi"] 