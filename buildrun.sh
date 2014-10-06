#!/bin/bash

docker build -t docker_dart .
docker run --link my-mongo:mongo -d -p 8080:8080 docker_dart 
