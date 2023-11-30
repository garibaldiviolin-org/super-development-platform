FROM python:3.11.4-slim-bullseye as base

ARG YOUR_ENV

# Setup env
ENV YOUR_ENV=${YOUR_ENV}
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

FROM base AS python-deps

# Install poetry and compilation dependencies
RUN pip install --upgrade pip && pip install poetry
RUN apt-get update && apt-get install -y --no-install-recommends gcc

# Install python dependencies in /.venv
COPY ./rest_api/pyproject.toml ./rest_api/poetry.lock* ./
RUN echo "$YOUR_ENV"
RUN poetry config virtualenvs.create false \
    && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") \
    --no-interaction --no-ansi

FROM python-deps AS runtime

COPY rest_api /home/rest_api
WORKDIR /home/rest_api

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
