#!/bin/bash

if [ -z "$GUARDRAILS_TOKEN" ]
then
    echo "GUARDRAILS_TOKEN environment variables is not set! exiting..."
    exit 1
fi

docker build \
    -f Dockerfile \
    --build-arg="GUARDRAILS_TOKEN=$GUARDRAILS_TOKEN" \
    -t "guardrails-client-app:dev" .;