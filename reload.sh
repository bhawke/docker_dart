#!/bin/bash
docker stop web
docker rm -f web
docker build -t docker_dart .
docker run -d -p 8080:8080 --name web --link db:mongo docker_dart
docker logs -f web

