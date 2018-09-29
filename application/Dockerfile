ARG PYTHON_VERSION=latest
FROM python:${PYTHON_VERSION}

ENV PYTHONUNBUFFERED 1

# Install updates and any additional packages we need
RUN apt-get update -y && \
    apt-get install procps -y

# Create our docker group and user
ARG DOCKER_USER=docker
RUN groupadd -r ${DOCKER_USER} && \
    useradd -r -g ${DOCKER_USER} ${DOCKER_USER}

# Create the directory for our project
ARG PROJECT_NAME=project_name
RUN mkdir /${PROJECT_NAME}

# Set the working directory
WORKDIR /${PROJECT_NAME}

# Gunicorn configuration
COPY entrypoint.sh /
RUN chown ${DOCKER_USER} /entrypoint.sh && \
    chmod +x /entrypoint.sh && \
    sed -i 's/PROJECT_NAME/'"${PROJECT_NAME}"'/g' /entrypoint.sh && \
    sed -i 's/DOCKER_USER/'"${DOCKER_USER}"'/g' /entrypoint.sh

# Copy the requirements file to the working directory
COPY requirements.txt .

# Update/install pip and requirements.txt
RUN pip install -U pip && \
    pip install -r requirements.txt

# Change ownership of files
RUN chown -R ${DOCKER_USER} /${PROJECT_NAME}

# Switch to the docker user
USER ${DOCKER_USER}

# What environment is this (dev, staging, production)? To be passed to the
# entrypoint script
ARG APP_ENV
ENV APP_ENV=${APP_ENV}

ENTRYPOINT ["/entrypoint.sh"]