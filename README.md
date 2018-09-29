# django-docker

Hat tip to [django-docker](https://github.com/huchenw/django-docker) and [laradock](https://github.com/laradock/laradock)

## How to get this working
### Docker
First, get [docker](https://www.docker.com)

### Repository
Next:

* download this repo
* create a virtual environemt for your project
* copy `env-template` to `.env` and fill in your project/docker settings
* add or remove any dependencies in `requirements.in`

> [pip-tools](https://github.com/jazzband/pip-tools) is awesome. Simply add your dependencies to a `requirements.in` file, run `pip-compile requirements.in` and pip-tools will generate the `requirements.txt` file for you.

* run: `pip install -U pip pip-tools`
* generate `requirements.txt` by running: `pip-compile requirements.in`
* install your packages by running: `pip install -r requirements.txt`
* install Django by running: `django-admin startproject YOUR-PROJECT-NAME-HERE .`

### .env and settings.py
> If you did not remove `python-dotenv` in `requirements.in`, which you probably shouldn't, follow the steps below. If you did remove it, update `settings.py` like you normally would and skip this section.

Using Docker's `.env` file, we're going to replace environment specific settings. First, we need to add the following code right below `import os`.

```python
from dotenv import load_dotenv
from pathlib import Path

load_dotenv(verbose=True)
env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)
```

The `DEBUG` environment variable in `.env` can be used in `settings.py` like the following:

`DEBUG = os.getenv("DEBUG")`

Any variable that exists in `.env` can be used. For example:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv("POSTGRES_DB"),
        'USER': os.getenv("POSTGRES_USER"),
        'PASSWORD': os.getenv("POSTGRES_PASSWORD"),
        'HOST': 'db',
        'PORT': '5432',
    }
}
```
