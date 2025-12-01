FROM python:3.13-slim

# Accept a build arg for the Guardrails token
# We'll add this to the config using the configure command below
ARG GUARDRAILS_TOKEN

# Create app directory
WORKDIR /app

# print the version just to verify
RUN python3 --version
# start the virtual environment
RUN python3 -m venv /opt/venv

# Enable venv
ENV PATH="/opt/venv/bin:$PATH"

# Install some utilities; you may not need all of these
RUN apt-get update
RUN apt-get install -y git

# Copy the requirements file
COPY requirements*.txt .

# Install app dependencies
# If you use Poetry this step might be different
RUN pip install -r requirements-lock.txt

# Run the Guardrails configure command to create a .guardrailsrc file
RUN guardrails configure --enable-metrics --enable-remote-inferencing  --token $GUARDRAILS_TOKEN

# Install any validators from the hub you want
RUN guardrails hub install hub://guardrails/toxic_language>=0.0.2 --no-install-local-models

# The ToxicLanguage Validator uses the punkt tokenizer, so we need to download that to a known directory
## Set the directory for nltk data
ENV NLTK_DATA=/opt/nltk_data

## Download punkt data
RUN python -m nltk.downloader -d /opt/nltk_data punkt_tab

# Copy the rest over
# We use a .dockerignore to keep unwanted files exluded
COPY . .

EXPOSE 8000

# This is our start command; yours might be different.
# The guardrails-api is a standard Flask application.
# You can use whatever production server you want that support Flask.
# Here we use gunicorn
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]