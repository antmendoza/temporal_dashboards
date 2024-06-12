#!/bin/bash

cd ./deployment
source 1-stop-and-clean-compose.sh

cd ..

cd ./sdk
source 4-clean-dashboards.sh

cd ..

