from fastapi import FastAPI
from pydantic import BaseModel
import os
import time
from sqlalchemy import create_engine, text
from sqlalchemy.exc import OperationalError
from minio import Minio

app = FastAPI(title="AgoMarket API")

# --------------------------------------------------------------------------
# Configuration DWH
# --------------------------------------------------------------------------
DB_USER = os.getenv("DWH_DB_USER", "agomarket")
DB_PASSWORD = os.getenv("DWH_DB_PASSWORD", "agomarket-pwd")
DB_HOST = os.getenv("DWH_DB_HOST", "agomarket-dwh")
DB_PORT = os.getenv("DWH_DB_PORT", "5432")
DB_NAME = os.getenv("DWH_DB_NAME", "agomarket-dwh")

DATABASE_URL = (
    f"postgresql+psycopg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)

engine = None  # sera initialisé au démarrage


# --------------------------------------------------------------------------
# Initialisation MinIO
# --------------------------------------------------------------------------
def initialiser_buckets_minio():
    endpoint = os.getenv("MINIO_ENDPOINT", "agomarket-datalake:9000")
    endpoint = endpoint.replace("http://", "").replace("https://", "")

    client = Minio(
        endpoint,
        access_key=os.getenv("MINIO_ACCESS_KEY", "agomarket"),
        secret_key=os.getenv("MINIO_SECRET_KEY", "agomarket-minio-pwd"),
        secure=False
    )

    buckets = ["bronze", "silver", "gold"]

    for bucket in buckets:
        if not client.bucket_exists(bucket):
            client.make_bucket(bucket)
            print(f"[INIT] Bucket créé : {bucket}")
        else:
            print(f"[INIT] Bucket déjà existant : {bucket}")


# --------------------------------------------------------------------------
# Attente active de PostgreSQL
# --------------------------------------------------------------------------
def attendre_postgresql():
    global engine
    for tentative in range(20):
        try:
            with engine.connect() as conn:
                conn.execute(text("SELECT 1"))
            print("[API] PostgreSQL est prêt.")
            return
        except OperationalError:
            print(f"[API] PostgreSQL pas prêt (tentative {tentative+1}/20).")
            time.sleep(2)
    raise Exception("PostgreSQL inaccessible après 20 tentatives.")


# --------------------------------------------------------------------------
# Événement de démarrage FastAPI
# --------------------------------------------------------------------------
@app.on_event("startup")
def startup_event():
    global engine

    print("[API] Initialisation MinIO…")
    initialiser_buckets_minio()

    print("[API] Création de l’engine SQLAlchemy…")
    engine = create_engine(DATABASE_URL, echo=False, future=True)

    print("[API] Vérification de la disponibilité PostgreSQL…")
    attendre_postgresql()

    print("[API] Démarrage terminé.")


# --------------------------------------------------------------------------
# Endpoint de santé
# --------------------------------------------------------------------------
class HealthResponse(BaseModel):
    status: str
    db_ok: bool


@app.get("/health", response_model=HealthResponse)
def health_check():
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        return HealthResponse(status="ok", db_ok=True)
    except Exception:
        return HealthResponse(status="ok", db_ok=False)