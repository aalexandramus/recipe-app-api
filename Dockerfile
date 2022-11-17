FROM python:3.9-alpine3.13
LABEL maintainer="ali"

ENV PYTHONUNBUFFERED 1

# punem toate dependencies din requirements in requirementul din docker
COPY ./requirements.txt /tmp/requirements.txt  
COPY ./requirements.dev.txt /tmp/requirements.dev.txt  
COPY ./app /app
WORKDIR /app
EXPOSE 8000

# overrides the one in docker compose, fisierul asta runs in docker si astfel nu rulam requirements-urile dev
ARG DEV=false
# combinatia tuturor comenzilor pentru a crea imaginea in docker
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    # instalam dependencies in docker
    /py/bin/pip install -r /tmp/requirements.txt && \
    # stergem fisierul de requirements din docker dupa ce il folosim pt a avea o imagine cat mai simpla
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
    # cream un user simplu 
        --disabled-password \ 
        --no-create-home \
        django-user

# rulam orice comanda din venv cu ajutorul path-ului
ENV PATH="/py/bin:$PATH"

# totul pana aici a fost facut cu the root user, de aici incolo schimbam userul pentru ca in cazul unui atac, atacatorul sa nu aiba toate drepturile root-ului
USER django-user 
