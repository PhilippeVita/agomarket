import psycopg
from src.config import DB_CONFIG


def get_connection():
    """
    Retourne une connexion PostgreSQL basée sur la configuration
    définie dans DB_CONFIG (chargée depuis le .env).
    """
    return psycopg.connect(**DB_CONFIG)