# -------- Stage 1: Builder --------
FROM python:3.11-slim AS builder

WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .

# Install all dependencies including dev/test
RUN pip install --no-cache-dir -r requirements.txt

# Copy application and tests
COPY app/ app/
COPY tests/ tests/

# -------- Stage 2: Runtime --------
FROM python:3.11-slim

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy only necessary app code and installed packages
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /app /app

USER appuser

ENV PORT=8000
ENV APP_ENV=production

EXPOSE 8000

# Healthcheck for CI
HEALTHCHECK --interval=10s --timeout=3s CMD curl -f http://localhost:8000/healthz || exit 1

CMD ["python", "app/main.py"]
