# Makefile for DevOps Mission 1

# Build Docker image
build:
	docker build -t devops-mission-1-app .

# Start container using docker compose
run:
	docker compose up -d

# Stop and remove containers, networks, and images
clean:
	docker compose down
	docker rmi devops-mission-1-app -f

# Run tests inside container
test:
	docker run --rm -v $(PWD)/tests:/tests devops-mission-1-app python -m unittest discover /tests

# Lint the code (optional)
lint:
	flake8 app
