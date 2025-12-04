Design Notes — Mission 1

1. Dockerfile uses Python 3.11-slim for both builder and runtime stages to reduce image size.
2. Multi-stage build ensures dev dependencies (pytest, flake8) are not included in the final runtime image by default, keeping it minimal.
3. A non-root user runs the app for security reasons.
4. Healthcheck is added to allow CI and Compose to verify container is healthy.
5. docker-compose.yml simplifies local development and exposes port 8080 on host to 8000 in container.
6. Makefile allows convenient commands: build, run, test, lint, clean.
7. CI workflow (GitHub Actions) checks linting, runs tests, and builds the container to ensure code quality.
8. This setup ensures "run in one command" for developers and automated CI checks for pull requests.
9. Trade-off: including dev dependencies in the image speeds up testing in container but slightly increases image size.
10. Extension: in future, we can push images to a registry, scan with Trivy, or add multi-arch builds.
