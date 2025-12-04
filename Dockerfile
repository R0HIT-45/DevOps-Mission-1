<<<<<<< HEAD
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
=======
# ---- Stage 1: Builder ----
FROM python:3.11-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc build-essential && \
    rm -rf /var/lib/apt/lists/*

# Copy requirement file and install
COPY app/requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ---- Stage 2: Final Image ----
FROM python:3.11-slim

WORKDIR /app

# Create app user
RUN useradd -m appuser
USER appuser

# Copy installed packages
COPY --from=builder /root/.local /home/appuser/.local
ENV PATH="/home/appuser/.local/bin:${PATH}"

# Copy app code
COPY . /app/

# Copy flake8 config
COPY .flake8 /app/.flake8
>>>>>>> f067b74 (Initial commit with CI pipeline)

# Expose port
EXPOSE 8000

<<<<<<< HEAD
# Add a healthcheck
HEALTHCHECK CMD curl --fail http://localhost:8000/healthz || exit 1

# Command to run the Flask app
CMD ["python", "app/main.py"]
=======
CMD ["python", "main.py"]
>>>>>>> f067b74 (Initial commit with CI pipeline)
