import os
from pathlib import Path
from dotenv import load_dotenv

# -----------------------------------------------------------------
# Chargement du fichier .env à la racine du projet
# -----------------------------------------------------------------
ENV_PATH = Path(__file__).resolve().parents[1] / ".env"
load_dotenv(ENV_PATH)

# -----------------------------------------------------------------
# Data Lake (MinIO)
# -----------------------------------------------------------------
# Chemin logique utilisé par les scripts ETL pour structurer les paths
# (ne crée rien dans MinIO, ne déclenche aucune action réseau)
DATALAKE_ROOT = Path(os.getenv("DATALAKE_ROOT", "/data"))

BRONZE = DATALAKE_ROOT / "bronze"
SILVER = DATALAKE_ROOT / "silver"
GOLD = DATALAKE_ROOT / "gold"

# -----------------------------------------------------------------
# Configuration PostgreSQL (Data Warehouse)
# -----------------------------------------------------------------
DB_HOST = os.getenv("DWH_DB_HOST", "agomarket-dwh")
DB_PORT = int(os.getenv("DWH_DB_PORT", "5432"))
DB_NAME = os.getenv("DWH_DB_NAME", "agomarket-dwh")
DB_USER = os.getenv("DWH_DB_USER", "agomarket")
DB_PASSWORD = os.getenv("DWH_DB_PASSWORD", "agomarket-pwd")

DB_CONFIG = {
    "host": DB_HOST,
    "port": DB_PORT,
    "dbname": DB_NAME,
    "user": DB_USER,
    "password": DB_PASSWORD,
}

# -----------------------------------------------------------------
# URL SQLAlchemy (utile pour l'API ou des outils futurs)
# -----------------------------------------------------------------
DATABASE_URL = (
    f"postgresql+psycopg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
)