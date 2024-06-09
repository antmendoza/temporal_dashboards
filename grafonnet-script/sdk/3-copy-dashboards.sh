#!/bin/bash

# copy to the sdk repository
cp sdk.json ../deployment/grafana/dashboards

# copy to grafana deployments
cp sdk.json ../../sdk

rm sdk.json

