# -------- Stage 1: Builder --------
FROM python:3.11-slim AS builder

# Set working directory inside the container
WORKDIR /app

# Copy only requirements first (for caching efficiency)
COPY app/ app/
COPY tests/ tests/
COPY requirements.txt requirements.txt

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# -------- Stage 2: Runtime --------
FROM python:3.11-slim

# Create a non-root user (for security)
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

# Add a healthcheck
HEALTHCHECK CMD curl --fail http://localhost:8000/healthz || exit 1

# Command to run the Flask app
CMD ["python", "app/main.py"]
