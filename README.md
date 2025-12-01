# guardrails-lite-client
A bare minimum deployment showing how to use guardrails client side (in an application).  This deployment contains a simple OpenAI compliant chat completions endpoint.  The completions are then validated by a Guard using the ToxicLanguage Validator.

## Run the server locally with docker

### Linux and MacOS
1. Clone this repository
2.  Make sure there is a valid Guardrails AI API Key in the `GUARDRAILS_TOKEN` environment variable.  `./buildscripts/build/.sh` uses this for performing hub installs during the Docker build.
3. `make build`
4. `make start`

Once the server is up and running, you can check out the Swagger docs at http://localhost:8000/docs


## Productionizing
We include a Dockerfile that shows the basic steps of containerizing this server.

We also include two bash scripts in the `buildscripts` directory that shows the basics of building the image and running it.