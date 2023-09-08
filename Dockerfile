
# There are no errors in the Dockerfile. However, there is a separate issue causing the error message "The container exited before becoming healthy. Please check the container logs."

# This error usually occurs when the application inside the container fails to start properly or does not respond to the health check in time.

# To fix this issue, we can modify the HEALTHCHECK command to check if the application is running on the correct port.

# Updated Dockerfile:

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

# Specify a new HEALTHCHECK command to check if the application is running on port 8000
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s CMD curl --fail http://localhost:8000/ || exit 1

# Specify the correct command to run the application using Uvicorn
CMD ["python3", "-m", "uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]
