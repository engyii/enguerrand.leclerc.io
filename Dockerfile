# Multi-stage build for Hugo static site
FROM hugomods/hugo:exts as builder

# Copy Hugo site source
COPY . /src
WORKDIR /src

# Build the site
RUN hugo --minify

# Production image with nginx
FROM nginx:alpine

# Copy built site from builder
COPY --from=builder /src/public /usr/share/nginx/html

# Copy custom nginx config (optional - for redirects, etc)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost/ || exit 1
