#!/bin/sh

docker build -t cswl/xampp:latest .
docker tag cswl/xampp:latest  cswl/xampp:7.2.12