
FROM python:3.8-slim

COPY . /auth_app
COPY ./requirements.txt /auth_app

WORKDIR /auth_app

# Install required packages
# Changed python3-pip to python3-pip
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    python3-dev \
    gcc \
    libc-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache -r requirements.txt

EXPOSE 8000

# Add a delay before the health check to ensure the app is fully loaded
# Updated the HEALTHCHECK command to check if the app has started successfully
CHECKHEALTH --interval=30s --timeout=10s CMD curl --fail http://localhost:8000/ || exit 1

# Use the command `python3 -m uvicorn` instead of `uvicorn`
CMD ["python3", "-m", "uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]
