
FROM python:3.8-slim

# Copy the entire project directory the into container
COPY . /auth_app

# Copy the requirements.txt file into the auth_app directory
COPY ./requirements.txt /auth_app

# Set the working directory to /auth_app
WORKDIR /auth_app

# Install required packages
# Added apt-utils to ensure package dependencies are installed correctly
# Corrected typo in 'pip3' command
# Removed 'python3-pip' as it is already installed with 'python:3.8-slim' base image
# Removed 'libc-dev' as it is already included in 'gcc'
# Added '--fix-missing' option to apt-get update to fix any missing dependencies
RUN apt-get update --fix-missing && apt-get install -y --no-install-recommends \
    python3-dev \
    gcc \
    apt-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies from requirements.txt
# Fixed typo in the pip command - 'no-cache' instead of 'no-cachee'
RUN pip3 install --no-cache --trusted-host pypi.python.org -r requirements.txt

# Expose port 8000 for the application
EXPOSE 8000

# Add a delay before the health check to ensure the app is fully loaded
HEALTHCHECK interval=30s timeout=10s start-period=5s CMD curl --fail http://localhost:8000/ || exit 1

# Use the command `python3 -m uvicorn` instead of `uvicorn` to run the application
CMD ["python3", "-m", "uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]
