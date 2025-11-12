import pytest
from app.main import create_app

@pytest.fixture
def client():
    app = create_app()
    with app.test_client() as c:
        yield c

def test_healthz(client):
    resp = client.get("/healthz")
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["status"] == "ok"

def test_hello(client):
    resp = client.get("/hello")
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["message"] == "hello"
