
FROM python:3.8-slim

COPY . /auth_app
COPY ./requirements.txt /auth_app

WORKDIR /auth_app

# Install required packages
# Chose 'python3-dev' instead of 'build-essential' to install Python development headers
# Also added 'gcc' and 'libc-dev' as they are necessary for some Python packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    gcc \
    libc-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

# Add a delay before the health check to ensure the app is fully loaded
HEALTHCHECKinterval --=30s --timeout=10s CMD sleep 10 || exit 1

CMD ["uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]
