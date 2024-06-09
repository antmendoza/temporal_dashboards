#!/bin/bash

cd ./sdk
#source 0-install-dependencies.sh
source 1-generate-dashboards.sh
source 3-copy-dashboards.sh

cd ..

cd ./deployment
source 0-start-compose.sh
