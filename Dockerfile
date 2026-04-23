# --- Build Stage ---
FROM python:3.12-slim-bookworm AS builder

# Default environment variables for Poetry and Python
ENV POETRY_NO_INTERACTION=1 \
  POETRY_VIRTUALENVS_IN_PROJECT=1 \
  POETRY_VIRTUALENVS_CREATE=1 \
  PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1

WORKDIR /app

# Dependency installation requires build tools and libpq-dev for psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  libpq-dev \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir poetry==2.3.4

COPY pyproject.toml poetry.lock ./

RUN poetry lock --regenerate && \
  poetry install --only main --no-root

# --- Runtime ---
FROM python:3.12-slim-bookworm AS runtime

ENV PATH="/app/.venv/bin:$PATH" \
  PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
  libpq5 \
  && rm -rf /var/lib/apt/lists/*

# Copy the virtual environment from the builder stage
COPY --from=builder /app/.venv /app/.venv

COPY app/ ./app
COPY migrations/ ./migrations
COPY alembic.ini ./alembic.ini

# Secure the application by running as a non-root user
RUN useradd -m appuser && chown -R appuser /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
