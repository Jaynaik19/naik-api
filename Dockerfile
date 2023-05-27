FROM python:3.12-rc-slim-buster

WORKDIR /app
COPY Pipfile.lock Pipfile ./

# Building deps
RUN pip install pipenv
RUN pipenv install --dev --system --deploy

COPY . /app

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "100", "--reload", "--loop", "asyncio"]
