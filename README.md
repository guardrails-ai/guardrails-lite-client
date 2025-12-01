# guardrails-lite-client
A bare minimum deployment showing how to use guardrails client side (in an application).  This deployment contains a simple OpenAI compliant chat completions endpoint.  The completions are then validated by a Guard using the ToxicLanguage Validator.

Additionally, this branch shows how to use the .guardrailsrc config file to air gap your application with respect to the Guardrails Hub.  Namely, as shown in `prod.guardrailsrc`, we disable anonymous metrics collection as well as remote inference capabilities, we also omit the `token` field since this is not required when not using remote inferencing. Instead of using an OpenAI model for chat capabilities, we just append a static response, but this could be swapped out with your own model instead.

Pay attention to the `example.env` file in this one.  It demonstrates two important environment variables necessary to allow HugginFace models to work offline.

## Run the server locally with docker

### Linux and MacOS
1. Clone this repository
2.  Make sure there is a valid Guardrails AI API Key in the `GUARDRAILS_TOKEN` environment variable.  `./buildscripts/build/.sh` uses this for performing hub installs during the Docker build.
3. `make build`
4. `make start`

Once the server is up and running, you can check out the Swagger docs at http://localhost:8000/docs

To verify the container's offline status, turn off your wifi and hit the /chat/completions endpoint from the swagger docs.

You can also check the contents of the container by inspecting the tar generated via `./buildscripts/export.sh`.

## Productionizing
We include a Dockerfile that shows the basic steps of containerizing this server.

We also include two bash scripts in the `buildscripts` directory that shows the basics of building the image and running it.