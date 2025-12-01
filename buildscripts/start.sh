docker stop guardrails-client-app || true
docker rm guardrails-client-app || true
docker run -p 8000:8000 --name guardrails-client-app --env-file ./.env -it guardrails-client-app:dev