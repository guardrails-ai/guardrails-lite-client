.PHONY: hub-install install lock install-lock env build start export

hub-install:
	guardrails hub install "hub://guardrails/toxic_language>=0.0.2" --no-install-local-models

install:
	pip install -r requirements.txt
	make hub-install

lock:
	pip freeze > requirements-lock.txt

install-lock:
	pip install -r requirements-lock.txt
	make hub-install

env:
	python3 -m venv ./.venv

build: 
	bash ./buildscripts/build.sh

start:
	bash ./buildscripts/start.sh

export:
	bash ./buildscripts/export.sh
