import logging
import sys
import time
from flask import Flask, jsonify, g, request


def create_app() -> Flask:
    app = Flask(__name__)

    logging.basicConfig(
        stream=sys.stdout,
        level=logging.INFO,
        format="%(asctime)s %(levelname)s %(message)s",
    )
    logger = logging.getLogger("app")

    @app.before_request
    def _start_timer():
        g._start_time = time.time()

    @app.after_request
    def _log_request(response):
        duration_ms = int((time.time() - g.get("_start_time", time.time())) * 1000)
        logger.info(
            "%s %s %s %s %dms",
            request.remote_addr,
            request.method,
            request.path,
            response.status_code,
            duration_ms,
        )
        return response

    @app.get("/healthz")
    def healthz():
        return jsonify({"status": "ok"}), 200

    @app.get("/hello")
    def hello():
        return jsonify({"message": "Hello, DevOps!"}), 200

    return app


if __name__ == "__main__":
    create_app().run(host="0.0.0.0", port=8000)
