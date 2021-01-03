#!/usr/bin/env bash

set -eu

# Run the initial migrate commands from the root directories.
# Requires /usr/local/lib/python3.7/site-packages/djangocms_forms/migrations to
# be writable.

./manage.py makemigrations \
  && ./manage.py migrate
