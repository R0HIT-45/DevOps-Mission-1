from app.main import create_app

def test_healthz():
    app = create_app()
    client = app.test_client()
    response = client.get("/healthz")
    assert response.status_code == 200
    assert response.json == {"status": "ok"}

def test_hello():
    app = create_app()
    client = app.test_client()
    response = client.get("/hello")
    assert response.status_code == 200
    assert response.json == {"message": "Hello, DevOps!"}
