FROM python:3.8-slim

COPY . /auth_app
COPY ./requirements.txt /auth_app

WORKDIR /auth_app

RUN pip3 install -r requirements.txt

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host=0.0.0.0", "--reload"]