
FROM python:3.8-slim

# Copy the entire project directory the into container
COPY . /auth_app

# Copy the requirements.txt file into the auth_app directory
COPY ./requirements.txt /auth_app

# Set the working directory to /auth_app
WORKDIR /auth_app

# Install required packages
# Added apt-utils to ensure package dependencies are installed correctly
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3-dev \
    gcc \
    libc-dev \
    python3-pip \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies from requirements.txt
# Fixed typo in the pip command - 'no-cache' instead of 'no-cachee'
RUN pip install --no-cache -r requirements.txt

# Expose port 8000 for the application
EXPOSE 8000

# Add a delay before the health check to ensure the app is fully loaded
HEALTHCHECK interval=30s timeout=10s start-period=5s CMD curl --fail http://localhost:8000/ || exit 1

# Use the command `python3 -m uvicorn` instead of `uvicorn` to run the application
CMD ["python3", "-m", "uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]
