# -------- Stage 1: Builder --------
FROM python:3.11-slim AS builder

# Set working directory inside the container
WORKDIR /app

# Copy only requirements first (for caching efficiency)
COPY app/requirements.txt .
COPY tests/requirements.txt ./tests/requirements.txt  # if tests have separate requirements

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy all source code after installing dependencies
COPY app/ app/
COPY tests/ tests/

# -------- Stage 2: Runtime --------
FROM python:3.11-slim

# Create a non-root user
RUN useradd -m appuser

# Set work directory
WORKDIR /app

# Copy app code from builder image
COPY --from=builder /app /app

# Switch to non-root user
USER appuser

# Set environment variables
ENV PORT=8000
ENV APP_ENV=production

# Expose port
EXPOSE 8000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s CMD curl -f http://localhost:8000/healthz || exit 1

# Start the app
CMD ["python", "app/main.py"]
