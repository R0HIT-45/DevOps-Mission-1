.PHONY: build run test lint clean

build:
	docker compose build

run:
	docker compose up -d

test:
	docker compose run --rm app pytest

lint:
	docker compose run --rm app flake8 .

clean:
	docker compose down --rmi all --volumes --remove-orphans
