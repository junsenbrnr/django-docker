#!/bin/bash

# h/t http://michal.karzynski.pl/blog/2013/06/09/django-nginx-gunicorn-virtualenv-supervisor/

# Name of the application
NAME=PROJECT_NAME

# for django, the location of manage.py
PROJECT_DIR=/PROJECT_NAME

# the user/group to run as
USER=DOCKER_USER
GROUP=DOCKER_USER

# how many worker processes should Gunicorn spawn
NUM_WORKERS=3

cd $PROJECT_DIR/$NAME

# which settings file should Django use
PROJECT_SETTINGS_MODULE=PROJECT_NAME.settings

# WSGI module name (project.name)
PROJECT_WSGI_MODULE=PROJECT_NAME.wsgi

export PROJECT_SETTINGS_MODULE=$PROJECT_SETTINGS_MODULE

export PYTHONPATH=$PROJECT_DIR:$PYTHONPATH

if [[ "$APP_ENV" == "dev" ]]; then
  LOG_LEVEL=debug
elif [[ "$APP_ENV" == "stage" ]]; then
  LOG_LEVEL=info
else
  LOG_LEVEL=warning
fi

# Start gunicorn
exec gunicorn ${PROJECT_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind 0.0.0.0:8000 \
  --log-level=$LOG_LEVEL \
  --log-file=- \
  --reload