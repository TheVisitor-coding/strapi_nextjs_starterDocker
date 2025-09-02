# =============================================================================
# NGINX REVERSE PROXY - DOCKERFILE
# =============================================================================

FROM nginx:alpine

# Install additional tools
RUN apk add --no-cache \
    curl \
    && rm -rf /var/cache/apk/*

# Copy nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Expose ports
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start nginx
CMD ["nginx", "-g", "daemon off;"] 