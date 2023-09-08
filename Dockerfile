
FROM python:3.8-slim

COPY . /auth_app
COPY ./requirements.txt /auth_app

WORKDIR /auth_app

RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    python3-dev \
    gcc \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache --trusted-host pypi.python.org -r requirements.txt

EXPOSE 8000

# Specify HEALTHCHECK command using the correct syntax
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s CMD curl --fail http://localhost:8000/ || exit 1

# Specify the correct command to run the application using Uvicorn
CMD ["python3", "-m", "uvicorn", "src.main:app", "--=host0.0.0.0", "--reload"]
