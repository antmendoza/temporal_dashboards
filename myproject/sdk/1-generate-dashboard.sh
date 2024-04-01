#!/bin/bash

jsonnet -J vendor -J lib main.libsonnet  -o sdk.json

mv sdk.json ../deployment/grafana/dashboards