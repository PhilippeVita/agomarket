import os
from pathlib import Path
from dotenv import load_dotenv

# Chargement du .env à la racine de pipelines/
ENV_PATH = Path(__file__).resolve().parents[2] / ".env"
load_dotenv(ENV_PATH)

# Data Lake (MinIO monté en volume)
DATALAKE_ROOT = Path(os.getenv("DATALAKE_ROOT", "/data"))

BRONZE = DATALAKE_ROOT / "bronze"
SILVER = DATALAKE_ROOT / "silver"
GOLD = DATALAKE_ROOT / "gold"

# Configuration PostgreSQL (harmonisée avec Docker)
DB_CONFIG = {
    "host": os.getenv("DWH_DB_HOST", "agomarket-dwh"),
    "port": int(os.getenv("DWH_DB_PORT", "5432")),
    "dbname": os.getenv("DWH_DB_NAME", "agomarket-dwh"),
    "user": os.getenv("DWH_DB_USER", "agomarket"),
    "password": os.getenv("DWH_DB_PASSWORD", "agomarket-pwd"),
}