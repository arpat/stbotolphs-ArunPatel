"""
Django settings for botolphs project.

Generated by 'django-admin startproject' using Django 1.11.25.

For more information on this file, see
https://docs.djangoproject.com/en/1.11/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.11/ref/settings/
"""
import os
import logging

# If there are any "dangerous" environment variables set, warn.
for k in (k for k in os.environ.keys() if k.startswith('DJANGO_DANGEROUS_')):
    logging.warning('Environment variable %s is set. DO NOT DO THIS IN PRODUCTION', k)

DATA_DIR = os.path.dirname(os.path.dirname(__file__))

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.11/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = os.environ['DJANGO_SECRET_KEY']

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = 'DJANGO_DEBUG' in os.environ

ALLOWED_HOSTS = []


# Application definition

ROOT_URLCONF = 'botolphs.urls'

# Internationalization
# https://docs.djangoproject.com/en/1.11/topics/i18n/

LANGUAGE_CODE = 'en-gb'

TIME_ZONE = 'Europe/London'

USE_I18N = True

USE_L10N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.11/howto/static-files/

STATIC_URL = '/static/'
MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(DATA_DIR, 'media')
STATIC_ROOT = os.path.join(DATA_DIR, 'static')

STATICFILES_DIRS = (
    os.path.join(BASE_DIR, 'botolphs', 'static'),
)
SITE_ID = 1


TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [os.path.join(BASE_DIR, 'botolphs', 'templates')],
        'OPTIONS': {
            'context_processors': [
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
                'django.template.context_processors.i18n',
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.template.context_processors.media',
                'django.template.context_processors.csrf',
                'django.template.context_processors.tz',
                'sekizai.context_processors.sekizai',
                'django.template.context_processors.static',
                'cms.context_processors.cms_settings'
            ],
            'loaders': [
                'django.template.loaders.filesystem.Loader',
                'django.template.loaders.app_directories.Loader',
            ],
        },
    },
]


MIDDLEWARE = [
    'cms.middleware.utils.ApphookReloadMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'cms.middleware.user.CurrentUserMiddleware',
    'cms.middleware.page.CurrentPageMiddleware',
    'cms.middleware.toolbar.ToolbarMiddleware',
    'cms.middleware.language.LanguageCookieMiddleware',
    'whitenoise.middleware.WhiteNoiseMiddleware',
]

INSTALLED_APPS = [
    'djangocms_admin_style',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.admin',
    'django.contrib.sites',
    'django.contrib.sitemaps',
    'django.contrib.staticfiles',
    'django.contrib.messages',
    'cms',
    'menus',
    'sekizai',
    'treebeard',
    'djangocms_text_ckeditor',
    'filer',
    'easy_thumbnails',
    'djangocms_file',
    'djangocms_link',
    'djangocms_picture',
    'djangocms_style',
    'djangocms_snippet',
    'djangocms_googlemap',
    'djangocms_video',
    'djangocms_forms',
    'storages',
    'botolphs'
]

LANGUAGES = (
    ('en-gb', 'British English'),
)

CMS_LANGUAGES = {
    1: [
        {
            'code': 'en-gb',
            'name': 'British English',
            'redirect_on_fallback': True,
            'public': True,
            'hide_untranslated': False,
        },
    ],
    'default': {
        'redirect_on_fallback': True,
        'public': True,
        'hide_untranslated': False,
    },
}

CMS_TEMPLATES = (
    ('page.html', 'Page'),
    ('feature.html', 'Page with Feature')
)

CMS_PERMISSION = True

CMS_PLACEHOLDER_CONF = {}


# Database configuration. The default settings allow configuration of the database from
# environment variables. An environment variable named ``DJANGO_DB_<key>`` will override the
# ``DATABASES['default'][<key>]`` setting.
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}

_db_envvar_prefix = 'DJANGO_DB_'
for name, value in os.environ.items():
    # Only look at variables which start with the prefix we expect
    if not name.startswith(_db_envvar_prefix):
        continue

    # Remove prefix
    name = name[len(_db_envvar_prefix):]

    # Special case non-string values
    if name == 'CONN_MAX_AGE':
        value = None if value == 'None' else int(value)

    # Set value
    DATABASES['default'][name] = value

MIGRATION_MODULES = dict()

THUMBNAIL_PROCESSORS = (
    'easy_thumbnails.processors.colorspace',
    'easy_thumbnails.processors.autocrop',
    'filer.thumbnail_processors.scale_and_crop_with_subject_location',
    'easy_thumbnails.processors.filters'
)

# The django smtp server settings
EMAIL_HOST = os.environ.get('DJANGO_EMAIL_HOST', 'localhost')
EMAIL_HOST_PASSWORD = os.environ.get('DJANGO_EMAIL_HOST_PASSWORD', '')
EMAIL_HOST_USER = os.environ.get('DJANGO_EMAIL_HOST_USER', '')
EMAIL_PORT = int(os.environ.get('DJANGO_EMAIL_PORT', 25))

STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'

if 'DJANGO_USE_AWS' in os.environ:
    # S3-based storage
    AWS_AUTO_CREATE_BUCKET = True
    AWS_S3_HOST = os.environ['DJANGO_AWS_S3_HOST']
    AWS_ACCESS_KEY_ID = os.environ['DJANGO_AWS_ACCESS_KEY_ID']
    AWS_SECRET_ACCESS_KEY = os.environ['DJANGO_AWS_SECRET_ACCESS_KEY']
    AWS_STORAGE_BUCKET_NAME = os.environ['DJANGO_AWS_STORAGE_BUCKET_NAME']
    AWS_S3_ENDPOINT_URL = os.environ['DJANGO_AWS_S3_ENDPOINT_URL']
    AWS_S3_REGION_NAME = os.environ['DJANGO_AWS_S3_REGION_NAME']
    AWS_S3_OBJECT_PARAMETERS = {
        'CacheControl': 'max-age=86400',
    }
    AWS_DEFAULT_ACL = 'public-read'
    S3_USE_SIGV4 = True

    AWS_S3_USE_SSL = True
    if 'DJANGO_DANGEROUS_DISABLE_AWS_USE_SSL' in os.environ:
        AWS_S3_USE_SSL = False

    # Configure file storage
    DEFAULT_FILE_STORAGE = 'storages.backends.s3boto3.S3Boto3Storage'
else:
    logging.warning('Not using S3 to store files. Container is not stateless.')

ALLOWED_HOSTS = ['*']

FILER_ENABLE_LOGGING = 'true'
FILER_DEBUG = 'true'
