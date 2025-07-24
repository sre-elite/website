# Dockerfile for local Hugo testing - matches GitHub Actions environment
FROM ubuntu:latest

# Set Hugo version to match GitHub Actions
ENV HUGO_VERSION=0.120.4
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    npm \
    nodejs \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Hugo CLI (multi-architecture support)
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        HUGO_ARCH="linux-amd64"; \
    elif [ "$ARCH" = "arm64" ]; then \
        HUGO_ARCH="linux-arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget -O /tmp/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_${HUGO_ARCH}.deb \
    && dpkg -i /tmp/hugo.deb \
    && rm /tmp/hugo.deb

# Install Dart Sass (using npm instead of snap for container compatibility)
RUN npm install -g sass

# Set working directory
WORKDIR /workspace

# Copy package files for npm dependencies (if they exist)
COPY themes/educenter-hugo/package*.json ./themes/educenter-hugo/
RUN cd themes/educenter-hugo && npm ci 2>/dev/null || true

# Copy the entire website source
COPY . .

# Set Hugo environment variables to match GitHub Actions
ENV HUGO_ENVIRONMENT=production
ENV HUGO_ENV=production

# Expose Hugo's default port
EXPOSE 1313

# Default command - build the site
CMD ["hugo", "--minify", "--baseURL", "https://www.sre-elite.com/"]

# For development server, override with:
# docker run -p 1313:1313 <image> hugo server --bind 0.0.0.0 --baseURL http://localhost:1313
