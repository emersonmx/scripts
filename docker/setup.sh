#!/bin/bash

docker run -p 5432:5432 --name postgres  -e POSTGRES_PASSWORD=secret -d postgres
