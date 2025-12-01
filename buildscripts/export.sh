#!/bin/bash

docker container rm -f guardrails-client-app || true
docker container create --name guardrails-client-app guardrails-client-app:air-gapped
docker container export guardrails-client-app > ./guardrails-client-app.tar