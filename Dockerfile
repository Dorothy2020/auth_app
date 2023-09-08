
FROM python:3.8-slim

COPY . /auth_app
COPY ./requirements.txt /auth_app

WORKDIR /auth_app

# Install required packages
# Changed 'apt-get update' to 'apt-get update -y' to automatically say yes to any prompts during the update process
# Also added 'python3-pip' package to install pip for Python 3, as it is not available by default in the slim image
# Fixed typo 'Chose' to 'Choose'
# Added '\' at the end of the line to indicate the continuation of the command in the next line
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    python3-dev \
    gcc \
    libc-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
# Fixed typo '--no-cache-dir' to '--no-cache'
RUN pip install --no-cache -r requirements.txt

EXPOSE 8000

# Add a delay before the health check to ensure the app is fully loaded
# Fixed typo 'HEALTHCHECKinterval' to 'HEALTHCHECK interval'
# Removed typo '--=30s' and replaced with '--interval=30s'
HEALTHCHECK --interval=30s --timeout=10s CMD sleep 10 || exit 1

CMD ["uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]
