FROM python:3.9-alpine3.13
LABEL maintainer="ali"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user

#6 punem toate dependencies din requirements in requirementul din docker
#12 overrides the one in docker compose, fisierul asta runs in docker si astfel nu rulam requirements-urile dev
#13 combinatia tuturor comenzilor pentru a crea imaginea in docker
#15 instalam dependencies in docker
#16 stergem fisierul de requirements din docker dupa ce il folosim pt a avea o imagine cat mai simpla
#21 # cream un user simplu 
#25 # rulam orice comanda din venv cu ajutorul path-ului
#27 totul pana aici a fost facut cu the root user, de aici incolo schimbam userul pentru ca in cazul unui atac, atacatorul sa nu aiba toate drepturile root-ului

