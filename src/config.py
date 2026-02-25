import os
from pathlib import Path
from dotenv import load_dotenv

# ============================================================================
# Chargement du fichier .env à la racine du projet
# ============================================================================
ENV_PATH = Path(__file__).resolve().parents[1] / ".env"
load_dotenv(ENV_PATH)


# ============================================================================
# Data Lake (MinIO)
# ============================================================================
# Chemin logique utilisé par les scripts ETL pour structurer les paths
# (ne crée rien dans MinIO, ne déclenche aucune action réseau)
DATALAKE_ROOT = Path(os.getenv("DATALAKE_ROOT", "/data"))

BRONZE = DATALAKE_ROOT / "bronze"
SILVER = DATALAKE_ROOT / "silver"
GOLD = DATALAKE_ROOT / "gold"


# ============================================================================
# Configuration PostgreSQL (scripts locaux Windows)
# ============================================================================
# IMPORTANT :
# - Les scripts Python exécutés hors Docker doivent utiliser localhost:5433
# - Les variables DB_* sont définies dans le .env
# - Les variables DWH_DB_* sont réservées aux conteneurs Docker (API, Airflow)
# ============================================================================

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "5433")),
    "dbname": os.getenv("DB_NAME", "agomarket-dwh"),
    "user": os.getenv("DB_USER", "agomarket"),
    "password": os.getenv("DB_PASSWORD", "agomarket-pwd"),
}


# ============================================================================
# URL SQLAlchemy (utile pour l’API ou outils futurs)
# ============================================================================
DATABASE_URL = (
    f"postgresql+psycopg://{DB_CONFIG['user']}:{DB_CONFIG['password']}"
    f"@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['dbname']}"
)