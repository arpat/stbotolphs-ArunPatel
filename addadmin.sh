#!/bin/sh

echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', \"${1}\")" | ./manage.py shell

