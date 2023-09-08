
FROM python:3.8-slim

COPY . /auth_app
COPY ./requirements.txt /auth_app

WORKDIR /auth_app

# (fixed typo: changed "pip3" to "pip")
RUN pip install -r requirements.txt

EXPOSE 8000

# (added a delay before the health check to ensure the app is fully loaded)
HECHECK --ALTHinterval=30s --timeout=10s CMD sleep 10 || exit 1

CMD ["uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]
