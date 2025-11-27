# ============================================
# Stage 1: Build Frontend
# ============================================
FROM node:20-alpine AS frontend-builder

WORKDIR /app/frontend

# Copy frontend package files
COPY frontend/package*.json ./

# Install ALL dependencies (including dev deps needed for build)
RUN npm ci

# Copy frontend source
COPY frontend/ ./

# Build frontend
RUN npm run build


# ============================================
# Stage 2: Setup Python Backend
# ============================================
FROM python:3.13-slim AS backend-builder

WORKDIR /app

# Install uv for fast dependency management
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Copy Python dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies (no dev dependencies)
RUN uv sync --locked --no-dev --no-install-project


# ============================================
# Stage 3: Final Production Image
# ============================================
FROM node:20-alpine

WORKDIR /app

# Copy built frontend from frontend-builder
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist
COPY --from=frontend-builder /app/frontend/package*.json ./frontend/

# Install only vite for preview server
WORKDIR /app/frontend
RUN npm install --production=false vite

# Set environment variables
ENV PORT=5173

# Expose frontend port
EXPOSE 5173

# Run Vite preview server
CMD ["npx", "vite", "preview", "--host", "0.0.0.0", "--port", "5173"]
